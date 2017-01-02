//
//  AddSetViewController.m
//  MuscleAbuse
//
//  Created by David Turnquist on 12/29/15.
//  Copyright © 2015 David Turnquist. All rights reserved.
//

#import "AddSetViewController.h"
#import "Constants.h"
#import "HorizontalPickerView.h"



@interface AddSetViewController ()

@end

@implementation AddSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"AddSetViewController called");
    // Do any additional setup after loading the view.

    //[self displaySets];
    
    self.firebaseRef = [[FIRDatabase database] reference];
    NSString *userID = [FIRAuth auth].currentUser.uid;

    self.firebaseCompletedExercisesRef = [[self.firebaseRef child:@"ce_by_workout"] child:userID];
    
    NSString *path = [NSString stringWithFormat:@"%@/%@", self.completedExerciseSnap.value[@"exerciseID"], userID];
     NSLog(@"testing 123B... %@", path);
    self.firebaseCEBySelectedExerciseRef = [[self.firebaseRef child:@"ce_by_exercise"] child:path];
    NSLog(@"testing 123C... %@", self.firebaseCEBySelectedExerciseRef);

    self.FIRDatabaseQuery = [[self.firebaseCompletedExercisesRef queryOrderedByChild:@"timestamp"] queryLimitedToFirst:4];
    
    
    
    
    // Basic setup
    self.horizontalPickerView.style = HPStyle_iOS7;
    self.title = self.completedExerciseSnap.value[@"name"];
    self.selectedPickerButton = self.weight;
    
    self.horizontalPickerView.backgroundColor = NavColor;
    

    
    
    [self displaySets];
    
    // Date labels
    
    
    
    
    // Set labels
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)viewDidAppear:(BOOL)animated {
    
    
    
}

