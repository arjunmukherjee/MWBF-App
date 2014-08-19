//
//  MainViewController.m
//  MWBF-Demo
//
//  Created by ARJUN MUKHERJEE on 8/2/14.
//  Copyright (c) 2014 ___Arjun Mukherjee___. All rights reserved.
//

#import "MainViewController.h"

@implementation MainViewController

@synthesize logActivityController = _logActivityController;
@synthesize statsController = _statsController;
@synthesize createBoutController = _createBoutController;
@synthesize moreController = _moreController;
@synthesize mainTabBarController = _mainTabBarController;
@synthesize tabsArray = _tabsArray;

- (void)viewDidLoad
{
    /*
    self.mainTabBarController = [[UITabBarController alloc] init];

    self.logActivityController = [[LogActivityViewController alloc] init];
    [self.logActivityController viewDidLoad];
    self.logActivityController.title = @"Log Activity";
    UINavigationController *nav1 = [[UINavigationController alloc] initWithRootViewController:self.logActivityController];
    
    self.statsController = [[StatsViewController alloc] init];
    self.statsController.title = @"My Stats";
    UINavigationController *nav2 = [[UINavigationController alloc] initWithRootViewController:self.statsController];

    self.createBoutController = [[StatsViewController alloc] init];
    self.createBoutController.title = @"Create Bout";
    UINavigationController *nav3 = [[UINavigationController alloc] initWithRootViewController:self.createBoutController];
    
    self.moreController = [[StatsViewController alloc] init];
    self.moreController.title = @"More";
    UINavigationController *nav4 = [[UINavigationController alloc] initWithRootViewController:self.moreController];

    self.tabsArray = [[NSArray alloc] initWithObjects:nav1,nav2,nav3,nav4,nil];

    self.mainTabBarController.viewControllers = self.tabsArray;
    [self.view addSubview:self.mainTabBarController.view];
     */
}

@end
