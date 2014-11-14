//
//  User.m
//  MWBF-Demo
//
//  Created by ARJUN MUKHERJEE on 8/1/14.
//  Copyright (c) 2014 ___Arjun Mukherjee___. All rights reserved.
//

#import "User.h"

@implementation User

@synthesize userId = _userId;
@synthesize userEmail = _userEmail;
@synthesize firstName,lastName;
@synthesize userName = _userName;
@synthesize friendsList = _friendsList;
@synthesize userStats;
@synthesize challengesList;
@synthesize fbProfileID;
@synthesize friendsActivitiesList;
@synthesize favActivityList;
@synthesize activityNotifications,friendsAndChallengesNotifications;
@synthesize backgroundImageName;
@synthesize weeklyPointsUser,weeklyPointsFriendsAverage,weeklyPointsLeader;
@synthesize randomQuote;

@synthesize bestDayLeader,bestWeekLeader,bestMonthLeader,bestYearLeader;
@synthesize bestDayLeaderPoints,bestWeekLeaderPoints,bestMonthLeaderPoints,bestYearLeaderPoints;
@synthesize dayLeader,weekLeader,monthLeader,yearLeader;
@synthesize friendRequestsList,challengeRequestsList;

+ (User *) getInstance
{
    static User *theUser =nil;
    
    if (!theUser )
    {
        theUser = [[super allocWithZone:nil] init];
    }
    
    return theUser;
}

+ (id) allocWithZone:(struct _NSZone *)zone
{
    return [self getInstance];
}

- (id) init
{
    self = [super init];
    if (self)
    {
        self.friendsList = [NSMutableArray array];
        self.friendsActivitiesList = [NSMutableArray array];
        self.favActivityList = [NSMutableArray array];
        self.friendRequestsList = [NSMutableArray array];
        self.challengeRequestsList = [NSMutableArray array];
        self.activityNotifications = YES;
        self.friendsAndChallengesNotifications = YES;
        self.backgroundImageName = @"background.jpg";
        
        // Initialize personal stats, so they don't show as "null"
        self.userStats.bestDay = @" ";
        self.userStats.bestWeek = @"-";
        self.userStats.bestMonth = @" ";
        self.userStats.bestYear = @" ";
        
        self.userStats.bestDayPoints = @" ";
        self.userStats.bestWeekPoints = @" ";
        self.userStats.bestMonthPoints = @" ";
        self.userStats.bestYearPoints = @" ";

        // Initialize the leader stats, so they don't show as "null"
        self.bestDayLeader = @" ";
        self.bestWeekLeader = @"-";
        self.bestMonthLeader = @" ";
        self.bestYearLeader = @" ";
        
        self.bestDayLeaderPoints = @" ";
        self.bestWeekLeaderPoints = @" ";
        self.bestMonthLeaderPoints = @" ";
        self.bestYearLeaderPoints = @" ";
    }
    
    return self;
}

- (NSMutableDictionary *)toNSDictionary
{
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setValue:self.userId forKey:@"id"];
    
    return dictionary;
}

@end
