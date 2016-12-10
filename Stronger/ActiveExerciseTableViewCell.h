//
//  ActiveExerciseTableViewCell.h
//  MuscleAbuse
//
//  Created by David Turnquist on 12/21/15.
//  Copyright © 2015 David Turnquist. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActiveExerciseTableViewCell : UITableViewCell
    
    @property (weak, nonatomic) IBOutlet UILabel *exerciseName;
    @property (weak, nonatomic) IBOutlet UILabel *set1;
    @property (weak, nonatomic) IBOutlet UILabel *set2;
    @property (weak, nonatomic) IBOutlet UILabel *set3;
    @property (weak, nonatomic) IBOutlet UILabel *set4;

@end
