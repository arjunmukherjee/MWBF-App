//
//  UserStats.m
//  MWBF
//
//  Created by ARJUN MUKHERJEE on 10/23/14.
//  Copyright (c) 2014 ___Arjun Mukherjee___. All rights reserved.
//

#import "UserStats.h"

@implementation UserStats

@synthesize bestDay,bestWeek,bestMonth,bestYear;
@synthesize bestDayPoints,bestWeekPoints,bestMonthPoints,bestYearPoints;
@synthesize currentWeekPoints;
@synthesize numberOfActiveChallenges,numberOfTotalChallenges;

- (NSString*) description
{
    return [NSString stringWithFormat:@"BD[%@] BM[%@], CW[%@], TC[%@], AC[%@]",self.bestDay,self.bestMonth,self.currentWeekPoints,self.numberOfTotalChallenges,self.numberOfActiveChallenges];
}


@end
