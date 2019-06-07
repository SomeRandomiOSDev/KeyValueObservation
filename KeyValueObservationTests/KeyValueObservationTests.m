//
//  KeyValueObservationTests.m
//  KeyValueObservationTests
//
//  Created by Joseph Newton on 02/05/2019.
//  Copyright © 2019 Joseph Newton. All rights reserved.
//

@import XCTest;
@import KeyValueObservation;

#import "SRDKeyValueObservation+Internal.h"

#pragma mark - Class (DummyClass) Interface

@interface DummyClass : NSObject {
@package
    NSInteger _integer;
}

@property (nonatomic, assign) NSInteger integer;
@property (nonatomic, assign) NSInteger integer2;

@property (nonatomic, strong) NSObject* object;

@property (nonatomic, strong) NSMutableArray *array;
@property (nonatomic, strong) NSMutableSet *set;

@end

#pragma mark - Class (KeyValueObservationTests) Interface

@interface KeyValueObservationTests : XCTestCase

@property (nonatomic, strong) dispatch_block_t handler;

@end

#pragma mark - Class (KeyValueObservationTests) Implementation

@implementation KeyValueObservationTests

#pragma mark - Test Methods

- (void)testNullParametersThrow {
    NSObject *object = [[NSObject alloc] init];
    NSArray *array = [[NSArray alloc] init];
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wnonnull"
    
    XCTAssertThrows([object observeKeyPath:nil options:NSKeyValueObservingOptionNew changeHandler:^(id _, SRDKeyValueObservedChange *__) { }]);
    XCTAssertThrows([object observeKeyPath:@"" options:NSKeyValueObservingOptionNew changeHandler:nil]);

    XCTAssertThrows([array observeKeyPath:nil forObjectsAtIndexes:[NSIndexSet new] options:NSKeyValueObservingOptionNew changeHandler:^(id _, SRDKeyValueObservedChange *__) { }]);
    XCTAssertThrows([array observeKeyPath:@"" forObjectsAtIndexes:nil options:NSKeyValueObservingOptionNew changeHandler:^(id _, SRDKeyValueObservedChange *__) { }]);
    XCTAssertThrows([array observeKeyPath:@"" forObjectsAtIndexes:[NSIndexSet new] options:NSKeyValueObservingOptionNew changeHandler:nil]);

    XCTAssertThrows([[SRDKeyValueObservation alloc] initWithObject:nil keyPath:nil options:kNilOptions changeHandler:nil]);
    XCTAssertThrows([[SRDKeyValueObservation alloc] initWithObject:object keyPath:nil options:kNilOptions changeHandler:nil]);
    XCTAssertThrows([[SRDKeyValueObservation alloc] initWithObject:object keyPath:@"" options:kNilOptions changeHandler:nil]);

    XCTAssertThrows([[SRDKeyValueObservation alloc] initWithArray:nil indexes:nil keyPath:nil options:kNilOptions changeHandler:nil]);
    XCTAssertThrows([[SRDKeyValueObservation alloc] initWithArray:array indexes:nil keyPath:nil options:kNilOptions changeHandler:nil]);
    XCTAssertThrows([[SRDKeyValueObservation alloc] initWithArray:array indexes:[NSIndexSet new] keyPath:nil options:kNilOptions changeHandler:nil]);
    XCTAssertThrows([[SRDKeyValueObservation alloc] initWithArray:array indexes:[NSIndexSet new] keyPath:@"" options:kNilOptions changeHandler:nil]);
    
#pragma clang diagnostic pop
}

- (void)testHandlerCalledAfterChange {
    DummyClass *dummy = [[DummyClass alloc] init];
    SRDKeyValueObservation *observation;
    
    void (^handler)(id, SRDKeyValueObservedChange *) = ^(DummyClass *object, SRDKeyValueObservedChange *change) {
        XCTAssertEqual(dummy, object);
        dummy->_integer -= 1;
    };
    
    @autoreleasepool {
        observation = [dummy observeKeyPath:@"integer" options:NSKeyValueObservingOptionNew changeHandler:handler];
        
        dummy.integer += 1;
        XCTAssertTrue(dummy.integer == 0);
        
        observation = nil;
    }
    
    dummy.integer += 1;
    XCTAssertTrue(dummy.integer == 1);
    
    observation = [dummy observeKeyPath:@"integer" options:NSKeyValueObservingOptionNew changeHandler:handler];
    
    dummy.integer += 1;
    XCTAssertTrue(dummy.integer == 1);
    
    [observation invalidate];
    
    dummy.integer += 1;
    XCTAssertTrue(dummy.integer == 2);
}

