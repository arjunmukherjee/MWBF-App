//
//  PersonalHealthStatsViewController.m
//  MWBF-Demo
//
//  Created by ARJUN MUKHERJEE on 8/20/14.
//  Copyright (c) 2014 ___Arjun Mukherjee___. All rights reserved.
//

#import "PersonalHealthStatsViewController.h"
#import "User.h"
#import "ActivityViewController.h"
#import "MWBFService.h"
#import <FacebookSDK/FacebookSDK.h>

#define TIME_INDEX 0
#define ACTIVITY_INDEX 1

@interface PersonalHealthStatsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *bestDayLabel;
@property (weak, nonatomic) IBOutlet UILabel *bestMonthLabel;
@property (weak, nonatomic) IBOutlet UILabel *bestYearLabel;
@property (weak, nonatomic) IBOutlet UILabel *bestDayPointsLabel;
@property (weak, nonatomic) IBOutlet UILabel *bestMonthPointsLabel;
@property (weak, nonatomic) IBOutlet UILabel *bestYearPointsLabel;
@property (weak, nonatomic) IBOutlet UILabel *bestDayHeader;
@property (weak, nonatomic) IBOutlet UILabel *bestMonthHeader;
@property (weak, nonatomic) IBOutlet UILabel *bestYearHeader;
@property (weak, nonatomic) IBOutlet UILabel *bestWeekHeader;
@property (weak, nonatomic) IBOutlet UILabel *bestWeekLabel;
@property (weak, nonatomic) IBOutlet UILabel *bestWeekPointsLabel;
@property (weak, nonatomic) IBOutlet UIButton *bestDayButton;
@property (weak, nonatomic) IBOutlet UIButton *bestWeekButton;
@property (weak, nonatomic) IBOutlet UIButton *bestMonthButton;
@property (weak, nonatomic) IBOutlet UIButton *bestYearButton;
@property (weak, nonatomic) IBOutlet UILabel *bestWeekEndLabel;
@property (weak, nonatomic) IBOutlet UIView *statsByTimeView;
@property (weak, nonatomic) IBOutlet UIView *statsByActivityView;
@property (weak, nonatomic) IBOutlet UIView *statsByLeaderView;

@property (weak, nonatomic) IBOutlet UISegmentedControl *statsSelector;

// LEADER
@property (weak, nonatomic) IBOutlet UILabel *leaderBestDayHeader;
@property (weak, nonatomic) IBOutlet UILabel *leaderBestWeekHeader;
@property (weak, nonatomic) IBOutlet UILabel *leaderBestMonthHeader;
@property (weak, nonatomic) IBOutlet UILabel *leaderBestYearHeader;

@property (weak, nonatomic) IBOutlet UILabel *leaderBestDayLabel;
@property (weak, nonatomic) IBOutlet UILabel *leaderBestDayPointsLabel;
@property (weak, nonatomic) IBOutlet UILabel *leaderBestWeekStartLabel;
@property (weak, nonatomic) IBOutlet UILabel *leaderBestWeekEndLabel;
@property (weak, nonatomic) IBOutlet UILabel *leaderBestWeekPointsLabel;
@property (weak, nonatomic) IBOutlet UILabel *leaderBestMonthLabel;
@property (weak, nonatomic) IBOutlet UILabel *leaderBestMonthPointsLabel;
@property (weak, nonatomic) IBOutlet UILabel *leaderBestYearLabel;
@property (weak, nonatomic) IBOutlet UILabel *leaderBestYearPointsLabel;
@property (weak, nonatomic) IBOutlet UIButton *leaderBestDayButton;
@property (weak, nonatomic) IBOutlet UIButton *leaderBestWeekButton;
@property (weak, nonatomic) IBOutlet UIButton *leaderBestMonthButton;
@property (weak, nonatomic) IBOutlet UIButton *leaderBestYearButton;
@property (weak, nonatomic) IBOutlet UILabel *leaderBestDayFriendNameLabel;
@property (weak, nonatomic) IBOutlet FBProfilePictureView *leaderBestDayFriendPic;
@property (weak, nonatomic) IBOutlet UILabel *leaderBestWeekFriendNameLabel;
@property (weak, nonatomic) IBOutlet FBProfilePictureView *leaderBestWeekFriendPic;
@property (weak, nonatomic) IBOutlet UILabel *leaderBestMonthFriendNameLabel;
@property (weak, nonatomic) IBOutlet FBProfilePictureView *leaderBestMonthFriendPic;
@property (weak, nonatomic) IBOutlet UILabel *leaderBestYearFriendNameLabel;
@property (weak, nonatomic) IBOutlet FBProfilePictureView *leaderBestYearFriendPic;



