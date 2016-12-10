//
//  Exercise.m
//  Stronger
//
//  Created by David Turnquist on 12/10/16.
//  Copyright © 2016 David Turnquist. All rights reserved.
//

#import "Exercise.h"

@implementation Exercise

    - (instancetype)init {
        return [self initWithName:@"" andNameLowercase:@"" pr:@""];
    }
    
    - (instancetype)initWithName:(NSString *)name andNameLowercase:(NSString *)nameLowercase pr:(NSString *)pr {
        self = [super init];
        if (self) {
            self.name = name;
            self.nameLowercase = nameLowercase;
            self.pr = pr;
        }
        return self;
    }
    
@end
