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
@property (strong, nonatomic) UIAlertView *deleteActivitiesAlert;
@property (strong, nonatomic) UIAlertView *refreshDataAlert;
@property (weak, nonatomic) IBOutlet UIButton *feedbackButton;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *infoButton;
@property (weak, nonatomic) IBOutlet UITextView *infoView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *refreshButton;

@end

@implementation MoreViewController

@synthesize resetUserDataButton,deleteActivitiesAlert,refreshButton,refreshDataAlert;
@synthesize userNameLabel;

- (void)viewDidLoad
{
    [super viewDidLoad];
    User *user = [User getInstance];
    self.userNameLabel.text = [NSString stringWithFormat:@"Welcome %@",user.userName];
    
    self.infoView.hidden = YES;
    [Utils setMaskTo:self.infoView byRoundingCorners:UIRectCornerAllCorners];
}

- (IBAction)infoButtonClicked:(id)sender
{
    if (self.infoView.hidden == YES)
    {
        [self.view bringSubviewToFront:self.infoView];
        self.infoView.hidden = NO;
    }
    else
        self.infoView.hidden = YES;
}

// Dismiss the keyboard when the background is tapped
- (IBAction)backgroundTap:(id)sender
{
    self.infoView.hidden = YES;
}

- (IBAction)resetUserDataClicked:(id)sender
{
    self.deleteActivitiesAlert = [[UIAlertView alloc] initWithTitle: @"Clean up" message: @"Do you really want to delete all your logged activities (irreversible) ?" delegate: self cancelButtonTitle: @"YES"  otherButtonTitles:@"NO",nil];
    
    [self.deleteActivitiesAlert show];
    
}

// Refresh all the users data
- (IBAction)refreshButtonClicked:(id)sender
{
    self.refreshDataAlert = [[UIAlertView alloc] initWithTitle: @"Refresh" message: @"Do you want to refresh all your data (could take a few seconds) ?" delegate: self cancelButtonTitle: @"YES"  otherButtonTitles:@"NO",nil];
    
    [self.refreshDataAlert show];
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
        {
            MWBFService *service = [[MWBFService alloc] init];
            
            self.activityIndicator.hidden = NO;
            [self.activityIndicator startAnimating];
            self.view.userInteractionEnabled = NO;
            
            dispatch_queue_t queue = dispatch_get_global_queue(0,0);
            
            dispatch_async(queue, ^{
                
                // Get the list of friends
                [User getInstance].friendsList = [service getFriendsList];
                
                // Get the all time highs
                [service getAllTimeHighs];
                
                // Get all the challenges the user is involved in
                [service getChallenges];
                
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [self.activityIndicator stopAnimating];
                    self.activityIndicator.hidden = YES;
                    self.view.userInteractionEnabled = YES;
                });
            });
        }
    }
}


@end
