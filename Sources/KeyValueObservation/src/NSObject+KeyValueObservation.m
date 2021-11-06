//
//  NSObject+KeyValueObservation.m
//  KeyValueObservation
//
//  Copyright © 2021 SomeRandomiOSDev. All rights reserved.
//

#import <KeyValueObservation/NSObject+KeyValueObservation.h>
#import <objc/message.h>

#import "SRDKeyValueObservation+Internal.h"

#pragma mark - Private Function Declarations

static void __observeValueForKeyPath(id self, SEL _cmd, NSString * __nullable, id __nullable, NSDictionary<NSKeyValueChangeKey, id> * __nullable, void * __nullable);

#pragma mark - Class Category | NSObject (KeyValueObservation)

@implementation NSObject (KeyValueObservation)

#pragma mark - Public Methods

- (SRDKeyValueObservation *)observeKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options changeHandler:(void (^)(id _Nonnull, SRDKeyValueObservedChange * _Nonnull))changeHandler {
    if (keyPath == nil)
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"'keyPath' cannot be nil" userInfo:nil];
    if (changeHandler == nil)
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"'changeHandler' cannot be nil" userInfo:nil];
    
    return [[SRDKeyValueObservation alloc] initWithObject:self keyPath:keyPath options:options changeHandler:changeHandler];
}



- (void)performWhileIgnoringObservations:(NSArray<SRDKVOInfo *> *)observations handler:(void (^NS_NOESCAPE)(void))handler {
    if (observations.count == 0)
        return handler();

    observations = [[NSArray alloc] initWithArray:observations copyItems:YES];

    Class const selfclass = object_getClass(self);
    Class const superclass = class_getSuperclass(selfclass);

    Method const superObserveValueForKeyPath = superclass != Nil ? class_getInstanceMethod(superclass, @selector(observeValueForKeyPath:ofObject:change:context:)) : NULL;
    Method observeValueForKeyPath = class_getInstanceMethod(selfclass, method_getName(superObserveValueForKeyPath));

    if (superObserveValueForKeyPath != NULL && observeValueForKeyPath == superObserveValueForKeyPath) {
        // This class doesn't override its superclass' implementation of
        // -[NSObject observeValueForKeyPath:ofObject:change:context:]. We should add the
        // method to the current class so as not to replace the superclass' implementation
        // with ours.

        class_addMethod(selfclass, method_getName(superObserveValueForKeyPath), (IMP)__observeValueForKeyPath, method_getTypeEncoding(superObserveValueForKeyPath));
        observeValueForKeyPath = class_getInstanceMethod(selfclass, method_getName(superObserveValueForKeyPath));
    }

    IMP const originalObserveValueForKeyPath = method_getImplementation(observeValueForKeyPath);

    __typeof(self) __unsafe_unretained const unowned = self;
    void (^ const __observeValueForKeyPath)(id, NSString *, id, NSDictionary *, void *) = ^(id _self, NSString *_keyPath, id _object, NSDictionary *_change, void *_context) {
        for (SRDKVOInfo *observation in observations) {
            if (unowned == _self && observation.observed == _object && [observation.keyPath isEqualToString:_keyPath])
                return; // Ignore
        }

        // Forward to original implementation
        ((void (*)(id, SEL, NSString *, id, NSDictionary *, void *))originalObserveValueForKeyPath)(_self, @selector(observeValueForKeyPath:ofObject:change:context:), _keyPath, _object, _change, _context);
    };

    IMP const replacementObserveValueForKeyPath = imp_implementationWithBlock(__observeValueForKeyPath);
    method_setImplementation(observeValueForKeyPath, replacementObserveValueForKeyPath);

    @try { handler(); }
    @finally {
        // Always set back original implementation and remove block
        method_setImplementation(observeValueForKeyPath, originalObserveValueForKeyPath);
        imp_removeBlock(replacementObserveValueForKeyPath);
    }
}

@end

#pragma mark - Private Function Definitions

/// Simple implementation of -[NSObject observeValueForKeyPath:ofObject:change:context:] that simply invoke its superclass' implementation
static void __observeValueForKeyPath(id self, SEL _cmd, NSString * __nullable keyPath, id __nullable object, NSDictionary<NSKeyValueChangeKey, id> * __nullable change, void * __nullable context) {
    Class const superclass = class_getSuperclass(object_getClass(self));

    struct objc_super super = {
        .receiver = self,
        .super_class = superclass
    };

    ((void (*)(struct objc_super *, SEL, NSString *, id, NSDictionary<NSKeyValueChangeKey, id> *, void *))objc_msgSendSuper)(&super, _cmd, keyPath, object, change, context);
}
