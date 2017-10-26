//
//  PlacemarkTests.m
//  TimelyMovesTests
//
//  Created by Daniel Bolivar herrera on 26/10/2017.
//  Copyright © 2017 Daniel Bolivar herrera. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Placemark.h"

@interface PlacemarkTests : XCTestCase

@end

@implementation PlacemarkTests 

- (void)setUp {
    [super setUp];
    
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testPlacemarkInitializer {
    CLLocationCoordinate2D loc = CLLocationCoordinate2DMake(0.239023, 32.3284829);
    NSDate *arrival = [NSDate dateWithTimeIntervalSince1970:293043];
    NSDate *departure = [NSDate dateWithTimeIntervalSince1970:3240923];
    
    Placemark *place = [[Placemark alloc] initWithPlaceName:@"Chatswood" location:loc arrivalDate:arrival departureDate:departure];
    
    XCTAssertEqual(place.name, @"Chatswood");
    XCTAssertEqual(loc.latitude, place.location.latitude);
    XCTAssertEqual(loc.longitude, place.location.longitude);
    XCTAssertEqual(place.arrivalDate, arrival);
    XCTAssertEqual(place.departureDate, departure);
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
