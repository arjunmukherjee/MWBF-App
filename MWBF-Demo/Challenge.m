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

@synthesize name,creatorId,startDate,endDate,playersSet,activitySet,pointsSet,challenge_id,messageList;
@synthesize aggregateActivityMap;

- (NSString*) description
{
    return [NSString stringWithFormat:@"%@:%@:%@:%@:%@",self.name,self.startDate,self.endDate,self.playersSet,self.activitySet];
}

- (NSMutableDictionary *)toNSDictionary
{
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setValue:self.creatorId forKey:@"user_id"];
    [dictionary setValue:self.name forKey:@"name"];
    [dictionary setValue:self.startDate forKey:@"startDate"];
    [dictionary setValue:self.endDate forKey:@"endDate"];
    [dictionary setValue:self.playersSet forKey:@"playersSet"];
    [dictionary setValue:self.activitySet forKey:@"activitySet"];
    
    return dictionary;
}

- (NSUInteger)hash
{
    return [self.challenge_id hash] ^ [self.creatorId hash];
}

- (BOOL)isEqual:(id)other
{
    if (other == self)
        return YES;
    if (!other || ![other isKindOfClass:[self class]])
        return NO;
    return [self isEqualToChallenge:other];
}

- (BOOL)isEqualToChallenge:(Challenge *)aChallenge
{
    if (self == aChallenge)
        return YES;
    if (![(id)[self challenge_id] isEqual:[aChallenge challenge_id]])
        return NO;
    if (![[self creatorId] isEqual:[aChallenge creatorId]])
        return NO;
    return YES;
}

@end
