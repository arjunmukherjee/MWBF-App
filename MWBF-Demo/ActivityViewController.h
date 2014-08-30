//
//  ActivityViewController.h
//  MWBF-Demo
//
//  Created by ARJUN MUKHERJEE on 8/5/14.
//  Copyright (c) 2014 ___Arjun Mukherjee___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseClassViewController.h"
#import "EColumnChart.h"

@interface ActivityViewController : BaseClassViewController <UITableViewDelegate, UITableViewDataSource,EColumnChartDelegate, EColumnChartDataSource>

@property (strong,nonatomic) NSArray *userActivitiesByActivityJsonArray;
@property (strong,nonatomic) NSArray *userActivitiesByTimeJsonArray;
@property (strong,nonatomic) NSString *activityDateString;
@property (strong,nonatomic) NSString *title;
@property (strong,nonatomic) NSString *numberOfRestDays;
@property (weak, nonatomic) IBOutlet UILabel *activityDateRangeLabel;



@end
