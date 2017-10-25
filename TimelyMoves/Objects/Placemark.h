//
//  Placemark.h
//  TimelyMoves
//
//  Created by Daniel Bolivar herrera on 25/10/2017.
//  Copyright © 2017 Daniel Bolivar herrera. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface Placemark : NSObject

@property (copy, nonatomic) NSString* name;
@property (nonatomic, assign) CLLocationCoordinate2D location;
@property (strong, nonatomic) NSDate* arrivalDate;
@property (strong, nonatomic) NSDate* departureDate;

@end
