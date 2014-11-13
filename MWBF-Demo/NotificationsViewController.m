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

@interface NotificationsViewController ()

@property (weak, nonatomic) IBOutlet UITableView *notificationsBoardTable;
@property (strong,nonatomic) NSMutableArray *pendingFriendRequestsList;
@property (strong,nonatomic) User *user;
@property (strong,nonatomic) FriendRequest *selectedFriendRequest;



@end

@implementation NotificationsViewController

@synthesize notificationsBoardTable;
@synthesize user;
@synthesize selectedFriendRequest;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.pendingFriendRequestsList = [NSMutableArray array];
    
    self.notificationsBoardTable.hidden = NO;
}

- (void) viewWillAppear:(BOOL)animated
{
    [self.pendingFriendRequestsList removeAllObjects];
    
    self.user = [User getInstance];
    for (int i=0; i <[self.user.friendRequestsList count]; i++)
        [self.pendingFriendRequestsList addObject:self.user.friendRequestsList[i]];
}


- (void) viewDidDisappear:(BOOL)animated
{
}

- (IBAction)acceptButtonClicked:(UIButton*) actionButton
{
    if (self.selectedFriendRequest == nil)
    {
        CGPoint buttonPosition = [actionButton convertPoint:CGPointZero toView:self.notificationsBoardTable];
        NSIndexPath *indexPath = [self.notificationsBoardTable indexPathForRowAtPoint:buttonPosition];
        NSInteger currentIndex = 0;
        if (indexPath != nil)
            currentIndex = indexPath.row;
        
        self.selectedFriendRequest = [self.pendingFriendRequestsList objectAtIndex:currentIndex];
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
        [self.notificationsBoardTable reloadData];
    }
    else
        [Utils alertStatus:[NSString stringWithFormat:@"Unable to add %@ to your friends list.",self.selectedFriendRequest.friend.firstName]  :@"Oops!" :0];
}

- (IBAction)rejectButtonClicked:(UIButton*) actionButton
{
    if (self.selectedFriendRequest == nil)
    {
        CGPoint buttonPosition = [actionButton convertPoint:CGPointZero toView:self.notificationsBoardTable];
        NSIndexPath *indexPath = [self.notificationsBoardTable indexPathForRowAtPoint:buttonPosition];
        NSInteger currentIndex = 0;
        if (indexPath != nil)
            currentIndex = indexPath.row;
        
        self.selectedFriendRequest = [self.pendingFriendRequestsList objectAtIndex:currentIndex];
    }
    
    MWBFService *service = [[MWBFService alloc] init];
    if ( [service actionFriendRequestWithId:self.selectedFriendRequest.requestId withAction:@"Reject"] )
    {
        User *userInst = [User getInstance];
        
        // Remove the request form the list of requests
        [userInst.friendRequestsList removeObject:self.selectedFriendRequest];
        
        [self.pendingFriendRequestsList removeObject:self.selectedFriendRequest];
        [self.notificationsBoardTable reloadData];
    }
}


///////// UITABLEVIEW METHODS /////////
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ([self.pendingFriendRequestsList count]);
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
