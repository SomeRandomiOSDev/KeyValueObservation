//
//  SRDKVOInfo.h
//  KeyValueObservation
//
//  Created by Joseph Newton on 2/7/19.
//  Copyright © 2019 Joseph Newton. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#pragma mark - Class (SRDKVOInfo) Interface

@interface SRDKVOInfo : NSObject <NSCopying, NSMutableCopying>

@property (nonatomic, strong, readonly, nullable) __kindof NSObject *observed;
@property (nonatomic, copy, readonly)             NSString *keyPath;

- (instancetype)initWithObserved:(nullable __kindof NSObject *)observed keyPath:(NSString *)keyPath;
+ (SRDKVOInfo *)infoWithObserved:(nullable __kindof NSObject *)observed keyPath:(NSString *)keyPath OBJC_SWIFT_UNAVAILABLE("use object initializers instead");

@end

#pragma mark - Class (SRDMutableKVOInfo) Interface

@interface SRDMutableKVOInfo : SRDKVOInfo <NSCopying, NSMutableCopying>

@property (nonatomic, strong, nullable) __kindof NSObject *observed;
@property (nonatomic, copy)             NSString *keyPath;

+ (SRDMutableKVOInfo *)infoWithObserved:(nullable __kindof NSObject *)observed keyPath:(NSString *)keyPath OBJC_SWIFT_UNAVAILABLE("use object initializers instead");

@end

NS_ASSUME_NONNULL_END
