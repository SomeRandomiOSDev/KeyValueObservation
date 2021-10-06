//
//  SRDKeyValueObservation+Internal.h
//  KeyValueObservation
//
//  Copyright © 2021 SomeRandomiOSDev. All rights reserved.
//

#import <KeyValueObservation/SRDKeyValueObservation.h>

@interface SRDKeyValueObservation()

- (instancetype)initWithObject:(NSObject *)object keyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options changeHandler:(void (^)(id, SRDKeyValueObservedChange *))changeHandler;
- (instancetype)initWithArray:(NSArray *)array indexes:(NSIndexSet *)indexes keyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options changeHandler:(void (^)(id, SRDKeyValueObservedChange *))changeHandler;

@end
