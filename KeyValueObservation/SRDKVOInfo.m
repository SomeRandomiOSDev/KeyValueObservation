//
//  SRDKeyObserverPair.m
//  KeyValueObservation
//
//  Created by Joseph Newton on 2/7/19.
//  Copyright © 2019 SomeRandomiOSDev. All rights reserved.
//

#import "SRDKVOInfo.h"

#pragma mark - Class (SRDKVOInfo) Implementation

@implementation SRDKVOInfo {
@package
    __kindof NSObject *_observed;
    NSString *_keyPath;
}

#pragma mark - Property Synthesis

@synthesize observed = _observed, keyPath = _keyPath;

#pragma mark - Initialization

- (instancetype)initWithObserved:(__kindof NSObject *)observed keyPath:(NSString *)keyPath {
    if (self = [super init]) {
        _observed = observed;
        _keyPath  = [keyPath copy];
    }
    
    return self;
}

#pragma mark - Factory Methods

+ (SRDKVOInfo *)infoWithObserved:(__kindof NSObject *)observed keyPath:(NSString *)keyPath {
    return [[SRDKVOInfo alloc] initWithObserved:observed keyPath:keyPath];
}

#pragma mark - NSCopying Protocol Requirements

- (id)copyWithZone:(NSZone *)zone {
    return [[SRDKVOInfo allocWithZone:zone] initWithObserved:_observed keyPath:_keyPath];
}

#pragma mark - NSMutableCopying Protocol Requirements

- (id)mutableCopyWithZone:(NSZone *)zone {
    return [[SRDMutableKVOInfo allocWithZone:zone] initWithObserved:_observed keyPath:_keyPath];
}

@end

#pragma mark - Class (SRDMutableKVOInfo) Implementation

@implementation SRDMutableKVOInfo

#pragma mark - Property Synthesis

@dynamic observed, keyPath;

- (void)setObserved:(__kindof NSObject *)observed {
    _observed = observed;
}

- (void)setKeyPath:(NSString *)keyPath {
    _keyPath = [keyPath copy];
}

#pragma mark - Factory Methods

+ (SRDMutableKVOInfo *)infoWithObserved:(__kindof NSObject *)observed keyPath:(NSString *)keyPath {
    return [[SRDMutableKVOInfo alloc] initWithObserved:observed keyPath:keyPath];
}

@end
