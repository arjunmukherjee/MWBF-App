//
//  AddFriendViewController.m
//  MWBF-Demo
//
//  Created by ARJUN MUKHERJEE on 8/18/14.
//  Copyright (c) 2014 ___Arjun Mukherjee___. All rights reserved.
//

#import "AddFriendViewController.h"

@interface AddFriendViewController ()
@property (weak, nonatomic) IBOutlet UITextField *friendsEmailTextField;
@property (weak, nonatomic) IBOutlet UIButton *searchFriendButton;
@property (weak, nonatomic) IBOutlet UILabel *friendEmailLabel;
@property (weak, nonatomic) IBOutlet UILabel *friendNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *addFriendButton;
@property (weak, nonatomic) IBOutlet UILabel *friendEmail;
@property (weak, nonatomic) IBOutlet UILabel *friendName;

@end

@implementation AddFriendViewController

@synthesize friendsEmailTextField,searchFriendButton,friendEmailLabel,friendNameLabel,addFriendButton;
@synthesize friendEmail,friendName;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.friendEmailLabel.hidden = YES;
    self.friendNameLabel.hidden = YES;
    self.addFriendButton.hidden = YES;
    self.friendEmail.hidden = YES;
    self.friendName.hidden = YES;
}

- (IBAction)searchButtonClicked:(id)sender
{
    self.friendEmailLabel.hidden = NO;
    self.friendNameLabel.hidden = NO;
    self.addFriendButton.hidden = NO;
    self.friendEmail.hidden = NO;
    self.friendName.hidden = NO;
}


- (IBAction)addButtonClicked:(id)sender
{
    NSLog(@"Added friend.");
}

@end
