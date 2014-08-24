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
        //NSLog(@"ID [%@][%@]",dateStr,pointsStr);
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


@end
