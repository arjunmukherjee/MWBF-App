//
//  MessagesViewController.m
//  MWBF
//
//  Created by ARJUN MUKHERJEE on 9/16/14.
//  Copyright (c) 2014 ___Arjun Mukherjee___. All rights reserved.
//

#import "MessagesViewController.h"
#import "User.h"

#define CHALLENGE_INDEX 0

@interface MessagesViewController ()

@property (weak, nonatomic) IBOutlet UITableView *challengesMessageBoardTable;
@property (weak, nonatomic) IBOutlet UITableView *friendsMessageBoardTable;
@property (weak, nonatomic) IBOutlet UISegmentedControl *messageBoardSelector;
@property (strong,nonatomic) User *user;

@end

@implementation MessagesViewController

@synthesize challengesMessageBoardTable,friendsMessageBoardTable,messageBoardSelector;
@synthesize user;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.user = [User getInstance];

    self.challengesMessageBoardTable.hidden = NO;
    self.friendsMessageBoardTable.hidden = YES;
}

- (void) viewDidDisappear:(BOOL)animated
{
    [self.user.challengesMessageList removeAllObjects];
    [self.user.friendsMessageList removeAllObjects];
}

- (IBAction)segmentedControlClicked
{
    if (self.messageBoardSelector.selectedSegmentIndex == CHALLENGE_INDEX)
    {
        self.challengesMessageBoardTable.hidden = NO;
        self.friendsMessageBoardTable.hidden = YES;
    }
    else
    {
        self.challengesMessageBoardTable.hidden = YES;
        self.friendsMessageBoardTable.hidden = NO;
    }
}

///////// UITABLEVIEW METHODS /////////
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.challengesMessageBoardTable)
        return [self.user.challengesMessageList count];
    else
        return [self.user.friendsMessageList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if (tableView == self.challengesMessageBoardTable)
    {
        static NSString *CellIdentifier = @"ChallengeNotification";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        cell.textLabel.text = [self.user.challengesMessageList objectAtIndex:indexPath.row];
    }
    else
    {
        static NSString *CellIdentifier = @"FriendNotification";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        cell.textLabel.text = [self.user.friendsMessageList objectAtIndex:indexPath.row];
    }
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}


@end
