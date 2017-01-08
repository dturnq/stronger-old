//
//  ExerciseTableViewCell.h
//  Stronger
//
//  Created by David Turnquist on 1/8/17.
//  Copyright © 2017 David Turnquist. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CellDelegate <NSObject>

- (void)didClickOnCellAtIndex:(NSInteger)cellIndex withData:(id)data;

@end

@interface ExerciseTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
- (IBAction)barbellClick:(id)sender;
- (IBAction)dumbbellClick:(id)sender;
- (IBAction)kettlebellClick:(id)sender;
- (IBAction)machineClick:(id)sender;
- (IBAction)bodyClick:(id)sender;

@property (weak, nonatomic) id<CellDelegate>delegate;
@property (assign, nonatomic) NSInteger cellIndex;

@end
