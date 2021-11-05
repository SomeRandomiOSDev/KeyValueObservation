//
//  SRDKeyValueObservation.h
//  KeyValueObservation
//
//  Copyright © 2021 SomeRandomiOSDev. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

OBJC_SWIFT_UNAVAILABLE("use Swift's KeyPath observing instead")
/// A class that represents a observation
@interface SRDKeyValueObservation : NSObject

/// Releases the observations associated with the object if they haven't already
/// been released. This method generally doesn't need to get called as it will
/// automatically be called when the receiver is deallocated
- (void)invalidate;

@end

NS_ASSUME_NONNULL_END
