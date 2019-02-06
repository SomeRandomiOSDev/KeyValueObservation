# KeyValueObservation
Block based key-value observations in Objective-C

[![Version](https://img.shields.io/cocoapods/v/KeyValueObservation.svg?style=flat)](https://cocoapods.org/pods/KeyValueObservation)
[![License](https://img.shields.io/cocoapods/l/KeyValueObservation.svg?style=flat)](https://cocoapods.org/pods/KeyValueObservation)
[![Platform](https://img.shields.io/cocoapods/p/KeyValueObservation.svg?style=flat)](https://cocoapods.org/pods/KeyValueObservation)

## Installation

KeyValueObservation is available through [CocoaPods](https://cocoapods.org). To install it, simply add the following line to your Podfile:

```ruby
pod 'KeyValueObservation'
```

## Usage

First import KeyValueObservation at the top of your Objective-C source file:

```objc
@import KeyValueObservation;
```

Then, adding an observer block is as simple as:

```objc
NSString *keyPath = @"Some Key Path";
NSKeyValueObservingOptions options = ...

NSObject *observation = [object observeKeyPath:keyPath 
                                       options:options 
                                 changeHandler:^(id object, SRDKeyValueObservedChange *change) {
    
    NSLog(@"Old value = %@", [change.oldValue description]);
    NSLog(@"New value = %@", [change.newValue description]);
    ...
}];
```

The Key-Value Observation remains in affect as long as the returned _observation_ object remains alive. Once this object is deallocated the observation block is released and no longer responds to changes. Optionally, you could also call the `invalidate` method of the returned object to stop observing changes before the object is deallocated.

Like regular Foundation's KVO APIs, `NSArray` objects aren't directly observable using KVO. However, like the Foundation provided APIs, you can observe the changes for objects within the array. For example:

```objc
NSString *keyPath = @"Some Key Path";
NSIndexSet *indexes = ...
NSKeyValueObservingOptions options = ...

NSObject *observation = [array observeKeyPath:keyPath
                          forObjectsAtIndexes:indexes
                                      options:options 
                                changeHandler:^(id object, SRDKeyValueObservedChange *change) {
 
    NSIndexSet *changedIndexes = change.indexes;

    // oldValue and newValue are arrays containing the before and after values of the
    // objects at the `changedIndexes`
    NSLog(@"Old value = %@", [change.oldValue description]);
    NSLog(@"New value = %@", [change.newValue description]);
    
    ...
}];
```

## Author

Joseph Newton, somerandomiosdev@gmail.com

## License

KeyValueObservation is available under the MIT license. See the LICENSE file for more info.
