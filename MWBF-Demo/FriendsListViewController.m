//
//  FriendsListViewController.m
//  MWBF-Demo
//
//  Created by ARJUN MUKHERJEE on 8/18/14.
//  Copyright (c) 2014 ___Arjun Mukherjee___. All rights reserved.
//

#import "FriendsListViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import "User.h"
#import "Friend.h"

@interface FriendsListViewController ()
@property (weak, nonatomic) IBOutlet UITableView *friendsListTable;
@property (strong,nonatomic) User *user;


@end

@implementation FriendsListViewController

@synthesize friendsListTable;
@synthesize user;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.user = [User getInstance];
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
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    Friend *friendObj = [self.user.friendsList objectAtIndex:indexPath.row];
    
    cell.textLabel.text = friendObj.name;
    
    return cell;
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        // Delete the row from the array
        //[self.addedActivityArray removeObjectAtIndex:indexPath.row];
        //[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}


@end
