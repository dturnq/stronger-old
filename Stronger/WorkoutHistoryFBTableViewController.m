//
//  WorkoutHistoryFBTableViewController.m
//  MuscleAbuse
//
//  Created by David Turnquist on 2/27/16.
//  Copyright © 2016 David Turnquist. All rights reserved.
//

#import "Constants.h"
#import "WorkoutHistoryFBTableViewController.h"
#import "WorkoutHistoryDetailFBTableViewController.h"

#import <SDWebImage/UIImageView+WebCache.h>

@interface WorkoutHistoryFBTableViewController ()

@end

@implementation WorkoutHistoryFBTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.firebaseRef = [[FIRDatabase database] reference];

    self.sourceString = @"workouts";
    
    [self setTableSourceUsingString:self.sourceString];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

/*
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return 0;
}
*/

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return  100;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    self.selectedWorkoutSnap = [self.dataSource objectAtIndex:indexPath.row];

    NSLog(@"About to segue - selected index path: %ld", (long)indexPath.row);
    
    [self performSegueWithIdentifier:@"SegueToViewWorkoutDetail" sender:self];
    
    //} else {
    // Go to the add exercise view
    //}
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

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


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqual: @"SegueToViewWorkoutDetail"]) {
        NSLog(@"Segue!");
        //UINavigationController *nav = segue.destinationViewController;
        WorkoutHistoryDetailFBTableViewController *destinationViewController = (WorkoutHistoryDetailFBTableViewController *) segue.destinationViewController;
        destinationViewController.selectedWorkoutSnap = self.selectedWorkoutSnap;
        
    }
    
}


- (IBAction)segControlTapped:(id)sender {
    
    NSLog(@"Tapped the segment control");
    
    if (self.segControlForSource.selectedSegmentIndex == 0) {
        NSLog(@"control a");
        self.sourceString = @"workouts";
        
        [self setTableSourceUsingString:self.sourceString];
        
    } else {
        NSLog(@"control b");
        
        self.sourceString = @"feed";
        
        [self setTableSourceUsingString:self.sourceString];
    }

}

-(void)setTableSourceUsingString:(NSString *)tableSourceString {
    
    self.dataSource = (id)[NSNull null];
    
    self.firebaseWorkoutsRef = [[self.firebaseRef child:tableSourceString] child:[FIRAuth auth].currentUser.uid];
    self.FIRDatabaseQuery = [[self.firebaseWorkoutsRef queryOrderedByChild:@"timestamp_start"] queryEndingAtValue:@-1];
    
    self.dataSource = [[FUITableViewDataSource alloc] initWithQuery:self.FIRDatabaseQuery view:self.tableView populateCell:^WorkoutHistoryTableViewCell * _Nonnull(UITableView * _Nonnull tableView, NSIndexPath * _Nonnull indexPath, FIRDataSnapshot * _Nonnull snap) {
        
        WorkoutHistoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FBWorkoutHistoryCell"];
        
        NSLog(@"Viewdidload - snap.key: %@", snap.key);
        cell.userDisplayNameLabel.text = snap.value[@"user_name"];
        cell.workoutNameLabel.text = snap.value[@"name"];
        
        ///// Profile Pic
        // Download the user's facebook profile picture
        NSURL *pictureURL = [NSURL URLWithString:snap.value[@"user_profileimage"]];
        NSLog(@"Picture URL: %@", pictureURL);
        [cell.userProfileImage sd_setImageWithURL:pictureURL];
        NSLog(@"about to return workout history cell");
        return cell;
    }];
    
    [self.tableView setDataSource:self.dataSource];
    [self.tableView reloadData];
    

}



@end
