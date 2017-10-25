//
//  InterfaceUtilities.m
//  TimelyMoves
//
//  Created by Daniel Bolivar herrera on 25/10/2017.
//  Copyright © 2017 Daniel Bolivar herrera. All rights reserved.
//

#import "InterfaceUtilities.h"

@implementation InterfaceUtilities

+ (void)buttonScaleAnimation:(UIButton *)button; {
    
    [UIView animateWithDuration:0.15
                          delay:0
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         button.transform = CGAffineTransformMakeScale(0.9, 0.9);
                     }
                     completion:^(BOOL finished) {
                         [UIView animateWithDuration:0.15
                                               delay:0
                                             options: UIViewAnimationOptionCurveEaseOut
                                          animations:^{
                                              button.transform = CGAffineTransformIdentity;
                                          }
                                  completion:nil];
                     }];
}

@end
