//
//  SelectExerciseTableViewController.h
//  MuscleAbuse
//
//  Created by David Turnquist on 12/22/15.
//  Copyright © 2015 David Turnquist. All rights reserved.
//


#import <UIKit/UIKit.h>
@import Firebase;
@import FirebaseDatabase;
@import FirebaseDatabaseUI;


@interface SelectExerciseTableViewController : UITableViewController

@property (strong, nonatomic) FIRDatabaseReference *firebaseRef;
@property (strong, nonatomic) FIRDatabaseReference *firebaseExercisesRef;
@property (strong, nonatomic) FUITableViewDataSource *dataSource;
@property (strong, nonatomic) FIRDatabaseQuery *FIRDatabaseQuery;


@property (weak, nonatomic) FIRDataSnapshot *selectedExerciseSnap;

@end
