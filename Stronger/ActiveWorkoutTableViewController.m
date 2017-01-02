//
//  ActiveWorkoutTableViewController.m
//  MuscleAbuse
//
//  Created by David Turnquist on 12/21/15.
//  Copyright © 2015 David Turnquist. All rights reserved.
//

#import "Constants.h"
#import "ActiveWorkoutTableViewController.h"
#import "SelectExerciseTableViewController.h"
#import "AddSetViewController.h"
#import "SaveWorkoutViewController.h"
#import "Constants.h"

@interface ActiveWorkoutTableViewController ()

@end

@implementation ActiveWorkoutTableViewController

#pragma mark - misellanieous utility funtions


-(void)awakeFromNib {
    [super awakeFromNib];
    //self.dataController = [[ActiveWorkoutDataController alloc] init];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    NSLog(@"view did load for activeworkouttableviewcontroller");
    
    NSLog(@"self: %@", self);
    
    self.firebaseRef = [[FIRDatabase database] reference];
    NSString *userID = [FIRAuth auth].currentUser.uid;
    //userID = @"OFFLINE MODE";

    NSLog(@"active workout key: %@", self.activeWorkoutKey);
    
    NSLog(@"active userid: %@", userID);
    
    self.FIRDatabaseQuery = [[[[self.firebaseRef child:@"ce_by_workout"] child:userID] child:self.activeWorkoutKey] queryOrderedByChild:@"order"];

    
    self.ceList = [[NSDictionary alloc] init];
    
    NSLog(@"just started the celist");
    
    //self.ceListenerHandle =
    [[[[self.firebaseRef child:@"ce_by_workout"] child:userID] child:self.activeWorkoutKey] observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSLog(@"firdatadnapshot - what does it have? %@", snapshot);
        if (snapshot.exists) {
            self.ceList = snapshot.value;
        } else {
            self.ceList = [[NSDictionary alloc] init];
        }
        
        
        NSLog(@"dictionary ce list: %@", self.ceList);
    }];
    
    NSLog(@"about to set the datasource");
    self.dataSource = [[FUITableViewDataSource alloc] initWithQuery:self.FIRDatabaseQuery view:self.tableView populateCell:^ActiveExercise2RowTableViewCell * _Nonnull(UITableView * _Nonnull tableView, NSIndexPath * _Nonnull indexPath, FIRDataSnapshot * _Nonnull snap) {
        
        // IDENTIFY HOW MANY SETS THERE ARE
        NSUInteger countOfList = [(NSDictionary *)snap.value[@"sets"] count];
        NSDictionary *arrayOfSets = snap.value[@"sets"];
        
        NSLog(@"The array of xsets: %@", arrayOfSets);
        
        NSLog(@"Count of sets: %lu", (unsigned long)countOfList);
        
        ActiveExercise2RowTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ActiveExercise2RowCell"];
        
        NSLog(@"Viewdidload cell creation - snap.workout: %@", snap.value[@"workout"]);
        
        
        //cell.showsReorderControl = YES;
        
        cell.exerciseName.text = snap.value[@"name"];
        
        //cell.exerciseName.text = @"Placeholder text"; //snap.value[@"name"];
        

        
        
        if (countOfList > 0) {
            NSLog(@"at least 1 set");
            NSDictionary *set = [arrayOfSets objectForKey:@"set0"];
            NSLog(@"the set: %@", set);
            NSString *reps =  [[set objectForKey:@"reps"] stringValue];
            NSLog(@"The reps: %@", reps);
            NSString *weight = [[set objectForKey:@"weight"] stringValue];
            NSLog(@"the wieght: %@", weight);
            cell.set1.text = [[reps stringByAppendingString:@" / "] stringByAppendingString:weight];
        } else {
            cell.set1.text = @"-";
        }
        
        if (countOfList > 1) {
            NSDictionary *set = [arrayOfSets objectForKey:@"set1"];
            NSString *reps =  [[set objectForKey:@"reps"] stringValue];
            NSString *weight = [[set objectForKey:@"weight"] stringValue];
            cell.set2.text = [[reps stringByAppendingString:@" / "] stringByAppendingString:weight];
        } else {
            cell.set2.text = @"-";
        }
        
        if (countOfList > 2) {
            NSDictionary *set = [arrayOfSets objectForKey:@"set2"];
            NSString *reps =  [[set objectForKey:@"reps"] stringValue];
            NSString *weight = [[set objectForKey:@"weight"] stringValue];
            cell.set3.text = [[reps stringByAppendingString:@" / "] stringByAppendingString:weight];
        } else {
            cell.set3.text = @"-";
        }
        
        if (countOfList > 3) {
            NSLog(@"There are 4+ sets");
            NSDictionary *set = [arrayOfSets objectForKey:@"set3"];
            NSString *reps =  [[set objectForKey:@"reps"] stringValue];
            NSString *weight = [[set objectForKey:@"weight"] stringValue];
            cell.set4.text = [[reps stringByAppendingString:@" / "] stringByAppendingString:weight];
        } else {
            cell.set4.text = @"-";
        }
        
        if (countOfList > 4) {
            NSLog(@"There are 5+ sets");
            NSDictionary *set = [arrayOfSets objectForKey:@"set4"];
            NSString *reps =  [[set objectForKey:@"reps"] stringValue];
            NSString *weight = [[set objectForKey:@"weight"] stringValue];
            cell.set5.text = [[reps stringByAppendingString:@" / "] stringByAppendingString:weight];
        } else {
            cell.set5.text = @"-";
        }
        
        if (countOfList > 5) {
            NSLog(@"There are 6+ sets");
            NSDictionary *set = [arrayOfSets objectForKey:@"set5"];
            NSString *reps =  [[set objectForKey:@"reps"] stringValue];
            NSString *weight = [[set objectForKey:@"weight"] stringValue];
            cell.set6.text = [[reps stringByAppendingString:@" / "] stringByAppendingString:weight];
        } else {
            cell.set6.text = @"-";
        }
        
        if (countOfList > 6) {
            NSLog(@"There are 7+ sets");
            NSDictionary *set = [arrayOfSets objectForKey:@"set6"];
            NSString *reps =  [[set objectForKey:@"reps"] stringValue];
            NSString *weight = [[set objectForKey:@"weight"] stringValue];
            cell.set7.text = [[reps stringByAppendingString:@" / "] stringByAppendingString:weight];
        } else {
            cell.set7.text = @"-";
        }
        
        if (countOfList > 7) {
            NSLog(@"There are 8+ sets");
            NSDictionary *set = [arrayOfSets objectForKey:@"set7"];
            NSString *reps =  [[set objectForKey:@"reps"] stringValue];
            NSString *weight = [[set objectForKey:@"weight"] stringValue];
            cell.set8.text = [[reps stringByAppendingString:@" / "] stringByAppendingString:weight];
        } else {
            cell.set8.text = @"-";
        }
        
        if (countOfList > 8) {
            NSLog(@"There are 5+ sets");
            NSDictionary *set = [arrayOfSets objectForKey:@"set8"];
            NSString *reps =  [[set objectForKey:@"reps"] stringValue];
            NSString *weight = [[set objectForKey:@"weight"] stringValue];
            cell.set9.text = [[reps stringByAppendingString:@" / "] stringByAppendingString:weight];
        } else {
            cell.set9.text = @"-";
        }
        
        if (countOfList > 9) {
            NSLog(@"There are 6+ sets");
            NSDictionary *set = [arrayOfSets objectForKey:@"set9"];
            NSString *reps =  [[set objectForKey:@"reps"] stringValue];
            NSString *weight = [[set objectForKey:@"weight"] stringValue];
            cell.set10.text = [[reps stringByAppendingString:@" / "] stringByAppendingString:weight];
        } else {
            cell.set10.text = @"-";
        }
        
        if (countOfList > 10) {
            NSLog(@"There are 7+ sets");
            NSDictionary *set = [arrayOfSets objectForKey:@"set10"];
            NSString *reps =  [[set objectForKey:@"reps"] stringValue];
            NSString *weight = [[set objectForKey:@"weight"] stringValue];
            cell.set11.text = [[reps stringByAppendingString:@" / "] stringByAppendingString:weight];
        } else {
            cell.set11.text = @"-";
        }
        
        if (countOfList > 11) {
            NSLog(@"There are 8+ sets");
            NSDictionary *set = [arrayOfSets objectForKey:@"set11"];
            NSString *reps =  [[set objectForKey:@"reps"] stringValue];
            NSString *weight = [[set objectForKey:@"weight"] stringValue];
            cell.set12.text = [[reps stringByAppendingString:@" / "] stringByAppendingString:weight];
        } else {
            cell.set12.text = @"-";
        }

        
        return cell;
        
    }];
    
    NSLog(@"about to set the datasource 2");
    [self.tableView setDataSource:self.dataSource];
    NSLog(@"set datasource");
    //self.dataController.workout = self.activeWorkout;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    //self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.dataSource objectAtIndex:indexPath.row];
    
    FIRDataSnapshot *snap = [self.dataSource objectAtIndex:indexPath.row];
    
    // IDENTIFY HOW MANY SETS THERE ARE
    NSUInteger countOfList = [(NSDictionary *)snap.value[@"sets"] count];
    
    int rowHeight = 75;
    
    if (countOfList > 3) {
        rowHeight = 110;
    }
    
    if (countOfList > 7) {
        rowHeight = 145;
    }
    
    return rowHeight;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //if (indexPath.row + 1 != ([self.dataController countOfList] + 1)) {
        // Open the completed exercise view
    self.selectedCompletedExerciseSnap = [self.dataSource objectAtIndex:indexPath.row];
    //self.selectedIndexPath = indexPath;
    NSLog(@"About to segue - selected index path: %ld", (long)indexPath.row);
        
    [self performSegueWithIdentifier:@"SegueToAddSet" sender:self];
        
    //} else {
        // Go to the add exercise view
    //}
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

