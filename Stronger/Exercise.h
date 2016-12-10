//
//  Exercise.h
//  Stronger
//
//  Created by David Turnquist on 12/10/16.
//  Copyright © 2016 David Turnquist. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Exercise : NSObject

    @property(copy, nonatomic) NSString *name;
    @property(copy, nonatomic) NSString *nameLowercase;
    @property(copy, nonatomic) NSString *pr;
    
    - (instancetype)initWithName:(NSString *)name andNameLowercase:(NSString *)namelowercase pr:(NSString *)pr;
    
@end
