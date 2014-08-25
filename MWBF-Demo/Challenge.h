//
//  Challenge.h
//  MWBF-Demo
//
//  Created by ARJUN MUKHERJEE on 8/24/14.
//  Copyright (c) 2014 ___Arjun Mukherjee___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface Challenge : NSObject

@property (strong,nonatomic) NSString *challenge_id;
@property (strong,nonatomic) NSString *name;
@property (strong,nonatomic) NSString *startDate;
@property (strong,nonatomic) NSString *endDate;
@property (strong,nonatomic) NSArray *playersSet;
@property (strong,nonatomic) NSArray *pointsSet;
@property (strong,nonatomic) NSArray *activitySet;


- (NSMutableDictionary *)toNSDictionary;

@end
