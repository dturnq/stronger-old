//
//  WorkoutSummaryTableViewCell.m
//  MuscleAbuse
//
//  Created by David Turnquist on 7/31/16.
//  Copyright © 2016 David Turnquist. All rights reserved.
//

#import "WorkoutSummaryTableViewCell.h"

@implementation WorkoutSummaryTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.userProfileImage.layer.cornerRadius = self.userProfileImage.frame.size.width / 2;
    self.userProfileImage.clipsToBounds = YES;
    self.userProfileImage.layer.borderWidth = 1.0f;
    self.userProfileImage.layer.borderColor = [UIColor blackColor].CGColor;
    //self.userProfileImage.frame = CGRectMake(self.userProfileImage.frame.origin.x, self.userProfileImage.frame.origin.y, 40,40);
    //self.userProfileImage.center = self.userProfileImage.superview.center;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