@property NSArray *userActivitiesArrayByActivity;
@property NSArray *userActivitiesArrayByTime;
@property NSString *activityDate;
@property NSString *numberOfRestDays;
@property NSString *title;

@property NSString *bestDay,*bestDayMonth,*bestDayYear;
@property NSString *bestMonth,*bestMonthYear;

@property NSString *bestWeekFromDay, *bestWeekFromMonth, *bestWeekFromYear;
@property NSString *bestWeekToDay, *bestWeekToMonth, *bestWeekToYear;

// LEADER
@property NSString *leaderBestDay,*leaderBestDayMonth,*leaderBestDayYear;
@property NSString *leaderBestMonth,*leaderBestMonthYear;

@property NSString *leaderBestWeekFromDay, *leaderBestWeekFromMonth, *leaderBestWeekFromYear;
@property NSString *leaderBestWeekToDay, *leaderBestWeekToMonth, *leaderBestWeekToYear;

@end

@implementation PersonalHealthStatsViewController

@synthesize bestDayLabel,bestMonthLabel,bestYearLabel;
@synthesize bestDayPointsLabel,bestMonthPointsLabel,bestYearPointsLabel,bestWeekLabel,bestWeekPointsLabel;
@synthesize bestDayHeader,bestWeekHeader,bestMonthHeader,bestYearHeader;
@synthesize bestDayButton,bestMonthButton,bestWeekButton,bestYearButton;
@synthesize title;

@synthesize userActivitiesArrayByActivity,userActivitiesArrayByTime,activityDate,numberOfRestDays;
@synthesize bestDay,bestDayMonth,bestDayYear;
@synthesize bestMonth,bestMonthYear;
@synthesize bestWeekEndLabel;
@synthesize bestWeekFromDay,bestWeekFromMonth,bestWeekFromYear,bestWeekToDay,bestWeekToMonth,bestWeekToYear;

@synthesize statsByTimeView,statsSelector;
@synthesize statsByActivityView,statsByLeaderView;

// LEADER
@synthesize leaderBestDayHeader,leaderBestDayLabel,leaderBestDayPointsLabel;
@synthesize leaderBestMonthHeader,leaderBestMonthLabel,leaderBestMonthPointsLabel;
@synthesize leaderBestWeekEndLabel,leaderBestWeekHeader,leaderBestWeekStartLabel,leaderBestWeekPointsLabel;
@synthesize leaderBestYearHeader,leaderBestYearLabel,leaderBestYearPointsLabel;
@synthesize leaderBestDayButton,leaderBestMonthButton,leaderBestWeekButton,leaderBestYearButton;
@synthesize leaderBestDay,leaderBestDayMonth,leaderBestDayYear;
@synthesize leaderBestMonth,leaderBestMonthYear;
@synthesize leaderBestWeekFromDay,leaderBestWeekFromMonth,leaderBestWeekFromYear;
@synthesize leaderBestWeekToDay,leaderBestWeekToMonth,leaderBestWeekToYear;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self loadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self loadData];
    
    self.statsByTimeView.hidden = NO;
    self.statsByActivityView.hidden = YES;
    self.statsByLeaderView.hidden = YES;
    
    self.statsSelector.selectedSegmentIndex = TIME_INDEX;
}

