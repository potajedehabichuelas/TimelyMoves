//
//  PlacemarkTableViewCell.m
//  TimelyMoves
//
//  Created by Daniel Bolivar herrera on 26/10/2017.
//  Copyright © 2017 Daniel Bolivar herrera. All rights reserved.
//

#import "PlacemarkTableViewCell.h"

@implementation PlacemarkTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configureCellWithTransitWithName:(NSString*)name departureTime:(NSDate*)departure arrivalTime:(NSDate*)arrival {
    self.name.text = name;
    
    NSDateFormatter *timeFormat = [[NSDateFormatter alloc] init];
    [timeFormat setDateFormat:@"HH:mm"];
    
    NSDate *departureTime = departure == nil ? [NSDate date] : departure;
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components: NSCalendarUnitMinute
                                                                   fromDate: arrival toDate: departureTime options: 0];
    
    self.transitMinutes.text = [NSString stringWithFormat:@"%li min", (long)[components minute]];
    
    self.departureTime.text = departure == nil ?  @"--:--" : [timeFormat stringFromDate:departure];
    
    self.arrivalTime.text =  [timeFormat stringFromDate:arrival];
}

@end
