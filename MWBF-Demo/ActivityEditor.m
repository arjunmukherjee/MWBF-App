//
//  ActivityEditor.m
//  MWBF
//
//  Created by ARJUN MUKHERJEE on 1/22/15.
//  Copyright (c) 2015 ___Arjun Mukherjee___. All rights reserved.
//

#import "ActivityEditor.h"
#import "MWBFService.h"
#import "User.h"
#import "Utils.h"

#define OK_INDEX 0

@interface ActivityEditor ()
@property (weak, nonatomic) IBOutlet UITextField *activityDescriptionTextField;
@property (weak, nonatomic) IBOutlet UIButton *deleteActivityButton;
@property (weak, nonatomic) IBOutlet UILabel *activityLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *pointsLabel;

@end

@implementation ActivityEditor

@synthesize activityId,activityName,activityLabel,activityDescriptionTextField,activityDate,dateLabel,activityUnits,activityValue;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.dateLabel.text = self.activityDate;
    self.activityLabel.text = [NSString stringWithFormat:@"%@ %@ %@",self.activityName,self.activityValue,self.activityUnits];
    self.pointsLabel.text = [NSString stringWithFormat:@"Points : %@",[Utils reducePrecisionOfFloat:self.points]];
}

- (IBAction)deleteActivityClicked:(id)sender
{
    
    UIAlertView *deleteDataAlert = [[UIAlertView alloc] initWithTitle: @"Delete" message: @"Are you sure you want to delete this activity ?" delegate: self cancelButtonTitle: @"YES"  otherButtonTitles:@"NO",nil];
    
    [deleteDataAlert show];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ( buttonIndex == OK_INDEX )
    {
        MWBFService *service = [[MWBFService alloc] init];
        BOOL success = [service deleteUserActivityWithId:self.activityId];
        
        if (!success)
            [Utils alertStatus:@"Delete Failed!" :@"Unable to delete user activity.. Please try again." :0];
        else
        {
            // Remove the activity from the users list
            User *user = [User getInstance];
            for (int i=0; i< [user.friendsActivitiesList count];i++)
            {
                if ( user.friendsActivitiesList[i][@"id"] == self.activityId)
                    [user.friendsActivitiesList removeObject:user.friendsActivitiesList[i]];
            }
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}


@end
