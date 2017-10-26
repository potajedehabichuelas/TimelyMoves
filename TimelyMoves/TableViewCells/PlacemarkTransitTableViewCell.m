//
//  PlacemarkTransitTableViewCell.m
//  TimelyMoves
//
//  Created by Daniel Bolivar herrera on 26/10/2017.
//  Copyright © 2017 Daniel Bolivar herrera. All rights reserved.
//

#import "PlacemarkTransitTableViewCell.h"

@implementation PlacemarkTransitTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configureCellWithTransitMinutes:(double)minutes multiplier:(double)multiplier {
    self.transitMinutes.text = [NSString stringWithFormat:@"%g min", minutes];
    self.transitViewHeightConstraint.constant = 120 * multiplier;
    NSLog(@"CONSTANT IS %f", self.transitViewHeightConstraint.constant);
    
}

@end
