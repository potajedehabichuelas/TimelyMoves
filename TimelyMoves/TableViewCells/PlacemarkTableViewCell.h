//
//  PlacemarkTableViewCell.h
//  TimelyMoves
//
//  Created by Daniel Bolivar herrera on 26/10/2017.
//  Copyright © 2017 Daniel Bolivar herrera. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlacemarkTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *transitMinutes;
@property (weak, nonatomic) IBOutlet UILabel *departureTime;
@property (weak, nonatomic) IBOutlet UILabel *arrivalTime;

- (void)configureCellWithTransitWithName:(NSString*)name departureTime:(NSDate*)departure arrivalTime:(NSDate*)arrival;

@end
