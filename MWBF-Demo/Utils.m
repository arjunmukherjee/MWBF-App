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
#import "Challenge.h"
#import "MWBFService.h"
#import "Friend.h"

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

+ (void) refreshUserData
{
    MWBFService *service = [[MWBFService alloc] init];
    
    // Get the list of friends
    [service getFriendsList];
    
    // Get the all time highs
    [service getAllTimeHighs];
    
    // Get the leaders all time highs
    [service getLeaderAllTimeHighs];
    
    // Get the activities for all the users friends
    [service getFeed];
    
    // Get the weekly comparisons between the user and his/her friends
    [service getWeeklyComparisons];
    
    // Get all the challenges the user is involved in
    [service getChallenges];
    
    // Get a motivational quote
    [service getRandomQuote];
}

// Convert a jsonArray of objects into an Array of UserActivity objects (aggregated by Time)
+ (void) convertJsonArrayByTimeToActivityObjectArrayWith:(NSArray*)jsonArray withLabelArray:(NSMutableArray*)labelArray withPointsArray:(NSMutableArray*)pointsArray
{
    for (id object in jsonArray)
    {
        NSString *dateStr = [object objectForKey:@"date"];
        NSString *pointsStr = [object objectForKey:@"points"];
        
        int pointsInt = [pointsStr intValue];
        float pointsFloat = [pointsStr floatValue];
        
        if (pointsFloat > pointsInt)
            pointsStr = [NSString stringWithFormat:@"%.1f",pointsFloat];
        else
            pointsStr = [NSString stringWithFormat:@"%d",pointsInt];
        
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
        
        int measurementInt = [measurement intValue];
        float measurementFloat = [measurement floatValue];
        
        if (measurementFloat > measurementInt)
            measurement = [NSString stringWithFormat:@"%.1f",measurementFloat];
        else
            measurement = [NSString stringWithFormat:@"%d",measurementInt];
        
        MWBFActivities *mwbfActivity = [activityList.activityDict objectForKey:activityId];
        
        UserActivity *ua = [[UserActivity alloc] init];
        
        int pointsInt = [points intValue];
        float pointsFloat = [points floatValue];
        
        if (pointsFloat > pointsInt)
            ua.points = [NSString stringWithFormat:@"%.1f",pointsFloat];
        else
            ua.points = [NSString stringWithFormat:@"%d",pointsInt];
      
        ua.activity = activityId;
        
        
        // Account for the bonus activity
        if (mwbfActivity != nil)
            ua.activityValue = [NSString stringWithFormat:@"%@ %@",measurement,mwbfActivity.measurementUnits];
        else
            ua.activityValue = @" ";
        
        [userActivityArray addObject:ua];
    }
    
    return userActivityArray;
}

+ (NSInteger) getNumberOfDaysInMonth:(NSInteger)monthInt
{
    NSInteger numberOfDaysInMonth = 0;
    
    if (monthInt != 0 )
    {
        NSCalendar* cal = [NSCalendar currentCalendar];
        NSDateComponents* comps = [[NSDateComponents alloc] init];
        
        // Set your month here
        [comps setMonth:monthInt];
        NSRange range = [cal rangeOfUnit:NSDayCalendarUnit
                                  inUnit:NSMonthCalendarUnit
                                 forDate:[cal dateFromComponents:comps]];
        numberOfDaysInMonth = range.length;
    }
    else
    {
        // Get the number of days in the current month
        NSDate *today = [NSDate date];
        NSCalendar *c = [NSCalendar currentCalendar];
        NSRange daysInMonth = [c rangeOfUnit:NSDayCalendarUnit
                                      inUnit:NSMonthCalendarUnit
                                     forDate:today];
        numberOfDaysInMonth = daysInMonth.length;
    }
    
    return numberOfDaysInMonth;
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

+ (void)setRoundedView:(UIView *)roundedView toDiameter:(float)newSize;
{
    CGPoint saveCenter = roundedView.center;
    CGRect newFrame = CGRectMake(roundedView.frame.origin.x, roundedView.frame.origin.y, newSize, newSize);
    roundedView.frame = newFrame;
    roundedView.layer.cornerRadius = newSize / 2.0;
    roundedView.center = saveCenter;
}

+ (NSString *)changeformatStringTo12hr:(NSString *)date
{
    // TODO : Just appending AM to the end of the string
    //        The conversion was just not working
    
    // Sep 18, 2014 01:42:58 AM
    /*
    NSDateFormatter* df24 = [[NSDateFormatter alloc] init];
    [df24 setTimeZone:[NSTimeZone systemTimeZone]];
    [df24 setDateFormat:@"MMM d, yyyy HH:mm:ss"];
    NSDate* convTime = [df24 dateFromString:date];
    
    NSDateFormatter* df12 = [[NSDateFormatter alloc] init];
    [df12 setTimeZone:[NSTimeZone systemTimeZone]];
    [df12 setDateFormat:@"MMM d, yyyy hh:mm:ss a"];
    
    NSString *convertedDate = [df12 stringFromDate:convTime];
    */
    
    date = [NSString stringWithFormat:@"%@ AM",date];
    
    return date;
}


+ (BOOL) isTimeIn24HourFormat:(NSString *) dateString
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[NSLocale currentLocale]];
    [formatter setDateStyle:NSDateFormatterNoStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    NSRange amRange = [dateString rangeOfString:[formatter AMSymbol]];
    NSRange pmRange = [dateString rangeOfString:[formatter PMSymbol]];
    BOOL is24h = (amRange.location == NSNotFound && pmRange.location == NSNotFound);
    
    return is24h;
}

