//
//  SaveWorkoutViewController.h
//  MuscleAbuse
//
//  Created by David Turnquist on 1/24/16.
//  Copyright © 2016 David Turnquist. All rights reserved.
//

#import <UIKit/UIKit.h>
@import Firebase;
@import FirebaseDatabase;
@import FirebaseDatabaseUI;

@interface SaveWorkoutViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *workoutNameTextField;

@property (strong, nonatomic) NSString *activeWorkoutKey;

@property (strong, nonatomic) FIRDatabaseReference *firebaseRef;
@property (strong, nonatomic) FIRDatabaseReference *firebaseWorkoutsRef;

@property (strong, nonatomic) NSNumber *timestamp_start;

@property (strong, nonatomic) NSDictionary *ceList;

@end
