//
//  Challenge.m
//  MWBF-Demo
//
//  Created by ARJUN MUKHERJEE on 8/24/14.
//  Copyright (c) 2014 ___Arjun Mukherjee___. All rights reserved.
//

#import "Challenge.h"
#import "Friend.h"

@implementation Challenge

@synthesize name,startDate,endDate,playersSet,activitySet,pointsSet,challenge_id,messageList;

- (NSString*) description
{
    return [NSString stringWithFormat:@"%@:%@:%@:%@:%@",self.name,self.startDate,self.endDate,self.playersSet,self.activitySet];
}

- (NSMutableDictionary *)toNSDictionary
{
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setValue:self.name forKey:@"name"];
    [dictionary setValue:self.startDate forKey:@"startDate"];
    [dictionary setValue:self.endDate forKey:@"endDate"];
    [dictionary setValue:self.playersSet forKey:@"playersSet"];
    [dictionary setValue:self.activitySet forKey:@"activitySet"];
    
    return dictionary;
}


@end
