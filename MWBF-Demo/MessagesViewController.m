//
//  MessagesViewController.m
//  MWBF
//
//  Created by ARJUN MUKHERJEE on 9/16/14.
//  Copyright (c) 2014 ___Arjun Mukherjee___. All rights reserved.
//

#import "MessagesViewController.h"
#import "User.h"
#import "ActivityNotificationCell.h"

#define ACTIVITIES_INDEX 0
#define NOTIFICATIONS_INDEX 1

@interface MessagesViewController ()

@property (weak, nonatomic) IBOutlet UITableView *notificationsBoardTable;
@property (weak, nonatomic) IBOutlet UITableView *activitiesBoardTable;
@property (weak, nonatomic) IBOutlet UISegmentedControl *messageBoardSelector;
@property (strong,nonatomic) NSMutableArray *friendActivitiesList;
@property (strong,nonatomic) User *user;

@end

@implementation MessagesViewController

@synthesize notificationsBoardTable,activitiesBoardTable,messageBoardSelector;
@synthesize user;
@synthesize friendActivitiesList;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.user = [User getInstance];
    
    self.notificationsBoardTable.hidden = YES;
    self.activitiesBoardTable.hidden = NO;
}

- (void) viewWillAppear:(BOOL)animated
{
    // Populate all the activities
    [Utils populateFriendsActivities];
    
    self.friendActivitiesList = [NSMutableArray arrayWithArray:self.user.friendsActivitiesList];
    
    [Utils changeAbsoluteDateToRelativeDays:self.friendActivitiesList];
    [self.activitiesBoardTable reloadData];
    
    [self.activitiesBoardTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[self.friendActivitiesList count]-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    
}


- (void) viewDidDisappear:(BOOL)animated
{
    [self.user.notificationsList removeAllObjects];
    //[self.user.friendsActivitiesList removeAllObjects];
}

- (IBAction)segmentedControlClicked
{
    if (self.messageBoardSelector.selectedSegmentIndex == NOTIFICATIONS_INDEX)
    {
        self.notificationsBoardTable.hidden = NO;
        self.activitiesBoardTable.hidden = YES;
    }
    else
    {
        self.notificationsBoardTable.hidden = YES;
        self.activitiesBoardTable.hidden = NO;
    }
}

///////// UITABLEVIEW METHODS /////////
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.notificationsBoardTable)
        return [self.user.notificationsList count];
    else
        return [self.friendActivitiesList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.notificationsBoardTable)
    {
        static NSString *CellIdentifier = @"Notifications";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        cell.textLabel.text = [self.user.notificationsList objectAtIndex:indexPath.row];
        cell.textLabel.font = [UIFont fontWithName:@"Trebuchet MS" size:12];
        cell.textLabel.textColor = [UIColor blueColor];
        
        return cell;
    }
    else
    {
        static NSString *CellIdentifier = @"MessageCell";
        ActivityNotificationCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        cell.activityMessage.font = [UIFont fontWithName:@"Trebuchet MS" size:12];
        cell.activityMessage.text = [self.friendActivitiesList objectAtIndex:indexPath.row];
        cell.activityMessage.textColor = [UIColor purpleColor];
        
        NSString *imageName = [Utils getImageNameFromMessage:[self.user.friendsActivitiesList objectAtIndex:indexPath.row]];
        UIImage *activityImg = [UIImage imageNamed:imageName];
        [cell.activityPic setImage:activityImg forState:UIControlStateNormal];
        [cell.activityPic setBackgroundImage:activityImg forState:UIControlStateNormal];
        
        return cell;
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}


@end
