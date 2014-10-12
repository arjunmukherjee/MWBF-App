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

@property NSArray *userActivitiesArrayByActivity;
@property NSArray *userActivitiesArrayByTime;
@property NSString *activityDate;
@property NSString *numberOfRestDays;
@property NSString *title;

@property NSString *bestDay,*bestDayMonth,*bestDayYear;
@property NSString *bestMonth,*bestMonthYear;

@property NSString *bestWeekFromDay, *bestWeekFromMonth, *bestWeekFromYear;
@property NSString *bestWeekToDay, *bestWeekToMonth, *bestWeekToYear;

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


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self loadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self loadData];
}

- (void) loadData
{
    User *user = [User getInstance];
    
    self.bestDayLabel.text = [NSString stringWithFormat:@"%@",user.bestDay];
    self.bestWeekLabel.text = [NSString stringWithFormat:@"%@",user.bestWeek];
    self.bestMonthLabel.text = [NSString stringWithFormat:@"%@",user.bestMonth];
    self.bestYearLabel.text = [NSString stringWithFormat:@"%@",user.bestYear];
    
    self.bestDayPointsLabel.text = [NSString stringWithFormat:@"%@ pts",user.bestDayPoints];
    self.bestWeekPointsLabel.text = [NSString stringWithFormat:@"%@ pts",user.bestWeekPoints];
    self.bestMonthPointsLabel.text = [NSString stringWithFormat:@"%@ pts",user.bestMonthPoints];
    self.bestYearPointsLabel.text = [NSString stringWithFormat:@"%@ pts",user.bestYearPoints];
    
    [Utils setMaskTo:bestDayHeader byRoundingCorners:UIRectCornerAllCorners];
    [Utils setMaskTo:bestWeekHeader byRoundingCorners:UIRectCornerAllCorners];
    [Utils setMaskTo:bestMonthHeader byRoundingCorners:UIRectCornerAllCorners];
    [Utils setMaskTo:bestYearHeader byRoundingCorners:UIRectCornerAllCorners];
    
    
    // BEST DAY
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

}
- (IBAction)personalStatsButtonClicked:(id) sender
{
    NSString *fromMonth, *fromDay, *fromYear;
    NSString *toMonth, *toDay, *toYear;
    
    if (sender == self.bestDayButton)
    {
        self.title = self.bestDayLabel.text;
        fromDay = self.bestDay;
        toDay = self.bestDay;
        fromMonth = self.bestDayMonth;
        toMonth = self.bestDayMonth;
        fromYear = self.bestDayYear;
        toYear = fromYear;
    }
    else if (sender == self.bestWeekButton)
    {
        self.title = [NSString stringWithFormat:@"Week of %@",self.bestWeekLabel.text];
        
        fromDay = self.bestWeekFromDay;
        toDay = self.bestWeekToDay;
        fromMonth = self.bestWeekFromMonth;
        toMonth = self.bestWeekToMonth;
        fromYear = self.bestWeekFromYear;
        toYear = self.bestWeekToYear;
    }
    else if (sender == self.bestMonthButton)
    {
        fromDay = @"1";
        toDay = @"31";
        fromMonth = self.bestMonth;
        toMonth = self.bestMonth;
        fromYear = self.bestMonthYear;
        toYear = fromYear;
        
        self.title = self.bestMonthLabel.text;
    }
    else
    {
        self.title = self.bestYearLabel.text;
        fromDay = @"1";
        toDay = @"31";
        fromMonth = @"Jan";
        toMonth = @"Dec";
        fromYear = self.bestYearLabel.text;
        toYear = fromYear;
    }
    
    NSString *fromDate = [NSString stringWithFormat:@"%@ %@, %@ 00:00:01 AM",fromMonth,fromDay,fromYear];
    NSString *toDate = [NSString stringWithFormat:@"%@ %@, %@ 11:59:59 PM",toMonth,toDay,toYear];
    
    [self getUserActivities:toDate fromDate:fromDate];
}

- (void) getUserActivities:(NSString *)toDate fromDate:(NSString *)fromDate
{
    self.activityIndicator.hidden = NO;
    [self.activityIndicator startAnimating];
    self.view.userInteractionEnabled = NO;
    
    dispatch_queue_t queue = dispatch_get_global_queue(0,0);
    
    dispatch_async(queue, ^{
        
        // Get the list of activities from the server
        MWBFService *service = [[MWBFService alloc] init];
        self.userActivitiesArrayByActivity = [service getActivitiesForUserByActivityFromDate:fromDate toDate:toDate];
        self.userActivitiesArrayByTime = [service getActivitiesForUserByTimeFromDate:fromDate toDate:toDate];
        
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
