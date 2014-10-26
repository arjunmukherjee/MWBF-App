//
//  User.h
//  MWBF-Demo
//
//  Created by ARJUN MUKHERJEE on 8/1/14.
//  Copyright (c) 2014 ___Arjun Mukherjee___. All rights reserved.
//  Test edit by vpasari

#import <Foundation/Foundation.h>
#import "Friend.h"
#import "UserStats.h"

@interface User : NSObject

@property (strong,nonatomic) NSString *userId;
@property (strong,nonatomic) NSString *userEmail;
@property (strong,nonatomic) NSString *userName;
@property (strong,nonatomic) NSString *firstName;
@property (strong,nonatomic) NSString *lastName;
@property (strong,nonatomic) NSMutableArray *friendsList;
@property (strong,nonatomic) NSString *fbProfileID;

// Challenges
@property (strong,nonatomic) NSMutableArray *challengesList;

// STATS
@property (strong,nonatomic) UserStats *userStats;

// Weekly Comparisons
@property (strong,nonatomic) NSString *weeklyPointsUser;
@property (strong,nonatomic) NSString *weeklyPointsFriendsAverage;
@property (strong,nonatomic) NSString *weeklyPointsLeader;

// Leader Stats
@property (strong,nonatomic) Friend *dayLeader;
@property (strong,nonatomic) Friend *weekLeader;
@property (strong,nonatomic) Friend *monthLeader;
@property (strong,nonatomic) Friend *yearLeader;
@property (strong,nonatomic) NSString *bestDayLeader;
@property (strong,nonatomic) NSString *bestWeekLeader;
@property (strong,nonatomic) NSString *bestMonthLeader;
@property (strong,nonatomic) NSString *bestYearLeader;
@property (strong,nonatomic) NSString *bestDayLeaderPoints;
@property (strong,nonatomic) NSString *bestWeekLeaderPoints;
@property (strong,nonatomic) NSString *bestMonthLeaderPoints;
@property (strong,nonatomic) NSString *bestYearLeaderPoints;


// New Messages
@property (strong,nonatomic) NSMutableArray *notificationsList;
@property (strong,nonatomic) NSMutableArray *friendsActivitiesList;

// Users favorite activities
@property (strong,nonatomic) NSMutableArray *favActivityList;

// Users notification settings
@property (nonatomic) BOOL activityNotifications;
@property (nonatomic) BOOL friendsAndChallengesNotifications;

// User background settings
@property (strong,nonatomic) NSString *backgroundImageName;

// Random quote (motivational)
@property (strong,nonatomic) NSString *randomQuote;


+ (User *) getInstance;
- (NSMutableDictionary *)toNSDictionary;

@end
