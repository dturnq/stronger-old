//
//  EditExerciseViewController.m
//  Stronger
//
//  Created by David Turnquist on 12/9/16.
//  Copyright © 2016 David Turnquist. All rights reserved.
//

#import "EditExerciseViewController.h"

@interface EditExerciseViewController ()

@end

@implementation EditExerciseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (!self.new) {
        self.exerciseNameTextField.text = self.selectedExerciseSnap.value[@"name"];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)saveButton:(id)sender {
}
    
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
