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

@interface TrackerTableViewController ()

@end

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

#pragma mark - TransitFeedDelegate methods

- (void)transitDidUpdate:(Transit *)transit {
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

@end
