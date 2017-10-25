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

@interface LocationManager : NSObject <CLLocationManagerDelegate>

@property (strong,nonatomic) CLLocationManager *locationManager;
@property (nonatomic, weak) id  authChangedDelegate;

#pragma mark Instance Methods
- (void)requestLocationAuth;

#pragma mark Class Methods
+ (LocationManager *)sharedManager;
+ (BOOL)locationAccessGranted;
+ (AuthorizationStatus)getLocationAuthAccess;

@end
