//
//  ActivityEditor.h
//  MWBF
//
//  Created by ARJUN MUKHERJEE on 1/22/15.
//  Copyright (c) 2015 ___Arjun Mukherjee___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseClassViewController.h"


@interface ActivityEditor : BaseClassViewController


@property (strong,nonatomic) NSString *activityName;
@property (strong,nonatomic) NSString *activityValue;
@property (strong,nonatomic) NSString *activityUnits;
@property (strong,nonatomic) NSString *activityDate;
@property (strong,nonatomic) NSString *activityId;
@property (strong,nonatomic) NSString *points;


@end
