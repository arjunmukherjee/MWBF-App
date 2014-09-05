//
//  Utils.m
//  MWBF-Demo
//
//  Created by ARJUN MUKHERJEE on 8/5/14.
//  Copyright (c) 2014 ___Arjun Mukherjee___. All rights reserved.
//

#import "Utils.h"
#import "UserActivity.h"
#import "Activity.h"
#import "MWBFActivities.h"

@implementation Utils

+ (void) alertStatus:(NSString *)msg :(NSString *)title :(int) tag
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                        message:msg
                                                       delegate:self
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil, nil];
    alertView.tag = tag;
    [alertView show];
}


// Convert a jsonArray of objects into an Array of UserActivity objects (aggregated by Time)
+ (void) convertJsonArrayByTimeToActivityObjectArrayWith:(NSArray*)jsonArray withLabelArray:(NSMutableArray*)labelArray withPointsArray:(NSMutableArray*)pointsArray
{
    for (id object in jsonArray)
    {
        NSString *dateStr = [object objectForKey:@"date"];
        NSString *pointsStr = [object objectForKey:@"points"];
        [labelArray addObject:dateStr];
        [pointsArray addObject:pointsStr];
    }
}


// Convert a jsonArray of objects into an Array of UserActivity objects (aggregated by Activity)
+ (NSMutableArray*) convertJsonArrayByActivityToActivityObjectArrayWith:(NSArray*)jsonArray
{
    Activity *activityList = [Activity getInstance];
    NSMutableArray *userActivityArray = [NSMutableArray array];
    
    for (id object in jsonArray)
    {
        NSString *activityId = [object objectForKey:@"activityId"];
        NSString *measurement = [object objectForKey:@"exerciseUnits"];
        NSString *points = [object objectForKey:@"points"];
        
        measurement = [NSString stringWithFormat:@"%.1f",[measurement floatValue]];
        
        MWBFActivities *mwbfActivity = [activityList.activityDict objectForKey:activityId];
        
        UserActivity *ua = [[UserActivity alloc] init];
        ua.points = [NSString stringWithFormat:@"%.1f",[points floatValue]];
        ua.activity = activityId;
        ua.activityValue = [NSString stringWithFormat:@"%@ %@",measurement,mwbfActivity.measurementUnits];
        
        [userActivityArray addObject:ua];
    }
    
    return userActivityArray;
}

+ (NSString*) getMonthStringFromInt:(NSInteger) monthInt
{
    NSArray *monthsArray = @[@"--",@"Jan",@"Feb",@"Mar",@"Apr",@"May",@"Jun",@"Jul",@"Aug",@"Sep",@"Oct",@"Nov",@"Dec"];
    return [monthsArray objectAtIndex:monthInt];
}

// Round the corners of a view
+(void) setMaskTo:(UIView*)view byRoundingCorners:(UIRectCorner)corners
{
    UIBezierPath* rounded = [UIBezierPath bezierPathWithRoundedRect:view.bounds  byRoundingCorners:corners cornerRadii:CGSizeMake(9.0, 9.0)];
    
    CAShapeLayer* shape = [[CAShapeLayer alloc] init];
    [shape setPath:rounded.CGPath];
    view.layer.mask = shape;
}

// Get the number of restDays between two dates
// Format of the date strings are "Aug 31, 2014 07:30:15 PM" 
+ (NSString *) getNumberOfRestDaysFromDate:(NSString *) fromDate toDate:(NSString*) toDate withActiveDays:(NSInteger) numberOfActiveDays
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMM d, yyyy hh:mm:ss a"];
    
    NSDate *toDateDt = [dateFormatter dateFromString:toDate];
    NSDate *fromDateDt = [dateFormatter dateFromString:fromDate];
    
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [gregorianCalendar components:NSDayCalendarUnit
                                                        fromDate:fromDateDt
                                                          toDate:toDateDt
                                                         options:0];
    NSInteger totalNumberOfDays = [components day] + 1;
    
    components = [gregorianCalendar components:NSDayCalendarUnit
                                      fromDate:[NSDate date]
                                        toDate:toDateDt
                                       options:0];
    NSInteger daysFromToday =  [components day];
    
    NSInteger localNumberOfRestDays = totalNumberOfDays - numberOfActiveDays - daysFromToday;
    if (localNumberOfRestDays < 0)
        localNumberOfRestDays = 0;
    
    return [NSString stringWithFormat:@"%ld of %ld",(long)localNumberOfRestDays,(totalNumberOfDays - daysFromToday)];
}


@end
