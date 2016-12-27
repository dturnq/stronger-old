//
//  ExistingWorkoutsTableViewController.h
//  MuscleAbuse
//
//  Created by David Turnquist on 8/20/16.
//  Copyright © 2016 David Turnquist. All rights reserved.
//

#import <UIKit/UIKit.h>
@import Firebase;
@import FirebaseDatabase;
@import FirebaseDatabaseUI;

@interface ExistingWorkoutsTableViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) FIRDatabaseReference *firebaseRef;
//@property (strong, nonatomic) FIRDatabaseReference *firebaseCompletedExercisesRef;
@property (strong, nonatomic) FUITableViewDataSource *dataSource;
@property (strong, nonatomic) FIRDatabaseQuery *FIRDatabaseQuery;

@property (strong, nonatomic) FIRDataSnapshot *selectedExistingExerciseSnap;

@property (strong, nonatomic) NSString *activeWorkoutKey;
@property (strong, nonatomic) NSNumber *timestamp_start;


@end
