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


@interface AddFriendViewController ()
@property (weak, nonatomic) IBOutlet UITextField *friendsEmailTextField;
@property (weak, nonatomic) IBOutlet UIButton *searchFriendButton;
@property (weak, nonatomic) IBOutlet UILabel *friendEmailLabel;
@property (weak, nonatomic) IBOutlet UILabel *friendNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *addFriendButton;
@property (weak, nonatomic) IBOutlet UILabel *friendEmail;
@property (weak, nonatomic) IBOutlet UILabel *friendFirstName;
@property (weak, nonatomic) IBOutlet UILabel *friendLastName;
@property (weak, nonatomic) IBOutlet FBProfilePictureView *friendProfilePicView;

@end

@implementation AddFriendViewController

@synthesize friendsEmailTextField,searchFriendButton,friendEmailLabel,friendNameLabel,addFriendButton;
@synthesize friendEmail,friendFirstName,friendLastName;
@synthesize friendProfilePicView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.friendProfilePicView.hidden = YES;
    
    self.friendsEmailTextField.delegate = self;
    
    self.friendEmailLabel.hidden = NO;
    self.friendNameLabel.hidden = NO;
    
    self.addFriendButton.hidden = NO;
    self.addFriendButton.enabled = NO;
    
    self.friendEmail.hidden = YES;
    self.friendFirstName.hidden = YES;
    self.friendLastName.hidden = YES;
    
    [Utils setRoundedView:self.friendProfilePicView toDiameter:75];
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
    
    self.friendsEmailTextField.text = [self.friendsEmailTextField.text lowercaseString];
    
    if ([self.friendsEmailTextField.text length] <= 0 )
    {
        [Utils alertStatus:@"Please provide your friend's email address" :@"Oops! Miss something ?" :0];
        return;
    }
    
    User *user = [User getInstance];
    if ([self.friendsEmailTextField.text isEqualToString: user.userEmail] )
    {
        [Utils alertStatus:@"That's your own email." :@"Nice try.." :0];
        return;
    }
    
    // TODO : Make this a hash and lookup the hash
    for(Friend *friendObj in user.friendsList)
    {
        // Check to see if the friend is already in your friend list
        if ( [friendObj.email isEqualToString:self.friendsEmailTextField.text] )
        {
            [Utils alertStatus:@"User is already on your friends list." :@"It's a small world!" :0];
            return;
        }
    }
    
    MWBFService *service = [[MWBFService alloc] init];
    NSDictionary *friendData = [service findFriendWithId:self.friendsEmailTextField.text];
    
    // TODO : Use the method below to conduct friend searches
    [service findFriendV1WithId:self.friendsEmailTextField.text];
    
    NSString *email = friendData[@"email"];
    NSString *firstName = friendData[@"firstName"];
    NSString *lastName = friendData[@"lastName"];
    NSString *profileId = friendData[@"fbProfileId"];
    
    //NSLog(@"Email[%@],FirstName[%@],LastName[%@],MemberSince[%@]",email,firstName,lastName,memberSince);
    
    if ([email length] <= 1)
    {
        [Utils alertStatus:@"Friend not found, do ask them to join us." :@"Where is this person ?" :0];
        
        self.addFriendButton.enabled = NO;
        
        self.friendEmail.hidden = YES;
        self.friendFirstName.hidden = YES;
        self.friendLastName.hidden = YES;
        self.friendProfilePicView.hidden = YES;
    }
    else
    {
        self.friendProfilePicView.hidden = NO;
        self.friendEmail.hidden = NO;
        self.friendFirstName.hidden = NO;
        self.friendLastName.hidden = NO;
        self.friendEmail.text = email;
        self.friendFirstName.text = firstName;
        self.friendLastName.text = lastName;
        self.friendProfilePicView.profileID = profileId;
        
        self.addFriendButton.hidden = NO;
        self.addFriendButton.enabled = YES;
    }
}


- (IBAction)addButtonClicked:(id)sender
{
    MWBFService *service = [[MWBFService alloc] init];
    if ( [service addFriendWithId:self.friendEmail.text] )
    {
       [Utils alertStatus:[NSString stringWithFormat:@"%@ added to your friends list.",self.friendFirstName.text] :@"Yippee" :0];
        
        User *user = [User getInstance];
        
        // Construct the new friend object
        Friend *newFriend = [[Friend alloc] init];
        newFriend.email = self.friendEmail.text;
        newFriend.firstName = self.friendFirstName.text;
        newFriend.lastName = self.friendLastName.text;
        newFriend.fbProfileID = self.friendProfilePicView.profileID;
        
        NSMutableArray *tempFriendsNameArray = [NSMutableArray array];
        [tempFriendsNameArray addObject:newFriend];
    
        // Add the current list of friends to the temp list
        for (Friend *existingFriend in user.friendsList)
            [tempFriendsNameArray addObject:existingFriend];
        
        // Add the newly added friend to the users friends list
        user.friendsList = [NSMutableArray arrayWithArray:tempFriendsNameArray];
        
        self.addFriendButton.enabled = NO;
        
        self.friendProfilePicView.hidden = YES;
        self.friendEmail.hidden = YES;
        self.friendFirstName.hidden = YES;
        self.friendLastName.hidden = YES;
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
        [Utils alertStatus:[NSString stringWithFormat:@"Unable to add %@ to your friends list.",self.friendFirstName.text]  :@"Oops!" :0];
        
}

// Dismiss the keyboard when the background is tapped
- (IBAction)backgroundTap:(id)sender
{
    [self.view endEditing:YES];
}

@end
