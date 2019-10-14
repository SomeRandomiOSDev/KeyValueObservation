//
//  NSObject+KeyValueObservation.h
//  KeyValueObservation
//
//  Created by Joseph Newton on 2/5/19.
//  Copyright © 2019 SomeRandomiOSDev. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <KeyValueObservation/SRDKVOInfo.h>
#import <KeyValueObservation/SRDKeyValueObservation.h>
#import <KeyValueObservation/SRDKeyValueObservedChange.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (KeyValueObservation)

/// Creates an registers a Key-Value Observation to the receiving object for the provided index path. The observed change is observed through calling the provided handler block.
///
/// \param keyPath The key path of the receiver to observe. If the receiver cannot observe the key path, an exception is raised.
/// \param options The options used for observation.
/// \param changeHandler The handler to call when the receiver fires a KVO event for the provided key path.
///
/// \returns An object that keeps the observation alive. Once this object is deallocated, the block is released no longer receives KVO events.
- (SRDKeyValueObservation *)observeKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options changeHandler:(void (^)(id, SRDKeyValueObservedChange *))changeHandler OBJC_SWIFT_UNAVAILABLE("use Swift's KeyPath observing instead");

/// Runs a given handler block synchronously while ignoring all Key-Value Observations specified by the @p observations parameter. This has the same effect as unregistering for each observer/keyPath in @p observations, running the block, then re-registering for each observation.
///
/// \param observations An array specifying the Key-Value Observations to ignore.
/// \param handler The block to run.
- (void)performWhileIgnoringObservations:(NSArray<SRDKVOInfo *> *)observations handler:(void (^NS_NOESCAPE)(void))handler;

@end

NS_ASSUME_NONNULL_END
