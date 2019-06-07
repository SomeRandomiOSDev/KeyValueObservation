//
//  SRDKeyValueObservedChange.h
//  KeyValueObservation
//
//  Created by Joseph Newton on 2/5/19.
//  Copyright © 2019 Joseph Newton. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

OBJC_SWIFT_UNAVAILABLE("use Swift's KeyPath observing instead")
/// A class that represents the changes associated with a KVO event
@interface SRDKeyValueObservedChange : NSObject

/// The new value of the observed change, if any
@property (nonatomic, strong, readonly, nullable) id newValue;
- (nullable id)newValue __attribute__((objc_method_family(none))); // To allow the use of 'new' in the property name

/// The old value of the observed change, if any
@property (nonatomic, strong, readonly, nullable) id oldValue;

/// The indexes of the objects in a to-many ordered collection that were changed for this particular event
@property (nonatomic, strong, readonly, nullable) NSIndexSet *indexes;

/// The kind of change
@property (nonatomic, assign, readonly)           NSKeyValueChange kind;

/// A flag indicating whether this event was fired before or after the update was made
@property (nonatomic, assign, readonly)           BOOL isPrior;

@end

NS_ASSUME_NONNULL_END
