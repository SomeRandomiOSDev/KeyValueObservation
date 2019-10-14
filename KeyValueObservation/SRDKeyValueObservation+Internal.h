//
//  SRDKeyValueObservation+Internal.h
//  KeyValueObservation
//
//  Created by Joseph Newton on 2/5/19.
//  Copyright © 2019 SomeRandomiOSDev. All rights reserved.
//

#import <KeyValueObservation/SRDKeyValueObservation.h>

@interface SRDKeyValueObservation()

- (instancetype)initWithObject:(NSObject *)object keyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options changeHandler:(void (^)(id, SRDKeyValueObservedChange *))changeHandler;
- (instancetype)initWithArray:(NSArray *)array indexes:(NSIndexSet *)indexes keyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options changeHandler:(void (^)(id, SRDKeyValueObservedChange *))changeHandler;

@end