-(void)displaySets
{


    NSLog(@"attempting to display sets: %@", self.firebaseCEBySelectedExerciseRef);

    [[[self.firebaseCEBySelectedExerciseRef queryOrderedByChild:@"timestamp"] queryLimitedToFirst:4] observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot *snapshot) {
        NSLog(@"%@ -> %@", snapshot.key, snapshot.value);
        
        // Create a dict of the CEs
        NSDictionary *dictOfCEs = snapshot.value;
        NSLog(@"Dict: %@", dictOfCEs);
        
        NSDictionary *dictToday = [[NSDictionary alloc] init];
        NSUInteger countOfCEs = 0;
        NSArray *keys = [[NSArray alloc] init];
        if (dictOfCEs == [NSNull null]) {
            NSLog(@"no CEs found...");
            [self.weight setTitle:[NSString stringWithFormat:@"%d", 25] forState:UIControlStateNormal];
            [self.reps setTitle:[NSString stringWithFormat:@"%d", 10] forState:UIControlStateNormal];
            if (self.selectedPickerButton == self.weight) {
                [self.horizontalPickerView selectRow:25 animated:YES];
            } else {
                [self.horizontalPickerView selectRow:10 animated:YES];
            }
            
        } else {
            
            NSArray *preKeys = [dictOfCEs allKeys];
            keys = [preKeys sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
                NSString *first = [[dictOfCEs objectForKey:a] objectForKey:@"timestamp"];
                NSString *second = [[dictOfCEs objectForKey:b] objectForKey:@"timestamp"];
                return [first compare:second];
            }];
            
            // Start with today's ce *****************
            dictToday = [dictOfCEs valueForKey:[keys firstObject]];
            
            NSLog(@"dictToday: %@", dictToday);
            
            countOfCEs = [dictOfCEs count];
        }
        
        
        
        NSLog(@"dict of CEs: %@", dictOfCEs);
        NSLog(@"count of CEs: %lu", (unsigned long)countOfCEs);
        
        NSDictionary *setsDict = @{};
        NSUInteger countOfSets = 0;
        
        NSDateFormatter *dayFormatter = [[NSDateFormatter alloc] init];
        [dayFormatter setLocale:[NSLocale currentLocale]];
        [dayFormatter setDateFormat:@"EEE"];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setLocale:[NSLocale currentLocale]];
        [dateFormatter setDateFormat:@"MMM d"];
        
        NSString *dayString = @"";
        NSString *dateString = @"";
        
        if (countOfCEs > 0) {
            // Take care of the date
            NSNumber *dateNumber = [dictToday valueForKey:@"timestamp"];
            NSDate *date = [NSDate dateWithTimeIntervalSinceReferenceDate:-dateNumber.longValue];
            dayString = [dayFormatter stringFromDate:date];
            dateString = [dateFormatter stringFromDate:date];
            NSLog(@"First key: %@", dateString);
            self.todayDay.text = dayString;
            self.todayDate.text = dateString;
            
            
            // Count the sets in the current CE
            setsDict = [dictToday valueForKey:@"sets"];
            countOfSets = [setsDict count];
        } else {
            // ok
            countOfSets = 0;
            self.todayDay.text = @"-";
            self.todayDate.text = @"-";
        }
        
        

        
        NSLog(@"The array of sets: %@", setsDict);
        
        NSLog(@"Count of sets: %lu", (unsigned long)countOfSets);
        
        NSString *reps = [[NSString alloc] init];
        NSString *weight = [[NSString alloc] init];
        NSString *foundRecentSet = @"no";
        
        
        if (countOfSets == 0) {
            self.aNewCE = @"yes";
        }
        
        if (countOfSets > 0) {
            NSLog(@"found a set");
            self.aNewCE= @"no";
            foundRecentSet = @"yes";
            
            NSDictionary *set = [setsDict objectForKey:@"set0"];
            reps =  [[set objectForKey:@"reps"] stringValue];
            weight = [[set objectForKey:@"weight"] stringValue];
            self.tSet1.text = [[reps stringByAppendingString:@" / "] stringByAppendingString:weight];
        } else {
            self.tSet1.text = @"-";
        }
        
        NSLog(@"Finished the first if...");
        
        if (countOfSets > 1) {
            NSDictionary *set = [setsDict objectForKey:@"set1"];
            reps =  [[set objectForKey:@"reps"] stringValue];
            weight = [[set objectForKey:@"weight"] stringValue];
            self.tSet2.text = [[reps stringByAppendingString:@" / "] stringByAppendingString:weight];
        } else {
            self.tSet2.text = @"-";
        }
        
        if (countOfSets > 2) {
            NSDictionary *set = [setsDict objectForKey:@"set2"];
            reps =  [[set objectForKey:@"reps"] stringValue];
            weight = [[set objectForKey:@"weight"] stringValue];
            self.tSet3.text = [[reps stringByAppendingString:@" / "] stringByAppendingString:weight];
        } else {
            self.tSet3.text = @"-";
        }
        
        if (countOfSets > 3) {
            NSLog(@"There are 4+ sets");
            NSDictionary *set = [setsDict objectForKey:@"set3"];
            reps =  [[set objectForKey:@"reps"] stringValue];
            weight = [[set objectForKey:@"weight"] stringValue];
            self.tSet4.text = [[reps stringByAppendingString:@" / "] stringByAppendingString:weight];
        } else {
            self.tSet4.text = @"-";
        }
        
        if (countOfSets > 4) {
            NSLog(@"There are 5+ sets");
            NSDictionary *set = [setsDict objectForKey:@"set4"];
            reps =  [[set objectForKey:@"reps"] stringValue];
            weight = [[set objectForKey:@"weight"] stringValue];
            self.tSet5.text = [[reps stringByAppendingString:@" / "] stringByAppendingString:weight];
        } else {
            self.tSet5.text = @"-";
        }
        
        NSLog(@"cchecking cchecking: %lu", (unsigned long)countOfSets);
        if (countOfSets > 0) {
            
            NSLog(@"count of sets: %lu", (unsigned long)countOfSets);
            NSLog(@"setting reps and weight based on this ce: %d / %d", weight.intValue, reps.intValue);
            
            [self.weight setTitle:[NSString stringWithFormat:@"%d", weight.intValue] forState:UIControlStateNormal];
            //[self.weight setTitle:[NSString stringWithFormat:@"%d", weight.intValue] forState:UIControlStateSelected];
            //[self.weight setTitle:[NSString stringWithFormat:@"%d", weight.intValue] forState:UIControlStateHighlighted];
            //[self.weight setTitle:[NSString stringWithFormat:@"%d", weight.intValue] forState:UIControlStateDisabled];
            //[self.weight setTitle:[NSString stringWithFormat:@"%d", weight.intValue] forState:UIControlStateNormal];
            //[self.weight setTitle:[NSString stringWithFormat:@"%d", weight.intValue] forState:UIControlStateReserved];
            [self.reps setTitle:[NSString stringWithFormat:@"%d", reps.intValue] forState:UIControlStateNormal];
            
            if (self.selectedPickerButton == self.weight) {
                [self.horizontalPickerView selectRow:weight.intValue animated:YES];
            } else {
                [self.horizontalPickerView selectRow:reps.intValue animated:YES];
            }
        }
        
        NSLog(@"Finished the last if...");
        
        // Then the next oldest CE (CE A) *****************
        
        if (countOfCEs > 1) {
            
            self.aNewCE = @"no";
            
            NSDictionary *dictA = [dictOfCEs valueForKey:[keys objectAtIndex:1]];
            
            // Take care of the date
            NSNumber *dateNumber = [dictA valueForKey:@"timestamp"];
            NSDate *date = [NSDate dateWithTimeIntervalSinceReferenceDate:-dateNumber.longValue];
            dayString = [dayFormatter stringFromDate:date];
            dateString = [dateFormatter stringFromDate:date];
            NSLog(@"First key: %@", dateString);
            self.dayA.text = dayString;
            self.dateA.text = dateString;
            
            // Count the sets in the current CE
            setsDict = [dictA valueForKey:@"sets"];
            NSLog(@"The array of sets: %@", setsDict);
            
            countOfSets = [setsDict count];
            
        } else {
            self.dayA.text = @"-";
            self.dateA.text = @"-";
            countOfSets = 0;
        }
        
        if ([self.aNewCE  isEqual: @"yes"]) {
            [self.weight setTitle:[NSString stringWithFormat:@"%d", 25] forState:UIControlStateNormal];
            [self.reps setTitle:[NSString stringWithFormat:@"%d", 10] forState:UIControlStateNormal];
            if (self.selectedPickerButton == self.weight) {
                [self.horizontalPickerView selectRow:25 animated:YES];
            } else {
                [self.horizontalPickerView selectRow:10 animated:YES];
            }
        }

        
        
        NSLog(@"Count of sets: %lu", (unsigned long)countOfSets);
        
        if (countOfSets > 0) {
            NSDictionary *set = [setsDict objectForKey:@"set0"];
            reps =  [[set objectForKey:@"reps"] stringValue];
            weight = [[set objectForKey:@"weight"] stringValue];
            self.setA1.text = [[reps stringByAppendingString:@" / "] stringByAppendingString:weight];
        
        } else {
            self.setA1.text = @"-";
        }
        
        if (countOfSets > 1) {
            NSDictionary *set = [setsDict objectForKey:@"set1"];
            reps =  [[set objectForKey:@"reps"] stringValue];
            weight = [[set objectForKey:@"weight"] stringValue];
            self.setA2.text = [[reps stringByAppendingString:@" / "] stringByAppendingString:weight];
        } else {
            self.setA2.text = @"-";
        }
        
        if (countOfSets > 2) {
            NSDictionary *set = [setsDict objectForKey:@"set2"];
            reps =  [[set objectForKey:@"reps"] stringValue];
            weight = [[set objectForKey:@"weight"] stringValue];
            self.setA3.text = [[reps stringByAppendingString:@" / "] stringByAppendingString:weight];
        } else {
            self.setA3.text = @"-";
        }
        
        if (countOfSets > 3) {
            NSLog(@"There are 4+ sets");
            NSDictionary *set = [setsDict objectForKey:@"set3"];
            reps =  [[set objectForKey:@"reps"] stringValue];
            weight = [[set objectForKey:@"weight"] stringValue];
            self.setA4.text = [[reps stringByAppendingString:@" / "] stringByAppendingString:weight];
        } else {
            self.setA4.text = @"-";
        }
        
        if (countOfSets > 4) {
            NSLog(@"There are 5+ sets");
            NSDictionary *set = [setsDict objectForKey:@"set4"];
            reps =  [[set objectForKey:@"reps"] stringValue];
            weight = [[set objectForKey:@"weight"] stringValue];
            self.setA5.text = [[reps stringByAppendingString:@" / "] stringByAppendingString:weight];
        } else {
            self.setA5.text = @"-";
        }
        
        if ((countOfSets > 0) & [foundRecentSet isEqualToString:@"no"]) {
            
            NSLog(@"settings weight and reps based on last workout");
            
            [self.weight setTitle:[NSString stringWithFormat:@"%d", weight.intValue] forState:UIControlStateNormal];
            [self.reps setTitle:[NSString stringWithFormat:@"%d", reps.intValue] forState:UIControlStateNormal];
            
            
            if (self.selectedPickerButton == self.weight) {
                [self.horizontalPickerView selectRow:weight.intValue animated:YES];
            } else {
                [self.horizontalPickerView selectRow:reps.intValue animated:YES];
            }
        }
        
        if (countOfCEs > 2) {
            NSDictionary *dictB = [dictOfCEs valueForKey:[keys objectAtIndex:2]];
            
            // Take care of the date
            NSNumber *dateNumber = [dictB valueForKey:@"timestamp"];
            NSDate *date = [NSDate dateWithTimeIntervalSinceReferenceDate:-dateNumber.longValue];
            dayString = [dayFormatter stringFromDate:date];
            dateString = [dateFormatter stringFromDate:date];
            NSLog(@"First key: %@", dateString);
            self.dayB.text = dayString;
            self.dateB.text = dateString;
            
            // Count the sets in the current CE
            setsDict = [dictB valueForKey:@"sets"];
            NSLog(@"The array of sets: %@", setsDict);
            
            countOfSets = [setsDict count];
            
        } else {
            self.dayB.text = @"-";
            self.dateB.text = @"-";
            countOfSets = 0;
        }
        
        NSLog(@"Count of sets: %lu", (unsigned long)countOfSets);
        
        if (countOfSets > 0) {
            NSDictionary *set = [setsDict objectForKey:@"set0"];
            NSString *reps =  [[set objectForKey:@"reps"] stringValue];
            NSString *weight = [[set objectForKey:@"weight"] stringValue];
            self.setB1.text = [[reps stringByAppendingString:@" / "] stringByAppendingString:weight];
        } else {
            self.setB1.text = @"-";
        }
        
        if (countOfSets > 1) {
            NSDictionary *set = [setsDict objectForKey:@"set1"];
            NSString *reps =  [[set objectForKey:@"reps"] stringValue];
            NSString *weight = [[set objectForKey:@"weight"] stringValue];
            self.setB2.text = [[reps stringByAppendingString:@" / "] stringByAppendingString:weight];
        } else {
            self.setB2.text = @"-";
        }
        
        if (countOfSets > 2) {
            NSDictionary *set = [setsDict objectForKey:@"set2"];
            NSString *reps =  [[set objectForKey:@"reps"] stringValue];
            NSString *weight = [[set objectForKey:@"weight"] stringValue];
            self.setB3.text = [[reps stringByAppendingString:@" / "] stringByAppendingString:weight];
        } else {
            self.setB3.text = @"-";
        }
        
        if (countOfSets > 3) {
            NSLog(@"There are 4+ sets");
            NSDictionary *set = [setsDict objectForKey:@"set3"];
            NSString *reps =  [[set objectForKey:@"reps"] stringValue];
            NSString *weight = [[set objectForKey:@"weight"] stringValue];
            self.setB4.text = [[reps stringByAppendingString:@" / "] stringByAppendingString:weight];
        } else {
            self.setB4.text = @"-";
        }
        
        if (countOfSets > 4) {
            NSLog(@"There are 5+ sets");
            NSDictionary *set = [setsDict objectForKey:@"set4"];
            NSString *reps =  [[set objectForKey:@"reps"] stringValue];
            NSString *weight = [[set objectForKey:@"weight"] stringValue];
            self.setB5.text = [[reps stringByAppendingString:@" / "] stringByAppendingString:weight];
        } else {
            self.setB5.text = @"-";
        }
        
        
        
        if (countOfCEs > 3) {
            NSDictionary *dictC = [dictOfCEs valueForKey:[keys objectAtIndex:3]];
            
            // Take care of the date
            NSNumber *dateNumber = [dictC valueForKey:@"timestamp"];
            NSDate *date = [NSDate dateWithTimeIntervalSinceReferenceDate:-dateNumber.longValue];
            dayString = [dayFormatter stringFromDate:date];
            dateString = [dateFormatter stringFromDate:date];
            NSLog(@"First key: %@", dateString);
            self.dayC.text = dayString;
            self.dateC.text = dateString;
            
            // Count the sets in the current CE
            setsDict = [dictC valueForKey:@"sets"];
            NSLog(@"The array of sets: %@", setsDict);
            
            countOfSets = [setsDict count];
            
        } else {
            self.dayC.text = @"-";
            self.dateC.text = @"-";
            countOfSets = 0;
        }
        
        NSLog(@"Count of sets: %lu", (unsigned long)countOfSets);
        
        if (countOfSets > 0) {
            NSDictionary *set = [setsDict objectForKey:@"set0"];
            NSString *reps =  [[set objectForKey:@"reps"] stringValue];
            NSString *weight = [[set objectForKey:@"weight"] stringValue];
            self.setC1.text = [[reps stringByAppendingString:@" / "] stringByAppendingString:weight];
        } else {
            self.setC1.text = @"-";
        }
        
        if (countOfSets > 1) {
            NSDictionary *set = [setsDict objectForKey:@"set1"];
            NSString *reps =  [[set objectForKey:@"reps"] stringValue];
            NSString *weight = [[set objectForKey:@"weight"] stringValue];
            self.setC2.text = [[reps stringByAppendingString:@" / "] stringByAppendingString:weight];
        } else {
            self.setC2.text = @"-";
        }
        
        if (countOfSets > 2) {
            NSDictionary *set = [setsDict objectForKey:@"set2"];
            NSString *reps =  [[set objectForKey:@"reps"] stringValue];
            NSString *weight = [[set objectForKey:@"weight"] stringValue];
            self.setC3.text = [[reps stringByAppendingString:@" / "] stringByAppendingString:weight];
        } else {
            self.setC3.text = @"-";
        }
        
        if (countOfSets > 3) {
            NSLog(@"There are 4+ sets");
            NSDictionary *set = [setsDict objectForKey:@"set3"];
            NSString *reps =  [[set objectForKey:@"reps"] stringValue];
            NSString *weight = [[set objectForKey:@"weight"] stringValue];
            self.setC4.text = [[reps stringByAppendingString:@" / "] stringByAppendingString:weight];
        } else {
            self.setC4.text = @"-";
        }
        
        if (countOfSets > 4) {
            NSLog(@"There are 5+ sets");
            NSDictionary *set = [setsDict objectForKey:@"set4"];
            NSString *reps =  [[set objectForKey:@"reps"] stringValue];
            NSString *weight = [[set objectForKey:@"weight"] stringValue];
            self.setC5.text = [[reps stringByAppendingString:@" / "] stringByAppendingString:weight];
        } else {
            self.setC5.text = @"-";
        }
        
    }];
    
    
    /*
    // Get most recent set for scroll bar
    NSSet *setLocalSet = [self.completedExercise.exerciseLocal setLocal];
    NSLog(@"Sets Pulled: %@", setLocalSet);
    NSSortDescriptor *dateDescriptorNewToOld = [[NSSortDescriptor alloc] initWithKey:@"clientCreatedAt" ascending:NO];
    NSArray *sortDescriptorsNewToOld = [[NSArray alloc] initWithObjects:dateDescriptorNewToOld, nil];
    
    NSArray *tempArray = [setLocalSet sortedArrayUsingDescriptors:sortDescriptorsNewToOld];
    if ([tempArray count]) {
        NSLog(@"Attempting to pull most recent set; array count: %lu", (unsigned long)[tempArray count]);
        self.setArray = [[NSArray alloc] initWithObjects:[tempArray objectAtIndex:0], nil];
    }
    
    // Pull sets for the current completed exercise
    setLocalSet = [self.completedExercise setLocal];
    //NSLog(@"Sets Pulled: %@", setLocalSet);
    NSSortDescriptor *dateDescriptorOldToNew = [[NSSortDescriptor alloc] initWithKey:@"clientCreatedAt" ascending:YES];
    NSArray *sortDescriptorsOldToNew = [[NSArray alloc] initWithObjects:dateDescriptorOldToNew, nil];
    NSArray *setArray = [setLocalSet sortedArrayUsingDescriptors:sortDescriptorsOldToNew];
    //NSLog(@"Sets: %@", setArray);
    
    [self displayPreviousSet:0 setArray:setArray];
    
    
    // Display prevoius 3 workouts worth of sets
    NSLog(@"Current exercise: %@", self.completedExercise.exerciseLocal.name);
    NSSet *completedExerciseLocalSet = [self.completedExercise.exerciseLocal completedExerciseLocal];
    NSArray *completedExerciseLocalArray = [completedExerciseLocalSet sortedArrayUsingDescriptors:sortDescriptorsNewToOld];
    
    int i = 1;
    //NSMutableArray *workoutArray = [[NSMutableArray alloc] initWithObjects:self.completedExercise.workoutLocal.clientObjectID, nil];
    for (CompletedExerciseLocal *completedExerciseLocal in completedExerciseLocalArray) {
        
        if (completedExerciseLocal.clientObjectID == self.completedExercise.clientObjectID) {
            continue;
        }
        
        setLocalSet = [completedExerciseLocal setLocal];
        NSArray *setArray = [setLocalSet sortedArrayUsingDescriptors:sortDescriptorsOldToNew];
        [self displayPreviousSet:i setArray:setArray];
        i++;
        if (i > 3) {
            break;
        }
        */
        
        /*
         WorkoutLocal *workoutLocal = completedExerciseLocal.workoutLocal;
         
         // If the workout hasn't already been shown
         
         if (![workoutArray containsObject:workoutLocal.clientObjectID]) {
         
         NSLog(@"Workout: %@", workoutLocal.name);
         
         // Add the workout to the array, to ensure it isn's shown
         [workoutArray addObject:workoutLocal.clientObjectID];
         
         // Pull and display the sets
         setLocalSet = [workoutLocal setLocal];
         if ([setLocalSet count]) {
         NSArray *setArray = [setLocalSet sortedArrayUsingDescriptors:sortDescriptorsOldToNew];
         [self displayPreviousSet:i setArray:setArray];
         i++;
         }
         
         if (i > 3) {
         break;
         }
         }
         else
         {
         NSLog(@"Excluded workout: %@", workoutLocal.name);
         }
         

    }
         */
}



