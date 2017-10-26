//
//  TransitTests.m
//  TimelyMovesTests
//
//  Created by Daniel Bolivar herrera on 26/10/2017.
//  Copyright © 2017 Daniel Bolivar herrera. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Transit.h"
#import "Placemark.h"

@interface TransitTests : XCTestCase

@end

int FIRST_TRANSIT_MINUTES = 3290;

@implementation TransitTests {
    Transit* transit;
}

- (void)setUp {
    [super setUp];
    
    transit = [[Transit alloc] init];
    
    CLLocationCoordinate2D loc1 = CLLocationCoordinate2DMake(0.239023, 32.3284829);
    NSDate *arrival1 = [NSDate date];
    NSDate *departure1 = [arrival1 dateByAddingTimeInterval:90];
    Placemark *place1 = [[Placemark alloc] initWithPlaceName:@"Chatswood" location:loc1 arrivalDate:arrival1 departureDate:departure1];
    
    CLLocationCoordinate2D loc2 = CLLocationCoordinate2DMake(0.23903, 32.32849);
    NSDate *arrival2 = [departure1 dateByAddingTimeInterval:(FIRST_TRANSIT_MINUTES*60)];
    NSDate *departure2 = [departure1 dateByAddingTimeInterval:90];
    Placemark *place2 = [[Placemark alloc] initWithPlaceName:@"Chatswood Central" location:loc2 arrivalDate:arrival2 departureDate:departure2];
    
    [transit.places addObject:place1];
    [transit.places addObject:place2];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testTransitMinutesForSection {
    int minutes = [transit getTransitMinutesForSection:0];
    XCTAssertEqual(minutes, FIRST_TRANSIT_MINUTES);
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
