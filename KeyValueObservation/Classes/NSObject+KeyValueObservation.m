//
//  NSObject+KeyValueObservation.m
//  KeyValueObservation
//
//  Created by Joseph Newton on 2/5/19.
//  Copyright © 2019 Joseph Newton. All rights reserved.
//

#import <KeyValueObservation/NSObject+KeyValueObservation.h>
#import "SRDKeyValueObservation+Internal.h"

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

@end
