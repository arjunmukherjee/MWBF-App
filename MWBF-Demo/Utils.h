//
//  Utils.h
//  MWBF-Demo
//
//  Created by ARJUN MUKHERJEE on 8/5/14.
//  Copyright (c) 2014 ___Arjun Mukherjee___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Friend.h"

@interface Utils : NSObject

#define TODAY_COLOR [UIColor colorWithRed:0.58 green:0.77 blue:0.49 alpha:0.8]
#define YESTERDAY_COLOR [UIColor colorWithRed:0.43 green:0.62 blue:0.92 alpha:0.8]
#define CELL_COLOR [UIColor colorWithWhite:0.9 alpha:0.3]

#define CELL_SELECTION_COLOR [[UIColor alloc] initWithRed:20.0 / 255 green:59.0 / 255 blue:102.0 / 255 alpha:0.5];
#define CELL_SELECTION_COLOR_GRAD [[UIColor alloc] initWithRed:20.0 / 255 green:50.0 / 255 blue:40.0 / 255 alpha:0.2];
#define CELL_SELECTION_COLOR_GRAD1 [[UIColor alloc] initWithRed:40.0 / 255 green:30.0 / 255 blue:40.0 / 255 alpha:0.2];


+ (void) alertStatus:(NSString *)msg :(NSString *)title :(int) tag;
+ (BOOL) isStringNullOrEmpty:(NSString *) text;

+ (void) refreshUserData;

+ (void) addLine:(UIView *) view addTop:(BOOL) addTopLine addBottom:(BOOL) addBottomLine withWidth: (NSInteger)width withColor: (UIColor *) color;

+ (void) convertJsonArrayByTimeToActivityObjectArrayWith:(NSArray*)jsonArray withLabelArray:(NSMutableArray*)labelArray withPointsArray:(NSMutableArray*)pointsArray;
+ (NSMutableArray*) convertJsonArrayByActivityToActivityObjectArrayWith:(NSArray*)jsonArray;

+ (void) setMaskTo:(UIView*)view byRoundingCorners:(UIRectCorner)corners;
+ (NSString*) getNumberOfRestDaysFromDate:(NSString *) fromDate toDate:(NSString*) toDate withActiveDays:(NSInteger) numberOfActiveDays;
+ (void)setRoundedView:(UIView *)roundedView toDiameter:(float)newSize;
+ (NSString *) getImageNameFromMessage:(NSString*)message;
+ (void) changeAbsoluteDateToRelativeDays: (NSMutableArray*) messageList;

+ (NSDictionary*)getActivityDetailsForFriend:(Friend *)friend;

// DATE METHODS
+ (void)startDate:(NSDate **)start andEndDate:(NSDate **)end ofWeekOn:(NSDate *)date;
+ (void) getFromDate:(NSString **)fromDate toDate:(NSString **)toDate withTitle:(NSString **) title For:(NSString *) timeInterval;
+ (NSString*) getMonthStringFromInt:(NSInteger) monthInt;
+ (BOOL) isTimeIn24HourFormat:(NSString *) dateString;
+ (NSString *)changeformatStringTo12hr:(NSString *)date;
+ (NSInteger) getNumberOfDaysInMonth:(NSInteger)monthInt;


@end
