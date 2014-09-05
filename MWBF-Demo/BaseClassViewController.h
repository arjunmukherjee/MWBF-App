//
//  BaseClassViewController.h
//  MWBF-Demo
//
//  Created by ARJUN MUKHERJEE on 8/5/14.
//  Copyright (c) 2014 ___Arjun Mukherjee___. All rights reserved.
//
// Class used to put in the common UI settings, like background image etc
// All other classes used in the tab view inherit from this class.

#import <UIKit/UIKit.h>
#import "Utils.h"

@interface BaseClassViewController : UIViewController

@property (nonatomic,strong) UIActivityIndicatorView *activityIndicator;

- (void) refreshUserData;

@end
