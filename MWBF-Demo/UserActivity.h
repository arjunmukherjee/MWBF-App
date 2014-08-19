//
//  Activity.h
//  MWBF-Demo
//
//  Created by ARJUN MUKHERJEE on 7/31/14.
//  Copyright (c) 2014 ___Arjun Mukherjee___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface UserActivity : NSObject

@property (strong,nonatomic) NSString *activity;
@property (strong,nonatomic) NSString *activityValue;
@property (strong,nonatomic) NSString *date;
@property (strong,nonatomic) NSString *points;
@property (strong,nonatomic) User *user;

- (NSMutableDictionary *)toNSDictionary;

@end