*/

// Override to support editing the table view.
/*
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
 
*/


// Override to support rearranging the table view.
/*
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
    
    //self.dataSource remov
    
}
*/



// Override to support conditional rearranging of the table view.
/*
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqual: @"SegueToAddSet"]) {
        // Send the CompletedExercise over
        
        UINavigationController *navController = segue.destinationViewController;
        AddSetViewController *destinationViewController = (AddSetViewController *)navController.topViewController;
        destinationViewController.completedExerciseSnap = self.selectedCompletedExerciseSnap;
        NSLog(@"sending completed exercise snap: %@", self.selectedCompletedExerciseSnap);
        
    }
    
    if ([segue.identifier isEqual: @"SegueToNameAndSaveWorkout"]) {
        // Send the CompletedExercise over
        
        UINavigationController *navController = segue.destinationViewController;
        SaveWorkoutViewController *destinationViewController = (SaveWorkoutViewController *)navController.topViewController;
        destinationViewController.activeWorkoutKey = self.activeWorkoutKey;
        destinationViewController.timestamp_start = self.timestamp_start;
        destinationViewController.ceList = self.ceList;
        //destinationViewController.dataController = self.dataController;
        
    }
    
}

- (IBAction)unwindToActiveWorkoutFBView:(UIStoryboardSegue *)unwindSegue
{
    
     if ([unwindSegue.identifier  isEqual: @"SelectExerciseSegue"]) {
     
         NSLog(@"Unwound to the active workout view");
         
         SelectExerciseTableViewController *selectExerciseTableViewController = unwindSegue.sourceViewController;
         FIRDataSnapshot *selectedExerciseSnap = selectExerciseTableViewController.selectedExerciseSnap;
         
         NSLog(@"Creating the new dictionary");
         
         NSString *userID = [FIRAuth auth].currentUser.uid;
         //userID = @"OFFLINE MODE";
         
         // Timestamp
         NSTimeInterval intervalInSeconds = [[NSDate date] timeIntervalSinceReferenceDate];
         NSNumber *date = [NSNumber numberWithDouble:-intervalInSeconds];
         
         NSNumber *order = [NSNumber numberWithInt:([[self.dataSource tableView] numberOfRowsInSection:0] + 1)];
         NSLog(@"order: %@", order);
         
         // Create the CE
         NSDictionary *newCompletedExercise = @{
                                                @"exerciseID": selectedExerciseSnap.key,
                                                @"name": selectedExerciseSnap.value[@"name"],
                                                @"sets": @{},
                                                @"workout" : self.activeWorkoutKey,
                                                @"timestamp" : date,
                                                @"user" : userID,
                                                @"order" : order,
                                                };
         
         
         
         FIRDatabaseReference *newCompletedExerciseRef = [self.firebaseRef childByAutoId];
         
         NSString *ceID = newCompletedExerciseRef.key;
         
         NSString *pathByWorkout = [NSString stringWithFormat:@"ce_by_workout/%@/%@/%@", userID, self.activeWorkoutKey, ceID];
         NSString *pathByExercise = [NSString stringWithFormat:@"ce_by_exercise/%@/%@/%@", selectedExerciseSnap.key, userID, ceID];
         
         NSLog(@"testing 123A... %@", pathByExercise);
         
         NSDictionary *updateDict = [[NSDictionary alloc] initWithObjects:@[newCompletedExercise, newCompletedExercise] forKeys:@[pathByWorkout, pathByExercise]];
         
         [self.firebaseRef updateChildValues:updateDict];
         
         NSLog(@"Created the new exercise reg");
         
         //[newCompletedExerciseRef setValue:newCompletedExercise];
         //[newCompletedExerciseRef setPriority:date];
         
         NSLog(@"new completed exercise: %@", newCompletedExerciseRef);
         
         // Create the second data table sorted by exercise type
         //NSString *newPath = [NSString stringWithFormat:@"ce_by_exercise/%@/%@", selectedExerciseSnap.key, newCompletedExerciseRef.key];
         //FIRDatabaseReference *newCEByExerciseRef = [[[[self.firebaseRef child:@"ce_by_exercise"] child:selectedExerciseSnap.key] child:userID] child:newCompletedExerciseRef.key];
         
         //[newCEByExerciseRef updateChildValues:newCompletedExercise];
         
         NSLog(@"Done saving new CE");
     }
    
    
     if ([unwindSegue.identifier  isEqual: @"AddSet"]) {
     
     
         NSLog(@"Set save segue completed - back to the active workout view");
         
     
         // Get the previous view controller
         AddSetViewController *addSetViewController = unwindSegue.sourceViewController;
         FIRDataSnapshot *selectedCompletedExerciseSnap = addSetViewController.completedExerciseSnap;
         
         NSLog(@"Set count test: %lu", [selectedCompletedExerciseSnap.value[@"sets"] count]);
     
         // Set the number formatter
         NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
         [f setNumberStyle:NSNumberFormatterDecimalStyle];
     
         // Timestamp
         NSTimeInterval intervalInSeconds = [[NSDate date] timeIntervalSinceReferenceDate];
         NSNumber *date = [NSNumber numberWithDouble:-intervalInSeconds];
         
         //NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
         //NSString *nowString = [NSString stringWithFormat:@"%@", now];
        
         //NSNumber *date = NSNumber number
     
         NSLog(@"Creating the set");
         
         NSNumber *reps = [f numberFromString:addSetViewController.reps.titleLabel.text];
         NSNumber *weight = [f numberFromString:addSetViewController.weight.titleLabel.text];
         NSNumber *codedSet = [NSNumber numberWithInt:([weight intValue] * 100000 + [reps intValue])];
     
         NSDictionary *newSet = @{
                                  @"reps": reps,
                                  @"weight": weight,
                                  @"coded_set" : codedSet,
                                  @"timestamp": date
                                  };
         
         
         // user id
         NSString *userID = [FIRAuth auth].currentUser.uid;
         //userID = @"OFFLINE MODE";
         
         // exercise id
         NSString *ceID = selectedCompletedExerciseSnap.key;
         
         // set count id
         NSNumber *count = [NSNumber numberWithUnsignedLong:[selectedCompletedExerciseSnap.value[@"sets"] count]];
         NSString *newKey = [NSString stringWithFormat:@"set%.0f", [count floatValue]];
         NSLog(@"newkey: %@", newKey);
         
         NSString *pathByWorkout = [NSString stringWithFormat:@"ce_by_workout/%@/%@/%@/sets/%@", userID, self.activeWorkoutKey, ceID, newKey];
         NSString *pathByExercise = [NSString stringWithFormat:@"ce_by_exercise/%@/%@/%@/sets/%@", selectedCompletedExerciseSnap.value[@"exerciseID"], userID, ceID, newKey];
         
         
         NSDictionary *updateDict = [[NSDictionary alloc] initWithObjects:@[newSet, newSet] forKeys:@[pathByWorkout, pathByExercise]];
         
         [self.firebaseRef updateChildValues:updateDict];
         

     }
    
    if ([unwindSegue.identifier isEqual: @"editExistingWorkoutUnwindSegue"]) {
        NSLog(@"segued over to the new workout");
    }
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (self.isMovingFromParentViewController) {
        // Do your stuff here
        NSLog(@"Is Moving from parent view controller");
    }
}

- (IBAction)deleteWorkoutButton:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Are you sure you want to delete your workout?" message:@"This cannot be undone." preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *alertActionDelete = [UIAlertAction actionWithTitle:@"Yes, delete it." style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
    
        NSString *userID = [FIRAuth auth].currentUser.uid;
        //userID = @"OFFLINE MODE";
        
        // find all your followers
        
        [[[self.firebaseRef child:@"followers"] child:userID] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
            NSLog(@"result of follower pull - snapshot: %@", snapshot);
            
            
            // use the list of followers to define the fanout
            NSMutableDictionary *writeToDict = [[NSMutableDictionary alloc] init];
            
            NSLog(@"about to check if snapshot is null xx");
            if (snapshot.value != [NSNull null]) {
                NSLog(@"it isn't null! bass");
                NSArray *writeToKeys = [snapshot.value allKeys];
                for (NSString *followerKey in writeToKeys) {
                    // follower feed
                    NSString *keyPath = [NSString stringWithFormat:@"feed/%@/%@", followerKey, self.activeWorkoutKey];
                    [writeToDict setObject:[NSNull null] forKey:keyPath];
                }
            } else {
                NSLog(@"no followers");
            }
            
            NSLog(@"now creating the self key");
            NSString *selfKey = [NSString stringWithFormat:@"workouts/%@/%@", userID, self.activeWorkoutKey];
            [writeToDict setObject:[NSNull null] forKey:selfKey];
            
            // CE list - by workout
            NSString *keyPath = [NSString stringWithFormat:@"ce_by_workout/%@/%@", userID, self.activeWorkoutKey];
            [writeToDict setObject:[NSNull null] forKey:keyPath];
            
            // delete Ces - by exercise
            NSLog(@"checking celist count: %lu", (unsigned long)[self.ceList count]);
            if ([self.ceList count] > 0) {
                NSArray *CEList = [self.ceList allKeys];
                for (NSString *ceKey in CEList) {
                    NSString *exerciseKey = [[self.ceList objectForKey:ceKey] objectForKey:@"exerciseID"];
                    NSString *keyPath = [NSString stringWithFormat:@"ce_by_exercise/%@/%@/%@", exerciseKey, userID,ceKey];
                    [writeToDict setObject:[NSNull null] forKey:keyPath];
                }
            } else {
                NSLog(@"no ces in workout");
            }
            
            
            NSLog(@"the writeto dict: %@", writeToDict);
            
            //[self.firebaseRef removeObserverWithHandle:*(self.ceListenerHandle)];
            
            
            [self.firebaseRef updateChildValues:writeToDict withCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
                if (error) {
                    NSLog(@"the workout didn't delete properly... shit: %@", error.debugDescription);
                } else {
                    NSLog(@"workout deleted");
                }
            }];
            
        } withCancelBlock:^(NSError * _Nonnull error) {
            NSLog(@"error pulling follower ata");
        }];
        
        NSLog(@"End of method");
        
    
        [self.navigationController popToRootViewControllerAnimated:YES];
        
    }];
    
    UIAlertAction *alertActionOops = [UIAlertAction actionWithTitle:@"Oops, keep lifting!" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    
    }];
    
    [alert addAction:alertActionOops];
    [alert addAction:alertActionDelete];

    [self presentViewController:alert animated:YES completion:nil];
    
    
}
@end
