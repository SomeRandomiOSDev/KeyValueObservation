# KeyValueObservation
Block based key-value observations in Objective-C

[![Codacy Badge](https://api.codacy.com/project/badge/Grade/d30d31c29f17449481b97a04610ff5b9)](https://app.codacy.com/app/SomeRandomiOSDev/KeyValueObservation?utm_source=github.com&utm_medium=referral&utm_content=SomeRandomiOSDev/KeyValueObservation&utm_campaign=Badge_Grade_Dashboard)
[![License MIT](https://img.shields.io/cocoapods/l/KeyValueObservation.svg)](https://cocoapods.org/pods/KeyValueObservation)
[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/KeyValueObservation.svg)](https://cocoapods.org/pods/KeyValueObservation) 
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage) 
[![Platform](https://img.shields.io/cocoapods/p/KeyValueObservation.svg)](https://cocoapods.org/pods/KeyValueObservation)
[![Build](https://travis-ci.com/SomeRandomiOSDev/KeyValueObservation.svg?branch=master)](https://travis-ci.com/SomeRandomiOSDev/KeyValueObservation)
[![Code Coverage](https://codecov.io/gh/SomeRandomiOSDev/KeyValueObservation/branch/master/graph/badge.svg)](https://codecov.io/gh/SomeRandomiOSDev/KeyValueObservation)

## Installation

KeyValueObservation is available through [CocoaPods](https://cocoapods.org) and [Carthage](https://github.com/Carthage/Carthage). 

To install via CocoaPods, simply add the following line to your Podfile:

```ruby
pod 'KeyValueObservation'
```

To install via Carthage, simply add the following line to your Cartfile:

```ruby
github "SomeRandomiOSDev/KeyValueObservation"
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
