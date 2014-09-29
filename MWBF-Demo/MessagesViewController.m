//
//  MessagesViewController.m
//  MWBF
//
//  Created by ARJUN MUKHERJEE on 9/16/14.
//  Copyright (c) 2014 ___Arjun Mukherjee___. All rights reserved.
//

#import "MessagesViewController.h"
#import "User.h"
#import "ActivityNotificationCell.h"
#import "ActivityViewController.h"
#import "Friend.h"


@interface MessagesViewController ()

@property (weak, nonatomic) IBOutlet UITableView *activitiesBoardTable;
@property (strong,nonatomic) NSMutableArray *friendActivitiesList;
@property (strong,nonatomic) User *user;
@property (nonatomic) NSInteger todayIndex;
@property (nonatomic) NSInteger yesterdayIndex;
@property (strong,nonatomic) Friend *selectedFriend;
@property (weak, nonatomic) IBOutlet UIProgressView *yourProgressBar;
@property (weak, nonatomic) IBOutlet UIProgressView *friendAverageProgressBar;
@property (weak, nonatomic) IBOutlet UIProgressView *leaderProgressBar;

@end

@implementation MessagesViewController

@synthesize activitiesBoardTable;
@synthesize user;
@synthesize friendActivitiesList;
@synthesize todayIndex;
@synthesize yesterdayIndex;
@synthesize selectedFriend;
@synthesize yourProgressBar,friendAverageProgressBar,leaderProgressBar;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.user = [User getInstance];
    
    self.friendActivitiesList = [NSMutableArray array];
    
    self.activitiesBoardTable.hidden = NO;
    self.todayIndex = 0;
    self.yesterdayIndex = 0;
    
    [self.yourProgressBar setTransform:CGAffineTransformMakeScale(1.0, 3.0)];
    [self.friendAverageProgressBar setTransform:CGAffineTransformMakeScale(1.0, 3.0)];
    [self.leaderProgressBar setTransform:CGAffineTransformMakeScale(1.0, 3.0)];
}

