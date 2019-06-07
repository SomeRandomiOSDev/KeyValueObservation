//
//  NSArray+KeyValueObservation.h
//  KeyValueObservation
//
//  Created by Joseph Newton on 2/5/19.
//  Copyright © 2019 Joseph Newton. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <KeyValueObservation/SRDKeyValueObservation.h>
#import <KeyValueObservation/SRDKeyValueObservedChange.h>

NS_ASSUME_NONNULL_BEGIN

OBJC_SWIFT_UNAVAILABLE("use Swift's KeyPath observing instead")
@interface NSArray (KeyValueObservation)

/// Creates an registers a Key-Value Observation to the objects in the array at given indexes for the provided index path. The observed change is observed through calling the provided handler block.
///
/// \param keyPath The key path of the receiving objects to observe. If the receiving objects cannot observe the key path, an exception is raised.
/// \param indexes The indexes of the objects in the array to observe.
/// \param options The options used for observation.
/// \param changeHandler The handler to call when the receiver fires a KVO event for the provided key path.
/// 
/// \returns An object that keeps the observation alive. Once this object is deallocated, the block is released no longer receives KVO events.
- (SRDKeyValueObservation *)observeKeyPath:(NSString *)keyPath forObjectsAtIndexes:(NSIndexSet *)indexes options:(NSKeyValueObservingOptions)options changeHandler:(void (^)(id, SRDKeyValueObservedChange *))changeHandler;

@end

NS_ASSUME_NONNULL_END
