//
//  WorkoutSummaryTableViewCell.h
//  MuscleAbuse
//
//  Created by David Turnquist on 7/31/16.
//  Copyright © 2016 David Turnquist. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WorkoutSummaryTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *workoutNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *userNameLabel;
@property (strong, nonatomic) IBOutlet UIImageView *userProfileImage;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UILabel *prLabel;
@property (strong, nonatomic) IBOutlet UILabel *exercisesLabel;
@property (strong, nonatomic) IBOutlet UILabel *minutesLabel;
@property (strong, nonatomic) IBOutlet UILabel *setsLabel;
@property (strong, nonatomic) IBOutlet UILabel *repsLabel;
@property (strong, nonatomic) IBOutlet UILabel *lbsLabel;

@end
