//
//  ChallengeDetailsViewController.h
//  MWBF-Demo
//
//  Created by ARJUN MUKHERJEE on 8/24/14.
//  Copyright (c) 2014 ___Arjun Mukherjee___. All rights reserved.
//

#import "BaseClassViewController.h"
#import "Challenge.h"
#import "EColumnChart.h"

@interface ChallengeDetailsViewController : BaseClassViewController <UITextFieldDelegate,EColumnChartDelegate, EColumnChartDataSource>

@property (strong,nonatomic) Challenge *challenge;

@end
