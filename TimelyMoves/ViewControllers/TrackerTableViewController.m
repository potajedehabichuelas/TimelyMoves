//
//  TrackerTableViewController.m
//  TimelyMoves
//
//  Created by Daniel Bolivar herrera on 25/10/2017.
//  Copyright © 2017 Daniel Bolivar herrera. All rights reserved.
//

#import "TrackerTableViewController.h"
#import "TransitTracker.h"
#import "LocationManager.h"
#import "PlacemarkTableViewCell.h"
#import "PlacemarkTransitTableViewCell.h"
#import "DGActivityIndicatorView.h"
#import "RMessage.h"

@interface TrackerTableViewController ()

@end

NSString* const PLACEMARK_TRANSIT_CELLID = @"PlacemarkTransitTableViewCell";
NSString* const PLACEMARK_CELLID = @"PlacemarkTableViewCell";
NSString* const HEADER_CELLID = @"headerCell";


@implementation TrackerTableViewController {
    TransitTracker* transits;
    DGActivityIndicatorView *activityIndicatorView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // This will remove extra separators from tableview
    self.tableView.tableFooterView = [UIView new];
    
    //Create a tracker object
    transits = [TransitTracker sharedManager];
    transits.transitFeedDelegate = self;
    
    //Start updating location
    [[LocationManager sharedManager] startUpdatingLocationWithDelegate:transits];
    
    activityIndicatorView = [[DGActivityIndicatorView alloc] initWithType:DGActivityIndicatorAnimationTypeDoubleBounce tintColor:[UIColor whiteColor] size:30.0f];
    activityIndicatorView.frame = CGRectMake(0.0f, 0.0f, 80.0f, 80.0f);
    activityIndicatorView.center = self.view.center;
    [self.view addSubview:activityIndicatorView];
    [activityIndicatorView startAnimating];
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self presentWaitNotification];
    });
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLayoutSubviews {
    
    if (self.tableView.contentSize.height * 1.1 < self.tableView.frame.size.height) {
        self.tableView.scrollEnabled = NO;
    } else {
        self.tableView.scrollEnabled = YES;
    }
}

- (void)presentWaitNotification {
    [RMessage showNotificationWithTitle:@"Please wait while we retrieve your location"
                               subtitle:@""
                                   type:RMessageTypeWarning
                         customTypeName:nil
                               callback:nil];
}

- (double)convertRangeOfMinutes:(double)minutes {
    //Returns a float in between 0.3 - 1.5
    minutes = minutes > 200 ? 200 : minutes;
    
    CGFloat const inMin = 0.0;
    CGFloat const inMax = 200;
    
    CGFloat const outMin = 0.3;
    CGFloat const outMax = 1.5;
    
    return  outMin + (outMax - outMin) * (minutes - inMin) / (inMax - inMin);
}

#pragma mark - TransitFeedDelegate methods


- (void)placemarkDidUpdateName:(Placemark*)place {
    [self.tableView reloadData];
}

- (void)placemarkDidUpdate:(Transit *)transit {
    if (transit.places.count > 0) {
        //Insert placemark
        [self.tableView beginUpdates];
        [self.tableView insertSections:[NSIndexSet indexSetWithIndex:transit.places.count-1]  withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView endUpdates];
    }
    
    if ([activityIndicatorView animating]) {
        [activityIndicatorView stopAnimating];
    }
}

- (void)transitDidStart:(Transit*)transit {
    //Insert new transit
    if (transit.places.count > 0) {
        [self.tableView beginUpdates];
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:transit.places.count-1]] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView insertRowsAtIndexPaths: @[[NSIndexPath indexPathForRow:1 inSection:transit.places.count-1]] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView endUpdates];
    }
}

- (void)transitDidUpdate:(Transit *)transit {
    [self.tableView beginUpdates];
    [self.tableView reloadData];
    [self.tableView endUpdates];
}

#pragma mark - Table view Delegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:HEADER_CELLID];
        return cell.contentView;
    } else {
        return [UIView new];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 120;
    } else {
        return 0;
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return transits.transit.places.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (transits.transit.coordinatesForPlace.count > section) {
        return 2;
    } else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        //First cell & even indexpaths are going to be placemarks alwasy
        PlacemarkTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:PLACEMARK_CELLID forIndexPath:indexPath];
        
        //Retrieve object
        Placemark *place = transits.transit.places[indexPath.section];
        [cell configureCellWithTransitWithName:place.name departureTime:place.departureDate arrivalTime:place.arrivalDate];
        
        return cell;
    } else {
        PlacemarkTransitTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:PLACEMARK_TRANSIT_CELLID forIndexPath:indexPath];

        int minutes = [transits.transit getTransitMinutesForSection:(int)indexPath.section];
        //The height of the walking section would vary height depending on how much time the user has been moving
        
        double multiplier = [self convertRangeOfMinutes:minutes];
        
        [cell configureCellWithTransitMinutes:minutes multiplier:multiplier];
        [self.tableView layoutIfNeeded];
        return cell;
    }

}

@end
