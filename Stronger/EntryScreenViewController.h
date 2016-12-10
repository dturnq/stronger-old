//
//  EntryScreenViewController.h
//  Stronger
//
//  Created by David Turnquist on 12/10/16.
//  Copyright © 2016 David Turnquist. All rights reserved.
//

#import <UIKit/UIKit.h>

@import Firebase;
@import FirebaseDatabase;
@import FirebaseAuth;

@import FirebaseDatabaseUI;

//#import "ActiveWorkoutTableViewController.h"

#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@interface EntryScreenViewController : UIViewController
    
    @property (strong, nonatomic) FIRDatabaseReference *firebaseRef;
    //@property (strong, nonatomic) FBSDKLoginManager *facebookLogin;
    
    @property (strong, nonatomic) FIRDatabaseReference *firebaseWorkoutsRef;
    @property (strong, nonatomic) FUITableViewDataSource *dataSource;
    @property (strong, nonatomic) FIRDatabaseQuery *FIRDatabaseQuery;
    
    @property (strong, nonatomic) NSString *activeWorkoutKey;
    @property (strong, nonatomic) IBOutlet UIButton *incompleteWorkoutButton;
    
    @property (strong, nonatomic) NSNumber *timestamp_start;
    
- (IBAction)logOut:(id)sender;

@end