#pragma mark -  HPickerViewDataSource



- (NSInteger)numberOfRowsInPickerView:(HorizontalPickerView *)pickerView
{
    return 1000;
}

#pragma mark -  HPickerViewDelegate

- (NSString *)pickerView:(HorizontalPickerView *)pickerView titleForRow:(NSInteger)row
{
    return [NSNumberFormatter localizedStringFromNumber:[NSNumber numberWithInteger:row] numberStyle:NSNumberFormatterDecimalStyle];
}

- (void)pickerView:(HorizontalPickerView *)pickerView didSelectRow:(NSInteger)row
{
    [self.selectedPickerButton setTitle:[NSString stringWithFormat:@"%@", @(row)] forState:UIControlStateNormal];
}




- (IBAction)selectWeightButton:(id)sender {
    [self.weight setTitleColor:[UIColor colorWithRed:0 green:0.478431 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
    [self.reps setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
    self.selectedPickerButton = self.weight;
    [self.horizontalPickerView selectRow:[self.weight.titleLabel.text intValue] animated:YES];
}

- (IBAction)selectRepsButton:(id)sender {
    [self.reps setTitleColor:[UIColor colorWithRed:0 green:0.478431 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
    [self.weight setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
    self.selectedPickerButton = self.reps;
    [self.horizontalPickerView selectRow:[self.reps.titleLabel.text intValue] animated:YES];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqual:@"SaveSet"]) {
        NSLog(@"Attemping to save the set");
        
        //Stopwatch *stopwatch = [[Stopwatch alloc] init];
        //[stopwatch setSetStartTime:self.completedTime];

    }
    
    
}


- (IBAction)deleteCE:(id)sender {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Are you sure you want to delete this exercise from your workout?" message:@"This cannot be undone." preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *alertActionDelete = [UIAlertAction actionWithTitle:@"Yes, delete it." style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        NSString *userID = [FIRAuth auth].currentUser.uid;
        //userID = @"OFFLINE MODE";
        
        NSLog(@"self.completedExerciseSnap: %@", self.completedExerciseSnap);
        
        NSString *workoutID = [self.completedExerciseSnap.value objectForKey:@"workout"];
        NSLog(@"self.completedExerciseSnap -> workout id: %@", workoutID);
        NSString *exerciseID = [self.completedExerciseSnap.value objectForKey:@"exerciseID"];
        NSLog(@"self.completedExerciseSnap -> workout id: %@", exerciseID);
        NSString *ceID = self.completedExerciseSnap.key;
        
        
        NSLog(@"self.completedExerciseSnap -> workout id: %@", ceID);
        
        
        NSMutableDictionary *writeToDict = [[NSMutableDictionary alloc] init];
        
        // CE list - by workout
        NSString *keyPath = [NSString stringWithFormat:@"ce_by_workout/%@/%@/%@", userID, workoutID, ceID];
        [writeToDict setObject:[NSNull null] forKey:keyPath];
        
        // CE list - by exercise
        keyPath = [NSString stringWithFormat:@"ce_by_exercise/%@/%@/%@", exerciseID, userID, ceID];
        [writeToDict setObject:[NSNull null] forKey:keyPath];
        
        NSLog(@"the writeto dict: %@", writeToDict);
        
        [self.firebaseRef updateChildValues:writeToDict withCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
            if (error) {
                NSLog(@"the ce didn't delete properly... shit: %@", error.debugDescription);
                
            } else {
                NSLog(@"ce deleted");
            }
        }];
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }];
    
    UIAlertAction *alertActionOops = [UIAlertAction actionWithTitle:@"Oops, keep lifting!" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alert addAction:alertActionOops];
    [alert addAction:alertActionDelete];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}



@end