- (void) viewWillAppear:(BOOL)animated
{
    self.todayIndex = 0;
    self.yesterdayIndex = 0;
    
    [self.friendActivitiesList removeAllObjects];
    for (int i=0; i <[self.user.friendsActivitiesList count]; i++)
        [self.friendActivitiesList addObject:self.user.friendsActivitiesList[i][@"feedPrettyString"]];
    
    [Utils changeAbsoluteDateToRelativeDays:self.friendActivitiesList];
    
    [self.activitiesBoardTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:([self.friendActivitiesList count]*2)-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    
    [self.activitiesBoardTable reloadData];
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
    return ([self.friendActivitiesList count]*2);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.activitiesBoardTable)
    {
        if (indexPath.row % 2 == 1)
            return 50.0;
        else
            return 4.0;
    }
    else
        return 34;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    if (indexPath.row % 2 == 1)
    {
        static NSString *CellIdentifier = @"MessageCell";
        ActivityNotificationCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        cell.backgroundColor = CELL_COLOR;
        cell.activityMessage.font = [UIFont fontWithName:@"Trebuchet MS" size:13];
        NSString *message = [self.friendActivitiesList objectAtIndex:(indexPath.row/2)];
        
        NSRange start = [message rangeOfString:@" "];
        NSString *activityMessage = @"";
        NSString *name = @"";
        if (start.location != NSNotFound)
        {
            activityMessage = [message substringFromIndex:start.location+1];
            name = [message substringToIndex:start.location];
        }
        
        cell.activityMessage.text = activityMessage;
        cell.userName.text = name;
        cell.activityMessage.textColor = [UIColor purpleColor];
        NSString *imageName = [Utils getImageNameFromMessage:[self.friendActivitiesList objectAtIndex:(indexPath.row/2)]];
        UIImage *activityImg = [UIImage imageNamed:imageName];
        
        [cell.activityPic setImage:activityImg forState:UIControlStateNormal];
        [cell.activityPic setBackgroundImage:activityImg forState:UIControlStateNormal];
        
        UIColor *selectionColor = [[UIColor alloc] initWithRed:20.0 / 255 green:59.0 / 255 blue:102.0 / 255 alpha:0.5];
        UIView *bgColorView = [[UIView alloc] init];
        bgColorView.backgroundColor = selectionColor;
        [cell setSelectedBackgroundView:bgColorView];
        
        return cell;
    }
    else
    {
        static NSString *CellIdentifier2 = @"cell2";
        UITableViewCell *cell2 = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier2];
        if (cell2 == nil)
            cell2 = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                           reuseIdentifier:CellIdentifier2];
        cell2.backgroundColor = [UIColor clearColor];
        
        // Mark to differentiate the today cells
        if (self.todayIndex == 0)
        {
            NSString *nextMessage = [self.friendActivitiesList objectAtIndex:(indexPath.row/2)];
            NSRange today = [nextMessage rangeOfString:@" today"];
            if (today.location != NSNotFound)
            {
                cell2.backgroundColor = TODAY_COLOR;
                self.todayIndex = (indexPath.row/2);
            }
        }
        else if( (indexPath.row/2) == self.todayIndex)
            cell2.backgroundColor = TODAY_COLOR;
        
        // Mark to differentiate the yesterday cells
        if (self.yesterdayIndex == 0)
        {
            NSString *nextMessage = [self.friendActivitiesList objectAtIndex:(indexPath.row/2)];
            NSRange yesterday = [nextMessage rangeOfString:@" yesterday"];
            if (yesterday.location != NSNotFound)
            {
                cell2.backgroundColor = YESTERDAY_COLOR;
                self.yesterdayIndex = (indexPath.row/2);
            }
        }
        else if( (indexPath.row/2) == self.yesterdayIndex)
            cell2.backgroundColor = YESTERDAY_COLOR;
        
        return cell2;
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // TODO : Convert friend lookup to dictionary
    self.selectedFriend = nil;
    
    id feedItem = [self.user.friendsActivitiesList objectAtIndex:(indexPath.row/2)];
    
    if ([feedItem[@"userId"] isEqualToString:user.userEmail])
        [Utils alertStatus:@"Use the Stats page, to see details of all your hard work." :@"That's you." :0];
    else
    {
        for (int i=0; i<[self.user.friendsList count]; i++)
        {
            Friend *friend = self.user.friendsList[i];
            if ( [friend.email isEqualToString:feedItem[@"userId"]] )
                self.selectedFriend = friend;
        }
        
        if (self.selectedFriend == nil)
            [Utils alertStatus:@"Could not find friend" :@"Oops!Something went wrong" :0];
        else
            [self performSegueWithIdentifier:@"FriendDetails" sender:self];
    }
}


- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"FriendDetails"] )
    {
        NSDictionary *returnDict = [Utils getActivityDetailsForFriend:self.selectedFriend];
        NSArray *jsonArrayByTime = returnDict[@"jsonArrayByTime"];
        NSArray *jsonArrayByActivity = returnDict[@"jsonArrayByActivity"];
        NSString *activityDate = returnDict[@"activityDate"];
        NSString *title = returnDict[@"title"];
        NSString *numberOfRestDays = returnDict[@"numberOfRestDays"];
        
        if ([jsonArrayByActivity count] <= 0 )
        {
            [Utils alertStatus:[NSString stringWithFormat:@"No activity found for %@ for this month",self.selectedFriend.firstName] :@"Ask them to get to work!" :0];
            return;
        }
        
        ActivityViewController *controller = [segue destinationViewController];
        controller.userActivitiesByTimeJsonArray = jsonArrayByTime;
        controller.userActivitiesByActivityJsonArray = jsonArrayByActivity;
        controller.activityDateString = activityDate;
        controller.title = title;
        controller.numberOfRestDays = numberOfRestDays;
    }
}


@end
