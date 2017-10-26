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

@interface TrackerTableViewController ()

@end

NSString* const PLACEMARK_TRANSIT_CELLID = @"PlacemarkTransitTableViewCell";
NSString* const PLACEMARK_CELLID = @"PlacemarkTableViewCell";
NSString* const HEADER_CELLID = @"headerCell";


@implementation TrackerTableViewController {
    TransitTracker* transits;
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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLayoutSubviews {
    
    if (self.tableView.contentSize.height < self.tableView.frame.size.height) {
        self.tableView.scrollEnabled = NO;
    } else {
        self.tableView.scrollEnabled = YES;
    }
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

- (void)transitDidUpdate:(Transit *)transit {
    
    [self.tableView reloadData];
}

#pragma mark - Table view Delegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:HEADER_CELLID];
    
    return cell.contentView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 120;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return transits.transit.places.count;// + transits.transit.coordinatesForPlace.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row % 2 == 0) {
        //First cell & even indexpaths are going to be placemarks alwasy
        PlacemarkTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:PLACEMARK_CELLID forIndexPath:indexPath];
        
        //Retrieve object
        Placemark *place = transits.transit.places[indexPath.row];
        [cell configureCellWithTransitWithName:place.name departureTime:place.departureDate arrivalTime:place.arrivalDate];
        
        return cell;
    } else {
        PlacemarkTransitTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:PLACEMARK_TRANSIT_CELLID forIndexPath:indexPath];
        int minutes = [transits.transit getTransitMinutesForTransitIndex:(int)indexPath.row-1];
        //The height of the walking section would vary height depending on how much time the user has been moving
        
        double multiplier = [self convertRangeOfMinutes:minutes];
        
        [cell configureCellWithTransitMinutes:minutes multiplier:multiplier];
        [self.tableView layoutIfNeeded];
        return cell;
    }

}

@end
