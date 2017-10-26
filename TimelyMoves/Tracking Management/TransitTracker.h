//
//  TransitTracker.h
//  TimelyMoves
//
//  Created by Daniel Bolivar herrera on 25/10/2017.
//  Copyright © 2017 Daniel Bolivar herrera. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LocationManager.h"
#import "Transit.h"

@protocol TransitFeedDelegate
- (void)transitDidUpdate:(Transit*)transit;
- (void)placemarkDidUpdate:(Transit*)transit;
@end

@interface TransitTracker : NSObject <LocationFeedDelegate>

@property (strong, nonatomic) Transit* transit;
@property (nonatomic, weak) id transitFeedDelegate;

#pragma mark Class Methods
+ (TransitTracker *)sharedManager;

@end
