//
//  WorkoutHistoryTableViewCell.h
//  MuscleAbuse
//
//  Created by David Turnquist on 8/6/16.
//  Copyright © 2016 David Turnquist. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WorkoutHistoryTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *userProfileImage;
@property (strong, nonatomic) IBOutlet UILabel *workoutNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *userDisplayNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *workoutDateLabel;

@end