+ (NSString *) getImageNameFromMessage:(NSString*)message
{
    if ([message rangeOfString:@" ran " options:NSCaseInsensitiveSearch].location != NSNotFound )
        return @"runIcon.png";
    if ([message rangeOfString:@" yoga " options:NSCaseInsensitiveSearch].location != NSNotFound )
        return @"yogaIcon.png";
    if ([message rangeOfString:@" gym " options:NSCaseInsensitiveSearch].location != NSNotFound )
        return @"gymIcon.png";
    if ([message rangeOfString:@" swam " options:NSCaseInsensitiveSearch].location != NSNotFound )
        return @"swimmingIcon.png";
    if ([message rangeOfString:@" sport " options:NSCaseInsensitiveSearch].location != NSNotFound )
        return @"sportsIcon.png";
    if ([message rangeOfString:@" biked " options:NSCaseInsensitiveSearch].location != NSNotFound )
        return @"bikeIcon.png";
    if ([message rangeOfString:@" walked " options:NSCaseInsensitiveSearch].location != NSNotFound )
        return @"walkingIcon.png";
    if ([message rangeOfString:@" trekked " options:NSCaseInsensitiveSearch].location != NSNotFound )
        return @"trekkingIcon.png";
    if ([message rangeOfString:@" elliptical " options:NSCaseInsensitiveSearch].location != NSNotFound )
        return @"ellipticalIcon.png";
    if ([message rangeOfString:@" climbed " options:NSCaseInsensitiveSearch].location != NSNotFound )
        return @"stairmasterIcon.png";
    if ([message rangeOfString:@" bonus " options:NSCaseInsensitiveSearch].location != NSNotFound )
        return @"bonusIcon.png";
    
    return @"defaultActivityIcon.png";
    
}

// Compare the date and start using words like "Today" "Yesterday"
+ (void) changeAbsoluteDateToRelativeDays: (NSMutableArray*) messageList
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMM d"];
    NSString *todayStr = [dateFormatter stringFromDate: [NSDate date]];
    todayStr = [NSString stringWithFormat:@"on %@",todayStr];
    
    NSDate *yesterday = [[NSDate date] dateByAddingTimeInterval: -86400.0];
    NSString *yesterdayStr = [dateFormatter stringFromDate:yesterday];
    yesterdayStr = [NSString stringWithFormat:@"on %@",yesterdayStr];
    
    for (int i=0; i < [messageList count]; i++)
    {
        messageList[i] = [messageList[i] stringByReplacingOccurrencesOfString:todayStr withString:@"today"];
        messageList[i] = [messageList[i] stringByReplacingOccurrencesOfString:yesterdayStr withString:@"yesterday"];
    }
}

+ (NSDictionary*)getActivityDetailsForFriend:(Friend *)friend
{
    NSString *title = [NSString stringWithFormat:@"%@'s Stats",friend.firstName];
    
    // Year
    NSDate *currentTime = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY"];
    NSString *year = [dateFormatter stringFromDate: currentTime] ;
    
    // Month
    [dateFormatter setDateFormat:@"MM"];
    NSInteger monthInteger = [[dateFormatter stringFromDate: currentTime] integerValue];
    NSString *month  = [Utils getMonthStringFromInt:monthInteger];
    
    NSInteger daysInMonth = [Utils getNumberOfDaysInMonth:monthInteger];
    
    NSString *fromDate = [NSString stringWithFormat:@"%@ 01, %@ 00:00:01 AM",month,year];
    NSString *toDate = [NSString stringWithFormat:@"%@ %ld, %@ 11:59:59 PM",month,(long)daysInMonth,year];
    
    NSString *activityDate = [NSString stringWithFormat:@"%@, %@",month,year];
    
    // Get the list of activities from the server
    MWBFService *service = [[MWBFService alloc] init];
    NSArray *jsonArrayByActivity = [service getActivitiesForFriend:friend byActivityFromDate:fromDate toDate:toDate];
    NSArray *jsonArrayByTime = [service getActivitiesForFriend:friend byTimeFromDate:fromDate toDate:toDate];
    
    NSString *numberOfRestDays = [Utils getNumberOfRestDaysFromDate:fromDate toDate:toDate withActiveDays:[jsonArrayByTime count]];
    
    return @{ @"jsonArrayByActivity" : jsonArrayByActivity, @"jsonArrayByTime" : jsonArrayByTime, @"title" : title,@"activityDate" : activityDate, @"numberOfRestDays" : numberOfRestDays };
}





@end
