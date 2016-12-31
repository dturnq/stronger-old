//
//  FriendTableViewCell.h
//  MuscleAbuse
//
//  Created by David Turnquist on 7/10/16.
//  Copyright © 2016 David Turnquist. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FriendTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *friendNameLabel;
@property (strong, nonatomic) IBOutlet UIButton *followingButton;

@end
