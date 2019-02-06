//
//  SRDKeyValueObservedChange+Internal.h
//  Pods
//
//  Created by Joseph Newton on 2/5/19.
//  Copyright © 2019 Joseph Newton. All rights reserved.
//

#import <KeyValueObservation/SRDKeyValueObservedChange.h>

@interface SRDKeyValueObservedChange()

- (instancetype)initWithChangeDictionary:(NSDictionary<NSKeyValueChangeKey,id> *)change;

@end
