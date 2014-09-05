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

@end

@implementation BaseClassViewController

@synthesize activityIndicator;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIImageView *backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background.jpg"]];
    [self.view addSubview:backgroundImage];
    [self.view sendSubviewToBack:backgroundImage];
    
    self.activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    CGPoint point = CGPointMake(self.view.center.x, self.view.center.y +20);
    self.activityIndicator.center = point;
    self.activityIndicator.color = [UIColor blueColor];
    [self.view addSubview: self.activityIndicator];
}

// Dismiss the keyboard when the GO button is hit
- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void) refreshUserData
{
    MWBFService *service = [[MWBFService alloc] init];
    
    // Get the list of friends
    [User getInstance].friendsList = [service getFriendsList];
    
    // Get the all time highs
    [service getAllTimeHighs];
    
    // Get all the challenges the user is involved in
    [service getChallenges];
}

@end
