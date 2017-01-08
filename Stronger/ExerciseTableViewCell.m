//
//  ExerciseTableViewCell.m
//  Stronger
//
//  Created by David Turnquist on 1/8/17.
//  Copyright © 2017 David Turnquist. All rights reserved.
//

#import "ExerciseTableViewCell.h"



@implementation ExerciseTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)barbellClick:(id)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickOnCellAtIndex:withData:)]) {
        [self.delegate didClickOnCellAtIndex:_cellIndex withData:@"barbell"];
    }
    
}

- (IBAction)dumbbellClick:(id)sender {
}
- (IBAction)kettlebellClick:(id)sender {
}

- (IBAction)machineClick:(id)sender {
}

- (IBAction)bodyClick:(id)sender {
}
@end
