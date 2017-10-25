//
//  Transit.h
//  TimelyMoves
//
//  Created by Daniel Bolivar herrera on 25/10/2017.
//  Copyright © 2017 Daniel Bolivar herrera. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Placemark.h"

@interface Transit : NSObject

//A transit is the represented as the coordinates to get from Placemark A (through C,D,E...) to B
//We have an array of places we go through (A,C,D,E,B)
//Then we also have a dictionary that stores locations to reach a new placemark. The key would be the index of the places array, and the value is the array of locations
@property (strong, nonatomic) NSMutableArray *places;
@property (strong, nonatomic) NSMutableDictionary *coordinatesForPlace;

-(void)addNewPlacemark:(Placemark*)place coordinates:(NSArray*)coordinates;

@end
