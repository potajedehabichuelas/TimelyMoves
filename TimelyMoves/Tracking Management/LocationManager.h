//
//  LocationManager.h
//  TimelyMoves
//
//  Created by Daniel Bolivar herrera on 25/10/2017.
//  Copyright © 2017 Daniel Bolivar herrera. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

typedef NS_ENUM(NSInteger, AuthorizationStatus) {
    LocAuthStatusGranted,
    LocAuthStatusDenied,
    LocAuthStatuUndetermined
};

@protocol LocationAuthChangedDelegate
- (void)locationAuthChanged:(AuthorizationStatus)newAuth;
@end

@protocol LocationFeedDelegate
- (void)locationUpdated:(CLLocation*)newLoc speed:(double)speed;
@end

@interface LocationManager : NSObject <CLLocationManagerDelegate>

@property (strong,nonatomic) CLLocationManager *locationManager;

@property (nonatomic, weak) id authChangedDelegate;
@property (nonatomic, weak) id locationFeedDelegate;

#pragma mark Instance Methods
- (void)requestLocationAuth;
- (void)startUpdatingLocationWithDelegate:(id)delegate;

#pragma mark Class Methods
+ (LocationManager *)sharedManager;
+ (BOOL)locationAccessGranted;
+ (AuthorizationStatus)getLocationAuthAccess;

@end
