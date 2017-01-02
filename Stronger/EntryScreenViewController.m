//
//  EntryScreenViewController.m
//  Stronger
//
//  Created by David Turnquist on 12/10/16.
//  Copyright © 2016 David Turnquist. All rights reserved.
//

#import "Constants.h"
#import "EntryScreenViewController.h"
#import "ActiveWorkoutTableViewController.h"


@interface EntryScreenViewController ()
    
    @end

@implementation EntryScreenViewController
    
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.firebaseRef = [[FIRDatabase database] reference];
    
    [self viewDidAppear:YES];
    
    
}
    
    
    
-(void)viewDidAppear:(BOOL)animated {
    
    NSString *userID = [FIRAuth auth].currentUser.uid;
    
    if (userID != nil) {

        self.firebaseWorkoutsRef = [[self.firebaseRef child:@"workouts"] child:userID];
        FIRDatabaseQuery *query = [[[[self.firebaseRef child:@"workouts"] child:userID] queryOrderedByChild:@"complete"] queryEqualToValue:@"No"];

        
        [query observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
            //NSLog(@"snap.value for query: %@", snapshot.value);
            
            NSDictionary *workouts = snapshot.value;
            if (workouts == (id)[NSNull null]) {

                self.incompleteWorkoutButton.titleLabel.text = @"No incomplete workouts";
            } else {

                self.incompleteWorkoutButton.titleLabel.text = [NSString stringWithFormat:@"%lu incomplete workouts", (unsigned long)[workouts count]];
            }
        }];

    } else {
        //self.firebaseWorkoutsRef = @"";
    }
    
    
    
}
    
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
    
    
-(IBAction)unwindToEntryScreen:(UIStoryboardSegue *)unwindSegue
    {
        
        // If the user clicked "Save", then save
        
        
        // If the user clicked "Cancel", delete workouts labelled "Garbage", plus all related objects
        if ([unwindSegue.identifier  isEqual: @"CancelWorkout"]) {
            
            // Unpin and delete all incomplete workouts
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0),
                           ^{
                               /*
                                PFIRDatabaseQuery *query = [PFIRDatabaseQuery queryWithClassName:@"Workout"];
                                [query fromLocalDatastore];
                                [query whereKey:@"active" equalTo:@"Garbage"];
                                NSArray *objects = [query findObjects];
                                
                                
                                for (Workout *workout in objects) {
                                
                                PFIRDatabaseQuery *querySets = [Set query];
                                [querySets fromLocalDatastore];
                                [querySets whereKey:@"workout" equalTo:workout];
                                NSArray *objects2 = [querySets findObjects];
                                [PFObject unpinAll:objects2];
                                
                                PFIRDatabaseQuery *queryCEs = [CompletedExercise query];
                                [queryCEs fromLocalDatastore];
                                [queryCEs whereKey:@"workout" equalTo:workout];
                                NSArray *objects3 = [queryCEs findObjects];
                                [PFObject unpinAll:objects3];
                                
                                [workout unpin];
                                }
                                dispatch_async(dispatch_get_main_queue(),
                                ^{
                                
                                });
                                */
                           });
        } else if ([unwindSegue.identifier isEqual:@"SaveWorkout"]) {
            //NSLog(@"Perform segue to Save Workout // nameing modal view");
            
            // Jump to the feed view
            //self.tabBarController.selectedViewController = [self.tabBarController.viewControllers objectAtIndex:2];
            
        } else if ([unwindSegue.identifier isEqual:@"ReturnFromModal"]) {
            // closed modal
            
        } else if ([unwindSegue.identifier isEqualToString:@"CloseExistingSegue"]) {
            
            [self viewDidAppear:YES];
        }
        
    }
    
    
