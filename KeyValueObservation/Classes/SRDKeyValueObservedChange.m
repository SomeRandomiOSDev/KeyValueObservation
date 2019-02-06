//
//  SRDKeyValueObservedChange.m
//  KeyValueObservation
//
//  Created by Joseph Newton on 2/5/19.
//  Copyright © 2019 Joseph Newton. All rights reserved.
//

#import "SRDKeyValueObservedChange.h"

#pragma mark - Class (SRDKeyValueObservedChange) Implementation

@implementation SRDKeyValueObservedChange

#pragma mark - Property Synthesis

@synthesize newValue = _newValue, oldValue = _oldValue, indexes = _indexes, kind = _kind, isPrior = _isPrior;

#pragma mark - Initialization

- (instancetype)initWithChangeDictionary:(NSDictionary<NSKeyValueChangeKey,id> *)change {
    if (self = [super init]) {
        _newValue = change[NSKeyValueChangeNewKey];
        if (_newValue == [NSNull null])
            _newValue = nil;
        
        _oldValue = change[NSKeyValueChangeOldKey];
        if (_oldValue == [NSNull null])
            _oldValue = nil;
        
        _indexes = (NSIndexSet *)change[NSKeyValueChangeIndexesKey];
        
        _kind    = (NSKeyValueChange)((NSNumber *)change[NSKeyValueChangeKindKey]).unsignedIntegerValue;
        _isPrior = ((NSNumber *)change[NSKeyValueChangeNotificationIsPriorKey]).boolValue;
    }
    
    return self;
}

@end
