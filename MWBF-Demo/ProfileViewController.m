//
//  ProfileViewController.m
//  MWBF
//
//  Created by ARJUN MUKHERJEE on 10/22/14.
//  Copyright (c) 2014 ___Arjun Mukherjee___. All rights reserved.
//

#import "ProfileViewController.h"
#import "ActivityViewController.h"
#import "MWBFService.h"
#import <FacebookSDK/FacebookSDK.h>
#import "Utils.h"

@interface ProfileViewController ()


@property (weak, nonatomic) IBOutlet FBProfilePictureView *fbProfilePic;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (strong,nonatomic) NSArray *jsonArrayByActivity;
@property (strong,nonatomic) NSArray *jsonArrayByTime;
@property (strong,nonatomic) NSString *activityDate;
@property (strong,nonatomic) NSString *title;
@property (strong,nonatomic) NSString *numberOfRestDays;

@property (weak, nonatomic) IBOutlet UILabel *challengesWonLabel;
@property (weak, nonatomic) IBOutlet UILabel *challengesActiveLabel;
@property (weak, nonatomic) IBOutlet UILabel *challengesTotalLabel;

@property (weak, nonatomic) IBOutlet UILabel *currentWeekLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentMonthLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentYearLabel;

@property (weak, nonatomic) IBOutlet UILabel *currentWeekHeaderLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentMonthHeaderLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentYearHeaderLabel;

@property (weak, nonatomic) IBOutlet UILabel *bestDayLabel;
@property (weak, nonatomic) IBOutlet UILabel *bestWeekLabel;
@property (weak, nonatomic) IBOutlet UILabel *bestMonthLabel;
@property (weak, nonatomic) IBOutlet UILabel *bestYearLabel;
@property (weak, nonatomic) IBOutlet UILabel *bestDayPoints;
@property (weak, nonatomic) IBOutlet UILabel *bestWeekPoints;
@property (weak, nonatomic) IBOutlet UILabel *bestMonthPoints;
@property (weak, nonatomic) IBOutlet UILabel *bestYearPoints;

@property (weak, nonatomic) IBOutlet UIButton *weekActivityButton;
@property (weak, nonatomic) IBOutlet UIButton *monthActivityButton;
@property (weak, nonatomic) IBOutlet UIButton *yearActivityButton;

@end

@implementation ProfileViewController

@synthesize friend;
@synthesize nameLabel;
@synthesize jsonArrayByActivity,jsonArrayByTime,activityDate,title,numberOfRestDays;
@synthesize currentWeekLabel,bestDayLabel,bestWeekLabel,bestMonthLabel,bestYearLabel;
@synthesize bestDayPoints,bestWeekPoints,bestMonthPoints,bestYearPoints;
@synthesize currentMonthLabel,currentYearLabel;
@synthesize challengesActiveLabel,challengesTotalLabel,challengesWonLabel;
@synthesize pageTitle;

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
    self.currentMonthLabel.text = [NSString stringWithFormat:@"%@ pts",self.friend.stats.currentMonthPoints];
    self.currentYearLabel.text = [NSString stringWithFormat:@"%@ pts",self.friend.stats.currentYearPoints];
    
    self.challengesActiveLabel.text = [NSString stringWithFormat:@"%@",self.friend.stats.numberOfActiveChallenges];
    self.challengesTotalLabel.text = [NSString stringWithFormat:@"%@",self.friend.stats.numberOfTotalChallenges];
    self.challengesWonLabel.text = [NSString stringWithFormat:@"%@",self.friend.stats.numberOfWonChallenges];
    
    [self.view bringSubviewToFront:self.currentYearLabel];
    [self.view bringSubviewToFront:self.currentMonthLabel];
    [self.view bringSubviewToFront:self.currentWeekLabel];
    [self.view bringSubviewToFront:self.currentYearHeaderLabel];
    [self.view bringSubviewToFront:self.currentMonthHeaderLabel];
    [self.view bringSubviewToFront:self.currentWeekHeaderLabel];
    
    self.navigationItem.title = self.pageTitle;
}

- (void) viewWillAppear:(BOOL)animated
{
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (IBAction)activityButtonClicked:(UIButton *) button
{
    NSString *fromDate = [[NSString alloc] init];
    NSString *toDate = [[NSString alloc] init];
    NSString *timeInterval = [[NSString alloc] init];
    NSString *titleForPage = [[NSString alloc] init];
    
    
    if ( button == self.weekActivityButton )
        timeInterval = @"week";
    else if ( button == self.monthActivityButton )
        timeInterval = @"month";
    else
        timeInterval = @"year";
    
    [Utils getFromDate:&fromDate toDate:&toDate withTitle:&titleForPage For:timeInterval];
    self.activityDate = titleForPage;
    self.title = [NSString stringWithFormat:@"%@'s Stats",self.friend.firstName];
    
    // Get the friends activity details
    self.activityIndicator.hidden = NO;
    [self.activityIndicator startAnimating];
    self.view.userInteractionEnabled = NO;
    
    
    dispatch_queue_t queue = dispatch_get_global_queue(0,0);
    
    dispatch_async(queue, ^{
        
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
                NSString *message = [NSString stringWithFormat:@"No activity found for %@ for this %@",self.friend.firstName,timeInterval];
                [Utils alertStatus:message :@"Ask them to get to work!" :0];
                return;
            }
            else
            {
                self.numberOfRestDays = [Utils getNumberOfRestDaysFromDate:fromDate toDate:toDate withActiveDays:[jsonArrayByTime count]];
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
