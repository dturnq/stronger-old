//
//  ViewFriendsTableViewController.h
//  MuscleAbuse
//
//  Created by David Turnquist on 7/15/16.
//  Copyright © 2016 David Turnquist. All rights reserved.
//

#import <UIKit/UIKit.h>
@import Firebase;
@import FirebaseDatabase;
@import FirebaseDatabaseUI;
#import "FriendTableViewCell.h"

@interface ViewFriendsTableViewController : UITableViewController

@property (strong, nonatomic) FIRDatabaseReference *firebaseRef;
@property (strong, nonatomic) FIRDatabaseReference *firebaseFollowersRef;
@property (strong, nonatomic) FUITableViewDataSource *dataSource;
@property (strong, nonatomic) FIRDatabaseQuery *FIRDatabaseQuery;


@property (strong, nonatomic) FIRDataSnapshot *selectedExerciseSnap;

@end
