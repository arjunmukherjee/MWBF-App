//
//  UserStats.h
//  MWBF
//
//  Created by ARJUN MUKHERJEE on 10/23/14.
//  Copyright (c) 2014 ___Arjun Mukherjee___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserStats : NSObject

// TODO : Find a pair ds, or maybe use regular C structs for the below (instead of 2 strings)

// STATS
@property (strong,nonatomic) NSString *currentWeekPoints;
@property (strong,nonatomic) NSString *currentMonthPoints;
@property (strong,nonatomic) NSString *currentYearPoints;

@property (strong,nonatomic) NSString *bestDay;
@property (strong,nonatomic) NSString *bestWeek;
@property (strong,nonatomic) NSString *bestMonth;
@property (strong,nonatomic) NSString *bestYear;
@property (strong,nonatomic) NSString *bestDayPoints;
@property (strong,nonatomic) NSString *bestWeekPoints;
@property (strong,nonatomic) NSString *bestMonthPoints;
@property (strong,nonatomic) NSString *bestYearPoints;

@property (strong,nonatomic) NSString *numberOfTotalChallenges;
@property (strong,nonatomic) NSString *numberOfActiveChallenges;
@property (strong,nonatomic) NSString *numberOfWonChallenges;


@end
