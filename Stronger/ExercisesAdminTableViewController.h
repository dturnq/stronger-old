//
//  ExercisesAdminTableViewController.h
//  Stronger
//
//  Created by David Turnquist on 1/7/17.
//  Copyright © 2017 David Turnquist. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExerciseAdmin.h"
@import Firebase;
@import FirebaseDatabase;
@import FirebaseDatabaseUI;


@interface ExercisesAdminTableViewController : UITableViewController

    @property (strong, nonatomic) FIRDatabaseReference *firebaseRef;
    @property (strong, nonatomic) FIRDatabaseReference *firebaseExercisesRef;
    @property (strong, nonatomic) FUITableViewDataSource *dataSource;
    @property (strong, nonatomic) FIRDatabaseQuery *FIRDatabaseQuery;


    @property (strong, nonatomic) FIRDataSnapshot *selectedExerciseSnap;
- (IBAction)nukeExercises:(id)sender;

-(NSMutableDictionary *)updateSearchListForExerciseAdmin:(ExerciseAdmin *)exerciseAdmin withDict:(id)exerciseDict forWriteToDict: (NSMutableDictionary *)writeToDict;

@end
