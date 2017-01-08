//
//  ExerciseAdmin.m
//  Stronger
//
//  Created by David Turnquist on 1/7/17.
//  Copyright © 2017 David Turnquist. All rights reserved.
//

#import "ExerciseAdmin.h"

@implementation ExerciseAdmin


- (instancetype)init {
    return [self initWithName:@"" andNameLowercase:@"" andKey:@"" andPR:@""];
}

- (instancetype)initWithName:(NSString *)name andNameLowercase:(NSString *)nameLowercase andKey:(NSString *)key andPR:(NSString *)pr {
    self = [super init];
    if (self) {
        self.name = name;
        self.nameLowercase = nameLowercase;
        self.key = key;
        self.pr = pr;
    }
    return self;
}


@end
