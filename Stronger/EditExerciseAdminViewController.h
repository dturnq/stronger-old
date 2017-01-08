//
//  EditExerciseAdminViewController.h
//  Stronger
//
//  Created by David Turnquist on 1/7/17.
//  Copyright © 2017 David Turnquist. All rights reserved.
//

#import <UIKit/UIKit.h>
@import Firebase;

@interface EditExerciseAdminViewController : UIViewController

@property (nonatomic) BOOL new;
@property (strong, nonatomic) FIRDataSnapshot *selectedExerciseSnap;

@property (weak, nonatomic) IBOutlet UITextField *exerciseNameTextField;
- (IBAction)saveButton:(id)sender;

@end
