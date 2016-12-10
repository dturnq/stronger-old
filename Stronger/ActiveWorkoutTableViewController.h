//
//  ActiveWorkoutTableViewController.h
//  MuscleAbuse
//
//  Created by David Turnquist on 12/21/15.
//  Copyright © 2015 David Turnquist. All rights reserved.
//

#import <UIKit/UIKit.h>
@import Firebase;
@import FirebaseDatabase;
@import FirebaseDatabaseUI;


#import "ActiveExerciseTableViewCell.h"
#import "AddExerciseTableViewCell.h"

@class ActiveWorkoutDataController;

@interface ActiveWorkoutTableViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate>

- (IBAction)deleteWorkoutButton:(id)sender;
@property (strong, nonatomic) FIRDatabaseReference *firebaseRef;
//@property (strong, nonatomic) FIRDatabaseReference *firebaseCompletedExercisesRef;
@property (strong, nonatomic) FUITableViewDataSource *dataSource;
@property (strong, nonatomic) FIRDatabaseQuery *FIRDatabaseQuery;



//@property (strong, nonatomic) ActiveWorkoutDataController *dataController;
//@property (strong, nonatomic) FIRDataSnapshot *activeWorkoutSnap;
@property (strong, nonatomic) NSString *activeWorkoutKey;

@property (strong, nonatomic) NSNumber *timestamp_start;


// Internal
@property (strong, nonatomic) FIRDataSnapshot *selectedCompletedExerciseSnap;
@property (strong, nonatomic) NSIndexPath *selectedIndexPath;
@property (strong, nonatomic) NSDictionary *ceList;
@property (nonatomic) FIRDatabaseHandle ceListenerHandle;

@end
