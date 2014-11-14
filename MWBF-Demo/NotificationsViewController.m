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
#import "FriendRequestCell.h"
#import "Utils.h"
#import "FriendRequest.h"
#import "ProfileViewController.h"
#import "MWBFService.h"

#define FRIENDS_REQUEST_INDEX 0
#define CHALLENGE_REQUEST_INDEX 1

@interface NotificationsViewController ()

@property (weak, nonatomic) IBOutlet UITableView *friendsNotificationsTable;
@property (strong,nonatomic) NSMutableArray *pendingFriendRequestsList;
@property (strong,nonatomic) NSMutableArray *pendingChallengeRequestsList;
@property (strong,nonatomic) User *user;
@property (strong,nonatomic) FriendRequest *selectedFriendRequest;
@property (weak, nonatomic) IBOutlet UIButton *friendReqCountAlert;
@property (weak, nonatomic) IBOutlet UIButton *challengeReqCountAlert;

@property (weak, nonatomic) IBOutlet UITableView *challengeNotificationsTable;
@property (weak, nonatomic) IBOutlet UISegmentedControl *notificationsSegmentedControl;


@end

@implementation NotificationsViewController

@synthesize friendsNotificationsTable;
@synthesize user;
@synthesize selectedFriendRequest;
@synthesize friendReqCountAlert;
@synthesize notificationsSegmentedControl,challengeNotificationsTable;
@synthesize pendingFriendRequestsList,pendingChallengeRequestsList;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.pendingFriendRequestsList = [NSMutableArray array];
    self.pendingChallengeRequestsList = [NSMutableArray array];
    
    self.friendsNotificationsTable.hidden = NO;
}

- (void) viewWillAppear:(BOOL)animated
{
    self.challengeReqCountAlert.hidden = YES;
    self.friendReqCountAlert.hidden = YES;
    
    self.friendsNotificationsTable.hidden = NO;
    self.challengeNotificationsTable.hidden = YES;
    
    [self reloadData];
}

- (void) reloadData
{
    // PENDING FRIEND REQUESTS
    [self.pendingFriendRequestsList removeAllObjects];
    self.user = [User getInstance];
    for (int i=0; i <[self.user.friendRequestsList count]; i++)
        [self.pendingFriendRequestsList addObject:self.user.friendRequestsList[i]];
    
    // Reset the friend request alert count
    if ( [self.pendingFriendRequestsList count] > 0 )
    {
        self.friendReqCountAlert.hidden = NO;
        [self.friendReqCountAlert setTitle:[NSString stringWithFormat:@"%lu",(unsigned long)[self.pendingFriendRequestsList count]] forState:UIControlStateNormal];
    }
    else
        self.friendReqCountAlert.hidden = YES;
    
    [self.friendsNotificationsTable reloadData];
    
    // PENDING CHALLENGE REQUESTS
    [self.pendingChallengeRequestsList removeAllObjects];
    self.user = [User getInstance];
    for (int i=0; i <[self.user.challengeRequestsList count]; i++)
        [self.pendingChallengeRequestsList addObject:self.user.friendRequestsList[i]];
    
    // Reset the challenge request alert count
    if ( [self.pendingChallengeRequestsList count] > 0 )
    {
        self.challengeReqCountAlert.hidden = NO;
        [self.challengeReqCountAlert setTitle:[NSString stringWithFormat:@"%lu",(unsigned long)[self.pendingChallengeRequestsList count]] forState:UIControlStateNormal];
    }
    else
        self.challengeReqCountAlert.hidden = YES;
    
    NSInteger requestCount = [user.friendRequestsList count] + [user.challengeRequestsList count];
    if (requestCount == 0 )
        [[[[[self tabBarController] tabBar] items] objectAtIndex:4] setBadgeValue:nil];
    else
        [[[[[self tabBarController] tabBar] items] objectAtIndex:4] setBadgeValue:[NSString stringWithFormat:@"%ld",(long)requestCount]];
    
    [self.challengeNotificationsTable reloadData];
}

- (IBAction)segmentedControlClicked:(id)sender
{
    self.challengeNotificationsTable.hidden = YES;
    
    if (self.notificationsSegmentedControl.selectedSegmentIndex == FRIENDS_REQUEST_INDEX)
    {
        self.friendsNotificationsTable.hidden = NO;
        self.challengeNotificationsTable.hidden = YES;
    }
    else
    {
        self.friendsNotificationsTable.hidden = YES;
        self.challengeNotificationsTable.hidden = NO;
    }
}

