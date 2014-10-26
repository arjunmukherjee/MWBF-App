//
//  FriendsListViewController.m
//  MWBF-Demo
//
//  Created by ARJUN MUKHERJEE on 8/18/14.
//  Copyright (c) 2014 ___Arjun Mukherjee___. All rights reserved.
//

#import "FriendsListViewController.h"
#import "ActivityViewController.h"
#import "User.h"
#import "Friend.h"
#import "FriendCell.h"
#import "MWBFService.h"
#import "ProfileViewController.h"


@interface FriendsListViewController ()
@property (weak, nonatomic) IBOutlet UITableView *friendsListTable;
@property (strong,nonatomic) User *user;
@property (nonatomic) NSInteger numberOfFriends;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *addFriendButton;
@property (strong,nonatomic) Friend *selectedFriend;


@end

@implementation FriendsListViewController

@synthesize friendsListTable;
@synthesize user;
@synthesize numberOfFriends;
@synthesize addFriendButton;
@synthesize selectedFriend;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self loadData];
    self.numberOfFriends = [self.user.friendsList count];
}

- (void)viewWillAppear:(BOOL)animated
{
    // Reload stuff only if the number of friends has changed since the view was initially loaded
    NSInteger newCount = [self.user.friendsList count];
    
    if (self.numberOfFriends != newCount)
    {
        [self loadData];
        [self.friendsListTable reloadData];
        self.numberOfFriends = [self.user.friendsList count];
    }
    
    self.navigationItem.rightBarButtonItem = self.addFriendButton;
}

- (void) loadData
{
    self.user = [User getInstance];
    
    // Sort the activites by the total points
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"firstName" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    NSArray *sortedArray = [self.user.friendsList sortedArrayUsingDescriptors:sortDescriptors];
    self.user.friendsList = [NSMutableArray arrayWithArray:sortedArray];

}

///////// UITABLEVIEW METHODS /////////


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.user.friendsList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"FriendDetailsCell";
    FriendCell *cell = [self.friendsListTable dequeueReusableCellWithIdentifier:CellIdentifier];
    Friend *friendObj = [self.user.friendsList objectAtIndex:indexPath.row];
    cell.friendNameLabel.text = [NSString stringWithFormat:@"%@ %@",friendObj.firstName,friendObj.lastName];
    cell.friendFbProfilePicView.profileID = friendObj.fbProfileID;
    [Utils setRoundedView:cell.friendFbProfilePicView toDiameter:40];
    
    UIColor *selectionColor = [[UIColor alloc] initWithRed:20.0 / 255 green:59.0 / 255 blue:102.0 / 255 alpha:0.5];
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = selectionColor;
    [cell setSelectedBackgroundView:bgColorView];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedFriend = [self.user.friendsList objectAtIndex:indexPath.row];
  
    [self performSegueWithIdentifier:@"FriendProfile" sender:self];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"FriendProfile"] )
    {
        ProfileViewController *controller = [segue destinationViewController];
        controller.friend = self.selectedFriend;
    }
}


@end
