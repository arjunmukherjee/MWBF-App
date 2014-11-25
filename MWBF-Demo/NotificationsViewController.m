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
#import "FBFriendNotificationCell.h"
#import "AddFriendViewController.h"

#define FRIENDS_REQUEST_INDEX 0
#define CHALLENGE_REQUEST_INDEX 1
#define NOTIFICATIONS_INDEX 2

@interface NotificationsViewController ()

@property (weak, nonatomic) IBOutlet UITableView *friendsNotificationsTable;
@property (strong,nonatomic) NSMutableArray *pendingFriendRequestsList;
@property (strong,nonatomic) NSMutableArray *pendingChallengeRequestsList;
@property (strong,nonatomic) NSMutableArray *notitificationsList;

@property (strong,nonatomic) User *user;
@property (strong,nonatomic) FriendRequest *selectedFriendRequest;
@property (strong,nonatomic) Friend *selectedFriendNotification;
@property (weak, nonatomic) IBOutlet UIButton *friendReqCountAlert;
@property (weak, nonatomic) IBOutlet UIButton *challengeReqCountAlert;
@property (weak, nonatomic) IBOutlet UIButton *notificationsCountAlert;
@property (weak, nonatomic) IBOutlet UITableView *notificationsTable;
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
@synthesize notitificationsList,notificationsTable,notificationsCountAlert;
@synthesize selectedFriendNotification;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.pendingFriendRequestsList = [NSMutableArray array];
    self.pendingChallengeRequestsList = [NSMutableArray array];
    self.notitificationsList = [NSMutableArray array];

    self.friendsNotificationsTable.hidden = NO;
}

- (void) viewWillAppear:(BOOL)animated
{
    self.challengeReqCountAlert.hidden = YES;
    self.friendReqCountAlert.hidden = YES;
    self.notificationsCountAlert.hidden = YES;
    
    self.friendsNotificationsTable.hidden = NO;
    self.challengeNotificationsTable.hidden = YES;
    self.notificationsTable.hidden = YES;
    
    [self.notificationsSegmentedControl setSelectedSegmentIndex:0];
    
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
    
    
    // NOTIFICATIONS
    [self.notitificationsList removeAllObjects];
    for (int i=0; i <[self.user.fbFriendNotificationsList count]; i++)
        [self.notitificationsList addObject:self.user.fbFriendNotificationsList[i]];
    
    // Reset the notification alert count
    if ( [self.notitificationsList count] > 0 )
    {
        self.notificationsCountAlert.hidden = NO;
        [self.notificationsCountAlert setTitle:[NSString stringWithFormat:@"%lu",(unsigned long)[self.notitificationsList count]] forState:UIControlStateNormal];
    }
    else
        self.notificationsCountAlert.hidden = YES;
    [self.notificationsTable reloadData];
    
    
    // PENDING CHALLENGE REQUESTS
    [self.pendingChallengeRequestsList removeAllObjects];
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
    [self.challengeNotificationsTable reloadData];

    
    // Set the count on the "More" tab item in the tabBar
    NSInteger requestCount = [user.friendRequestsList count] + [user.challengeRequestsList count] + [user.fbFriendNotificationsList count];
    if (requestCount == 0 )
        [[[[[self tabBarController] tabBar] items] objectAtIndex:4] setBadgeValue:nil];
    else
        [[[[[self tabBarController] tabBar] items] objectAtIndex:4] setBadgeValue:[NSString stringWithFormat:@"%ld",(long)requestCount]];
   
    [self setCountOnNotificationCellWithValue:requestCount];
    
}