- (void)testOtherKeyPathsStillFunction {
    DummyClass *dummy = [[DummyClass alloc] init];
    __block BOOL integerHandlerCalled = NO, integer2HandlerCalled = NO;
    
    [dummy addObserver:self forKeyPath:@"integer2" options:NSKeyValueObservingOptionNew context:NULL];
    SRDKeyValueObservation *observation = [dummy observeKeyPath:@"integer" options:NSKeyValueObservingOptionNew changeHandler:^(DummyClass *object, SRDKeyValueObservedChange *change) {
        integerHandlerCalled = YES;
    }];
    self.handler = ^{
        integer2HandlerCalled = YES;
    };
    
    dummy.integer += 1;
    XCTAssertTrue(integerHandlerCalled);
    XCTAssertFalse(integer2HandlerCalled);
    
    integerHandlerCalled = NO;
    dummy.integer2 += 1;
    XCTAssertTrue(integer2HandlerCalled);
    XCTAssertFalse(integerHandlerCalled);
    
    integer2HandlerCalled = NO;
    dummy.integer += 1;
    dummy.integer2 += 1;
    XCTAssertTrue(integerHandlerCalled);
    XCTAssertTrue(integer2HandlerCalled);
    
    self.handler = nil;
    
    [observation invalidate];
    observation = nil;
}

- (void)testCorrectValues {
    DummyClass *dummy = [[DummyClass alloc] init];
    SRDKeyValueObservation *observation;
    
    observation = [dummy observeKeyPath:@"integer" options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew changeHandler:^(DummyClass *object, SRDKeyValueObservedChange *change) {
        XCTAssertNil(change.oldValue);
        XCTAssertNotNil(change.newValue);
        
        XCTAssertTrue([change.newValue isKindOfClass:[NSNumber class]]);
        XCTAssertTrue([(NSNumber *)change.newValue isEqualToNumber:@0]);
        XCTAssertEqual(change.kind, NSKeyValueChangeSetting);
    }];
    
    observation = [dummy observeKeyPath:@"integer" options:NSKeyValueObservingOptionNew changeHandler:^(DummyClass *object, SRDKeyValueObservedChange *change) {
        XCTAssertNil(change.oldValue);
        XCTAssertNotNil(change.newValue);
        
        XCTAssertTrue([change.newValue isKindOfClass:[NSNumber class]]);
        XCTAssertTrue([(NSNumber *)change.newValue isEqualToNumber:@1]);
        XCTAssertEqual(change.kind, NSKeyValueChangeSetting);
    }];
    
    dummy.integer = 1;
    
    observation = [dummy observeKeyPath:@"integer" options:NSKeyValueObservingOptionOld changeHandler:^(DummyClass *object, SRDKeyValueObservedChange *change) {
        XCTAssertNil(change.newValue);
        XCTAssertNotNil(change.oldValue);
        
        XCTAssertTrue([change.oldValue isKindOfClass:[NSNumber class]]);
        XCTAssertTrue([(NSNumber *)change.oldValue isEqualToNumber:@1]);
        XCTAssertEqual(change.kind, NSKeyValueChangeSetting);
    }];
    
    dummy.integer = 2;
    
    observation = [dummy observeKeyPath:@"integer" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew changeHandler:^(DummyClass *object, SRDKeyValueObservedChange *change) {
        XCTAssertNotNil(change.oldValue);
        XCTAssertNotNil(change.newValue);
        
        XCTAssertTrue([change.oldValue isKindOfClass:[NSNumber class]]);
        XCTAssertTrue([change.newValue isKindOfClass:[NSNumber class]]);
        
        XCTAssertTrue([(NSNumber *)change.oldValue isEqualToNumber:@2]);
        XCTAssertTrue([(NSNumber *)change.newValue isEqualToNumber:@3]);
        
        XCTAssertEqual(change.kind, NSKeyValueChangeSetting);
    }];
    
    dummy.integer = 3;
    
    observation = [dummy observeKeyPath:@"integer" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew | NSKeyValueObservingOptionPrior changeHandler:^(DummyClass *object, SRDKeyValueObservedChange *change) {
        if (change.isPrior) {
            XCTAssertNotNil(change.oldValue);
            XCTAssertNil(change.newValue);
            
            XCTAssertTrue([change.oldValue isKindOfClass:[NSNumber class]]);
            XCTAssertTrue([(NSNumber *)change.oldValue isEqualToNumber:@3]);
        }
        else {
            XCTAssertNotNil(change.oldValue);
            XCTAssertNotNil(change.newValue);
            
            XCTAssertTrue([change.oldValue isKindOfClass:[NSNumber class]]);
            XCTAssertTrue([change.newValue isKindOfClass:[NSNumber class]]);
            
            XCTAssertTrue([(NSNumber *)change.oldValue isEqualToNumber:@3]);
            XCTAssertTrue([(NSNumber *)change.newValue isEqualToNumber:@4]);
        }
        
        XCTAssertEqual(change.kind, NSKeyValueChangeSetting);
    }];
    
    dummy.integer = 4;
    
    [observation invalidate];
    observation = nil;
}

