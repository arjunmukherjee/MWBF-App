//
//  MainViewController.h
//  MWBF-Demo
//
//  Created by ARJUN MUKHERJEE on 8/2/14.
//  Copyright (c) 2014 ___Arjun Mukherjee___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StatsViewController.h"
#import "LogActivityViewController.h"

@interface MainViewController : UITabBarController

// Tabs
@property (nonatomic,retain) LogActivityViewController *logActivityController;
@property (nonatomic,retain) StatsViewController *statsController;
@property (nonatomic,retain) StatsViewController *createBoutController;
@property (nonatomic,retain) StatsViewController *moreController;

@property (nonatomic,retain) UITabBarController *mainTabBarController;
@property (nonatomic,retain) NSArray *tabsArray;

@end