- (void) loadData
{
    User *user = [User getInstance];
    
    
    // SELF
    self.bestDayLabel.text = [NSString stringWithFormat:@"%@",user.bestDay];
    self.bestWeekLabel.text = [NSString stringWithFormat:@"%@",user.bestWeek];
    self.bestMonthLabel.text = [NSString stringWithFormat:@"%@",user.bestMonth];
    self.bestYearLabel.text = [NSString stringWithFormat:@"%@",user.bestYear];
    
    self.bestDayPointsLabel.text = [NSString stringWithFormat:@"%@ pts",user.bestDayPoints];
    self.bestWeekPointsLabel.text = [NSString stringWithFormat:@"%@ pts",user.bestWeekPoints];
    self.bestMonthPointsLabel.text = [NSString stringWithFormat:@"%@ pts",user.bestMonthPoints];
    self.bestYearPointsLabel.text = [NSString stringWithFormat:@"%@ pts",user.bestYearPoints];
    
    
    // LEADER
    self.leaderBestDayLabel.text = [NSString stringWithFormat:@"%@",user.bestDayLeader];
    self.leaderBestWeekStartLabel.text = [NSString stringWithFormat:@"%@",user.bestWeekLeader];
    self.leaderBestMonthLabel.text = [NSString stringWithFormat:@"%@",user.bestMonthLeader];
    self.leaderBestYearLabel.text = [NSString stringWithFormat:@"%@",user.bestYearLeader];
    
    if (user.dayLeader != nil)
    {
        self.leaderBestDayFriendNameLabel.text = [NSString stringWithFormat:@"%@",user.dayLeader.firstName];
        self.leaderBestWeekFriendNameLabel.text = [NSString stringWithFormat:@"%@",user.weekLeader.firstName];
        self.leaderBestMonthFriendNameLabel.text = [NSString stringWithFormat:@"%@",user.monthLeader.firstName];
        self.leaderBestYearFriendNameLabel.text = [NSString stringWithFormat:@"%@",user.yearLeader.firstName];
        
        self.leaderBestDayPointsLabel.text = [NSString stringWithFormat:@"%@ pts",user.bestDayLeaderPoints];
        self.leaderBestWeekPointsLabel.text = [NSString stringWithFormat:@"%@ pts",user.bestWeekLeaderPoints];
        self.leaderBestMonthPointsLabel.text = [NSString stringWithFormat:@"%@ pts",user.bestMonthLeaderPoints];
        self.leaderBestYearPointsLabel.text = [NSString stringWithFormat:@"%@ pts",user.bestYearLeaderPoints];
    }
    else
    {
        self.leaderBestDayFriendNameLabel.text = @" ";
        self.leaderBestWeekFriendNameLabel.text = @" ";
        self.leaderBestMonthFriendNameLabel.text = @" ";
        self.leaderBestYearFriendNameLabel.text = @" ";
        
        self.leaderBestDayPointsLabel.text = @" ";
        self.leaderBestWeekPointsLabel.text = @" ";
        self.leaderBestMonthPointsLabel.text = @" ";
        self.leaderBestYearPointsLabel.text = @" ";
        
        self.leaderBestDayButton.enabled = NO;
        self.leaderBestWeekButton.enabled = NO;
        self.leaderBestMonthButton.enabled = NO;
        self.leaderBestYearButton.enabled = NO;
    }
    
    self.leaderBestDayFriendPic.profileID = user.dayLeader.fbProfileID;
    self.leaderBestWeekFriendPic.profileID = user.weekLeader.fbProfileID;
    self.leaderBestMonthFriendPic.profileID = user.monthLeader.fbProfileID;
    self.leaderBestYearFriendPic.profileID = user.yearLeader.fbProfileID;
    
    [Utils setRoundedView:self.leaderBestDayFriendPic toDiameter:22];
    [Utils setRoundedView:self.leaderBestWeekFriendPic toDiameter:22];
    [Utils setRoundedView:self.leaderBestMonthFriendPic toDiameter:22];
    [Utils setRoundedView:self.leaderBestYearFriendPic toDiameter:22];
    
    [Utils setMaskTo:bestDayHeader byRoundingCorners:UIRectCornerAllCorners];
    [Utils setMaskTo:bestWeekHeader byRoundingCorners:UIRectCornerAllCorners];
    [Utils setMaskTo:bestMonthHeader byRoundingCorners:UIRectCornerAllCorners];
    [Utils setMaskTo:bestYearHeader byRoundingCorners:UIRectCornerAllCorners];
    
    [Utils setMaskTo:leaderBestDayHeader byRoundingCorners:UIRectCornerAllCorners];
    [Utils setMaskTo:leaderBestWeekHeader byRoundingCorners:UIRectCornerAllCorners];
    [Utils setMaskTo:leaderBestMonthHeader byRoundingCorners:UIRectCornerAllCorners];
    [Utils setMaskTo:leaderBestYearHeader byRoundingCorners:UIRectCornerAllCorners];
    
    
    // SELF
    // BEST DAY
    if ([self.bestDayLabel.text length] > 2)
    {
        NSArray *tempArray = [self.bestDayLabel.text componentsSeparatedByString:@","];
        NSArray *tempArray1 = [tempArray[0] componentsSeparatedByString:@" "];
        self.bestDay = tempArray1[1];
        self.bestDayMonth = tempArray1[0];
        self.bestDayYear = tempArray[1];
        
        // BEST WEEK
        tempArray = [user.bestWeek componentsSeparatedByString:@"-"];
        if ( (tempArray != nil) && ( [tempArray count] > 0) )
        {
            self.bestWeekLabel.text = tempArray[0];
            self.bestWeekEndLabel.text = tempArray[1];
            
            tempArray1 = [tempArray[0] componentsSeparatedByString:@","];
            NSArray *tempArray2 = [tempArray1[0] componentsSeparatedByString:@" "];
            
            self.bestWeekFromMonth = tempArray2[0];
            self.bestWeekFromDay = tempArray2[1];
            self.bestWeekFromYear = tempArray1[1];
            
            tempArray1 = [tempArray[1] componentsSeparatedByString:@","];
            tempArray2 = [tempArray1[0] componentsSeparatedByString:@" "];
            self.bestWeekToMonth = tempArray2[0];
            self.bestWeekToDay = tempArray2[1];
            self.bestWeekToYear = tempArray1[1];
        }
        
        // BEST MONTH
        tempArray = [self.bestMonthLabel.text componentsSeparatedByString:@","];
        self.bestMonth = tempArray[0];
        self.bestMonthYear = tempArray[1];
        
        
        // LEADER
        // BEST DAY
        tempArray = [self.leaderBestDayLabel.text componentsSeparatedByString:@","];
        tempArray1 = [tempArray[0] componentsSeparatedByString:@" "];
        self.leaderBestDay = tempArray1[1];
        self.leaderBestDayMonth = tempArray1[0];
        self.leaderBestDayYear = tempArray[1];
        
        // BEST WEEK
        tempArray = [user.bestWeekLeader componentsSeparatedByString:@"-"];
        if ( (tempArray != nil) && ( [tempArray count] > 0) )
        {
            self.leaderBestWeekStartLabel.text = tempArray[0];
            self.leaderBestWeekEndLabel.text = tempArray[1];
            
            tempArray1 = [tempArray[0] componentsSeparatedByString:@","];
            NSArray *tempArray2 = [tempArray1[0] componentsSeparatedByString:@" "];
            
            self.leaderBestWeekFromMonth = tempArray2[0];
            self.leaderBestWeekFromDay = tempArray2[1];
            self.leaderBestWeekFromYear = tempArray1[1];
            
            tempArray1 = [tempArray[1] componentsSeparatedByString:@","];
            tempArray2 = [tempArray1[0] componentsSeparatedByString:@" "];
            self.leaderBestWeekToMonth = tempArray2[0];
            self.leaderBestWeekToDay = tempArray2[1];
            self.leaderBestWeekToYear = tempArray1[1];
        }
        
        // BEST MONTH
        tempArray = [self.leaderBestMonthLabel.text componentsSeparatedByString:@","];
        self.leaderBestMonth = tempArray[0];
        self.leaderBestMonthYear = tempArray[1];
    }
    else
    {
        self.bestDayButton.enabled = NO;
        self.bestWeekButton.enabled = NO;
        self.bestMonthButton.enabled = NO;
        self.bestYearButton.enabled = NO;
    }
}
- (IBAction)personalStatsButtonClicked:(id) sender
{
    NSString *fromMonth, *fromDay, *fromYear;
    NSString *toMonth, *toDay, *toYear;
    Friend *leader = nil;
    User *user = [User getInstance];
    
    if (sender == self.bestDayButton)
    {
        self.title = @"Your best day";
        self.activityDate = self.bestDayLabel.text;
        fromDay = self.bestDay;
        toDay = self.bestDay;
        fromMonth = self.bestDayMonth;
        toMonth = self.bestDayMonth;
        fromYear = self.bestDayYear;
        toYear = fromYear;
    }
    else if (sender == self.bestWeekButton)
    {
        self.title = @"Your best week";
        self.activityDate = [NSString stringWithFormat:@"Week of %@",self.bestWeekLabel.text];
        
        fromDay = self.bestWeekFromDay;
        toDay = self.bestWeekToDay;
        fromMonth = self.bestWeekFromMonth;
        toMonth = self.bestWeekToMonth;
        fromYear = self.bestWeekFromYear;
        toYear = self.bestWeekToYear;
    }
    else if (sender == self.bestMonthButton)
    {
        self.title = @"Your best month";
        self.activityDate = self.bestMonthLabel.text;
        
        fromDay = @"1";
        toDay = @"31";
        fromMonth = self.bestMonth;
        toMonth = self.bestMonth;
        fromYear = self.bestMonthYear;
        toYear = fromYear;
    }
    else if (sender == self.bestYearButton)
    {
        self.title = @"Your best year";
        self.activityDate = self.bestYearLabel.text;
        
        fromDay = @"1";
        toDay = @"31";
        fromMonth = @"Jan";
        toMonth = @"Dec";
        fromYear = self.bestYearLabel.text;
        toYear = fromYear;
    }
    else if (sender == self.leaderBestDayButton)
    {
        leader = user.dayLeader;
        self.title = [NSString stringWithFormat:@"%@'s best day",leader.firstName];
        self.activityDate = self.leaderBestDayLabel.text;
        
        fromDay = self.leaderBestDay;
        toDay = self.leaderBestDay;
        fromMonth = self.leaderBestDayMonth;
        toMonth = self.leaderBestDayMonth;
        fromYear = self.leaderBestDayYear;
        toYear = fromYear;
    }
    else if (sender == self.leaderBestWeekButton)
    {
        leader = user.weekLeader;
        self.activityDate = [NSString stringWithFormat:@"Week of %@",self.bestWeekLabel.text];
        self.title = [NSString stringWithFormat:@"%@'s best week",leader.firstName];
        
        fromDay = self.leaderBestWeekFromDay;
        toDay = self.leaderBestWeekToDay;
        fromMonth = self.leaderBestWeekFromMonth;
        toMonth = self.leaderBestWeekToMonth;
        fromYear = self.leaderBestWeekFromYear;
        toYear = self.leaderBestWeekToYear;
    }
    else if (sender == self.leaderBestMonthButton)
    {
        leader = user.monthLeader;
        self.activityDate = self.bestMonthLabel.text;
        self.title = [NSString stringWithFormat:@"%@'s best month",leader.firstName];
        
        fromDay = @"1";
        toDay = @"31";
        fromMonth = self.leaderBestMonth;
        toMonth = self.leaderBestMonth;
        fromYear = self.leaderBestMonthYear;
        toYear = fromYear;
    }
    else
    {
        leader = user.yearLeader;
        self.activityDate = self.bestYearLabel.text;
        self.title = [NSString stringWithFormat:@"%@'s best year",leader.firstName];
        
        fromDay = @"1";
        toDay = @"31";
        fromMonth = @"Jan";
        toMonth = @"Dec";
        fromYear = self.leaderBestYearLabel.text;
        toYear = fromYear;
    }
    
    NSString *fromDate = [NSString stringWithFormat:@"%@ %@, %@ 00:00:01 AM",fromMonth,fromDay,fromYear];
    NSString *toDate = [NSString stringWithFormat:@"%@ %@, %@ 11:59:59 PM",toMonth,toDay,toYear];
    
    [self getUserActivities:toDate fromDate:fromDate forUser:leader];
}

