//
//  TransitTracker.m
//  TimelyMoves
//
//  Created by Daniel Bolivar herrera on 25/10/2017.
//  Copyright © 2017 Daniel Bolivar herrera. All rights reserved.
//

#import "TransitTracker.h"

const int STOP_BY_SECONDS = 3;

#define CLCOORDINATE_EPSILON 0.005f
#define CLCOORDINATES_EQUAL2( coord1, coord2 ) (fabs(coord1.latitude - coord2.latitude) < CLCOORDINATE_EPSILON && fabs(coord1.longitude - coord2.longitude) < CLCOORDINATE_EPSILON)

@implementation TransitTracker {

    BOOL locationIsStill;
    BOOL firstPlacemarkAdded;
    BOOL departureTimeNeedsUpdating;
    
    NSMutableArray *partialLocations;
    NSDate *timeElapsedStill;
    CLGeocoder* reverseGeocoder;
}

@synthesize transit;

+ (TransitTracker *)sharedManager {
    
    static TransitTracker *_sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[self alloc] init];
    });
    
    return _sharedInstance;
}

-(id)init {
    if (self = [super init]) {
        self.transit = [[Transit alloc] init];
        partialLocations = [[NSMutableArray alloc] init];
        locationIsStill = NO;
        departureTimeNeedsUpdating = NO;
        firstPlacemarkAdded = NO;
        timeElapsedStill = nil;
        reverseGeocoder = [[CLGeocoder alloc] init];
    }
    return self;
}

- (void)updatePlacemarkName:(CLLocation*)location placemark:(Placemark*)place {
    //Geodecode address

    if (reverseGeocoder) {
        [reverseGeocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
            CLPlacemark* placemark = [placemarks firstObject];
            NSString* locationName = @"";
            if (placemark) {
                if (placemark.name != nil) {
                    locationName = placemark.name;
                } else {
                    locationName = placemark.locality;
                }
            } else {
                locationName = @"Nameless place";
            }
            [place setName:locationName];
            //Call delegate to update the marker
            [self.transitFeedDelegate transitDidUpdate:self.transit];
        }];
    }
}


- (void)createNewPlacemarkWithLocation:(CLLocation*)location {
    
    //First create the object and add it to the Transits along with the coordinates (if there were any)
    Placemark *newPlace = [[Placemark alloc] initWithPlaceName:@"" location:location.coordinate arrivalDate:location.timestamp departureDate:nil];
    //We add it firstly into the array, then geodecoding address to avoid items potentially coming in different order
    [self updatePlacemarkName:location placemark:newPlace];
    
    [self.transit.places addObject:newPlace];
    
    //Add array of coordinates and placemark object
    if (self.transit.places.count == 0 ) {
        //If it's the first placemark in the array we don't store coordinate array (this is the startup point / placemark)
        newPlace.departureDate = [NSDate date];
    } else {
        NSString* dictKey = [NSString stringWithFormat:@"%lul",(self.transit.places.count-1)];
        [self.transit.coordinatesForPlace setObject:partialLocations forKey:dictKey];
        
        //Later on we will update departure date (if the location changes) (not for the first item)
        departureTimeNeedsUpdating = YES;
    }
    
    //Clear the structure
    partialLocations = [[NSMutableArray alloc] init];
}

- (void)updateLastPlaceMarkDepartureTime:(NSDate*)departureTime {
    //Update last placeholder departure time
    Placemark* lastPlace = [self.transit.places lastObject];
    lastPlace.departureDate = departureTime;
}

#pragma mark LocationFeedDelegate Methods

- (void)locationUpdated:(CLLocation*)newLoc {
    
    CLLocation* lastLocation = [partialLocations lastObject];
    
    if (!firstPlacemarkAdded) {
        //If this is the first location we got, we add it straightaway
        [self createNewPlacemarkWithLocation:newLoc];
        firstPlacemarkAdded = YES;
    }
    
    //Compare locations to check if they're equal (can't be exactly equal since they contain Double values)
    if (CLCOORDINATES_EQUAL2(newLoc.coordinate, lastLocation.coordinate)) {
    
        //Check if the 'locationIsStill' flag was already set to true (location has been still for a while)
        if (!locationIsStill) {
            NSLog(@"USER LOCATION IS STILL: INITIALIZING TIMER");
            //Set bool flagt to true
            locationIsStill = YES;
            //start the timer (elapsed time) to determine if we should add a placemark
            timeElapsedStill = [NSDate date];
            
        } else if (locationIsStill && [[NSDate date] timeIntervalSinceDate:timeElapsedStill] > STOP_BY_SECONDS) {
            
            //Check if the elapsed time is more than the value set by 'STOP_BY_SECONDS'
            NSLog(@"CREATING NEW PLACEMARK: ELAPSED TIME %f", [[NSDate date] timeIntervalSinceDate:timeElapsedStill]);
            
            locationIsStill = NO;
            timeElapsedStill = nil;
            
            //Create & add a new placemark
            [self createNewPlacemarkWithLocation:lastLocation];
        }
        
    } else {
        NSLog(@"USER LOCATION IS MOVING");
        //If there different we need to make sure we reset flags & timer
        locationIsStill = NO;
        timeElapsedStill = nil;
        
        //Add the location to the array - to avoid having components with virtually the same location
        [partialLocations addObject:newLoc];
        
        if (departureTimeNeedsUpdating) {
            [self updateLastPlaceMarkDepartureTime:newLoc.timestamp];
        }
        
    }
}

@end