#pragma mark - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    
    if ([segue.identifier  isEqual: @"StartNewWorkout"]) {
        

        // Prep values
        FIRUser *user = [FIRAuth auth].currentUser;
        NSString *username = user.displayName;
        //username = @"OFFLINE MODE";
        NSString *userID = user.uid;
        //userID = @"OFFLINE MODE";
        NSString *userImage = [NSString stringWithFormat:@"%@", user.photoURL];
        userImage = @"OFFLINE MODE";
        

        // Timestamp
        NSTimeInterval intervalInSeconds = [[NSDate date] timeIntervalSinceReferenceDate];
        NSNumber *date = [NSNumber numberWithDouble:-intervalInSeconds];
        NSNumber *fakeDate = [NSNumber numberWithDouble:0];
        
        self.timestamp_start = date;
        

        NSDictionary *workoutDict = @{
                                      @"name" : @"Live workout!",
                                      @"name_lowercase" : @"live workout!",
                                      @"complete" : @"No",
                                      @"timestamp_start" : date,
                                      @"timestamp_end" : fakeDate,
                                      @"user_name" : username,
                                      @"user_profileimage" : userImage,
                                      };
        

        FIRDatabaseReference *newWorkoutRef = [self.firebaseWorkoutsRef childByAutoId];
        self.activeWorkoutKey = newWorkoutRef.key;
        

        [[[self.firebaseRef child:@"followers"] child:userID] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
            

            
            NSMutableDictionary *writeToDict = [[NSMutableDictionary alloc] init];
            

            if (snapshot.value != [NSNull null]) {
                NSArray *writeToKeys = [snapshot.value allKeys];
                for (NSString *followerKey in writeToKeys) {
                    // follower feed
                    NSString *keyPath = [NSString stringWithFormat:@"feed/%@/%@", followerKey, self.activeWorkoutKey];
                    [writeToDict setObject:[NSNull null] forKey:keyPath];
                }
            } else {
                // no followers
            }
            
            NSString *selfKey = [NSString stringWithFormat:@"workouts/%@/%@", userID, self.activeWorkoutKey];
            
            [writeToDict setObject:workoutDict forKey:selfKey];
            
            //[self.firebaseRef setValuesForKeysWithDictionary:writeToDict];
            
            
            [self.firebaseRef updateChildValues:writeToDict withCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
                if (error) {
                    NSLog(@"the workout didn't post properly... shit: %@", error.debugDescription);
                } else {
                    NSLog(@"new workout created");
                }
            }];
            
            
        } withCancelBlock:^(NSError * _Nonnull error) {
            NSLog(@"error pulling follower ata");
        }];
        
        
        
        
        //[newWorkoutRef setValue:workoutDict];
        
        
        
        // Fill in the values
        /*
         Workout *activeWorkout = [Workout object];
         //activeWorkout.user = user;
         activeWorkout.beganAt = now;
         activeWorkout.active = @"Active";
         activeWorkout.totalCompletedExercises = [NSNumber numberWithInt:0];
         activeWorkout.totalSets = [NSNumber numberWithInt:0];
         activeWorkout.totalReps = [NSNumber numberWithInt:0];
         activeWorkout.totalWeight = [NSNumber numberWithInt:0];
         */
        
        
        // Prep the stopwatch
        /*
         Stopwatch *stopwatch = [[Stopwatch alloc] init];
         [stopwatch setWorkoutStartTime:now];
         [stopwatch setSetStartTime:now];
         */
        
        
        // Send the workout to the destination view controller
        ActiveWorkoutTableViewController *destinationViewController = segue.destinationViewController;
        destinationViewController.activeWorkoutKey = self.activeWorkoutKey;
        destinationViewController.timestamp_start = self.timestamp_start;
        //destinationViewController.activeWorkoutSnap = activeWorkout;
    } else if ([segue.identifier isEqual:@"ContinueWorkout"]) {
        // Send the workout to the destination view controller
        ActiveWorkoutTableViewController *destinationViewController = segue.destinationViewController;
        //destinationViewController.activeWorkoutSnap = self.activeWorkout;
        
    }
    
}
    
    
- (IBAction)logOut:(id)sender {
    
    [[FIRAuth auth] signOut:nil];
    
}
    @end

