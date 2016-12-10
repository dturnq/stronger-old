//
//  SaveWorkoutViewController.m
//  MuscleAbuse
//
//  Created by David Turnquist on 1/24/16.
//  Copyright © 2016 David Turnquist. All rights reserved.
//

#import "SaveWorkoutViewController.h"

@interface SaveWorkoutViewController ()

@end

@implementation SaveWorkoutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.firebaseRef = [[FIRDatabase database] reference];
    NSString *userID = [FIRAuth auth].currentUser.uid;
    userID = @"OFFLINE MODE";
    self.firebaseWorkoutsRef = [[self.firebaseRef child:@"workouts"] child:userID];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
 
    if ([segue.identifier isEqual:@"SaveWorkout"]) {
 
        // BEFORE saving the workout, set all workouts, CEs, sets to "Raw Complete"
        NSLog(@"Beginning save segue to feed");
        
        NSTimeInterval intervalInSeconds = [[NSDate date] timeIntervalSinceReferenceDate];
        NSNumber *date = [NSNumber numberWithDouble:-intervalInSeconds];
        
        FIRUser *user = [FIRAuth auth].currentUser;
        NSString *username = user.displayName;
        username = @"OFFLINE MODE";
        NSString *userID = user.uid;
        userID = @"OFFLINE MODE";
        NSString *userImage = [NSString stringWithFormat:@"%@", user.photoURL];
        userImage = @"OFFLINE MODE";
        NSNumber *duration = [NSNumber numberWithInteger:([self.timestamp_start integerValue] - [date integerValue])];
        
        NSLog(@"duration: %@", duration);
        
        //FIRDatabaseReference *newWorkoutRef = [self.firebaseWorkoutsRef childByAutoId];
        //self.activeWorkoutKey = newWorkoutRef.key;
        [[[self.firebaseRef child:@"pr"] child:userID] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot_pr) {
            
            NSLog(@"pulling the PR");
            
            NSDictionary *prAllDict = [[NSDictionary alloc] init];
            
            if (snapshot_pr.exists) {
                prAllDict = snapshot_pr.value;
            }
            
            NSMutableDictionary *writeToDict = [[NSMutableDictionary alloc] init];
            
            NSArray *ceKeyList = [self.ceList allKeys];
            
            int weightCounter = 0;
            int ceCounter = 0;
            int repCounter = 0;
            int setCounter = 0;
            int prCounter = 0;
            
            
            for (NSString *ceKey in ceKeyList) {
                
                ceCounter = ceCounter + 1;
                
                NSDictionary *ceDict = self.ceList[ceKey];
                
                // Get the strongest set in the CE
                NSString *exerciseID = [ceDict objectForKey:@"exerciseID"];
                
                NSNumber *cePR = [NSNumber numberWithInt:0];
                
                NSLog(@"ceDict: %@", ceDict);
                NSLog(@"cePR: %@", cePR);

                NSDictionary *ceSets = [ceDict objectForKey:@"sets"];
                
                NSLog(@"ceSets: %@", ceSets);
                NSLog(@"keys in cesets: %@", [ceSets allKeys]);
                
                NSArray *setKeys = [ceSets allKeys];
                
                int setKeysCount = (int)[setKeys count];
                
                NSLog(@"setkeyscount: %d", setKeysCount);
                
                if (setKeysCount == 0) {
                    NSString *ceByExercisePath = [NSString stringWithFormat:@"ce_by_exercise/%@/%@/%@", exerciseID, userID, ceKey];
                    [writeToDict setObject:[NSNull null] forKey:ceByExercisePath];
                    
                    NSString *ceByWorkoutPath = [NSString stringWithFormat:@"ce_by_workout/%@/%@/%@", userID, ceDict[@"workout"], ceKey];
                    [writeToDict setObject:[NSNull null] forKey:ceByWorkoutPath];
                    
                    ceCounter = ceCounter - 1;
                } else {
                    setCounter = setCounter + setKeysCount;
                    
                    for (NSString *ceSetKey in setKeys) {
                        
                        NSDictionary *ceSetDict = ceSets[ceSetKey];
                        
                        NSLog(@"ce_set: %@", ceSetDict);
                        int setStat = [ceSetDict[@"coded_set"] intValue];
                        int setReps = [ceSetDict[@"reps"] intValue];
                        int setWeight = [ceSetDict[@"weight"] intValue];
                        int cePRInt = [cePR intValue];
                        
                        repCounter = repCounter + setReps;
                        weightCounter = weightCounter + setWeight;
                        
                        NSLog(@"setstat: %d", setStat);
                        NSLog(@"cepr: %d", cePRInt);
                        
                        if ([ceSetDict[@"coded_set"] intValue] > [cePR intValue]) {
                            cePR = ceSetDict[@"coded_set"];
                        }
                    }
                    
                    
                    //NSDictionary *prDict = [[NSDictionary alloc] init];
                    NSDictionary *prDict = [prAllDict objectForKey:exerciseID];
                    NSLog(@"prdict: %@", prDict);
                    NSNumber *currentPR = [NSNumber numberWithInt:0];
                    if (prDict) {
                        NSLog(@"Yup, there's a pr");
                        currentPR = prDict[@"pr_coded"];
                    } else {
                        NSLog(@"no pr found");
                    }
                    
                    if ([cePR intValue] > [currentPR intValue]) {
                        NSLog(@"PRd!");
                        prCounter = prCounter + 1;
                        NSString *prPath = [NSString stringWithFormat:@"pr/%@/%@/pr_coded", userID, exerciseID];
                        [writeToDict setObject:cePR forKey:prPath];
                        
                        NSString *ceByExercisePath = [NSString stringWithFormat:@"ce_by_exercise/%@/%@/%@/pr", exerciseID, userID, ceKey];
                        [writeToDict setObject:@"Yes" forKey:ceByExercisePath];
                        
                        NSString *ceByWorkoutPath = [NSString stringWithFormat:@"ce_by_workout/%@/%@/%@/pr", userID, ceDict[@"workout"], ceKey];
                        [writeToDict setObject:@"Yes" forKey:ceByWorkoutPath];
                        
                    } else {
                        NSLog(@"No pr");
                    }
                }
                
                
                
            }
            
            NSDictionary *workoutDict = @{
                                          @"name" : self.workoutNameTextField.text,
                                          @"name_lowercase" : [self.workoutNameTextField.text lowercaseString],
                                          @"complete" : @"Yes",
                                          @"timestamp_start" : self.timestamp_start,
                                          @"timestamp_end" : date,
                                          @"user_name" : username,
                                          @"user_profileimage" : userImage,
                                          @"ce_count" : [NSNumber numberWithInt:ceCounter],
                                          @"set_count" : [NSNumber numberWithInt:setCounter],
                                          @"rep_count" : [NSNumber numberWithInt:repCounter],
                                          @"weight_count" : [NSNumber numberWithInt:weightCounter],
                                          @"pr_count" : [NSNumber numberWithInt:prCounter],
                                          @"duration" : duration,
                                          };
            
            
            [[[self.firebaseRef child:@"followers"] child:userID] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
                NSLog(@"result of follower pull: %@", snapshot);
                NSLog(@"result of follower pull: %@", snapshot.value);
                
                NSArray *writeToKeys = [snapshot.value allKeys];

                for (NSString *followerKey in writeToKeys) {
                    NSString *keyPath = [NSString stringWithFormat:@"feed/%@/%@", followerKey, self.activeWorkoutKey];
                    [writeToDict setObject:workoutDict forKey:keyPath];
                }
                NSString *selfKey = [NSString stringWithFormat:@"workouts/%@/%@", userID, self.activeWorkoutKey];
                [writeToDict setObject:workoutDict forKey:selfKey];
                
                NSLog(@"the writeto dict: %@", writeToDict);
                
                [self.firebaseRef updateChildValues:writeToDict withCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
                    if (error) {
                        NSLog(@"the workout didn't post properly... shit: %@", error.debugDescription);
                    } else {
                        NSLog(@"Successful workous save! Congrats!");
                    }
                }];
                
            } withCancelBlock:^(NSError * _Nonnull error) {
                NSLog(@"error pulling follower ata");
            }];
            

            
        }];
        
        
        
        
        
        //FIRDatabaseReference *workoutUpdateRef = [self.firebaseWorkoutsRef child:self.activeWorkoutKey];
        //[workoutUpdateRef updateChildValues:workoutDict];
 
    }
    
}


@end
