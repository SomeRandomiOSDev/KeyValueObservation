//
//  NSArray+KeyValueObservation.m
//  KeyValueObservation
//
//  Copyright © 2021 SomeRandomiOSDev. All rights reserved.
//

#import <KeyValueObservation/NSArray+KeyValueObservation.h>
#import "SRDKeyValueObservation+Internal.h"

#pragma mark - Class Category | NSArray (KeyValueObservation)

@implementation NSArray (KeyValueObservation)

#pragma mark - Public Methods

- (SRDKeyValueObservation *)observeKeyPath:(NSString *)keyPath forObjectsAtIndexes:(NSIndexSet *)indexes options:(NSKeyValueObservingOptions)options changeHandler:(void (^)(id, SRDKeyValueObservedChange *))changeHandler {
    if (keyPath == nil)
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"'keyPath' cannot be nil" userInfo:nil];
    if (indexes == nil)
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"'indexes' cannot be nil" userInfo:nil];
    if (changeHandler == nil)
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"'changeHandler' cannot be nil" userInfo:nil];
    
    return [[SRDKeyValueObservation alloc] initWithArray:self indexes:indexes keyPath:keyPath options:options changeHandler:changeHandler];
}

@end
