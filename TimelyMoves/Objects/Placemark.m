//
//  Placemark.m
//  TimelyMoves
//
//  Created by Daniel Bolivar herrera on 25/10/2017.
//  Copyright © 2017 Daniel Bolivar herrera. All rights reserved.
//

#import "Placemark.h"

@implementation Placemark

-(id)init {
    if (self = [super init]) {
        self.name = nil;
        self.location = kCLLocationCoordinate2DInvalid;
        self.arrivalDate = nil;
        self.departureDate = nil;
    }
    return self;
}

- (id)initWithPlaceName:(NSString*)name location:(CLLocationCoordinate2D)coordinate arrivalDate:(NSDate*)arrival departureDate:(NSDate*)departure {
    self = [super init];
    if(self) {
        self.name = name;
        self.location = coordinate;
        self.arrivalDate = arrival;
        self.departureDate = departure;
    }
    return self;
}

@end
