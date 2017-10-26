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
    
    if (tIndex >= 0 && self.places.count > tIndex+1) {
        Placemark *firstPlace = self.places[tIndex];
        Placemark *nextPlace = self.places[tIndex+1];
        
        NSLog(@"departure %@",firstPlace.departureDate);
        NSLog(@"arrival %@",nextPlace.arrivalDate);
    
        NSLog(@"elapsed seconds %f",[nextPlace.arrivalDate timeIntervalSinceDate:firstPlace.departureDate]);
        return [nextPlace.arrivalDate timeIntervalSinceDate:firstPlace.departureDate] / 60;
        
    } else {
        return 0;
    }
}

@end
