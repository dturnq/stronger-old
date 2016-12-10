//
//  ExercisesTableViewController.h
//  Stronger
//
//  Created by David Turnquist on 12/9/16.
//  Copyright © 2016 David Turnquist. All rights reserved.
//

#import <UIKit/UIKit.h>
@import Firebase;
@import FirebaseDatabase;
@import FirebaseDatabaseUI;


@interface ExercisesTableViewController : UITableViewController

    @property (strong, nonatomic) FIRDatabaseReference *firebaseRef;
    @property (strong, nonatomic) FIRDatabaseReference *firebaseExercisesRef;
    @property (strong, nonatomic) FUITableViewDataSource *dataSource;
    @property (strong, nonatomic) FIRDatabaseQuery *FIRDatabaseQuery;
    
    
    @property (strong, nonatomic) FIRDataSnapshot *selectedExerciseSnap;
    
@end
