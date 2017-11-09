//
//  TransitTracker.m
//  TimelyMoves
//
//  Created by Daniel Bolivar herrera on 25/10/2017.
//  Copyright © 2017 Daniel Bolivar herrera. All rights reserved.
//

#import "TransitTracker.h"

//Time required to consider a new place (if location is still)
const int STOP_BY_SECONDS = 3;
//Minimun accuracy required (in meters) to consider location
const int MIN_ACCURACY = 150;
//Delegate location update frequency (in seconds); i.e the transitFeedDelegate will be called every this interval
const int UPDATE_FREQUENCY = 5;

#define CLCOORDINATE_NEW_PLACEMARK_EPSILON 0.00001f // around 2.5 metres radious movement to consider that we are still in the same place
#define CLCOORDINATES_IS_IN_PLACEMARK_EQUAL2( coord1, coord2 ) (fabs(coord1.latitude - coord2.latitude) < CLCOORDINATE_NEW_PLACEMARK_EPSILON && fabs(coord1.longitude - coord2.longitude) < CLCOORDINATE_NEW_PLACEMARK_EPSILON)

#define CLCOORDINATE_NEW_LOCATION_EPSILON 0.000009f // Constant value to consider 2 locations are equal (2 meters)
#define CLCOORDINATES_EQUAL2( coord1, coord2 ) (fabs(coord1.latitude - coord2.latitude) < CLCOORDINATE_NEW_LOCATION_EPSILON && fabs(coord1.longitude - coord2.longitude) < CLCOORDINATE_NEW_LOCATION_EPSILON)

@implementation TransitTracker {

    BOOL locationIsStill;
    BOOL firstPlacemarkAdded;
    BOOL departureTimeNeedsUpdating;
    
    NSMutableArray *partialLocations;
    NSDate *timeElapsedStill;
    NSDate *timeElapsedForUpdate;
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
        locationIsStill = YES;
        departureTimeNeedsUpdating = NO;
        firstPlacemarkAdded = NO;
        timeElapsedStill = nil;
        timeElapsedForUpdate = nil;
        reverseGeocoder = [[CLGeocoder alloc] init];
    }
    return self;
}

- (void)updatePlacemarkName:(CLLocation*)location placemark:(Placemark*)place {
    //Geodecode address
    
    if (reverseGeocoder) {
        place.name = @"Loading address...";
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
            [self.transitFeedDelegate placemarkDidUpdateName:place];
        }];
    }
}

- (void)createNewPlacemarkWithLocation:(CLLocation*)location {
    
    //First create the object and add it to the Transits along with the coordinates (if there were any)
    Placemark *newPlace = [[Placemark alloc] initWithPlaceName:@"" location:location.coordinate arrivalDate:[NSDate date] departureDate:nil];
    //Note for the line 86
    // I was using the locations timestamp property, but it was returning a date which was one minute before the actual date timestamp -> location.timestamp
    
    
    //We add it firstly into the array, then geodecoding address to avoid items potentially coming in different order
    [self updatePlacemarkName:location placemark:newPlace];
    
    [self.transit.places addObject:newPlace];
    
    //Later on we will update departure date (if the location changes) (not for the first item)
    departureTimeNeedsUpdating = YES;
    
    //Call delegate to update the marker
    [self.transitFeedDelegate placemarkDidUpdate:self.transit];
    
    //Clear the structure
    partialLocations = [[NSMutableArray alloc] init];
    //Initial point would be the same as last of the previous leg (it is also useful as we need a previous location to compare)
    [partialLocations addObject:location];
}

- (void)updateLastPlaceMarkDepartureTime:(NSDate*)departureTime {
    //Update last placeholder departure time
    Placemark* lastPlace = [self.transit.places lastObject];
    lastPlace.departureDate = departureTime;
    departureTimeNeedsUpdating = NO;
}

