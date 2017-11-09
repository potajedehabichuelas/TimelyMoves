//
//  LocationManager.m
//  TimelyMoves
//
//  Created by Daniel Bolivar herrera on 25/10/2017.
//  Copyright © 2017 Daniel Bolivar herrera. All rights reserved.
//

#import "LocationManager.h"

@implementation LocationManager 

#pragma mark Class Methods

+ (LocationManager *)sharedManager {
    
    static LocationManager *_sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[self alloc] init];
    });
    
    return _sharedInstance;
}

+ (BOOL)locationAccessGranted {
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse) {
        return YES;
    } else {
        return NO;
    }
}

- (void)startUpdatingLocationWithDelegate:(id)delegate {
    //Starts updating location and sets the delegate that would receive the location's information
    self.locationFeedDelegate = delegate;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    self.locationManager.allowsBackgroundLocationUpdates = YES;
    self.locationManager.pausesLocationUpdatesAutomatically = YES;
    [self.locationManager startUpdatingLocation];
}

+ (AuthorizationStatus)getLocationAuthAccess {
    
    switch ([CLLocationManager authorizationStatus]) {
        case kCLAuthorizationStatusAuthorizedAlways | kCLAuthorizationStatusAuthorizedWhenInUse :
            return LocAuthStatusGranted;
            break;
            
        case kCLAuthorizationStatusNotDetermined:
            return LocAuthStatuUndetermined;
            break;
            
        case kCLAuthorizationStatusDenied:
            return LocAuthStatusDenied;
            break;
        default:
            return LocAuthStatuUndetermined;
            break;
    }
}

#pragma mark CLLocationManager Delegate

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if (status == kCLAuthorizationStatusDenied) {
        // Inform User
        if (self.authChangedDelegate != nil) {
            [self.authChangedDelegate locationAuthChanged:LocAuthStatusDenied];
        }
    } else if ([LocationManager locationAccessGranted]) {
        if (self.authChangedDelegate != nil) {
            [self.authChangedDelegate locationAuthChanged:LocAuthStatusGranted];
        }
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    
    CLLocation *newLocation = [locations lastObject];
    
    if (newLocation != nil) {
        //Send the location to the listener
        [self.locationFeedDelegate locationUpdated:newLocation];
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"Location manager could not retrieve location: %@", error);
}

#pragma mark Instance Methods

-(id)init {
    if (self = [super init]) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
    }
    return self;
}

- (void)requestLocationAuth {
    [self.locationManager requestAlwaysAuthorization];
}

@end
