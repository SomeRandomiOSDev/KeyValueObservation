# KeyValueObservation

[![Codacy Badge](https://api.codacy.com/project/badge/Grade/d30d31c29f17449481b97a04610ff5b9)](https://app.codacy.com/app/SomeRandomiOSDev/KeyValueObservation?utm_source=github.com&utm_medium=referral&utm_content=SomeRandomiOSDev/KeyValueObservation&utm_campaign=Badge_Grade_Dashboard)
[![License MIT](https://img.shields.io/cocoapods/l/KeyValueObservation.svg)](https://cocoapods.org/pods/KeyValueObservation)
[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/KeyValueObservation.svg)](https://cocoapods.org/pods/KeyValueObservation) 
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage) 
[![Platform](https://img.shields.io/cocoapods/p/KeyValueObservation.svg)](https://cocoapods.org/pods/KeyValueObservation)
[![Code Coverage](https://codecov.io/gh/SomeRandomiOSDev/KeyValueObservation/branch/master/graph/badge.svg)](https://codecov.io/gh/SomeRandomiOSDev/KeyValueObservation)

[![Carthage](https://github.com/SomeRandomiOSDev/KeyValueObservation/actions/workflows/carthage.yml/badge.svg)](https://github.com/SomeRandomiOSDev/KeyValueObservation/actions/workflows/carthage.yml)
[![Cocoapods](https://github.com/SomeRandomiOSDev/KeyValueObservation/actions/workflows/cocoapods.yml/badge.svg)](https://github.com/SomeRandomiOSDev/KeyValueObservation/actions/workflows/cocoapods.yml)
[![XCFramework](https://github.com/SomeRandomiOSDev/KeyValueObservation/actions/workflows/xcframework.yml/badge.svg)](https://github.com/SomeRandomiOSDev/KeyValueObservation/actions/workflows/xcframework.yml)
[![Xcode Project](https://github.com/SomeRandomiOSDev/KeyValueObservation/actions/workflows/xcodebuild.yml/badge.svg)](https://github.com/SomeRandomiOSDev/KeyValueObservation/actions/workflows/xcodebuild.yml)

Block based key-value observations in Objective-C

## Installation

**KeyValueObservation** is available through [CocoaPods](https://cocoapods.org) and [Carthage](https://github.com/Carthage/Carthage). 

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

An additional capability of this library is the ability to easily ignore certain Key-Value Observations for the context of a handler block without any additional overhead. For example:

```objc
@implementation FooBar

...

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"foobar"] && object == self.foobarObject) {
        // Some action. Won't ever be called from the context of -[FooBar someMethod] given 
        // the use of -[NSObject performWhileIgnoringObservations:handler:]
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

...

- (void)someMethod {
    [self performWhileIgnoringObservations:@[[SRDKVOInfo infoWithObserved:self.foobarObject keyPath:@"foobar"]] handler:^{
        self.foobarObject.foobar = @"foobar";
    }];
}

@end
```

In lieu of having to add flags to your object to determine when or when not to ignore particular Key-Value Observations one can simply do it from the context of a handler block. Any observations that match any of the `SRDKVOInfo` objects passed in to the method will be automatically ignored while executing the block. After the block finishes executing, the observations are once again passed through as normal.

Note that `-[NSObject performWhileIgnoringObservations:handler:]` uses method implementation swizzling to be able to ignore the specified observations, therefore it is important that you do not do any swizzling for the method `-[NSObject observeValueForKeyPath:ofObject:change:context:]` for the receiving class from the context of the handler block. Doing so could lead to unexpected results.

## Contributing

Whether it's submitting a feature request, reporting a bug, or writing code yourself, all contributions to this library are welcome! Please see [CONTRIBUTING](.github/CONTRIBUTING.md) for more information on how you can contribute.

## Author

Joe Newton, somerandomiosdev@gmail.com

## License

**KeyValueObservation** is available under the MIT license. See the `LICENSE` file for more info.
