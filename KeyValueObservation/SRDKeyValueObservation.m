//
//  SRDKeyValueObservation.m
//  KeyValueObservation
//
//  Created by Joseph Newton on 2/5/19.
//  Copyright © 2019 Joseph Newton. All rights reserved.
//

#import <KeyValueObservation/SRDKeyValueObservation.h>
#import <KeyValueObservation/SRDKeyValueObservedChange.h>

#import "SRDKeyValueObservation+Internal.h"
#import "SRDKeyValueObservedChange+Internal.h"

#pragma mark - Breakpoint Functions

#if DEBUG
extern __attribute__((noinline, used, visibility("hidden")))
void srd_invalidate_kvo_after_free(void) { asm(""); }
#endif // #if DEBUG

#pragma mark - Class (SRDKeyValueObservation) Implementation

@implementation SRDKeyValueObservation {
    __unsafe_unretained NSObject *_unownedObject;
    __weak NSObject *_object;
    
    NSIndexSet *_indexes;
    NSString *_keyPath;
    void (^_handler)(id, SRDKeyValueObservedChange *);
}

#pragma mark - Initialization

- (instancetype)initWithObject:(NSObject *)object keyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options changeHandler:(void (^)(id, SRDKeyValueObservedChange *))changeHandler {
    if (object == nil)
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"'object' cannot be nil" userInfo:nil];
    if (keyPath == nil)
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"'keyPath' cannot be nil" userInfo:nil];
    if (changeHandler == nil)
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"'changeHandler' cannot be nil" userInfo:nil];
    
    if (self = [super init]) {
        _unownedObject = object;
        _object        = object;
        _keyPath       = [keyPath copy];
        _handler       = changeHandler;
        
        [object addObserver:self forKeyPath:keyPath options:options context:NULL];
    }
    
    return self;
}

- (instancetype)initWithArray:(NSArray *)array indexes:(NSIndexSet *)indexes keyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options changeHandler:(void (^)(id, SRDKeyValueObservedChange *))changeHandler {
    if (array == nil)
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"'array' cannot be nil" userInfo:nil];
    if (indexes == nil)
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"'indexes' cannot be nil" userInfo:nil];
    if (keyPath == nil)
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"'keyPath' cannot be nil" userInfo:nil];
    if (changeHandler == nil)
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"'changeHandler' cannot be nil" userInfo:nil];
    
    if (self = [super init]) {
        _unownedObject = array;
        _object        = array;
        _indexes       = indexes;
        _keyPath       = keyPath;
        _handler       = changeHandler;
        
        [array addObserver:self toObjectsAtIndexes:indexes forKeyPath:keyPath options:options context:NULL];
    }
    
    return self;
}

- (void)dealloc {
    [self invalidate];
}

#pragma mark - Public Methods

- (void)invalidate {
    __strong NSObject *object = _object;
    
#if DEBUG
    if (object == nil && _unownedObject != nil) {
        NSLog(@"-[%@ %@] called after the observed object was deallocated. Set a symbolic breakpoint for 'srd_invalidate_kvo_after_free' to debug", self.description, NSStringFromSelector(_cmd));
        srd_invalidate_kvo_after_free();
    }
#endif // #if DEBUG
    
    if (object != nil) {
        if ([object isKindOfClass:[NSArray class]])
            [(NSArray *)object removeObserver:self fromObjectsAtIndexes:_indexes forKeyPath:_keyPath];
        else
            [object removeObserver:self forKeyPath:_keyPath];
    }
    
    _unownedObject = nil;
    _object        = nil;
    _indexes       = nil;
    _keyPath       = nil;
    _handler       = nil;
}

#pragma mark - NSObject Overrides

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if (object == _unownedObject && [keyPath isEqualToString:_keyPath]) {
        _handler(object, [[SRDKeyValueObservedChange alloc] initWithChangeDictionary:change]);
    }
}

@end