- (void)testArrayObservations {
    NSMutableArray<DummyClass *> *array = [NSMutableArray array];
    for (NSUInteger i = 0; i < 10; ++i)
        [array addObject:[[DummyClass alloc] init]];
    
    SRDKeyValueObservation *observation = [array observeKeyPath:@"integer" forObjectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(2, 3)] options:NSKeyValueObservingOptionNew changeHandler:^(DummyClass *object, SRDKeyValueObservedChange *change) {
        XCTAssertEqual([array indexOfObject:object], 3);
        
        XCTAssertNil(change.oldValue);
        XCTAssertNotNil(change.newValue);
        
        XCTAssertTrue([change.newValue isKindOfClass:[NSNumber class]]);
        XCTAssertTrue([(NSNumber *)change.newValue isEqualToNumber:@2]);
        
        XCTAssertEqual(change.kind, NSKeyValueChangeSetting);
    }];
    
    array[0].integer = 1;
    array[3].integer = 2;
    
    [observation invalidate];
    observation = nil;
}

- (void)testToManyRelationshipObservations {
    DummyClass *dummy = [[DummyClass alloc] init];
    dummy.array = [NSMutableArray arrayWithObject:[[NSObject alloc] init]];
    dummy.set   = [NSMutableSet setWithObject:@"0"];
    
    SRDKeyValueObservation *observation = [dummy observeKeyPath:@"array" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld changeHandler:^(DummyClass *object, SRDKeyValueObservedChange *change) {
        XCTAssertNil(change.oldValue);
        
        XCTAssertNotNil(change.newValue);
        XCTAssertTrue([change.newValue isKindOfClass:[NSArray class]]);
        XCTAssertTrue(((NSArray *)change.newValue).count == 1);
        
        XCTAssertTrue([change.indexes isEqualToIndexSet:[NSIndexSet indexSetWithIndex:1]]);
        XCTAssertEqual(((NSArray *)change.newValue)[0], dummy.array[1]);
        
        XCTAssertEqual(change.kind, NSKeyValueChangeInsertion);
    }];

    [dummy willChange:NSKeyValueChangeInsertion valuesAtIndexes:[NSIndexSet indexSetWithIndex:1] forKey:@"array"];
    [dummy.array addObject:[[NSObject alloc] init]];
    [dummy didChange:NSKeyValueChangeInsertion valuesAtIndexes:[NSIndexSet indexSetWithIndex:1] forKey:@"array"];
    
    [observation invalidate];
    observation = [dummy observeKeyPath:@"array" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld | NSKeyValueObservingOptionPrior changeHandler:^(DummyClass *object, SRDKeyValueObservedChange *change) {
        XCTAssertNil(change.newValue);
        
        XCTAssertNotNil(change.oldValue);
        XCTAssertTrue([change.oldValue isKindOfClass:[NSArray class]]);
        XCTAssertTrue(((NSArray *)change.oldValue).count == 1);
        
        XCTAssertTrue([change.indexes isEqualToIndexSet:[NSIndexSet indexSetWithIndex:1]]);
        if (change.isPrior) {
            XCTAssertEqual(((NSArray *)change.oldValue)[0], dummy.array[1]);
        }
        
        XCTAssertEqual(change.kind, NSKeyValueChangeRemoval);
    }];

    [dummy willChange:NSKeyValueChangeRemoval valuesAtIndexes:[NSIndexSet indexSetWithIndex:1] forKey:@"array"];
    [dummy.array removeObjectAtIndex:1];
    [dummy didChange:NSKeyValueChangeRemoval valuesAtIndexes:[NSIndexSet indexSetWithIndex:1] forKey:@"array"];
    
    [observation invalidate];
    observation = [dummy observeKeyPath:@"array" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld | NSKeyValueObservingOptionPrior changeHandler:^(DummyClass *object, SRDKeyValueObservedChange *change) {
        if (change.isPrior) {
            XCTAssertNil(change.newValue);
            
            XCTAssertNotNil(change.oldValue);
            XCTAssertTrue([change.oldValue isKindOfClass:[NSArray class]]);
            XCTAssertTrue(((NSArray *)change.oldValue).count == 1);
            
            XCTAssertTrue([change.indexes isEqualToIndexSet:[NSIndexSet indexSetWithIndex:0]]);
            XCTAssertEqual(((NSArray *)change.oldValue)[0], dummy.array[0]);
        }
        else {
            XCTAssertNotNil(change.oldValue);
            XCTAssertTrue([change.oldValue isKindOfClass:[NSArray class]]);
            XCTAssertTrue(((NSArray *)change.oldValue).count == 1);
            
            XCTAssertNotNil(change.newValue);
            XCTAssertTrue([change.newValue isKindOfClass:[NSArray class]]);
            XCTAssertTrue(((NSArray *)change.newValue).count == 1);
            
            XCTAssertTrue([change.indexes isEqualToIndexSet:[NSIndexSet indexSetWithIndex:0]]);
            XCTAssertEqual(((NSArray *)change.newValue)[0], dummy.array[0]);
        }
        
        XCTAssertEqual(change.kind, NSKeyValueChangeReplacement);
    }];

    [dummy willChange:NSKeyValueChangeReplacement valuesAtIndexes:[NSIndexSet indexSetWithIndex:0] forKey:@"array"];
    dummy.array[0] = [[NSObject alloc] init];
    [dummy didChange:NSKeyValueChangeReplacement valuesAtIndexes:[NSIndexSet indexSetWithIndex:0] forKey:@"array"];
    
    
    
    __block NSSet *set = nil;
    [observation invalidate];
    observation = [dummy observeKeyPath:@"set" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld changeHandler:^(DummyClass *object, SRDKeyValueObservedChange *change) {
        XCTAssertNil(change.oldValue);
        
        XCTAssertNotNil(change.newValue);
        XCTAssertTrue([change.newValue isKindOfClass:[NSSet class]]);
        XCTAssertTrue([set isEqualToSet:(NSSet *)change.newValue]);
        XCTAssertTrue([set isSubsetOfSet:dummy.set]);
        
        XCTAssertEqual(change.kind, NSKeyValueChangeInsertion);
    }];
    
    set = [NSSet setWithObjects:@"1", @"2", nil];
    [dummy willChangeValueForKey:@"set" withSetMutation:NSKeyValueUnionSetMutation usingObjects:set];
    [dummy.set unionSet:set];
    [dummy didChangeValueForKey:@"set" withSetMutation:NSKeyValueUnionSetMutation usingObjects:set];
    
    [observation invalidate];
    observation = [dummy observeKeyPath:@"set" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld changeHandler:^(DummyClass *object, SRDKeyValueObservedChange *change) {
        XCTAssertNil(change.newValue);
        
        XCTAssertNotNil(change.oldValue);
        XCTAssertTrue([change.oldValue isKindOfClass:[NSSet class]]);
        XCTAssertTrue([set isEqualToSet:(NSSet *)change.oldValue]);
        XCTAssertFalse([dummy.set intersectsSet:set]);
        
        XCTAssertEqual(change.kind, NSKeyValueChangeRemoval);
    }];
    
    [dummy willChangeValueForKey:@"set" withSetMutation:NSKeyValueMinusSetMutation usingObjects:set];
    [dummy.set minusSet:set];
    [dummy didChangeValueForKey:@"set" withSetMutation:NSKeyValueMinusSetMutation usingObjects:set];
    
    [observation invalidate];
    [dummy.set unionSet:[NSSet setWithObject:@"1"]];
    observation = [dummy observeKeyPath:@"set" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld changeHandler:^(DummyClass *object, SRDKeyValueObservedChange *change) {
        XCTAssertNil(change.newValue);
        
        XCTAssertNotNil(change.oldValue);
        XCTAssertTrue([change.oldValue isKindOfClass:[NSSet class]]);
        XCTAssertFalse([set intersectsSet:(NSSet *)change.oldValue]);
        XCTAssertFalse([dummy.set intersectsSet:(NSSet *)change.oldValue]);
        
        XCTAssertEqual(change.kind, NSKeyValueChangeRemoval);
    }];
    
    [dummy willChangeValueForKey:@"set" withSetMutation:NSKeyValueIntersectSetMutation usingObjects:set];
    [dummy.set intersectSet:set];
    [dummy didChangeValueForKey:@"set" withSetMutation:NSKeyValueIntersectSetMutation usingObjects:set];
    
    [observation invalidate];
    dummy.set = [NSMutableSet setWithObject:@"0"];
    observation = [dummy observeKeyPath:@"set" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld changeHandler:^(DummyClass *object, SRDKeyValueObservedChange *change) {
        XCTAssertNotNil(change.oldValue);
        XCTAssertNotNil(change.newValue);
        
        XCTAssertTrue([change.oldValue isKindOfClass:[NSSet class]]);
        XCTAssertTrue([change.newValue isKindOfClass:[NSSet class]]);
        
        XCTAssertTrue([(NSSet *)change.newValue isSubsetOfSet:dummy.set]);
        XCTAssertFalse([(NSSet *)change.oldValue isSubsetOfSet:dummy.set]);
        
        XCTAssertEqual(change.kind, NSKeyValueChangeReplacement);
    }];
    
    [dummy willChangeValueForKey:@"set" withSetMutation:NSKeyValueSetSetMutation usingObjects:set];
    [dummy.set setSet:set];
    [dummy didChangeValueForKey:@"set" withSetMutation:NSKeyValueSetSetMutation usingObjects:set];

    [observation invalidate];
    observation = nil;
}

