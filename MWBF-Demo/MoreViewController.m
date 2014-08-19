//
//  MoreViewController.m
//  MWBF-Demo
//
//  Created by ARJUN MUKHERJEE on 8/5/14.
//  Copyright (c) 2014 ___Arjun Mukherjee___. All rights reserved.
//

#import "MoreViewController.h"
#import "MWBFService.h"
#import "Utils.h"
#import "User.h"
#import <MessageUI/MessageUI.h>

#define OK_INDEX 0

@interface MoreViewController ()
@property (weak, nonatomic) IBOutlet UIButton *resetUserDataButton;
@property (weak, nonatomic) IBOutlet UIButton *logoutButton;
@property (strong, nonatomic) UIAlertView *deleteActivitiesAlert;
@property (strong, nonatomic) UIAlertView *logoutAlert;
@property (weak, nonatomic) IBOutlet UIButton *feedbackButton;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;

@end

@implementation MoreViewController

@synthesize resetUserDataButton,logoutButton,deleteActivitiesAlert,logoutAlert;
@synthesize userNameLabel;

- (void)viewDidLoad
{
    [super viewDidLoad];
    User *user = [User getInstance];
    self.userNameLabel.text = [NSString stringWithFormat:@"Welcome %@",user.userName];
}

- (IBAction)resetUserDataClicked:(id)sender
{
    self.deleteActivitiesAlert = [[UIAlertView alloc] initWithTitle: @"Clean up" message: @"Do you really want to delete all your logged activities ?" delegate: self cancelButtonTitle: @"YES"  otherButtonTitles:@"NO",nil];
    
    [self.deleteActivitiesAlert show];
    
}

- (IBAction)logoutButtonClicked:(id)sender
{
    self.logoutAlert = [[UIAlertView alloc] initWithTitle: @"Logout" message: @"Do you want to logout ?" delegate: self cancelButtonTitle: @"YES"  otherButtonTitles:@"NO",nil];
    
    [self.logoutAlert show];
    
}

- (IBAction)sendFeedback:(id)sender
{
    MFMailComposeViewController *mailcontroller = [[MFMailComposeViewController alloc] init];
    [mailcontroller setMailComposeDelegate:self];
    NSString *email =@"arjunmuk@gmail.com";
    NSArray *emailArray = [[NSArray alloc] initWithObjects:email, nil];
    [mailcontroller setToRecipients:emailArray];
    [mailcontroller setSubject:@"MWBF Feedback"];
    [self presentViewController:mailcontroller animated:YES completion:nil];
}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if( alertView == self.deleteActivitiesAlert )
    {
        if ( buttonIndex == OK_INDEX )
        {
            NSLog(@"Deleting all of the users data.");
            MWBFService *service = [[MWBFService alloc] init];
            BOOL success = [service deleteAllActivitiesForUser];
        
            if (!success)
                [Utils alertStatus:@"Reset Failed!" :@"Unable to delete user data.. Please try again." :0];
        }
    }
    else
    {
        if ( buttonIndex == OK_INDEX )
            [self performSegueWithIdentifier:@"logout" sender:self];
    }
}


@end
