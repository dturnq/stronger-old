//
//  ExercisesAdminTableViewController.m
//  Stronger
//
//  Created by David Turnquist on 1/7/17.
//  Copyright © 2017 David Turnquist. All rights reserved.
//

#import "ExercisesAdminTableViewController.h"
#import "EditExerciseAdminViewController.h"
#import "ExerciseAdmin.h"

@interface ExercisesAdminTableViewController ()

@end

@implementation ExercisesAdminTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"opened the exercise list");
    
    self.firebaseRef = [[FIRDatabase database] reference];

    NSLog(@"about to set the path");
    self.firebaseExercisesRef = [[self.firebaseRef child:@"exercises"] child:@"main"];
    NSLog(@"path set");
    self.FIRDatabaseQuery = [[self.firebaseExercisesRef child:@"main"] queryOrderedByChild:@"name_lowercase"];
    
    NSLog(@"initialzing the query");
    
    self.dataSource = [[FUITableViewDataSource alloc] initWithQuery:self.FIRDatabaseQuery
                                                               view:self.tableView
                                                       populateCell:^UITableViewCell * _Nonnull(UITableView * _Nonnull tableView, NSIndexPath * _Nonnull indexPath, FIRDataSnapshot * _Nonnull snap) {
                                                           
                                                           UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ExerciseCell"];
                                                           
                                                           NSLog(@"snap value: %@", snap.value);
                                                           
                                                           if (snap != (id)[NSNull null]) {

                                    
                                                               //ExerciseAdmin *exercise = [[ExerciseAdmin alloc] initWithName:snap.value[@"name"] andNameLowercase:snap.value[@"name_lowercase"] pr:snap.value[@"pr"]];
                                                               
                                                               //NSLog(@"The exercise: %@", exercise);
                                                               
                                                               cell.textLabel.text = snap.value[@"name"];
                                                           } else {
                                                               cell.textLabel.text = @"Well this is odd";
                                                           }
                                                           
                                                           
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
        EditExerciseAdminViewController *destinationViewController = (EditExerciseAdminViewController *)[nav topViewController];
        destinationViewController.new = NO;
        destinationViewController.selectedExerciseSnap = self.selectedExerciseSnap;
        
    } else if ([segue.identifier isEqual: @"NewExerciseSegue"]) {
        UINavigationController *nav = segue.destinationViewController;
        EditExerciseAdminViewController *destinationViewController = (EditExerciseAdminViewController *)[nav topViewController];
        destinationViewController.new = YES;
    }
    
}



