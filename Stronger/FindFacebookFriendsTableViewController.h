//
//  FindFacebookFriendsTableViewController.h
//  MuscleAbuse
//
//  Created by David Turnquist on 4/22/16.
//  Copyright © 2016 David Turnquist. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FriendTableViewCell.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKLoginKit/FBSDKLoginManager.h>
@import Firebase;
@import FirebaseDatabase;
@import FirebaseAuth;
@import FirebaseDatabaseUI;
@import FirebaseFacebookAuthUI;

@interface FindFacebookFriendsTableViewController : UITableViewController


@property (nonatomic) int numberOfRows;
@property (weak, nonatomic) NSString *status;

@property (strong, nonatomic) NSArray *resultsArray;
//@property (weak, nonatomic) NSArray *resultsKeysList;

-(void)loginToFacebook;
@property (strong, nonatomic) FBSDKLoginManager *facebookLogin;
@property (strong, nonatomic) FIRDatabaseReference *firebaseRef;
@property (strong, nonatomic) NSString *userID;
@property (strong, nonatomic) NSString *userNameLower;
@property (strong, nonatomic) NSString *userName;

-(void)pullFacebookFriendsList;
-(void)pullFollowingList;
@property (strong, nonatomic) FIRDatabaseReference *firebaseFollowingRef;
@property (strong, nonatomic) FIRDataSnapshot *followingSnapshot;
//@property (strong, nonatomic) FUITableViewDataSource *dataSource;
//@property (strong, nonatomic) FIRDatabaseQuery *FIRDatabaseQuery;


-(void)updateFollowerStatus:(UIButton*)button;



@end
