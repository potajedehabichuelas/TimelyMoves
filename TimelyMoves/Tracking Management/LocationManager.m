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
        [_sharedInstance InitLocationManager];
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

#pragma mark Instance Methods

- (void)InitLocationManager {
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
}

- (void)requestLocationAuth {
    [self.locationManager requestAlwaysAuthorization];
}

@end
