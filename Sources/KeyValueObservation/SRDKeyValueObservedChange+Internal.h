//
//  SRDKeyValueObservedChange+Internal.h
//  Pods
//
//  Copyright © 2021 SomeRandomiOSDev. All rights reserved.
//

#import <KeyValueObservation/SRDKeyValueObservedChange.h>

@interface SRDKeyValueObservedChange()

- (instancetype)initWithChangeDictionary:(NSDictionary<NSKeyValueChangeKey,id> *)change;

@end
