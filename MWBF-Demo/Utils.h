//
//  Utils.h
//  MWBF-Demo
//
//  Created by ARJUN MUKHERJEE on 8/5/14.
//  Copyright (c) 2014 ___Arjun Mukherjee___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utils : NSObject

+ (void) alertStatus:(NSString *)msg :(NSString *)title :(int) tag;

+ (void) convertJsonArrayByTimeToActivityObjectArrayWith:(NSArray*)jsonArray withLabelArray:(NSMutableArray*)labelArray withPointsArray:(NSMutableArray*)pointsArray;
+ (NSMutableArray*) convertJsonArrayByActivityToActivityObjectArrayWith:(NSArray*)jsonArray;

+ (NSString*) getMonthStringFromInt:(NSInteger) monthInt;
+ (void) setMaskTo:(UIView*)view byRoundingCorners:(UIRectCorner)corners;
+ (NSString*) getNumberOfRestDaysFromDate:(NSString *) fromDate toDate:(NSString*) toDate withActiveDays:(NSInteger) numberOfActiveDays;
+ (NSInteger) getNumberOfDaysInMonth:(NSInteger)monthInt;
+ (void)setRoundedView:(UIView *)roundedView toDiameter:(float)newSize;


@end
