//
//  TabBarViewController.m
//  MuscleAbuse
//
//  Created by David Turnquist on 1/24/16.
//  Copyright © 2016 David Turnquist. All rights reserved.
//

#import "TabBarViewController.h"
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
            NSLog(@"User is signed in with uid: %@", user.uid);
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