- (void)linkLocationArrayToPlacemark {
    //Set the reference that would hold the locations
    NSString* dictKey = [NSString stringWithFormat:@"%lul",(self.transit.places.count-1)];
    [self.transit.coordinatesForPlace setObject:partialLocations forKey:dictKey];
    [self.transitFeedDelegate transitDidStart:self.transit];
}

#pragma mark LocationFeedDelegate Methods

- (void)locationUpdated:(CLLocation*)newLoc {
    
    CLLocation* lastLocation = [partialLocations lastObject];

    if (newLoc.horizontalAccuracy > MIN_ACCURACY || newLoc.verticalAccuracy > MIN_ACCURACY) {
        NSLog(@"TransitTracker Error: Location is not accurate enough");
        return;
    }
    
    //Compare locations to check if they're equal (can't be exactly equal since they contain Double values)
    if (CLCOORDINATES_EQUAL2(newLoc.coordinate, lastLocation.coordinate) || !firstPlacemarkAdded) {
    
        //Check if the 'locationIsStill' flag was already set to true (location has been still for a while)
        if (!locationIsStill && firstPlacemarkAdded) {
            NSLog(@"Location is still: Initializing timer");
            //Set bool flagt to true
            locationIsStill = YES;
            //start the timer (elapsed time) to determine if we should add a placemark
            timeElapsedStill = [NSDate date];
            
        } else if ((locationIsStill && ([[NSDate date] timeIntervalSinceDate:timeElapsedStill] > STOP_BY_SECONDS)) || !firstPlacemarkAdded) {
            
            //Check if the elapsed time is more than the value set by 'STOP_BY_SECONDS'
            NSLog(@"Creating new placemark: User has been still for too long!");
            
            //We need to keep 'locationIsStill' as YES since we are not moving (we add a placemark because we are staying still!) and this should not change after we add a placemark
            //We do set the timer to nil to avoid creating placemarks everytime we enter
            timeElapsedStill = nil;
            
            //Create & add a new placemark
            [self createNewPlacemarkWithLocation:newLoc];
            if (!firstPlacemarkAdded) {firstPlacemarkAdded = YES;}
        }
        
    } else {
        
        //First location is always the placemark's base, so if we are still in a radious of
        // 'CLCOORDINATE_NEW_PLACEMARK_EPSILON' meters we dont consider we are moving
        
        CLLocation *lastPlacemarkLoc = partialLocations.firstObject;
        //Translation, if there is only one location in the array and this location is within a radious of
        // 'CLCOORDINATE_NEW_PLACEMARK_EPSILON' meters then we are not moving
        // If there are more locations in the array this condition is not valid as it means we just came back to the placemark
        // location but we are still moving
        
        if (partialLocations.count == 1 && CLCOORDINATES_IS_IN_PLACEMARK_EQUAL2(newLoc.coordinate, lastPlacemarkLoc.coordinate)) {
            return;
        }
        
        NSLog(@"%d",(int)partialLocations.count);
        NSLog(@"distance is %d", CLCOORDINATES_IS_IN_PLACEMARK_EQUAL2(newLoc.coordinate, lastPlacemarkLoc.coordinate));
        
        NSLog(@"User is moving");
        //If there different we need to make sure we reset flags & timer
        locationIsStill = NO;
        timeElapsedStill = nil;
        
        //Add the location to the array - to avoid having components with virtually the same location
        [partialLocations addObject:newLoc];
        
        if (departureTimeNeedsUpdating) {
            [self updateLastPlaceMarkDepartureTime:newLoc.timestamp];
            [self linkLocationArrayToPlacemark];
        }
        
    }
    
    if (timeElapsedForUpdate == nil) {
        //Start the timer to schedule the next delegate update
        timeElapsedForUpdate = [NSDate date];
    } else {
        if ([[NSDate date] timeIntervalSinceDate:timeElapsedForUpdate] > UPDATE_FREQUENCY) {
            //Call the delegate to start updating this section
            [self.transitFeedDelegate transitDidUpdate:transit];
            timeElapsedForUpdate = nil;
        }
    }
}

@end
