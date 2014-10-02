//
//  BaseClassViewController.m
//  MWBF-Demo
//
//  Created by ARJUN MUKHERJEE on 8/5/14.
//  Copyright (c) 2014 ___Arjun Mukherjee___. All rights reserved.
//

#import "BaseClassViewController.h"
#import "Utils.h"
#import "MWBFService.h"
#import "User.h"

@interface BaseClassViewController ()
@property (weak, nonatomic) IBOutlet UILabel *versionLabel;

@end

@implementation BaseClassViewController

@synthesize activityIndicator;
@synthesize versionLabel;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UINavigationController* more = self.tabBarController.moreNavigationController;
    more.navigationBar.barStyle = UIBarStyleBlack;

    User *user = [User getInstance];
    NSString *imageName = user.backgroundImageName;
    
    // Do any additional setup after loading the view.
    UIImageView *backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    [self.view addSubview:backgroundImage];
    [self.view sendSubviewToBack:backgroundImage];
    
    self.activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    CGPoint point = CGPointMake(self.view.center.x, self.view.center.y +20);
    self.activityIndicator.center = point;
    self.activityIndicator.color = [UIColor blueColor];
    [self.view addSubview: self.activityIndicator];
    
    NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle]infoDictionary];
    NSString *buildVersion = infoDictionary[(NSString*)kCFBundleVersionKey];
    
    self.versionLabel.text = [NSString stringWithFormat:@"Version : %@(%@)",appVersion,buildVersion];
}

// Dismiss the keyboard when the GO button is hit
- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
