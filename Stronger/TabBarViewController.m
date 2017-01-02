//
//  TabBarViewController.m
//  MuscleAbuse
//
//  Created by David Turnquist on 1/24/16.
//  Copyright © 2016 David Turnquist. All rights reserved.
//

#import "TabBarViewController.h"
#import "Constants.h"
@import FirebaseGoogleAuthUI;
@import FirebaseFacebookAuthUI;
@import FirebaseTwitterAuthUI;

@interface TabBarViewController () <FUIAuthDelegate>

@end

@implementation TabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.firebaseRef = [[FIRDatabase database] reference];
    
    self.authUI = [FUIAuth defaultAuthUI];
    self.authUI.delegate = self;
    
    NSArray<id<FUIAuthProvider>> *providers = @[
                                                [[FUIFacebookAuth alloc] init],
                                                ];
    
    self.authUI.providers = providers;
    
    [[FIRAuth auth] addAuthStateDidChangeListener:^(FIRAuth * _Nonnull auth, FIRUser * _Nullable user) {
        if (user) {
            // user authenticated
            NSLog(@"TabBarViewController.m User is signed in with uid: %@", [FIRAuth auth].currentUser.uid);
            
            NSLog(@"TabBarViewController.m User is signed in with uid: %@", [FIRAuth auth].currentUser.uid);
            NSLog(@"TabBarViewController.m user display name: %@", user.displayName);

        } else {
            NSLog(@"No user is signed in.");
            UINavigationController *authViewController = [self.authUI authViewController];
            [self presentViewController:authViewController animated:YES completion:^{
                NSLog(@"presented bitches");
            }];
            // OLD ALTERNATIVE: [self performSegueWithIdentifier:@"SegueToLogin" sender:self];
        }
    }];
}
    
- (void)authUI:(FUIAuth *)authUI didSignInWithUser:(nullable FIRUser *)user error:(nullable NSError *)error {
    // Implement this method to handle signed in user or error if any.
    
    
    // SAVE THE USER
    // Timestamp
     NSTimeInterval intervalInSeconds = [[NSDate date] timeIntervalSinceReferenceDate];
     NSNumber *date = [NSNumber numberWithDouble:-intervalInSeconds];
     
     NSLog(@"about to cerate the dictionary from user: %@", user);
    
     NSString *provider_last = @"";
     NSString *facebookUID = @"";
     NSString *uid = @"";
     NSString *name = @"";
     NSString *name_lowercase = @"";
     NSString *photoURL = @"";
     NSString *fbPhotoURL = @"";
     NSString *email = @"";

     if (user != nil) {
         
         provider_last = [user.providerData[0] providerID];
         uid = user.uid;  // firebase-specific UID
         name = user.displayName;
         name_lowercase = [name lowercaseString];
         email = user.email;
         photoURL = [NSString stringWithFormat:@"%@", user.photoURL];
         
         for (id<FIRUserInfo> profile in user.providerData) {
             
             if ([profile.providerID isEqual: @"facebook.com"]) {
                 NSString *fid = profile.uid;
                 facebookUID = [NSString stringWithFormat:@"%@%@", @"facebook:", fid];
                 fbPhotoURL = [NSString stringWithFormat:@"%@", profile.photoURL];
             }
         }

     } else {
         // No user is signed in.
     }
     
    
    // save the fbook id mapping
    if ([facebookUID isEqual: @""]) {
        // No fbook id
        NSLog(@"no fbook id");
    } else {
        NSLog(@"should save the fb users...");
        [[[self.firebaseRef child:@"fb_users"] child:facebookUID] setValue:@{@"firebase_uid": uid}];
    }
    
    
     // Create the user
     NSDictionary *userDict = @{
     @"provider_last": provider_last,
     @"facebookUID": facebookUID,
     @"uid": uid,
     @"name": name,
     @"name_lowercase": name,
     @"photoURL": photoURL,
     @"fbPhotoURL": fbPhotoURL,
     @"email": email,
     @"lastLoginTimeStamp": date
     };
    
    NSLog(@"User data to save: %@", userDict);
    
     // save it
     NSLog(@"Attempting to save");
     [[[self.firebaseRef child:@"users"] child:user.uid] setValue:userDict];
     NSLog(@"Saved");
    
    NSLog(@"Ran the didsigninuser authui method yeeeeeeHA! authui: %@, user: %@, error: %@", authUI, user, error);
    
}


- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary *)options {
    
    NSString *sourceApplication = options[UIApplicationOpenURLOptionsSourceApplicationKey];
    return [[FUIAuth defaultAuthUI] handleOpenURL:url sourceApplication:sourceApplication];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

    /*
-(void)viewDidAppear:(BOOL)animated {
    
    [[FIRAuth auth] addAuthStateDidChangeListener:^(FIRAuth * _Nonnull auth, FIRUser * _Nullable user) {
        if (user) {
            // user authenticated
            NSLog(@"User is signed in with uid: %@", user.uid);
        } else {
            NSLog(@"No user is signed in.");
            [self performSegueWithIdentifier:@"SegueToLogin" sender:self];
        }
    }];
     
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
