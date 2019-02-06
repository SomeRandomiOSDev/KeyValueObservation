//
//  NSObject+KeyValueObservation.h
//  KeyValueObservation
//
//  Created by Joseph Newton on 2/5/19.
//  Copyright © 2019 Joseph Newton. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <KeyValueObservation/SRDKeyValueObservation.h>
#import <KeyValueObservation/SRDKeyValueObservedChange.h>

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_UNAVAILABLE("Use Swift's KeyPath observing instead")
@interface NSObject (KeyValueObservation)

/// Creates an registers a Key-Value Observation to the receiving object for the provided index path. The observed change is observed through calling the provided handler block.
///
/// \param keyPath The key path of the receiver to observe. If the receiver cannot observe the key path, an exception is raised.
/// \param options The options used for observation.
/// \param changeHandler The handler to call when the receiver fires a KVO event for the provided key path.
///
/// \returns An object that keeps the observation alive. Once this object is deallocated, the block is released no longer receives KVO events.
- (SRDKeyValueObservation *)observeKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options changeHandler:(void (^)(id, SRDKeyValueObservedChange *))changeHandler;

@end

NS_ASSUME_NONNULL_END
