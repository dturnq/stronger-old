//
//  EditExerciseViewController.h
//  Stronger
//
//  Created by David Turnquist on 12/9/16.
//  Copyright © 2016 David Turnquist. All rights reserved.
//

#import <UIKit/UIKit.h>
@import Firebase;

@interface EditExerciseViewController : UIViewController

    @property (nonatomic) BOOL new;
    @property (strong, nonatomic) FIRDataSnapshot *selectedExerciseSnap;
    
    @property (weak, nonatomic) IBOutlet UITextField *exerciseNameTextField;
    - (IBAction)saveButton:(id)sender;
    
@end
