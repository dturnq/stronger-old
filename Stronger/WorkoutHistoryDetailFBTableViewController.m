//
//  WorkoutHistoryDetailFBTableViewController.m
//  MuscleAbuse
//
//  Created by David Turnquist on 2/27/16.
//  Copyright © 2016 David Turnquist. All rights reserved.
//

#import "WorkoutHistoryDetailFBTableViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "ActiveExerciseTableViewCell.h"

@interface WorkoutHistoryDetailFBTableViewController ()

@end

@implementation WorkoutHistoryDetailFBTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"selected workout snap: %@", self.selectedWorkoutSnap);
    self.ceArray = @[];
    self.ceDictionary = @{};
    self.selectedWorkoutDict = self.selectedWorkoutSnap.value;
    self.firebaseRef = [[FIRDatabase database] reference];
    NSString *userID = [FIRAuth auth].currentUser.uid;
    userID = @"OFFLINE MODE";
    self.firebaseSelectedWorkoutRef = [[[self.firebaseRef child:@"ce_by_workout"] child:userID] child:self.selectedWorkoutSnap.key];
    //self.FIRDatabaseQuery = [[self.firebaseSelectedWorkoutRef queryOrderedByChild:@"workout"] queryEqualToValue:self.selectedWorkoutSnap.key];
    
    self.FIRDatabaseQuery = [self.firebaseSelectedWorkoutRef queryOrderedByChild:@"order"];
    
    self.selectedWorkoutHandle = [self.firebaseSelectedWorkoutRef observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSLog(@"opened the selected workout handle");
        NSLog(@"snapshot: %@", snapshot);
        if (snapshot.value == [NSNull null]) {
            self.ceArray = @[];
            self.ceDictionary = @{};
        } else {
            
            NSArray *tempArray = [snapshot.value allObjects];
            NSMutableDictionary *tempDict = [[NSMutableDictionary alloc] init];
            for (NSDictionary *dict in tempArray) {
                NSNumber *order = [dict valueForKey:@"order"];
                [tempDict setObject:dict forKey:order];
            }
            
            self.ceDictionary = tempDict;
            
            /*
            NSArray *keys = [tempDict allKeys];
            keys = [keys sortedArrayUsingComparator:^(id a, id b) {
                return [a compare:b options:NSNumericSearch];
            }];
             */
            
           
        }
        NSLog(@"ce array: %@", self.ceArray);
        [self.tableView reloadData];
    }];
    
    /*
    self.dataSource = [[FUITableViewDataSource alloc] initWithQuery:self.FIRDatabaseQuery cellReuseIdentifier:@"CompletedExerciseCell" view:self.tableView];
    
    
    
    [self.dataSource populateCellWithBlock:^(UITableViewCell *cell, FIRDataSnapshot *snap) {
        //NSLog(@"snap: %@", snap);
        //NSLog(@"snap.value: %@", snap.value);
        NSLog(@"Viewdidload - snap.key: %@", snap.key);
        cell.textLabel.text = snap.value[@"name"];
    }];
    
    [self.tableView setDataSource:self.dataSource];
     */
    
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else {
        return [self.ceDictionary count];
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 220;
    } else {
        return 90;
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return @"Completed exercises";
    } else {
        return @"";
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ActiveExerciseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CompletedExerciseCell" forIndexPath:indexPath];
    
    NSLog(@"indexpath: %ld", (long)indexPath.row);
    
    // Configure the cell...
    if (indexPath.section == 1) {
        NSLog(@"This is a CE cell");
        //cell.textLabel.text = [[self.ceDictionary objectForKey:[NSNumber numberWithInteger:indexPath.row]] objectForKey:@"name"];
        
        
        NSDictionary *ceDict = [self.ceDictionary objectForKey:[NSNumber numberWithInteger:indexPath.row + 1]];
        
        
        
        cell.exerciseName.text = ceDict[@"name"];
        
        //cell.exerciseName.text = @"Placeholder text"; //snap.value[@"name"];
        
        NSUInteger countOfList = [(NSDictionary *)ceDict[@"sets"] count];
        NSDictionary *arrayOfSets = ceDict[@"sets"];
        
        NSLog(@"The array of sets: %@", arrayOfSets);
        
        NSLog(@"Count of sets: %lu", (unsigned long)countOfList);
        
        
        if (countOfList > 0) {
            NSLog(@"at least 1 set");
            NSDictionary *set = [arrayOfSets objectForKey:@"set0"];
            NSLog(@"the set: %@", set);
            NSString *reps =  [[set objectForKey:@"reps"] stringValue];
            NSLog(@"The reps: %@", reps);
            NSString *weight = [[set objectForKey:@"weight"] stringValue];
            NSLog(@"the wieght: %@", weight);
            cell.set1.text = [[reps stringByAppendingString:@" / "] stringByAppendingString:weight];
        } else {
            cell.set1.text = @"-";
        }
        
        if (countOfList > 1) {
            NSDictionary *set = [arrayOfSets objectForKey:@"set1"];
            NSString *reps =  [[set objectForKey:@"reps"] stringValue];
            NSString *weight = [[set objectForKey:@"weight"] stringValue];
            cell.set2.text = [[reps stringByAppendingString:@" / "] stringByAppendingString:weight];
        } else {
            cell.set2.text = @"-";
        }
        
        if (countOfList > 2) {
            NSDictionary *set = [arrayOfSets objectForKey:@"set2"];
            NSString *reps =  [[set objectForKey:@"reps"] stringValue];
            NSString *weight = [[set objectForKey:@"weight"] stringValue];
            cell.set3.text = [[reps stringByAppendingString:@" / "] stringByAppendingString:weight];
        } else {
            cell.set3.text = @"-";
        }
        
        if (countOfList > 3) {
            NSLog(@"There are 4+ sets");
            NSDictionary *set = [arrayOfSets objectForKey:@"set3"];
            NSString *reps =  [[set objectForKey:@"reps"] stringValue];
            NSString *weight = [[set objectForKey:@"weight"] stringValue];
            cell.set4.text = [[reps stringByAppendingString:@" / "] stringByAppendingString:weight];
        } else {
            cell.set4.text = @"-";
        }

        
        
        
        
        //[[self.ceArray objectAtIndex:(indexPath.row-1)] objectForKey:@"name"];
    } else {
        NSLog(@"This is a header cell");
        WorkoutSummaryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WorkoutSummaryCell" forIndexPath:indexPath];
        NSLog(@"workout dicct: %@", self.selectedWorkoutDict);
        
        
        cell.workoutNameLabel.text = [self.selectedWorkoutDict objectForKey:@"name"];
        cell.userNameLabel.text = [self.selectedWorkoutDict objectForKey:@"user_name"];
        cell.exercisesLabel.text = [NSString stringWithFormat:@"%@",self.selectedWorkoutDict[@"ce_count"]];
        cell.setsLabel.text = [NSString stringWithFormat:@"%@",self.selectedWorkoutDict[@"set_count"]];
        cell.repsLabel.text = [NSString stringWithFormat:@"%@",self.selectedWorkoutDict[@"rep_count"]];
        cell.lbsLabel.text = [NSString stringWithFormat:@"%@",self.selectedWorkoutDict[@"weight_count"]];
        cell.prLabel.text = [NSString stringWithFormat:@"%@",self.selectedWorkoutDict[@"pr_count"]];
        NSNumber *minutes = [NSNumber numberWithInt:(int)([self.selectedWorkoutDict[@"pr_count"] integerValue] / 60)];
        cell.minutesLabel.text  = [NSString stringWithFormat:@"%@",minutes];
        
        // Figure out the date
        NSDate *date = [NSDate dateWithTimeIntervalSinceReferenceDate:(-[self.selectedWorkoutDict[@"timestamp_end"] doubleValue])];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
        [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
        
        NSString *formattedDateString = [dateFormatter stringFromDate:date];
        
        NSLog(@"formatted date string: %@", formattedDateString);
        
        
        NSCalendar *calendar = [NSCalendar currentCalendar];
        if ([calendar isDateInToday:date]) {
            formattedDateString = @"Today";
        } else if ([calendar isDateInYesterday:date]) {
            formattedDateString = @"Yesterday";
        }
        
        cell.dateLabel.text = formattedDateString;
        
        ///// Profile Pic
        // Download the user's facebook profile picture
        
        NSURL *pictureURL = [NSURL URLWithString:[self.selectedWorkoutDict objectForKey:@"user_profileimage"]];
        NSLog(@"Picture URL: %@", pictureURL);
        
        //cell.userp
        
        [cell.userProfileImage sd_setImageWithURL:pictureURL];
        
        //[cell.userProfileImage setImageWithURL:pictureURL placeholderImage:nil options:SDWebImageRefreshCached];
    }
    
    
    return cell;
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
