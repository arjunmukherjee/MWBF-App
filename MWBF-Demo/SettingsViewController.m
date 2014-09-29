//
//  SettingsViewController.m
//  MWBF
//
//  Created by ARJUN MUKHERJEE on 9/25/14.
//  Copyright (c) 2014 ___Arjun Mukherjee___. All rights reserved.
//

#import "SettingsViewController.h"
#import "User.h"

@interface SettingsViewController ()
@property (weak, nonatomic) IBOutlet UISwitch *activityNotificationsSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *friendsAndChallengesNotificationSwitch;
@property (weak, nonatomic) IBOutlet UIButton *defaultTheme;
@property (weak, nonatomic) IBOutlet UIButton *theme1;
@property (weak, nonatomic) IBOutlet UIButton *theme2;

@end

@implementation SettingsViewController

@synthesize activityNotificationsSwitch,friendsAndChallengesNotificationSwitch;
@synthesize defaultTheme,theme1,theme2;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    User *user = [User getInstance];
    NSString *imageName = user.backgroundImageName;
    
    // Do any additional setup after loading the view.
    UIImageView *backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    [self.view addSubview:backgroundImage];
    [self.view sendSubviewToBack:backgroundImage];

}

- (void)viewWillAppear:(BOOL)animated
{

}

- (IBAction)activityNotificationChanged:(id)sender
{
    User *user = [User getInstance];
    if ([self.activityNotificationsSwitch isOn])
        user.activityNotifications = YES;
    else
        user.activityNotifications = NO;
}

- (IBAction)friendsAndChallengesNotificationChanged:(id)sender
{
    User *user = [User getInstance];
    if ([self.friendsAndChallengesNotificationSwitch isOn])
        user.friendsAndChallengesNotifications = YES;
    else
        user.friendsAndChallengesNotifications = NO;
}

- (IBAction)themeButtonClicked:(UIButton*)button
{
    User *user = [User getInstance];
    
    NSString *message;
    if (button == self.defaultTheme)
    {
        user.backgroundImageName = @"background.jpg";
        message = @"Your theme has been set to Streaks.";
    }
    else if (button == self.theme1)
    {
        user.backgroundImageName = @"background-2.png";
        message = @"Your theme has been set to Chardin.";
    }
    else
    {
        user.backgroundImageName = @"background-3.png";
        message = @"Your theme has been set to Astro.";
    }
 
    [Utils alertStatus:message :@"Theme set" :0];
}








@end
