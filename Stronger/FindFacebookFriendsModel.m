//
//  FindFacebookFriendsModel.m
//  Stronger
//
//  Created by David Turnquist on 1/1/17.
//  Copyright © 2017 David Turnquist. All rights reserved.
//

#import "FindFacebookFriendsModel.h"

@implementation FindFacebookFriendsModel

FIRDatabaseQuery *prequery = [[[self.firebaseRef child:@"fb_users"] queryOrderedByKey] queryEqualToValue:friendID];

[prequery observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {

@end
