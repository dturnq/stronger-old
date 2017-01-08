//
//  ExerciseAdmin.h
//  Stronger
//
//  Created by David Turnquist on 1/7/17.
//  Copyright © 2017 David Turnquist. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ExerciseAdmin : NSObject

    @property(copy, nonatomic) NSString *name;
    @property(copy, nonatomic) NSString *nameLowercase;
    @property(copy, nonatomic) NSString *pr;
    @property(copy, nonatomic) NSString *key;

    - (instancetype)initWithName:(NSString *)name andNameLowercase:(NSString *)namelowercase andKey:(NSString *)key andPR:(NSString *)pr;

@end
