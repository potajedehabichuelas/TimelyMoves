//
//  WelcomeViewController.m
//  TimelyMoves
//
//  Created by Daniel Bolivar herrera on 25/10/2017.
//  Copyright © 2017 Daniel Bolivar herrera. All rights reserved.
//

#import "WelcomeViewController.h"
#import "InterfaceUtilities.h"

NSString *const showTrackerSegue = @"showPlacesSegue";

@interface WelcomeViewController () {
}
    
@end

@implementation WelcomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[LocationManager sharedManager] setAuthChangedDelegate:self];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)requestAccess:(UIButton *)sender {
    
    [InterfaceUtilities buttonScaleAnimation:sender];
    
    if ([LocationManager getLocationAuthAccess ] == LocAuthStatuUndetermined) {
        [[LocationManager sharedManager] requestLocationAuth];
    } else if ([LocationManager getLocationAuthAccess ] == LocAuthStatusDenied) {
        [self presentAlertWithTitle:@"Location access Denied" message:@"Please open this app's settings and grant location access"];
    }
}

- (void)presentAlertWithTitle:(NSString*)title message:(NSString*)message {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok"
                                                       style:UIAlertActionStyleDefault
                                                     handler:nil];
    [alertController addAction:actionOk];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)locationAuthChanged:(AuthorizationStatus)newAuth {
    if (newAuth == LocAuthStatusDenied) {
        // Inform User
        [self presentAlertWithTitle:@"Location access Denied" message:@"Please open this app's settings and grant location access"];
    } else if (newAuth == LocAuthStatusGranted) {
        //Go to TrackerTableVC
        [self performSegueWithIdentifier:showTrackerSegue sender:self];
    }
}

@end
