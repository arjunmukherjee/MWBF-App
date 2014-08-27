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
#import "MWBFService.h"

@interface FriendsListViewController ()
@property (weak, nonatomic) IBOutlet UITableView *friendsListTable;
@property (strong,nonatomic) User *user;
@property (strong,nonatomic) UIActivityIndicatorView *activityIndicator;
@property (strong,nonatomic) NSArray *jsonArrayByActivity;
@property (strong,nonatomic) NSArray *jsonArrayByTime;
@property (strong,nonatomic) NSString *activityDate;
@property (strong,nonatomic) NSString *title;


@end

@implementation FriendsListViewController

@synthesize friendsListTable;
@synthesize user;
@synthesize activityIndicator;
@synthesize jsonArrayByActivity, jsonArrayByTime;
@synthesize activityDate, title;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.user = [User getInstance];
    
    self.activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.activityIndicator.center = self.view.center;
    self.activityIndicator.color = [UIColor blueColor];
    [self.view addSubview: self.activityIndicator];
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
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@",friendObj.firstName,friendObj.lastName];
    
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
        
        NSString *fromDate = [NSString stringWithFormat:@"%@ 01, %@ 00:00:01 AM",month,year];
        NSString *toDate = [NSString stringWithFormat:@"%@ 31, %@ 11:59:59 PM",month,year];
        
        self.activityDate = [NSString stringWithFormat:@"%@, %@",month,year];
        
        // Get the list of activities from the server
        MWBFService *service = [[MWBFService alloc] init];
        self.jsonArrayByActivity = [service getActivitiesForFriend:friend byActivityFromDate:fromDate toDate:toDate];
        self.jsonArrayByTime = [service getActivitiesForFriend:friend byTimeFromDate:fromDate toDate:toDate];
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self.activityIndicator stopAnimating];
            self.activityIndicator.hidden = YES;
            self.view.userInteractionEnabled = YES;
            
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
    }
}


@end
