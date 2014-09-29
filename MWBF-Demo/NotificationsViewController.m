//
//  NotificationsViewController.m
//  MWBF
//
//  Created by ARJUN MUKHERJEE on 9/24/14.
//  Copyright (c) 2014 ___Arjun Mukherjee___. All rights reserved.
//

#import "NotificationsViewController.h"
#import "User.h"
#import "ActivityNotificationCell.h"

@interface NotificationsViewController ()

@property (weak, nonatomic) IBOutlet UITableView *notificationsBoardTable;
@property (strong,nonatomic) User *user;

@end

@implementation NotificationsViewController

@synthesize notificationsBoardTable;
@synthesize user;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.user = [User getInstance];
    
    self.notificationsBoardTable.hidden = NO;
}

- (void) viewWillAppear:(BOOL)animated
{
}


- (void) viewDidDisappear:(BOOL)animated
{
    [self.user.notificationsList removeAllObjects];
}


///////// UITABLEVIEW METHODS /////////
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.user.notificationsList count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 34;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Notifications";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.textLabel.text = [self.user.notificationsList objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont fontWithName:@"Trebuchet MS" size:12];
    cell.textLabel.textColor = [UIColor blueColor];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}


@end
