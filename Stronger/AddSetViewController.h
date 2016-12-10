//
//  AddSetViewController.h
//  MuscleAbuse
//
//  Created by David Turnquist on 12/29/15.
//  Copyright © 2015 David Turnquist. All rights reserved.
//

#import <UIKit/UIKit.h>
@import Firebase;
@import FirebaseDatabase;
@import FirebaseDatabaseUI;
//#import "AKPickerView.h"
@class HorizontalPickerView;

@interface AddSetViewController : UIViewController  <UIPickerViewDelegate>

- (IBAction)deleteCE:(id)sender;
@property (strong, nonatomic) FIRDatabaseReference *firebaseRef;
@property (strong, nonatomic) FIRDatabaseReference *firebaseCompletedExercisesRef;
@property (strong, nonatomic) FIRDatabaseReference *firebaseCEBySelectedExerciseRef;
@property (strong, nonatomic) FUITableViewDataSource *dataSource;
@property (strong, nonatomic) FIRDatabaseQuery *FIRDatabaseQuery;



@property (weak, nonatomic) FIRDataSnapshot *completedExerciseSnap;


@property (weak, nonatomic) IBOutlet UIButton *weight;
@property (weak, nonatomic) IBOutlet UIButton *reps;



//- (IBAction)saveSet:(id)sender;
- (IBAction)selectWeightButton:(id)sender;
- (IBAction)selectRepsButton:(id)sender;

@property (weak, nonatomic) IBOutlet HorizontalPickerView *horizontalPickerView;

//@property (strong, nonatomic) AKPickerView *pickerView;

// Internal
@property (strong, nonatomic) UIButton *selectedPickerButton;

@property (strong, nonatomic) IBOutlet UIView *subView;

@property (strong, nonatomic) NSString *aNewCE;

//-(void)displayPreviousSet:(int)setNum setArray:(NSArray *)setArray;
//-(void)displaySets;



// Date labels
@property (strong, nonatomic) IBOutlet UILabel *todayDate;
@property (strong, nonatomic) IBOutlet UILabel *dateA;
@property (strong, nonatomic) IBOutlet UILabel *dateB;
@property (strong, nonatomic) IBOutlet UILabel *dateC;

// PREDATELABELS
@property (strong, nonatomic) IBOutlet UILabel *todayDay;
@property (strong, nonatomic) IBOutlet UILabel *dayA;
@property (strong, nonatomic) IBOutlet UILabel *dayB;
@property (strong, nonatomic) IBOutlet UILabel *dayC;

// Set labels
@property (strong, nonatomic) IBOutlet UILabel *tSet1;
@property (strong, nonatomic) IBOutlet UILabel *tSet2;
@property (strong, nonatomic) IBOutlet UILabel *tSet3;
@property (strong, nonatomic) IBOutlet UILabel *tSet4;
@property (strong, nonatomic) IBOutlet UILabel *tSet5;

@property (strong, nonatomic) IBOutlet UILabel *setA1;
@property (strong, nonatomic) IBOutlet UILabel *setA2;
@property (strong, nonatomic) IBOutlet UILabel *setA3;
@property (strong, nonatomic) IBOutlet UILabel *setA4;
@property (strong, nonatomic) IBOutlet UILabel *setA5;

@property (strong, nonatomic) IBOutlet UILabel *setB1;
@property (strong, nonatomic) IBOutlet UILabel *setB2;
@property (strong, nonatomic) IBOutlet UILabel *setB3;
@property (strong, nonatomic) IBOutlet UILabel *setB4;
@property (strong, nonatomic) IBOutlet UILabel *setB5;

@property (strong, nonatomic) IBOutlet UILabel *setC1;
@property (strong, nonatomic) IBOutlet UILabel *setC2;
@property (strong, nonatomic) IBOutlet UILabel *setC3;
@property (strong, nonatomic) IBOutlet UILabel *setC4;
@property (strong, nonatomic) IBOutlet UILabel *setC5;



@end
