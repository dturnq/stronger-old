//
//  SelectExerciseTableViewController.m
//  MuscleAbuse
//
//  Created by David Turnquist on 12/22/15.
//  Copyright © 2015 David Turnquist. All rights reserved.
//

#import "Constants.h"
#import "SelectExerciseTableViewController.h"
#import "EditExerciseViewController.h"
#import "Exercise.h"

@interface SelectExerciseTableViewController () <UITableViewDelegate, UITableViewDataSource, UISearchControllerDelegate, UISearchBarDelegate, UISearchResultsUpdating>

@end

@implementation SelectExerciseTableViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.dimsBackgroundDuringPresentation = NO;
    //self.searchController.searchBar.scopeButtonTitles = @[NSLocalizedString(@"ScopeButtonCountry",@"Country"), NSLocalizedString(@"ScopeButtonCapital",@"Capital")];
    self.searchController.searchBar.delegate = self;
    self.tableView.tableHeaderView = self.searchController.searchBar;
    self.definesPresentationContext = YES;
    [self.searchController.searchBar sizeToFit];
    
    NSLog(@"opened the exercise list");
    
    self.firebaseRef = [[FIRDatabase database] reference];
    //NSString *userID = [FIRAuth auth].currentUser.uid;
    
    NSLog(@"about to set the path");
    //self.firebaseExercisesRef = [[self.firebaseRef child:@"exercises"] child:userID];
    self.firebaseExercisesRef = [[self.firebaseRef child:@"exercises"] child:@"main/main"];
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
                                                           
                                                           UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ExerciseCell2"];
                                                           
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


-(void)didPresentSearchController:(UISearchController *)searchController {
    NSLog(@"search controller presented");
}

-(void)didDismissSearchController:(UISearchController *)searchController {
    NSLog(@"search controller dismissed");
    self.tableView.dataSource = self.dataSource;
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"search controller cancel button clicked");
    self.tableView.dataSource = self.dataSource;
}


// this runs every time you type into the search bar
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    NSLog(@"ran updateSearchResultsForSearchController");
    NSString *searchString = searchController.searchBar.text;
    NSLog(@"search string: %@", searchString);
    
    NSLog(@"search string updated: %@", searchString);
    [self searchForText:searchString.lowercaseString];
    [self.tableView reloadData];
}

-(void)searchForText:(NSString *)searchString {
    
    if ([searchString isEqual: @""]) {
        self.tableView.dataSource = self.dataSource;
    } else {
        
        NSString *searchLoc = [NSString stringWithFormat:@"exercises/main/search/%@", searchString];
        
        FIRDatabaseReference *searchRef = [self.firebaseRef child:searchLoc];
        
        FIRDatabaseQuery *searchQuery = [searchRef queryOrderedByChild:@"name_lowercase"];
        
        NSLog(@"initialzing the query");
        
        self.dataSourceSearch = [[FUITableViewDataSource alloc] initWithQuery:searchQuery
                                                                         view:self.tableView
                                                                 populateCell:^UITableViewCell * _Nonnull(UITableView * _Nonnull tableView, NSIndexPath * _Nonnull indexPath, FIRDataSnapshot * _Nonnull snap) {
                                                                     
                                                                     Exercise *exercise = [[Exercise alloc] initWithName:snap.value[@"name"]
                                                                                                        andNameLowercase:snap.value[@"name_lowercase"]
                                                                                                                      pr:@"N/A"];
                                                                     
                                                                     NSLog(@"The exercise: %@", exercise);
                                                                     
                                                                     UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ExerciseCell"];
                                                                     
                                                                     cell.textLabel.text = exercise.name;
                                                                     
                                                                     return cell;
                                                                     
                                                                 }];
        
        [self.tableView setDataSource:self.dataSourceSearch];
    }
    
}


#pragma mark - Table view data source

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
    static NSString *CellIdentifier = @"ExerciseCell";
    
    PFTableViewCell *cell = (PFTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[PFTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell
    cell.textLabel.text = [object objectForKey:self.textKey];
    //cell.imageView.file = [object objectForKey:self.imageKey];
    
    return cell;
}
*/


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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //[super tableView:tableView didSelectRowAtIndexPath:indexPath];
    NSLog(@"Did select row at index path");
    
    self.selectedExerciseSnap = [self.dataSource objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"SelectExerciseSegue" sender:self];
}

@end