// TODO : Same method and code in BaseClassViewController.m
- (void) setCountOnNotificationCellWithValue : (NSInteger) requestCount
{
    UIViewController *tbMore = ((UIViewController*) [self.tabBarController.moreNavigationController.viewControllers objectAtIndex:0]);
    int nRows = [((UITableView *)tbMore.view) numberOfRowsInSection:0];
    for (int i = 0; i < nRows; i++)
    {
        // Only modify the notifications cell
        if (i == 0)
        {
            UITableViewCell *cell = [((UITableView *)tbMore.view) cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            
            UILabel *commentsCount = [[UILabel alloc]initWithFrame:CGRectMake(0, 4, 28, 20)];
            commentsCount.text = [NSString stringWithFormat:@"%ld",(long)requestCount];
            commentsCount.textColor = [UIColor whiteColor];
            commentsCount.font = [UIFont fontWithName:@"Trebuchet MS" size:14];
            if (requestCount == 0)
                commentsCount.backgroundColor = [UIColor clearColor];
            else
                commentsCount.backgroundColor = [UIColor lightGrayColor];
            
            commentsCount.textAlignment = NSTextAlignmentCenter;
            [Utils setMaskTo:commentsCount byRoundingCorners:UIRectCornerAllCorners];
            
            cell.accessoryView = commentsCount;
        }
    }
}


- (IBAction)segmentedControlClicked:(id)sender
{
    self.challengeNotificationsTable.hidden = YES;
    
    if (self.notificationsSegmentedControl.selectedSegmentIndex == FRIENDS_REQUEST_INDEX)
    {
        self.friendsNotificationsTable.hidden = NO;
        self.challengeNotificationsTable.hidden = YES;
        self.notificationsTable.hidden = YES;
    }
    else if (self.notificationsSegmentedControl.selectedSegmentIndex == 4)
    {
        // TODO : Set the index in the above line to CHALLENGE_REQUEST_INDEX and correct the storyBoard
        self.friendsNotificationsTable.hidden = YES;
        self.challengeNotificationsTable.hidden = NO;
        self.notificationsTable.hidden = YES;
    }
    else
    {
        self.friendsNotificationsTable.hidden = YES;
        self.challengeNotificationsTable.hidden = YES;
        self.notificationsTable.hidden = NO;
        self.notificationsCountAlert.hidden = YES;
        
        // Set the count on the "More" tab item in the tabBar
        NSInteger requestCount = [user.friendRequestsList count] + [user.challengeRequestsList count];
        if (requestCount == 0 )
            [[[[[self tabBarController] tabBar] items] objectAtIndex:4] setBadgeValue:nil];
        else
            [[[[[self tabBarController] tabBar] items] objectAtIndex:4] setBadgeValue:[NSString stringWithFormat:@"%ld",(long)requestCount]];
        
        [self setCountOnNotificationCellWithValue:requestCount];
        
        // TODO : Should I remove the items ?
        //[self.notitificationsList removeAllObjects];
        //User *user = [User getInstance];
        //[user.fbFriendNotificationsList removeAllObjects];
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
        return [self.pendingFriendRequestsList count];
    else if (tableView == self.challengeNotificationsTable)
        return [self.pendingChallengeRequestsList count];
    else
        return [self.notitificationsList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.friendsNotificationsTable)
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
    else
    {
        static NSString *CellIdentifier = @"FBFriendNotifications";
        Friend *friend = [self.notitificationsList objectAtIndex:(indexPath.row)];
        
        FBFriendNotificationCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        cell.notificationMessage.font = [UIFont fontWithName:@"Trebuchet MS" size:13];
        cell.notificationMessage.textColor = [UIColor blueColor];
        cell.notificationMessage.text = [NSString stringWithFormat:@"Your Facebook friend %@ %@ just joined MWBF, connect with them.",friend.firstName,friend.lastName];
        cell.friendFbProfilePicView.profileID = friend.fbProfileID;
        UIColor *selectionColor = CELL_SELECTION_COLOR;
        UIView *bgColorView = [[UIView alloc] init];
        bgColorView.backgroundColor = selectionColor;
        [cell setSelectedBackgroundView:bgColorView];
        
        return cell;
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.friendsNotificationsTable)
    {
        FriendRequest *frReq = [self.pendingFriendRequestsList objectAtIndex:(indexPath.row)];
        self.selectedFriendRequest = frReq;
    
        [self performSegueWithIdentifier:@"Profile" sender:self];
    }
    else
    {
        self.selectedFriendNotification = [self.notitificationsList objectAtIndex:(indexPath.row)];
        [self performSegueWithIdentifier:@"FindFriend" sender:self];
    }
}


- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Profile"] )
    {
        ProfileViewController *controller = [segue destinationViewController];
        controller.friend = self.selectedFriendRequest.friend;
        controller.pageTitle = self.selectedFriendRequest.friend.firstName;
    }
    else if ([segue.identifier isEqualToString:@"FindFriend"] )
    {
        AddFriendViewController *controller = [segue destinationViewController];
        controller.friendName = [NSString stringWithFormat:@"%@",self.selectedFriendNotification.firstName];
    }
}

@end