- (NSInteger)getCellIndex:(UIButton *)actionButton
{
    UIView *parentCell = actionButton.superview;
    while (![parentCell isKindOfClass:[UITableViewCell class]]) {   // iOS 7 onwards the table cell hierachy has changed.
        parentCell = parentCell.superview;
    }
    
    UIView *parentView = parentCell.superview;
    while (![parentView isKindOfClass:[UITableView class]]) {   // iOS 7 onwards the table cell hierachy has changed.
        parentView = parentView.superview;
    }
    
    UITableView *tableView = (UITableView *)parentView;
    NSIndexPath *indexPath = [tableView indexPathForCell:(UITableViewCell *)parentCell];
    
    NSInteger currentIndex = 0;
    if (indexPath != nil)
        currentIndex = indexPath.row;
    
    return currentIndex;
}

- (IBAction)acceptButtonClicked:(UIButton*) actionButton
{
    BOOL resetSelectedFriend = NO;
    
    if (self.selectedFriendRequest == nil)
    {
        self.selectedFriendRequest = [self.pendingFriendRequestsList objectAtIndex:[self getCellIndex:actionButton]];
        resetSelectedFriend = YES;
    }
    
    MWBFService *service = [[MWBFService alloc] init];
    if ( [service actionFriendRequestWithId:self.selectedFriendRequest.requestId withAction:@"Accept"] )
    {
        [Utils alertStatus:[NSString stringWithFormat:@"You and %@ are now friends.",self.selectedFriendRequest.friend.firstName] :@"Yippee" :0];
        
        User *userInst = [User getInstance];
        
        // Add the new friend to the users list of friends
        NSMutableArray *tempFriendsNameArray = [NSMutableArray array];
        [tempFriendsNameArray addObject:self.selectedFriendRequest.friend];
        
        // Add the current list of friends to the temp list
        for (Friend *existingFriend in userInst.friendsList)
            [tempFriendsNameArray addObject:existingFriend];
        
        // Add the newly added friend to the users friends list
        userInst.friendsList = [NSMutableArray arrayWithArray:tempFriendsNameArray];
        
        // Remove the request form the list of requests
        [userInst.friendRequestsList removeObject:self.selectedFriendRequest];
        [self.pendingFriendRequestsList removeObject:self.selectedFriendRequest];
        
        [self reloadData];
        
    }
    else
        [Utils alertStatus:[NSString stringWithFormat:@"Unable to add %@ to your friends list.",self.selectedFriendRequest.friend.firstName]  :@"Oops!" :0];
    
    if (resetSelectedFriend)
        self.selectedFriendRequest = nil;
}

- (IBAction)rejectButtonClicked:(UIButton*) actionButton
{
    BOOL resetSelectedFriend = NO;
    
    if (self.selectedFriendRequest == nil)
    {
        self.selectedFriendRequest = [self.pendingFriendRequestsList objectAtIndex:[self getCellIndex:actionButton]];
        resetSelectedFriend = YES;
    }
    
    MWBFService *service = [[MWBFService alloc] init];
    if ( [service actionFriendRequestWithId:self.selectedFriendRequest.requestId withAction:@"Reject"] )
    {
        User *userInst = [User getInstance];
        
        // Remove the request form the list of requests
        [userInst.friendRequestsList removeObject:self.selectedFriendRequest];
        [self.pendingFriendRequestsList removeObject:self.selectedFriendRequest];
    
        [self reloadData];
        
        [Utils alertStatus:[NSString stringWithFormat:@"You rejected %@'s friend request.",self.selectedFriendRequest.friend.firstName] :@"Good riddance" :0];
    }
    
    if (resetSelectedFriend)
        self.selectedFriendRequest = nil;
}


///////// UITABLEVIEW METHODS /////////
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.friendsNotificationsTable)
        return ([self.pendingFriendRequestsList count]);
    else
        return ([self.pendingChallengeRequestsList count]);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"PendingRequests";
    FriendRequest *frReq = [self.pendingFriendRequestsList objectAtIndex:(indexPath.row)];
    
    FriendRequestCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.friendNameLabel.text = [NSString stringWithFormat:@"%@ %@",frReq.friend.firstName,frReq.friend.lastName];
    cell.friendFbProfilePicView.profileID = frReq.friend.fbProfileID;
    
    UIColor *selectionColor = CELL_SELECTION_COLOR;
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = selectionColor;
    [cell setSelectedBackgroundView:bgColorView];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FriendRequest *frReq = [self.pendingFriendRequestsList objectAtIndex:(indexPath.row)];
    self.selectedFriendRequest = frReq;
    
    [self performSegueWithIdentifier:@"Profile" sender:self];
}


- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Profile"] )
    {
        ProfileViewController *controller = [segue destinationViewController];
        controller.friend = self.selectedFriendRequest.friend;
        controller.pageTitle = self.selectedFriendRequest.friend.firstName;
    }
}

@end