-(IBAction)unwindToExerciseFBList:(UIStoryboardSegue *)unwindSegue
{
    
    // If the user clicked "Save", then save
    if ([unwindSegue.identifier  isEqual: @"SaveExerciseToUnwind"]) {
        
        EditExerciseAdminViewController *editExerciseViewController = unwindSegue.sourceViewController;
        
        
        
        if (editExerciseViewController.new == YES) {
            
            // DEFINE THE KEY VARIABLES AND SET UP THE EXERCISE ADMIN OBJECT
            NSString *exerciseKey = [self.firebaseExercisesRef childByAutoId].key;
            NSString *name = editExerciseViewController.exerciseNameTextField.text;
            NSString *nameLowercase = name.lowercaseString;
            NSString *pr =  @"00000-00000";
            
            ExerciseAdmin *exerciseAdmin = [[ExerciseAdmin alloc] initWithName:name andNameLowercase:nameLowercase andKey:exerciseKey andPR:pr];
            
            // CREATE A DICTIONARY FOR THE MAIN BRANCH
            NSDictionary *exerciseDict = @{
                                           @"name" : name,
                                           @"name_lowercase" : nameLowercase
                                           };
            
            // CREATE THE SEARCH DATA
            NSMutableDictionary *writeToDict = [[NSMutableDictionary alloc] init];
            writeToDict = [self updateSearchListForExerciseAdmin:exerciseAdmin withDict:exerciseDict forWriteToDict:writeToDict];
            
            // ADD IN THE MAIN QUERY LOCATION
            NSString *exerciseLoc = [NSString stringWithFormat:@"main/%@", exerciseKey];
            [writeToDict setObject:exerciseDict forKey:exerciseLoc];
            
            // SAVE
            [self.firebaseExercisesRef updateChildValues:writeToDict withCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
                if (error) {
                    NSLog(@"the exercises didn't post properly... shit: %@", error.debugDescription);
                } else {
                    NSLog(@"Successful workouts save! Congrats!");
                }
            }];
            
        } else {
            
            // SAVE EDIT EXERCISE
            
            // THE KEY FACTS
            NSString *exerciseKey = editExerciseViewController.selectedExerciseSnap.key;
            NSString *oldName = [editExerciseViewController.selectedExerciseSnap.value objectForKey:@"name"];
            NSString *oldNameLowercase = oldName.lowercaseString;
            NSString *pr = [editExerciseViewController.selectedExerciseSnap.value objectForKey:@"pr"];
            
            NSString *newName = editExerciseViewController.exerciseNameTextField.text;
            NSString *newNameLowercase = newName.lowercaseString;
            
            // SET UP THE EXERCISEADMIN
            ExerciseAdmin *exerciseAdminOld = [[ExerciseAdmin alloc] initWithName:oldName andNameLowercase:oldNameLowercase andKey:exerciseKey andPR:pr];
            ExerciseAdmin *exerciseAdminNew = [[ExerciseAdmin alloc] initWithName:newName andNameLowercase:newNameLowercase andKey:exerciseKey andPR:pr];
            
            // CLEAN OUT THE OLD SEARCH DATA
            NSMutableDictionary *writeToDict = [[NSMutableDictionary alloc] init];
            writeToDict = [self updateSearchListForExerciseAdmin:exerciseAdminOld withDict:[NSNull null] forWriteToDict:writeToDict];
            
            // CREATE THE NEW DICT
            NSDictionary *exerciseDict = @{
                                           @"name" : newName,
                                           @"name_lowercase" : newNameLowercase,
                                           };
            
            // NOW ADD IN THE NEW DATA
            writeToDict = [self updateSearchListForExerciseAdmin:exerciseAdminNew withDict:exerciseDict forWriteToDict:writeToDict];
            
            // ADD IN THE MAIN QUERY LOCATION
            NSString *exerciseLoc = [NSString stringWithFormat:@"main/%@", exerciseKey];
            [writeToDict setObject:exerciseDict forKey:exerciseLoc];
            
            // SAVE
            [self.firebaseExercisesRef updateChildValues:writeToDict withCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
                if (error) {
                    NSLog(@"the exercises didn't post properly... shit: %@", error.debugDescription);
                } else {
                    NSLog(@"Successful workouts save! Congrats!");
                }
            }];
        }
        
        NSLog(@"Unwound to exercise list");
        
    } else if ([unwindSegue.identifier  isEqual: @"CancelEditExercise"]) {
        
        NSLog(@"Cancelled edit ex");
    }
}

-(NSMutableDictionary *)updateSearchListForExerciseAdmin:(ExerciseAdmin *)exerciseAdmin withDict:(id)exerciseDict forWriteToDict:(NSMutableDictionary *)writeToDict {

    // The search table
    NSArray *words = [exerciseAdmin.nameLowercase componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSMutableArray *searchStringList = [[NSMutableArray alloc] init];
    
    NSMutableArray *wordList = [[NSMutableArray alloc] init];
    
    for (NSString *word in words)
    {
        NSLog(@"word: %@", word);
        [wordList addObject:word];
        
    }
    
    NSMutableArray *wordCompoundList = [wordList mutableCopy];
    
    // The longest combination will be as many words long as there are in the list - but we get the first one free
    for (int i = 1; i < wordList.count; i = i+1)
    {
        NSLog(@"i: %d", i);
        // in order to not create an infinitely growing loop, we copy the current version of the word compound list
        NSMutableArray *wordCompoundListTemp = [wordCompoundList mutableCopy];
        
        // For each loop, add each word to each compound
        for (NSString *wordCompound in wordCompoundListTemp) {
            
            for (NSString *word in wordList)
            {
                NSString *newCompound = [NSString stringWithFormat:@"%@ %@", wordCompound, word];
                [wordCompoundList addObject:newCompound];
            }
        }
        
        
    }
    
    NSLog(@"Compound list: %@", wordCompoundList);
    
    
    
    
    for (NSString *wordCompound in wordCompoundList)
    {
        
        int wordCompoundLength = (int)[wordCompound length];
        
        for (int i = 1; i <= wordCompoundLength; i=i+1) {
            NSString *charString = [wordCompound substringToIndex:i];
            NSLog(@"char string: %@", charString);
            
            if (![searchStringList containsObject:charString]) {
                
                [searchStringList addObject:charString];
                
                NSString *exerciseSearchLoc = [NSString stringWithFormat:@"search/%@/%@", charString, exerciseAdmin.key];
                [writeToDict setObject:exerciseDict forKey:exerciseSearchLoc];
            }
        }
        
        
        
    }

    return writeToDict;
    
    
}

- (IBAction)nukeExercises:(id)sender {
    
    [[self.firebaseExercisesRef child:@"search"] removeValue];
    
}

@end
