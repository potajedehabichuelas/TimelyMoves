//
//  WelcomeViewController.h
//  TimelyMoves
//
//  Created by Daniel Bolivar herrera on 25/10/2017.
//  Copyright © 2017 Daniel Bolivar herrera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocationManager.h"

@interface WelcomeViewController : UIViewController  <LocationAuthChangedDelegate>

@property (weak, nonatomic) IBOutlet UIButton *allowAccessButton;

@end
