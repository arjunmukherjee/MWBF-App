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
#import "ProfileViewController.h"


@interface MessagesViewController ()

@property (weak, nonatomic) IBOutlet UITableView *activitiesBoardTable;
@property (strong,nonatomic) NSMutableArray *friendActivitiesList;
@property (strong,nonatomic) NSMutableArray *unreadActivitiesList;
@property (strong,nonatomic) User *user;
@property (nonatomic) NSInteger todayIndex;
@property (nonatomic) NSInteger yesterdayIndex;
@property (strong,nonatomic) Friend *selectedFriend;
@property (weak, nonatomic) IBOutlet UIProgressView *yourProgressBar;
@property (weak, nonatomic) IBOutlet UIProgressView *friendAverageProgressBar;
@property (weak, nonatomic) IBOutlet UIProgressView *leaderProgressBar;
@property (weak, nonatomic) IBOutlet UILabel *yourProgressLabel;
@property (weak, nonatomic) IBOutlet UILabel *friendsProgressLabel;
@property (weak, nonatomic) IBOutlet UILabel *leaderProgressLabel;
@property (weak, nonatomic) IBOutlet UILabel *randomQuoteLabel;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *userProfileButton;
@property (weak,nonatomic) NSString *pageTitle;

@end

@implementation MessagesViewController

@synthesize activitiesBoardTable;
@synthesize unreadActivitiesList;
@synthesize user;
@synthesize friendActivitiesList;
@synthesize todayIndex;
@synthesize yesterdayIndex;
@synthesize selectedFriend;
@synthesize yourProgressBar,friendAverageProgressBar,leaderProgressBar;
@synthesize yourProgressLabel,friendsProgressLabel,leaderProgressLabel;
@synthesize randomQuoteLabel;
@synthesize pageTitle;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.user = [User getInstance];
    
    self.friendActivitiesList = [NSMutableArray array];
    self.unreadActivitiesList = [NSMutableArray array];
    
    self.activitiesBoardTable.hidden = NO;
    self.todayIndex = 0;
    self.yesterdayIndex = 0;
    
    [self.yourProgressBar setTransform:CGAffineTransformMakeScale(1.0, 2.0)];
    [self.friendAverageProgressBar setTransform:CGAffineTransformMakeScale(1.0, 2.0)];
    [self.leaderProgressBar setTransform:CGAffineTransformMakeScale(1.0, 2.0)];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(redrawUserWall:)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
}


- (void) redrawUserWall:(NSNotification *)notification
{
    self.todayIndex = 0;
    self.yesterdayIndex = 0;
    
    NSArray *currentFeedList = [NSArray arrayWithArray:self.friendActivitiesList];
    NSMutableArray *refreshedFeedList = [NSMutableArray array];
    
    [self.friendActivitiesList removeAllObjects];
    [self.unreadActivitiesList removeAllObjects];
    
    // Get all the new user and friend activities
    self.user = [User getInstance];
    for (int i=0; i <[self.user.friendsActivitiesList count]; i++)
    {
        NSString *feedItem = self.user.friendsActivitiesList[i][@"feedPrettyString"];
        [refreshedFeedList addObject:feedItem];
    }
    [Utils changeAbsoluteDateToRelativeDays:refreshedFeedList];
    
    for (int i=0; i <[refreshedFeedList count]; i++)
    {
        NSString *feedItem = refreshedFeedList[i];
        [self.friendActivitiesList addObject:feedItem];
        
        // Check if the activity is a new activity (only if it is not the first time)
        if ( [currentFeedList count] > 0 )
        {
            if ( ![currentFeedList containsObject:feedItem] )
                [self.unreadActivitiesList addObject:feedItem];
        }
    }
    
    [Utils changeAbsoluteDateToRelativeDays:self.friendActivitiesList];
    
    NSInteger scrollIndex = ([self.friendActivitiesList count]*2)-1;
    
    [self.activitiesBoardTable reloadData];
    
    if (scrollIndex > 0)
        [self.activitiesBoardTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:scrollIndex inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    
    float leader = 0.0;
    if ([user.weeklyPointsUser floatValue] > [user.weeklyPointsLeader floatValue])
        leader = [user.weeklyPointsUser floatValue];
    else
        leader = [user.weeklyPointsLeader floatValue];
    
    NSString *leaderStr;
    int leaderInt = leader;
    if (leader > leaderInt)
        leaderStr = [NSString stringWithFormat:@"%0.1f",leader];
    else
        leaderStr = [NSString stringWithFormat:@"%d",leaderInt];
    
    self.yourProgressBar.progress = [user.weeklyPointsUser floatValue]/leader;
    self.friendAverageProgressBar.progress = [user.weeklyPointsFriendsAverage floatValue]/leader;
    self.leaderProgressBar.progress = 1;
    
    self.yourProgressLabel.text = [NSString stringWithFormat:@"You (%@)",user.weeklyPointsUser];
    self.friendsProgressLabel.text = [NSString stringWithFormat:@"Friends (%@)",user.weeklyPointsFriendsAverage];
    self.leaderProgressLabel.text = [NSString stringWithFormat:@"Leader (%@)",leaderStr];
    
    // Scan the feeds and get the location of the today and the yesterday items
    for (int i=0; i < [self.friendActivitiesList count]; i++)
    {
        NSString *message = [self.friendActivitiesList objectAtIndex:i];
        NSRange today = [message rangeOfString:@" today"];
        if (today.location != NSNotFound && self.todayIndex == 0)
            self.todayIndex = i;
        
        NSRange yesterday = [message rangeOfString:@" yesterday"];
        if (yesterday.location != NSNotFound && self.yesterdayIndex == 0)
            self.yesterdayIndex = i;
    }
    
    // Set the random quote
    self.randomQuoteLabel.text = self.user.randomQuote;
}

- (void) viewWillAppear:(BOOL)animated
{
    [self redrawUserWall:nil];
}

- (IBAction) userProfileButtonClicked:(id)sender
{
    self.selectedFriend = [Utils convertUserToFriendObj];
    self.pageTitle = @"You";
    
    [self performSegueWithIdentifier:@"Profile" sender:self];
}

- (void) viewDidDisappear:(BOOL)animated
{
    //[self.user.notificationsList removeAllObjects];
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
    
    // Even rows have the data, Odd rows are thinner and blank
    if (indexPath.row % 2 == 1)
    {
        static NSString *CellIdentifier = @"MessageCell";
        ActivityNotificationCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        cell.backgroundColor = CELL_COLOR;
        cell.activityMessage.font = [UIFont fontWithName:@"Trebuchet MS" size:13];
        NSString *message = [self.friendActivitiesList objectAtIndex:(indexPath.row/2)];
        
        // Check if it is a new activity
        if ( [self.unreadActivitiesList containsObject:message] )
            cell.unreadActivityImage.hidden = NO;
        else
            cell.unreadActivityImage.hidden = YES;
        
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
        
        UIColor *selectionColor = CELL_SELECTION_COLOR;
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
        if ((indexPath.row/2) == self.todayIndex)
            cell2.backgroundColor = TODAY_COLOR;
        else if ((indexPath.row/2) == self.yesterdayIndex)
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
        [self userProfileButtonClicked:nil];
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
        {
            self.pageTitle = self.selectedFriend.firstName;
            [self performSegueWithIdentifier:@"Profile" sender:self];
        }
    }
}


- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Profile"] )
    {
        ProfileViewController *controller = [segue destinationViewController];
        controller.friend = self.selectedFriend;
        controller.pageTitle = self.pageTitle;
    }
}


@end
