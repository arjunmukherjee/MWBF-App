//
//  FriendProfileViewController.m
//  MWBF
//
//  Created by ARJUN MUKHERJEE on 10/22/14.
//  Copyright (c) 2014 ___Arjun Mukherjee___. All rights reserved.
//

#import "FriendProfileViewController.h"
#import "ActivityViewController.h"
#import "MWBFService.h"
#import <FacebookSDK/FacebookSDK.h>

@interface FriendProfileViewController ()
@property (weak, nonatomic) IBOutlet FBProfilePictureView *fbProfilePic;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *activitiesButton;

@property (strong,nonatomic) NSArray *jsonArrayByActivity;
@property (strong,nonatomic) NSArray *jsonArrayByTime;
@property (strong,nonatomic) NSString *activityDate;
@property (strong,nonatomic) NSString *title;
@property (strong,nonatomic) NSString *numberOfRestDays;

@property (weak, nonatomic) IBOutlet UILabel *challengesWonLabel;
@property (weak, nonatomic) IBOutlet UILabel *activeChallengesLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentWeekLabel;

@property (weak, nonatomic) IBOutlet UILabel *bestDayLabel;
@property (weak, nonatomic) IBOutlet UILabel *bestWeekLabel;
@property (weak, nonatomic) IBOutlet UILabel *bestMonthLabel;
@property (weak, nonatomic) IBOutlet UILabel *bestYearLabel;
@property (weak, nonatomic) IBOutlet UILabel *bestDayPoints;
@property (weak, nonatomic) IBOutlet UILabel *bestWeekPoints;
@property (weak, nonatomic) IBOutlet UILabel *bestMonthPoints;
@property (weak, nonatomic) IBOutlet UILabel *bestYearPoints;


@end

@implementation FriendProfileViewController

@synthesize friend;
@synthesize nameLabel,activitiesButton;
@synthesize jsonArrayByActivity,jsonArrayByTime,activityDate,title,numberOfRestDays;
@synthesize challengesWonLabel,activeChallengesLabel,currentWeekLabel,bestDayLabel,bestWeekLabel,bestMonthLabel,bestYearLabel;
@synthesize bestDayPoints,bestWeekPoints,bestMonthPoints,bestYearPoints;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.fbProfilePic.profileID = self.friend.fbProfileID;
    self.nameLabel.text = [NSString stringWithFormat:@"%@ %@",self.friend.firstName,self.friend.lastName];
    [Utils setRoundedView:self.fbProfilePic toDiameter:80];
    
    self.bestDayLabel.text = self.friend.stats.bestDay;
    self.bestDayPoints.text = [NSString stringWithFormat:@"%@ pts",self.friend.stats.bestDayPoints];
   
    self.bestWeekLabel.text = self.friend.stats.bestWeek;
    self.bestWeekPoints.text = [NSString stringWithFormat:@"%@ pts",self.friend.stats.bestWeekPoints];
    
    self.bestMonthLabel.text = self.friend.stats.bestMonth;
    self.bestMonthPoints.text = [NSString stringWithFormat:@"%@ pts",self.friend.stats.bestMonthPoints];
    
    self.bestYearLabel.text = self.friend.stats.bestYear;
    self.bestYearPoints.text = [NSString stringWithFormat:@"%@ pts",self.friend.stats.bestYearPoints];
    
    self.currentWeekLabel.text = [NSString stringWithFormat:@"%@ pts",self.friend.stats.currentWeekPoints];
    
    self.activeChallengesLabel.text = [NSString stringWithFormat:@"%@",self.friend.stats.numberOfActiveChallenges];
    self.challengesWonLabel.text = @"0";
     
}

- (void) viewWillAppear:(BOOL)animated
{
    self.navigationItem.rightBarButtonItem = self.activitiesButton;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)activitiesButtonClicked:(id)sender
{
    self.title = [NSString stringWithFormat:@"%@'s Stats",self.friend.firstName];
    
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
        self.jsonArrayByActivity = [service getActivitiesForFriend:self.friend byActivityFromDate:fromDate toDate:toDate];
        self.jsonArrayByTime = [service getActivitiesForFriend:self.friend byTimeFromDate:fromDate toDate:toDate];
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self.activityIndicator stopAnimating];
            self.activityIndicator.hidden = YES;
            self.view.userInteractionEnabled = YES;
            
            if ([self.jsonArrayByActivity count] <= 0 )
            {
                [Utils alertStatus:[NSString stringWithFormat:@"No activity found for %@ for this month",self.friend.firstName] :@"Ask them to get to work!" :0];
                return;
            }
            else
            {
                NSString *numberOfRestDays = [Utils getNumberOfRestDaysFromDate:fromDate toDate:toDate withActiveDays:[jsonArrayByTime count]];
                [self performSegueWithIdentifier:@"FriendDetails" sender:self];
            }
        });
    });
 
    
}

#pragma mark - Navigation

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
