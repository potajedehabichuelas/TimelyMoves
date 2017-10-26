//
//  Transit.m
//  TimelyMoves
//
//  Created by Daniel Bolivar herrera on 25/10/2017.
//  Copyright © 2017 Daniel Bolivar herrera. All rights reserved.
//

#import "Transit.h"

@implementation Transit

-(id)init {
    if (self = [super init]) {
        self.coordinatesForPlace = [[NSMutableDictionary alloc] init];
        self.places = [[NSMutableArray alloc] init];
    }
    return self;
}

- (double)getTransitMinutesForTransitIndex:(int)tIndex {
    
    if (tIndex < 0){
        return 0;
    } else {
        Placemark *firstPlace = self.places[tIndex];
        if (self.places.count <= tIndex+1) {
            //There is no next place so we are still in transit
            return [[NSDate date] timeIntervalSinceDate:firstPlace.departureDate] / 60;
        } else {
            Placemark *nextPlace = self.places[tIndex+1];
            return [nextPlace.arrivalDate timeIntervalSinceDate:firstPlace.departureDate] / 60;
        }
    }
}

@end
