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

-(void)addNewPlacemark:(Placemark*)place coordinates:(NSArray*)coordinates {
    
    
}

@end
