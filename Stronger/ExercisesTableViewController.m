//
//  ExercisesTableViewController.m
//  Stronger
//
//  Created by David Turnquist on 12/9/16.
//  Copyright © 2016 David Turnquist. All rights reserved.
//

#import "ExercisesTableViewController.h"
#import "EditExerciseViewController.h"
#import "Exercise.h"

@interface ExercisesTableViewController ()

@end

@implementation ExercisesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"opened the exercise list");
    
    self.firebaseRef = [[FIRDatabase database] reference];
    NSString *userID = [FIRAuth auth].currentUser.uid;
    //userID = @"OFFLINE MODE";
    NSLog(@"about to set the path");
    self.firebaseExercisesRef = [[self.firebaseRef child:@"exercises"] child:userID];
    NSLog(@"path set");
    self.FIRDatabaseQuery = [self.firebaseExercisesRef queryOrderedByChild:@"name_lowercase"];

    NSLog(@"initialzing the query");
    
    self.dataSource = [[FUITableViewDataSource alloc] initWithQuery:self.FIRDatabaseQuery
                                                               view:self.tableView
                                                       populateCell:^UITableViewCell * _Nonnull(UITableView * _Nonnull tableView, NSIndexPath * _Nonnull indexPath, FIRDataSnapshot * _Nonnull snap) {
        
        Exercise *exercise = [[Exercise alloc] initWithName:snap.value[@"name"]
                                           andNameLowercase:snap.value[@"name_lowercase"]
                                                         pr:snap.value[@"pr"]];
                                                           
        NSLog(@"The exercise: %@", exercise);
                                                           
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ExerciseCell"];
        
        cell.textLabel.text = exercise.name;
        
        return cell;
        
    }];
    
    [self.tableView setDataSource:self.dataSource];
    self.tableView.delegate = self;
    
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
    
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    self.selectedExerciseSnap = [self.dataSource objectAtIndex:indexPath.row];

    [self performSegueWithIdentifier:@"EditExerciseSegue" sender:self];
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
    
    if ([segue.identifier isEqual: @"EditExerciseSegue"]) {
        UINavigationController *nav = segue.destinationViewController;
        EditExerciseViewController *destinationViewController = (EditExerciseViewController *)[nav topViewController];
        destinationViewController.new = NO;
        destinationViewController.selectedExerciseSnap = self.selectedExerciseSnap;
        
    } else if ([segue.identifier isEqual: @"NewExerciseSegue"]) {
        UINavigationController *nav = segue.destinationViewController;
        EditExerciseViewController *destinationViewController = (EditExerciseViewController *)[nav topViewController];
        destinationViewController.new = YES;
    }
    
}
    
    
    
-(IBAction)unwindToExerciseFBList:(UIStoryboardSegue *)unwindSegue
    {
        
        // If the user clicked "Save", then save
        if ([unwindSegue.identifier  isEqual: @"SaveExerciseToUnwind"]) {
            
            EditExerciseViewController *editExerciseViewController = unwindSegue.sourceViewController;
            
            
            if (editExerciseViewController.new == YES) {
                
                NSDictionary *exerciseDict = @{
                                               @"name" : editExerciseViewController.exerciseNameTextField.text,
                                               @"name_lowercase" : [editExerciseViewController.exerciseNameTextField.text lowercaseString],
                                               @"pr" : @"00000-00000",
                                               };
                
                FIRDatabaseReference *newExerciseRef = [self.firebaseExercisesRef childByAutoId];
                [newExerciseRef setValue:exerciseDict];
                
            } else {
                NSDictionary *exerciseDict = @{
                                               @"name" : editExerciseViewController.exerciseNameTextField.text,
                                               @"name_lowercase" : [editExerciseViewController.exerciseNameTextField.text lowercaseString],
                                               };
                
                FIRDatabaseReference *exerciseUpdateRef = [self.firebaseExercisesRef child:editExerciseViewController.selectedExerciseSnap.key];
                [exerciseUpdateRef updateChildValues:exerciseDict];
            }
            
            NSLog(@"Unwound to exercise list");
            
        } else if ([unwindSegue.identifier  isEqual: @"CancelEditExercise"]) {
            
            NSLog(@"Cancelled edit ex");
        }
    }

@end
