//
//  WorkoutHistoryDetailFBTableViewController.h
//  MuscleAbuse
//
//  Created by David Turnquist on 2/27/16.
//  Copyright © 2016 David Turnquist. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WorkoutSummaryTableViewCell.h"

@import Firebase;
@import FirebaseDatabase;
@import FirebaseDatabaseUI;

@interface WorkoutHistoryDetailFBTableViewController : UITableViewController

@property (strong, nonatomic) FIRDatabaseReference *firebaseRef;
@property (strong, nonatomic) FIRDatabaseReference *firebaseSelectedWorkoutRef;
@property (strong, nonatomic) FUITableViewDataSource *dataSource;
@property (strong, nonatomic) FIRDatabaseQuery *FIRDatabaseQuery;

@property (weak, nonatomic) FIRDataSnapshot *selectedWorkoutSnap;
@property (strong, nonatomic) NSDictionary *selectedWorkoutDict;

@property (nonatomic) FIRDatabaseHandle selectedWorkoutHandle;
@property (strong, nonatomic) NSArray *ceArray;
@property (strong, nonatomic) NSDictionary *ceDictionary;

@end
