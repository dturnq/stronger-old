//
//  WorkoutHistoryTableViewCell.m
//  MuscleAbuse
//
//  Created by David Turnquist on 8/6/16.
//  Copyright © 2016 David Turnquist. All rights reserved.
//

#import "WorkoutHistoryTableViewCell.h"

@implementation WorkoutHistoryTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.userProfileImage.layer.cornerRadius = self.userProfileImage.frame.size.width / 2;
    self.userProfileImage.clipsToBounds = YES;
    self.userProfileImage.layer.borderWidth = 1.0f;
    self.userProfileImage.layer.borderColor = [UIColor blackColor].CGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
