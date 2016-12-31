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
    
    NSString *path = [NSString stringWithFormat:@"following/%@",self.userID];
    self.firebaseFollowingRef = [self.firebaseRef child:path];
    
    self.followingSnapshot = [[FIRDataSnapshot alloc] init];
    
    [self pullFollowingList];
    [self loginToFacebook];
    
    NSLog(@"Current user: %@", [FIRAuth auth].currentUser);
    NSLog(@"Current user emial: %@", [FIRAuth auth].currentUser.email);
    NSLog(@"Current user photo: %@", [FIRAuth auth].currentUser.photoURL);
    NSLog(@"Current user photo: %@", [FIRAuth auth].currentUser.displayName);
    NSLog(@"Current user provider data: %@", [FIRAuth auth].currentUser.providerData);
    NSLog(@"Current user provider data row 0: %@", [FIRAuth auth].currentUser.providerData[0]);
    NSLog(@"Current user provider data row 0 uid: %@", [[FIRAuth auth].currentUser.providerData[0] uid]);
    NSLog(@"Current user provider data row  0 photourl: %@", [[FIRAuth auth].currentUser.providerData[0] photoURL]);
    NSLog(@"Current user provider data row  0 displayname: %@", [[FIRAuth auth].currentUser.providerData[0] displayName]);
    NSLog(@"Current user provider data row  0 displayname: %@", [[FIRAuth auth].currentUser.providerData[0] email]);
    
    NSLog(@"FindFacebookFriendsTableViewController.h user id: %@", self.userID);
    
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
                    //NSLog(@"provider data: %@", authData.providerData);
                    
                    
                    //[self dismissViewControllerAnimated:YES completion:nil];
                    
                    // Timestamp
                    NSTimeInterval intervalInSeconds = [[NSDate date] timeIntervalSinceReferenceDate];
                    NSNumber *date = [NSNumber numberWithDouble:-intervalInSeconds];
                    
                    NSLog(@"about to cerate the dictionary from user: %@", user);
                    
                    NSString *provider = @"";
                    NSString *name = @"";
                    NSString *name_lowercase = @"";
                    //NSString *firstName = authData.providerData[@"cachedUserProfile"][@"first_name"];
                    //NSString *lastName = authData.providerData[@"cachedUserProfile"][@"last_name"];
                    //NSString *gender = user.providerData[@"cachedUserProfile"][@"gender"];
                    NSString *photoURL = @"";
                    NSString *email = @"";
                    
                    FIRUser *user = [FIRAuth auth].currentUser;
                    
                    if (user != nil) {
                        for (id<FIRUserInfo> profile in user.providerData) {
                            provider = profile.providerID;
                            NSString *uid = profile.uid;  // Provider-specific UID
                            name = profile.displayName;
                            name_lowercase = [name lowercaseString];
                            email = profile.email;
                            photoURL = [NSString stringWithFormat:@"%@", profile.photoURL];
                            
                            NSLog(@"all the goodies: %@ / %@ / %@ / %@ / %@", provider, uid, name, email, photoURL);
                        }
                    } else {
                        // No user is signed in.
                    }
                    
                    NSLog(@"Provider: %@", provider);
                    NSLog(@"displayName: %@", name);
                    //NSLog(@"Firstname: %@", firstName);
                    //NSLog(@"LastName: %@", lastName);
                    //NSLog(@"Gender: %@", gender);
                    NSLog(@"ProfileImageURL: %@", photoURL);
                    NSLog(@"email: %@", email);
                    
                    NSLog(@"and that's it...");
                    
                    // Create the user
                    NSDictionary *newUser = @{
                                              @"provider": provider,
                                              @"name": name,
                                              @"name_lowercase": name,
                                              //@"firstName": firstName,
                                              //@"lastName": lastName,
                                              //@"gender": gender,
                                              @"photoURL": photoURL,
                                              @"email": email,
                                              @"lastLoginTimeStamp": date
                                              };
                    // save it
                    
                    NSLog(@"Attempting to save");
                    [[[self.firebaseRef child:@"users"] child:user.uid] setValue:newUser];
                    NSLog(@"Saved");
                    
                    NSLog(@"attempting to pull friend's list");
                    [self pullFacebookFriendsList];
                }
            }];
            
            
        }

        
    }];
}

-(void)pullFacebookFriendsList {
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
            NSLog(@"error @encountered when trying to find friends - better luck next time - %@", error);
            self.status = @"error";
            NSLog(@"Result: %@", result);
        } else if ([[result objectForKey:@"data"] count] == 0) {
            NSLog(@"finished request - no friends");
            NSLog(@"Result: %@", result);
            self.status = @"no friends";
            NSNumber *temp = [NSNumber numberWithLong:[[result objectForKey:@"data"] count]];
            NSLog(@"NSNumber: %@", temp);
            self.numberOfRows = 1;
            self.resultsArray = @[];
        } else {
            NSLog(@"finished request");
            NSLog(@"Result: %@", result);
            self.status = @"done";
            NSNumber *temp = [NSNumber numberWithLong:[[result objectForKey:@"data"] count]];
            NSLog(@"NSNumber: %@", temp);
            self.numberOfRows = [temp intValue];
            self.resultsArray = [result objectForKey:@"data"];
            
        }
        [self.tableView reloadData];
        
        
        // I could individually pull each friend, and see whether I get a match
        // I could pull my whole list of followers, and do a comparison
        // If I wanted, I could even store my list of followers -> but why?
        
        
    }];
    
}

-(void)pullFollowingList {
    NSLog(@"Pulling followers list");
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

    return self.numberOfRows;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


- (FriendTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
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
    
    if ([self.status  isEqual: @"done"]) {


        NSDictionary *friendDict = [self.resultsArray objectAtIndex:indexPath.row];
        friendName = [friendDict objectForKey:@"name"];
        NSString *friendID = [NSString stringWithFormat:@"facebook:%@",[friendDict objectForKey:@"id"]];
        
        if ([self.followingSnapshot hasChild:friendID]) {
            NSLog(@"Found - setting follower status to unfollower");
            followerStatus = @"Unfollow";
        } else {
            NSLog(@"Not found - setting follower status to unfollower");
            followerStatus = @"Follow";
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
    NSDictionary *friendDict = [self.resultsArray objectAtIndex:row];
    NSString *friendIDTemp = [friendDict objectForKey:@"id"];
    NSString *friendID = [NSString stringWithFormat:@"facebook:%@",friendIDTemp];
    NSString *friendName = [friendDict objectForKey:@"name"];
    NSString *friendNameLower = [friendName lowercaseString];

    if ([self.followingSnapshot hasChild:friendID]) {
        
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

        FIRDatabaseQuery *query = [[[[[self.firebaseRef child:@"workouts"] child:friendID] queryOrderedByChild:@"timestamp_start"] queryEndingAtValue:@-1] queryLimitedToFirst:100];
        
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
            
            NSDictionary *followerDict = @{@"name": self.userName, @"name_lowercase":self.userNameLower};
            
            NSString *urlKey = [NSString stringWithFormat:@"followers/%@/%@", friendID, self.userID];
            [writeToDict setObject:followerDict forKey:urlKey];
            

            NSDictionary *followingDict = @{@"name": friendName, @"name_lowercase":friendNameLower};
            
            NSString *urlKey2 = [NSString stringWithFormat:@"following/%@/%@", self.userID, friendID];
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