- (void)testInvalidateAfterFreeLogs {
    SRDKeyValueObservation* observation;
    @autoreleasepool {
        observation = [[SRDKeyValueObservation alloc] initWithObject:[[DummyClass alloc] init] keyPath:@"integer" options:kNilOptions changeHandler:^(id _, id __) {}];
    }

    [observation invalidate];
}

- (void)testObservedObjectSetToFromNil {
    DummyClass* dummy = [[DummyClass alloc] init];
    SRDKeyValueObservation *observation;
    __block BOOL first = YES;

    observation = [dummy observeKeyPath:@"object" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew changeHandler:^(id object, SRDKeyValueObservedChange *change) {
        if (first) {
            XCTAssertNil(change.oldValue);
            XCTAssertNotNil(change.newValue);

            first = NO;
        }
        else {
            XCTAssertNotNil(change.oldValue);
            XCTAssertNil(change.newValue);
        }
    }];

    dummy.object = [[NSObject alloc] init];
    dummy.object = nil;
}

#pragma mark - NSObject Overrides

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    XCTAssertTrue([keyPath isEqualToString:@"integer2"]);
    self.handler();
}

@end

#pragma mark - Class (DummyClass) Implementation

@implementation DummyClass

#pragma mark - Property Synthesis

@synthesize integer = _integer, integer2 = _integer2, object = _object, array = _array, set = _set;

@end
