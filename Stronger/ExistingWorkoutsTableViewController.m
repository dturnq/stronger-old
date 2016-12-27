//
//  ExistingWorkoutsTableViewController.m
//  MuscleAbuse
//
//  Created by David Turnquist on 8/20/16.
//  Copyright © 2016 David Turnquist. All rights reserved.
//

#import "ExistingWorkoutsTableViewController.h"
#import "ActiveWorkoutTableViewController.h"

@interface ExistingWorkoutsTableViewController ()

@end

@implementation ExistingWorkoutsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.firebaseRef = [[FIRDatabase database] reference];
    NSString *userID = [FIRAuth auth].currentUser.uid;
    //userID = @"OFFLINE MODE";
    //self.firebaseCompletedExercisesRef = [[self.firebaseRef child:@"ce_by_workout"] child:userID];
    
    
    self.FIRDatabaseQuery = [[[[self.firebaseRef child:@"workouts"] child:userID] queryOrderedByChild:@"complete"] queryEqualToValue:@"No"];
    
    
     self.dataSource = [[FUITableViewDataSource alloc] initWithQuery:self.FIRDatabaseQuery view:self.tableView populateCell:^UITableViewCell * _Nonnull(UITableView * _Nonnull tableView, NSIndexPath * _Nonnull indexPath, FIRDataSnapshot * _Nonnull snap) {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ExistingWorkoutCell"
                                                                forIndexPath:indexPath];
        
        NSLog(@"snap: %@", snap);
        
        // Figure out the date
        NSDate *date = [NSDate dateWithTimeIntervalSinceReferenceDate:(-[snap.value[@"timestamp_start"] doubleValue])];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
        [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
        
        NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
        [timeFormatter setDateStyle:NSDateFormatterNoStyle];
        [timeFormatter setTimeStyle:NSDateFormatterShortStyle];
        
        NSString *formattedDateString = [dateFormatter stringFromDate:date];
        NSString *formattedTimeString = [timeFormatter stringFromDate:date];
        
        NSString *finalString = [NSString stringWithFormat:@"Began %@ at %@", formattedDateString, formattedTimeString];
        
        cell.textLabel.text = finalString;
        
        return cell;
        
    }];
    
    
    
    
    
    //self.dataSource = [[FUITableViewDataSource alloc] initWithQuery:self.FIRDatabaseQuery prototypeReuseIdentifier:@"ExistingWorkoutCell" view:self.tableView];
    
    /*
    
    [self.dataSource populateCellWithBlock:^(UITableViewCell *cell, FIRDataSnapshot *snap) {
        NSLog(@"snap: %@", snap);
        
        // Figure out the date
        NSDate *date = [NSDate dateWithTimeIntervalSinceReferenceDate:(-[snap.value[@"timestamp_start"] doubleValue])];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
        [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
        
        NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
        [timeFormatter setDateStyle:NSDateFormatterNoStyle];
        [timeFormatter setTimeStyle:NSDateFormatterShortStyle];
        
        NSString *formattedDateString = [dateFormatter stringFromDate:date];
        NSString *formattedTimeString = [timeFormatter stringFromDate:date];
        
        NSString *finalString = [NSString stringWithFormat:@"Began %@ at %@", formattedDateString, formattedTimeString];
        
        cell.textLabel.text = finalString;
    }];
      */
    
    
    [self.tableView setDataSource:self.dataSource];
    
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    // Open the completed exercise view
    
    self.selectedExistingExerciseSnap = [self.dataSource objectAtIndex:indexPath.row];
    // OLD: self.selectedExistingExerciseSnap = [self.dataSource.array objectAtIndex:indexPath.row];

    NSLog(@"About to segue - selected index path: %ld", (long)indexPath.row);

    
    [self performSegueWithIdentifier:@"EditExistingWorkoutSegue" sender:self];
    

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
    if ([segue.identifier isEqual: @"EditExistingWorkoutSegue"]) {
        NSLog(@"EditExistingWorkoutSegue");
        
        
        // Send the workout to the destination view controller
        
        ActiveWorkoutTableViewController *destinationViewController = segue.destinationViewController;
        
        self.activeWorkoutKey = self.selectedExistingExerciseSnap.key;
        self.timestamp_start = [self.selectedExistingExerciseSnap.value objectForKey:@"timestamp_start"];
        
        NSLog(@"see the key: %@", self.activeWorkoutKey);
        NSLog(@"see the timestamp: %@", self.timestamp_start);
        
        destinationViewController.activeWorkoutKey = self.activeWorkoutKey;
        destinationViewController.timestamp_start = self.timestamp_start;
        
        NSLog(@"destination view controller: %@", destinationViewController);
        NSLog(@"destination view controller - activewokroytkey: %@", destinationViewController.activeWorkoutKey);
        NSLog(@"finished passing stuff");
        
        
    }
}


@end
