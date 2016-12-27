//
//  TabBarViewController.h
//  MuscleAbuse
//
//  Created by David Turnquist on 1/24/16.
//  Copyright © 2016 David Turnquist. All rights reserved.
//

#import <UIKit/UIKit.h>
@import Firebase;
@import FirebaseDatabase;
@import FirebaseAuth;
@import FirebaseDatabaseUI;
@import FirebaseAuthUI;

@interface TabBarViewController : UITabBarController


    @property (strong, nonatomic) FIRDatabaseReference *firebaseRef;
    
    @property (strong, nonatomic) FUIAuth *authUI;

@end
