//
//  WorkoutHistoryFBTableViewController.h
//  MuscleAbuse
//
//  Created by David Turnquist on 2/27/16.
//  Copyright © 2016 David Turnquist. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WorkoutHistoryTableViewCell.h"
@import Firebase;
@import FirebaseDatabase;
@import FirebaseDatabaseUI;

@interface WorkoutHistoryFBTableViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) FIRDatabaseReference *firebaseRef;
@property (strong, nonatomic) FIRDatabaseReference *firebaseWorkoutsRef;
@property (strong, nonatomic) FUITableViewDataSource *dataSource;
@property (strong, nonatomic) FIRDatabaseQuery *FIRDatabaseQuery;

@property (strong, nonatomic) FIRDataSnapshot *selectedWorkoutSnap;



@end
