//
//  FindFacebookFriendsTableViewController.m
//  MuscleAbuse
//
//  Created by David Turnquist on 4/22/16.
//  Copyright © 2016 David Turnquist. All rights reserved.
//

#import "FindFacebookFriendsTableViewController.h"
#import "Constants.h"

@interface FindFacebookFriendsTableViewController ()

@end

@implementation FindFacebookFriendsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;

    NSLog(@"FindFacebookFriendsTableViewController.h View did load");
    
    self.numberOfRows = 1;
    self.status = @"searching";
    
    self.firebaseRef = [[FIRDatabase database] reference];
    self.facebookLogin = [[FBSDKLoginManager alloc] init];
    self.userID = [FIRAuth auth].currentUser.uid;
    self.userName = [FIRAuth auth].currentUser.displayName;
    self.userNameLower = [[FIRAuth auth].currentUser.displayName lowercaseString];
    
    NSLog(@"username orig: %@", self.userName);
    NSLog(@"username orig: %@", self.userNameLower);
    NSLog(@"user global orig: %@", [FIRAuth auth].currentUser);
    
    NSString *path = [NSString stringWithFormat:@"following/%@",self.userID];
    self.firebaseFollowingRef = [self.firebaseRef child:path];
    
    self.followingSnapshot = [[FIRDataSnapshot alloc] init];
    
    [self pullFollowingList];
    [self loginToFacebook];

}

-(void)loginToFacebook {
    
    [self.facebookLogin logInWithReadPermissions:@[@"email", @"user_friends"] fromViewController:self handler:^(FBSDKLoginManagerLoginResult *facebookResult, NSError *facebookError) {
        
        if (facebookError) {
            NSLog(@"Facebook login failed. Error: %@", facebookError);
        } else if (facebookResult.isCancelled) {
            NSLog(@"Facebook login got cancelled.");
        } else {
            NSLog(@"Facebook login working");
            NSString *accessToken = [[FBSDKAccessToken currentAccessToken] tokenString];
            FIRAuthCredential *credential = [FIRFacebookAuthProvider credentialWithAccessToken:accessToken];
            [[FIRAuth auth] signInWithCredential:credential completion:^(FIRUser *user, NSError *error) {
                if (error) {
                    NSLog(@"Login failed. %@", error);
                } else {
                    NSLog(@"Logged in! %@", user);
                    
                    NSLog(@"attempting to pull friend's list");
                    [self pullFacebookFriendsList];
                }
            }];
            
            
        }

        
    }];
}

-(void)pullFacebookFriendsList {
    
    // Pull the Facebook Friend List
    // Format will be an array of dictionaries, with each dictionary containing a user
    // within the dictionary, there will be an "id" (with a pure number ID) and a "name"
    
    NSLog(@"about to start fb friends request");
    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
                                  initWithGraphPath:@"/me/friends"
                                  parameters:@{@"fields": @"id, name"}
                                  HTTPMethod:@"GET"];
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
                                          id result,
                                          NSError *error) {
        NSLog(@"finished request");
        NSLog(@"Result: %@", result);
        // Handle the result
        
        if (error) {
            self.status = @"error";
        } else if ([[result objectForKey:@"data"] count] == 0) {
            self.status = @"no friends";
            NSNumber *temp = [NSNumber numberWithLong:[[result objectForKey:@"data"] count]];
            NSLog(@"NSNumber: %@", temp);
            self.numberOfRows = 1;
            self.fbFriendListArray = @[];
        } else {
            NSLog(@"Result: %@", result);
            self.status = @"done";
            NSNumber *temp = [NSNumber numberWithLong:[[result objectForKey:@"data"] count]];
            self.numberOfRows = [temp intValue];
            
            
            /*
            NSArray *fbFriendListArray = [result objectForKey:@"data"];
            
            
            
            for (NSDictionary *friendDict in fbFriendListArray) {
                NSString *friendName = [friendDict objectForKey:@"name"];
                NSString *friendID = [NSString stringWithFormat:@"facebook:%@",[friendDict objectForKey:@"id"]];
                
                FIRDatabaseQuery *prequery = [[[self.firebaseRef child:@"fb_users"] queryOrderedByKey] queryEqualToValue:friendID];
                
                prequery observesignle
            }
            */
            
            
            
            self.fbFriendListArray = [result objectForKey:@"data"];
            
            
            
            
            
        }
        [self.tableView reloadData];
        
        
        // I could individually pull each friend, and see whether I get a match
        // I could pull my whole list of followers, and do a comparison
        // If I wanted, I could even store my list of followers -> but why?
        
        
    }];
    
}

