//
//  PlacemarkTransitTableViewCell.h
//  TimelyMoves
//
//  Created by Daniel Bolivar herrera on 26/10/2017.
//  Copyright © 2017 Daniel Bolivar herrera. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlacemarkTransitTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *transitMinutes;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *transitViewHeightConstraint;

- (void)configureCellWithTransitMinutes:(double)minutes multiplier:(double)multiplier;

@end
