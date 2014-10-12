//
//  User.h
//  MWBF-Demo
//
//  Created by ARJUN MUKHERJEE on 8/1/14.
//  Copyright (c) 2014 ___Arjun Mukherjee___. All rights reserved.
//  Test edit by vpasari

#import <Foundation/Foundation.h>

@interface User : NSObject

@property (strong,nonatomic) NSString *userId;
@property (strong,nonatomic) NSString *userEmail;
@property (strong,nonatomic) NSString *userName;
@property (strong,nonatomic) NSMutableArray *friendsList;
@property (strong,nonatomic) NSString *fbProfileID;

// Challenges
@property (strong,nonatomic) NSMutableArray *challengesList;

// Stats
@property (strong,nonatomic) NSString *bestDay;
@property (strong,nonatomic) NSString *bestWeek;
@property (strong,nonatomic) NSString *bestMonth;
@property (strong,nonatomic) NSString *bestYear;
@property (strong,nonatomic) NSString *weeklyPointsUser;
@property (strong,nonatomic) NSString *weeklyPointsFriendsAverage;
@property (strong,nonatomic) NSString *weeklyPointsLeader;


@property (strong,nonatomic) NSString *bestDayPoints;
@property (strong,nonatomic) NSString *bestWeekPoints;
@property (strong,nonatomic) NSString *bestMonthPoints;
@property (strong,nonatomic) NSString *bestYearPoints;

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
