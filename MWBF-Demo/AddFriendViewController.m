//
//  AddFriendViewController.m
//  MWBF-Demo
//
//  Created by ARJUN MUKHERJEE on 8/18/14.
//  Copyright (c) 2014 ___Arjun Mukherjee___. All rights reserved.
//

#import "AddFriendViewController.h"
#import "MWBFService.h"
#import "Utils.h"
#import "User.h"
#import "Friend.h"
#import <FacebookSDK/FacebookSDK.h>
#import "FriendCell.h"


@interface AddFriendViewController ()
@property (weak, nonatomic) IBOutlet UIButton *searchFriendButton;
@property (strong, nonatomic) IBOutlet UITableView *friendsListTable;
@property (strong,nonatomic) NSMutableArray *searchResults;
@property (weak, nonatomic) IBOutlet UITextField *friendIdTextField;

@end

@implementation AddFriendViewController

@synthesize searchFriendButton;
@synthesize friendsListTable;
@synthesize searchResults;
@synthesize friendIdTextField;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.searchResults = [NSMutableArray array];
    self.friendsListTable.hidden = YES;
}

// Dismiss the keyboard when the GO button is hit
- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)searchButtonClicked:(id)sender
{
    [self backgroundTap:nil];
    
    if ([Utils isStringNullOrEmpty:self.friendIdTextField.text ] )
    {
        [Utils alertStatus:@"Please provide your friend's email or name." :@"Oops ! Miss Something ?" :0];
        return;
    }
    
    User *user = [User getInstance];
    if ([self.friendIdTextField.text isEqualToString: user.userEmail] )
    {
        [Utils alertStatus:@"That's your own email." :@"Nice try.." :0];
        return;
    }
    
    // TODO : Make this a hash and lookup the hash
    for(Friend *friendObj in user.friendsList)
    {
        // Check to see if the friend is already in your friend list
        if ( [friendObj.email isEqualToString:self.friendIdTextField.text] )
        {
            [Utils alertStatus:@"User is already on your friends list." :@"It's a small world!" :0];
            return;
        }
    }
    
    MWBFService *service = [[MWBFService alloc] init];
    
    [self.searchResults removeAllObjects];
    NSMutableArray *tempSearchResults = [service findFriendV1WithId:self.friendIdTextField.text];
    
    // Remove all friends from the search results that are already the user's friends
    for (Friend *friend in tempSearchResults)
    {
        BOOL friendFound = NO;
        for (Friend *usersFriend in user.friendsList)
        {
            if ([friend.email isEqualToString:usersFriend.email])
            {
                friendFound = YES;
                continue;
            }
        }
        
        if ( !friendFound )
            [self.searchResults addObject:friend];
    }
    
    
    
    if ([self.searchResults count] < 1)
    {
        [Utils alertStatus:@"Friend not found, do ask them to join us." :@"Where is this person ?" :0];
        self.friendsListTable.hidden = YES;
    }
    else
    {
        self.friendsListTable.hidden = NO;
        [self.friendsListTable reloadData];
    }
}


- (void)addFriend:(Friend *)friend
{
    MWBFService *service = [[MWBFService alloc] init];
    if ( [service addFriendWithId:friend.email] )
    {
       [Utils alertStatus:[NSString stringWithFormat:@"%@ added to your friends list.",friend.firstName] :@"Yippee" :0];
        
        User *user = [User getInstance];
        
        // Add the new friend to the users list of friends
        NSMutableArray *tempFriendsNameArray = [NSMutableArray array];
        [tempFriendsNameArray addObject:friend];
    
        // Add the current list of friends to the temp list
        for (Friend *existingFriend in user.friendsList)
            [tempFriendsNameArray addObject:existingFriend];
        
        // Add the newly added friend to the users friends list
        user.friendsList = [NSMutableArray arrayWithArray:tempFriendsNameArray];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
        [Utils alertStatus:[NSString stringWithFormat:@"Unable to add %@ to your friends list.",friend.firstName]  :@"Oops!" :0];
        
}

// Dismiss the keyboard when the background is tapped
- (IBAction)backgroundTap:(id)sender
{
    [self.view endEditing:YES];
}

///////// UITABLEVIEW METHODS /////////


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.searchResults count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"FriendDetailsCell";
    FriendCell *cell = [self.friendsListTable dequeueReusableCellWithIdentifier:CellIdentifier];
    Friend *friendObj = [self.searchResults objectAtIndex:indexPath.row];
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
    Friend *friendObj = [self.searchResults objectAtIndex:indexPath.row];
    
    [self addFriend:friendObj];
}


@end