-(void)pullFollowingList {
    NSLog(@"Pulling followers list");
    // firebaseFollowingRef refers to root/following/[uid]
    // it will contain a list of people you are following. format will be uid for the user being followed, with a dictionary inside containing basic user info.
    [self.firebaseFollowingRef observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSLog(@"Snapshot updated");
        self.followingSnapshot = snapshot;
        [self.tableView reloadData];

    }];
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.numberOfRows;
}


- (FriendTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"indexpath.row: %ld", (long)indexPath.row);
    
    FriendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"friendCell" forIndexPath:indexPath];
    
    // Configure the cell...
    
    NSString *friendName = @"Searching friends...";
    NSString *followerStatus = @"";
    
    
    if ([self.status  isEqual: @"error"]) {
        friendName = @"Error logging into Facebook";
        followerStatus = @"";
    }
    
    if ([self.status  isEqual: @"no friends"]) {
        friendName = @"No friends found :(";
        followerStatus = @"";
    }
    
    if ([self.status isEqual: @"done"]) {


        NSDictionary *friendDict = [self.fbFriendListArray objectAtIndex:indexPath.row];
        friendName = [friendDict objectForKey:@"name"];
        NSString *friendID = [NSString stringWithFormat:@"facebook:%@",[friendDict objectForKey:@"id"]];
        
        
        
        if ([self.followingSnapshot hasChild:friendID]) {
            NSLog(@"Found - setting follower status to unfollow");
            followerStatus = @"Unfollow";
            NSLog(@"followerstatus: %@", followerStatus);
        } else {
            NSLog(@"Not found - setting follower status to follow");
            followerStatus = @"Follow";
            NSLog(@"followerstatus: %@", followerStatus);
        }
        NSLog(@"friendname: %@", friendName);
        NSLog(@"followerstatus: %@", followerStatus);
        
    }
    
    //NSLog(@"Setting up cell state - action button will say: %@", followerStatus);
    cell.friendNameLabel.text = friendName;
    //cell.followingButton.titleLabel.text = followerStatus;
    [cell.followingButton setTitle:followerStatus forState:UIControlStateNormal];
    //NSLog(@"cellButton text should say:%@", cell.followingButton.titleLabel.text);
    cell.followingButton.tag = indexPath.row;
    [cell.followingButton addTarget:self action:@selector(updateFollowerStatus:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

-(void)updateFollowerStatus:(UIButton*)button {
    long row = button.tag;
    NSLog(@"row clicked: %ld", row);
    NSDictionary *friendDict = [self.fbFriendListArray objectAtIndex:row];
    NSString *friendIDTemp = [friendDict objectForKey:@"id"];
    NSString *friendID = [NSString stringWithFormat:@"facebook:%@",friendIDTemp];
    NSString *friendName = [friendDict objectForKey:@"name"];
    NSString *friendNameLower = [friendName lowercaseString];

    NSLog(@"friend id: %@", friendID);
    
    if ([self.followingSnapshot hasChild:friendID]) {
        
        // This REMOVES you as a follower
        
        NSLog(@"Already following");
        FIRDatabaseQuery *query = [[[[[self.firebaseRef child:@"workouts"] child:friendID] queryOrderedByChild:@"timestamp_start"] queryEndingAtValue:@-1] queryLimitedToFirst:100];
        
        [query observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {

            
            NSMutableDictionary *writeToDict = [[NSMutableDictionary alloc] init];
            
            
            if (snapshot.exists) {
                NSDictionary *workouts = snapshot.value;
                
                NSLog(@"friend workouts: %@", workouts);
                
                NSArray *keys = [workouts allKeys];
                
                for (NSString *workoutKey in keys) {
                    NSString *urlKey = [NSString stringWithFormat:@"feed/%@/%@", self.userID, workoutKey];
                    [writeToDict setObject:[NSNull null] forKey:urlKey];
                    
                    NSLog(@"Updated workout key");
                }
            } else {
                NSLog(@"there's no snapshot sucka");
            }

            
            NSString *urlKey = [NSString stringWithFormat:@"followers/%@/%@", friendID, self.userID];
            [writeToDict setObject:[NSNull null] forKey:urlKey];

            
            NSString *urlKey2 = [NSString stringWithFormat:@"following/%@/%@", self.userID, friendID];
            [writeToDict setObject:[NSNull null] forKey:urlKey2];
            
            NSLog(@"the writeto dict: %@", writeToDict);
            
            [self.firebaseRef updateChildValues:writeToDict withCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
                if (error) {
                    NSLog(@"the following update didn't post properly... shit: %@", error.debugDescription);
                } else {
                    NSLog(@"psoted");
                }
            }];
            
        }];
        
        
        
    } else {

        // This ADDS you ass a follower
        NSLog(@"This seems to be a new friend - friend ID not found");
        
        NSLog(@"friend is =>%@",friendID);
        
        //[[[self.firebaseRef child:@"fb_users"] child:friendID] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        
        FIRDatabaseQuery *prequery = [[[self.firebaseRef child:@"fb_users"] queryOrderedByKey] queryEqualToValue:friendID];
        
        [prequery observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
            
            NSLog(@"snap: %@", snapshot);
            
            NSDictionary *idDict = snapshot.value;
            NSString *friendIDFirebase = @"";
            
            
            if (idDict == (id)[NSNull null]) {
                // too bad
                NSLog(@"EXTREME ERROR: WAS NOT ABLE TO PULL ID");
            } else {
                NSLog(@"VICTORY - DICT: %@", idDict);
                friendIDFirebase = [[idDict valueForKey:friendID] valueForKey:@"firebase_uid"];
                
                FIRDatabaseQuery *query = [[[[[self.firebaseRef child:@"workouts"] child:friendIDFirebase] queryOrderedByChild:@"timestamp_start"] queryEndingAtValue:@-1] queryLimitedToFirst:100];
                
                [query observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
                    
                    NSMutableDictionary *writeToDict = [[NSMutableDictionary alloc] init];
                    
                    
                    if (snapshot.exists) {
                        NSDictionary *workouts = snapshot.value;
                        
                        NSLog(@"friend workouts: %@", workouts);
                        
                        NSArray *keys = [workouts allKeys];
                        
                        for (NSString *workoutKey in keys) {
                            NSDictionary *workoutDict = [workouts objectForKey:workoutKey];
                            
                            NSString *urlKey = [NSString stringWithFormat:@"feed/%@/%@", self.userID, workoutKey];
                            [writeToDict setObject:workoutDict forKey:urlKey];
                            
                            NSLog(@"Updated workout key");
                        }
                    } else {
                        NSLog(@"there's no snapshot sucka");
                    }
                    
                    NSLog(@"done with loop");
                    
                    NSLog(@"username: %@", self.userName);
                    NSLog(@"username lower: %@", self.userNameLower);
                    
                    NSDictionary *followerDict = @{@"name": self.userName, @"name_lowercase":self.userNameLower};
                    
                    NSLog(@"setting the followerdict: %@", followerDict);
                    NSString *urlKey = [NSString stringWithFormat:@"followers/%@/%@", friendIDFirebase, self.userID];
                    [writeToDict setObject:followerDict forKey:urlKey];
                    
                    
                    NSDictionary *followingDict = @{@"name": friendName, @"name_lowercase":friendNameLower};
                    
                    NSLog(@"setting the following dict: %@", followingDict);
                    
                    NSString *urlKey2 = [NSString stringWithFormat:@"following/%@/%@", self.userID, friendIDFirebase];
                    [writeToDict setObject:followingDict forKey:urlKey2];
                    
                    
                    [self.firebaseRef updateChildValues:writeToDict withCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
                        if (error) {
                            NSLog(@"the following update didn't post properly... shit: %@", error.debugDescription);
                        } else {
                            NSLog(@"psoted");
                        }
                    }];
                    
                }];
                
            }
        }];
        
    }
    
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