- (IBAction)segmentedControlClicked
{
    if (self.statsSelector.selectedSegmentIndex == TIME_INDEX)
    {
        self.statsByTimeView.hidden = NO;
        self.statsByActivityView.hidden = YES;
        self.statsByLeaderView.hidden = YES;
    }
    else if (self.statsSelector.selectedSegmentIndex == ACTIVITY_INDEX)
    {
        self.statsByTimeView.hidden = YES;
        self.statsByActivityView.hidden = NO;
        self.statsByLeaderView.hidden = YES;
    }
    else // Leader
    {
        self.statsByTimeView.hidden = YES;
        self.statsByActivityView.hidden = YES;
        self.statsByLeaderView.hidden = NO;
    }
}


- (void) getUserActivities:(NSString *)toDate fromDate:(NSString *)fromDate forUser:(Friend *) friend
{
    self.activityIndicator.hidden = NO;
    [self.activityIndicator startAnimating];
    self.view.userInteractionEnabled = NO;
    
    dispatch_queue_t queue = dispatch_get_global_queue(0,0);
    
    dispatch_async(queue, ^{
        
        // Get the list of activities from the server
        MWBFService *service = [[MWBFService alloc] init];
        if (friend == nil)
        {
            self.userActivitiesArrayByActivity = [service getActivitiesForUserByActivityFromDate:fromDate toDate:toDate];
            self.userActivitiesArrayByTime = [service getActivitiesForUserByTimeFromDate:fromDate toDate:toDate];
        }
        else
        {
            self.userActivitiesArrayByActivity = [service getActivitiesForFriend:friend byActivityFromDate:fromDate toDate:toDate];
            self.userActivitiesArrayByTime = [service getActivitiesForFriend:friend byTimeFromDate:fromDate toDate:toDate];
        }
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self.activityIndicator stopAnimating];
            self.activityIndicator.hidden = YES;
            self.view.userInteractionEnabled = YES;
            
            self.numberOfRestDays = [Utils getNumberOfRestDaysFromDate:fromDate toDate:toDate withActiveDays:[self.userActivitiesArrayByTime count]];
            
            [self performSegueWithIdentifier:@"UserActivities" sender:self];
        });
    });
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"UserActivities"] )
    {
        ActivityViewController *controller = [segue destinationViewController];
        controller.userActivitiesByTimeJsonArray = self.userActivitiesArrayByTime;
        controller.userActivitiesByActivityJsonArray = self.userActivitiesArrayByActivity;
        controller.activityDateString = self.activityDate;
        controller.title = self.title;
        controller.numberOfRestDays = self.numberOfRestDays;
    }
}

@end
