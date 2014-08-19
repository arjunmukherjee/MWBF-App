//
//  Activity.m
//  MWBF-Demo
//
//  Created by ARJUN MUKHERJEE on 7/31/14.
//  Copyright (c) 2014 ___Arjun Mukherjee___. All rights reserved.
//

#import "UserActivity.h"

@implementation UserActivity

@synthesize activity = _activity;
@synthesize activityValue = _activityValue;
@synthesize date = _date;
@synthesize points = _points;
@synthesize user = _user;


- (NSString*) description
{
    return [NSString stringWithFormat:@"%@:%@:%@:%@",self.activity,self.activityValue,self.date,self.points];
}

- (NSMutableDictionary *)toNSDictionary
{
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setValue:self.activity forKey:@"activityId"];
    [dictionary setValue:self.activityValue forKey:@"exerciseUnits"];
    [dictionary setValue:self.date forKey:@"date"];
    [dictionary setValue:[self.user toNSDictionary] forKey:@"user"];
    
    return dictionary;
}

@end
