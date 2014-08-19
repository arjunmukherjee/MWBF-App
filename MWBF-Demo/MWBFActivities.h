//
//  MWBFActivities.h
//  MWBF-Demo
//
//  Created by ARJUN MUKHERJEE on 8/6/14.
//  Copyright (c) 2014 ___Arjun Mukherjee___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MWBFActivities : NSObject

@property (strong,nonatomic) NSString *measurementUnits;
@property (nonatomic) NSInteger activityId;
@property (nonatomic) double pointsPerUnit;
@property (strong,nonatomic) NSString *activityName;


@end
