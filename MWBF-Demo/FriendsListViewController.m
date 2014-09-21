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


@interface FriendsListViewController ()
@property (weak, nonatomic) IBOutlet UITableView *friendsListTable;
@property (strong,nonatomic) User *user;
@property (strong,nonatomic) UIActivityIndicatorView *activityIndicator;
@property (strong,nonatomic) NSArray *jsonArrayByActivity;
@property (strong,nonatomic) NSArray *jsonArrayByTime;
@property (strong,nonatomic) NSString *activityDate;
@property (strong,nonatomic) NSString *title;
@property (strong,nonatomic) NSString *numberOfRestDays;
@property (nonatomic) NSInteger numberOfFriends;
@property (strong,nonatomic) NSMutableArray *cellsArray;


@end

@implementation FriendsListViewController

@synthesize friendsListTable;
@synthesize user;
@synthesize activityIndicator;
@synthesize jsonArrayByActivity, jsonArrayByTime;
@synthesize activityDate, title;
@synthesize numberOfRestDays;
@synthesize numberOfFriends;
@synthesize cellsArray;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.cellsArray = [NSMutableArray array];
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
}

- (void) loadData
{
    self.user = [User getInstance];
    // Sort the activites by the total points
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"firstName" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    NSArray *sortedArray = [self.user.friendsList sortedArrayUsingDescriptors:sortDescriptors];
    self.user.friendsList = [NSMutableArray arrayWithArray:sortedArray];
    
    [self loadTableCells];
}

///////// UITABLEVIEW METHODS /////////

// Create an array with the cells preloaded
- (void) loadTableCells
{
    // Clean out the array
    [self.cellsArray removeAllObjects];
    
    for (int i = 0; i < [self.user.friendsList count]; i++)
    {
        static NSString *CellIdentifier = @"FriendDetailsCell";
        FriendCell *cell = [self.friendsListTable dequeueReusableCellWithIdentifier:CellIdentifier];
        Friend *friendObj = [self.user.friendsList objectAtIndex:i];
        cell.friendNameLabel.text = [NSString stringWithFormat:@"%@ %@",friendObj.firstName,friendObj.lastName];
        cell.friendFbProfilePicView.profileID = friendObj.fbProfileID;
        [Utils setRoundedView:cell.friendFbProfilePicView toDiameter:40];
        
        UIColor *selectionColor = [[UIColor alloc] initWithRed:20.0 / 255 green:59.0 / 255 blue:102.0 / 255 alpha:0.5];
        UIView *bgColorView = [[UIView alloc] init];
        bgColorView.backgroundColor = selectionColor;
        [cell setSelectedBackgroundView:bgColorView];
        
        [self.cellsArray addObject:cell];
    }
}

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
    return [self.cellsArray objectAtIndex:indexPath.row];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Friend *friend = [self.user.friendsList objectAtIndex:indexPath.row];
    self.title = [NSString stringWithFormat:@"%@'s Stats",friend.firstName];
  
    // Get the friends activity details
    self.activityIndicator.hidden = NO;
    [self.activityIndicator startAnimating];
    self.view.userInteractionEnabled = NO;
    
    
    dispatch_queue_t queue = dispatch_get_global_queue(0,0);
    
    dispatch_async(queue, ^{
        
        // Year
        NSDate *currentTime = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"YYYY"];
        NSString *year = [dateFormatter stringFromDate: currentTime] ;
        
        // Month
        [dateFormatter setDateFormat:@"MM"];
        NSInteger monthInteger = [[dateFormatter stringFromDate: currentTime] integerValue];
        NSString *month  = [Utils getMonthStringFromInt:monthInteger];
        
        NSInteger daysInMonth = [Utils getNumberOfDaysInMonth:monthInteger];
        
        NSString *fromDate = [NSString stringWithFormat:@"%@ 01, %@ 00:00:01 AM",month,year];
        NSString *toDate = [NSString stringWithFormat:@"%@ %ld, %@ 11:59:59 PM",month,(long)daysInMonth,year];
        
        self.activityDate = [NSString stringWithFormat:@"%@, %@",month,year];
        
        // Get the list of activities from the server
        MWBFService *service = [[MWBFService alloc] init];
        self.jsonArrayByActivity = [service getActivitiesForFriend:friend byActivityFromDate:fromDate toDate:toDate];
        self.jsonArrayByTime = [service getActivitiesForFriend:friend byTimeFromDate:fromDate toDate:toDate];
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self.activityIndicator stopAnimating];
            self.activityIndicator.hidden = YES;
            self.view.userInteractionEnabled = YES;
            
            self.numberOfRestDays = [Utils getNumberOfRestDaysFromDate:fromDate toDate:toDate withActiveDays:[self.jsonArrayByTime count]];
            
            if ([self.jsonArrayByActivity count] <= 0 )
                [Utils alertStatus:[NSString stringWithFormat:@"No activity found for %@ for this month",friend.firstName] :@"Ask them to get to work!" :0];
            else
                [self performSegueWithIdentifier:@"FriendDetails" sender:self];
        });
    });
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"FriendDetails"] )
    {
        ActivityViewController *controller = [segue destinationViewController];
        controller.userActivitiesByTimeJsonArray = self.jsonArrayByTime;
        controller.userActivitiesByActivityJsonArray = self.jsonArrayByActivity;
        controller.activityDateString = self.activityDate;
        controller.title = self.title;
        controller.numberOfRestDays = self.numberOfRestDays;
    }
}


@end
