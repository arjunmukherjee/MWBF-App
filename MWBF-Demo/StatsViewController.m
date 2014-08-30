//
//  StatsViewController.m
//  MWBF-Demo
//
//  Created by ARJUN MUKHERJEE on 8/2/14.
//  Copyright (c) 2014 ___Arjun Mukherjee___. All rights reserved.
//

#import "StatsViewController.h"
#import "Utils.h"
#import "MWBFService.h"
#import "ActivityViewController.h"
#import "SVSegmentedControl.h"
#import <QuartzCore/QuartzCore.h>

#define TODAY_INDEX 0
#define WEEK_INDEX 1
#define MONTH_INDEX 2

@interface StatsViewController ()

@property (weak, nonatomic) IBOutlet UIButton *getActivityButton;
@property (weak, nonatomic) IBOutlet UIPickerView *datePicker;
@property (nonatomic,strong) UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UIButton *infoButton;
@property (weak, nonatomic) IBOutlet UIView *infoView;


@property NSMutableArray *yearsArray;
@property NSArray *monthsArray;
@property NSMutableArray *fromDaysArray;
@property NSMutableArray *toDaysArray;
@property NSArray *userActivitiesArrayByActivity;
@property NSArray *userActivitiesArrayByTime;
@property NSString *activityDate;
@property NSString *numberOfRestDays;

@end


@implementation StatsViewController

@synthesize datePicker,getActivityButton;
@synthesize yearsArray, monthsArray, fromDaysArray, toDaysArray, userActivitiesArrayByActivity, userActivitiesArrayByTime, activityDate;
@synthesize activityIndicator;
@synthesize infoView;
@synthesize infoButton;
@synthesize numberOfRestDays;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Initializers
    self.yearsArray = [NSMutableArray array];
    self.monthsArray = [NSMutableArray array];
    self.fromDaysArray = [NSMutableArray array];
    self.toDaysArray = [NSMutableArray array];
    self.activityIndicator = [[UIActivityIndicatorView alloc] init];
    
    self.infoView.hidden = YES;
    [Utils setMaskTo:self.infoView byRoundingCorners:UIRectCornerAllCorners];
    
    
    // Date : years value (2014 to current year)
    NSDate *currentTime = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY"];
    NSInteger yearInteger = [[dateFormatter stringFromDate: currentTime] integerValue];
    for(int i=2014; i <=(yearInteger); i++)
    {
        NSString *value = [NSString stringWithFormat:@"%d",i];
        [self.yearsArray addObject:value];
    }
    
    // Date month
    self.monthsArray = @[@"--",@"Jan",@"Feb",@"Mar",@"Apr",@"May",@"Jun",@"Jul",@"Aug",@"Sep",@"Oct",@"Nov",@"Dec"];
    
    // Date days : From & To
    [self.fromDaysArray addObject:@"--"];
    [self.toDaysArray addObject:@"--"];
    for(int i=1; i <32; i++)
    {
        NSString *value = [NSString stringWithFormat:@"%d",i];
        [self.fromDaysArray addObject:value];
        [self.toDaysArray addObject:value];
    }
    
    self.activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.activityIndicator.center = self.view.center;
    self.activityIndicator.color = [UIColor blueColor];
    [self.view addSubview: self.activityIndicator];
    
    // Get the new segmentedController
   SVSegmentedControl *quickDateSelector = [[SVSegmentedControl alloc] initWithSectionTitles:[NSArray arrayWithObjects:@"Today", @"Week", @"Month",@"Year", nil]];
    [quickDateSelector addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
	quickDateSelector.crossFadeLabelsOnDrag = YES;
    quickDateSelector.textColor = [UIColor lightGrayColor];
	[quickDateSelector setSelectedSegmentIndex:0 animated:NO];
	quickDateSelector.thumb.tintColor = [UIColor colorWithRed:0.999 green:0.889 blue:0.312 alpha:1.000];
	quickDateSelector.thumb.textColor = [UIColor blackColor];
	quickDateSelector.thumb.textShadowColor = [UIColor colorWithWhite:1 alpha:0.5];
	quickDateSelector.thumb.textShadowOffset = CGSizeMake(0, 1);
	quickDateSelector.center = CGPointMake(160, 160);
	[self.view addSubview:quickDateSelector];
}

// Gets the start and end date for a week , given a date in the week
- (void)startDate:(NSDate **)start andEndDate:(NSDate **)end ofWeekOn:(NSDate *)date
{
    NSDate *startDate = nil;
    NSTimeInterval duration = 0;
    BOOL b = [[NSCalendar currentCalendar] rangeOfUnit:NSWeekCalendarUnit startDate:&startDate interval:&duration forDate:date];
    if(! b){
        *start = nil;
        *end = nil;
        return;
    }
    NSDate *endDate = [startDate dateByAddingTimeInterval:duration-1];
    
    *start = startDate;
    *end = endDate;
}

- (IBAction)infoButtonClicked:(id)sender
{
    if (self.infoView.hidden == YES)
    {
        self.infoView.hidden = NO;
        [self.view bringSubviewToFront:self.infoView];
    }
    else
    {
        self.infoView.hidden = YES;
        [self.view sendSubviewToBack:self.infoView ];
    }
    
}

- (IBAction)backgroundTapped:(id)sender
{
    self.infoView.hidden = YES;
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
            
            if ([self.userActivitiesArrayByActivity count] <= 0 )
                [Utils alertStatus:[NSString stringWithFormat:@"No activity found for %@",self.activityDate] :@"Get to work!" :0];
            else
                [self performSegueWithIdentifier:@"user_activities" sender:self];
        });
    });
}

#pragma mark - UIControlEventValueChanged

- (void) segmentedControlChangedValue:(SVSegmentedControl*)segmentedControl
{
    // Year
    NSDate *currentTime = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY"];
    NSString *year = [dateFormatter stringFromDate: currentTime] ;
    
    // Month
    [dateFormatter setDateFormat:@"MM"];
    NSInteger monthInteger = [[dateFormatter stringFromDate: currentTime] integerValue];
    NSString *month  = [self.monthsArray objectAtIndex:monthInteger];
    
    NSString *fromDate = [[NSString alloc] init];
    NSString *toDate = [[NSString alloc] init];
    
    self.activityDate = [NSString stringWithFormat:@"%@",year];
    
    if (segmentedControl.selectedSegmentIndex == TODAY_INDEX)
    {
        // Today
        [dateFormatter setDateFormat:@"dd"];
        NSString *today = [dateFormatter stringFromDate: currentTime] ;
        
        self.activityDate = @"Today";
        self.activityDate = [activityDate stringByAppendingString:[NSString stringWithFormat:@"  %@,%@",month,today]];
        
        fromDate = [NSString stringWithFormat:@"%@ %@, %@ 00:00:01 AM",month,today,year];
        toDate = [NSString stringWithFormat:@"%@ %@, %@ 11:59:59 PM",month,today,year];
        
    }
    else if (segmentedControl.selectedSegmentIndex == WEEK_INDEX)
    {
        self.activityDate = @"This week";
        
        NSDate *this_start = nil, *this_end = nil;
        [self startDate:&this_start andEndDate:&this_end ofWeekOn:[NSDate date]];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MMM dd, YYYY"];
        
        fromDate = [dateFormatter stringFromDate: this_start];
        toDate = [dateFormatter stringFromDate: this_end];
        
        fromDate = [NSString stringWithFormat:@"%@ 00:00:01 AM",fromDate];
        toDate = [NSString stringWithFormat:@"%@ 11:59:59 PM",toDate];
    }
    else if (segmentedControl.selectedSegmentIndex == MONTH_INDEX)
    {
        self.activityDate = [activityDate stringByAppendingString:[NSString stringWithFormat:@" %@",month]];
        
        fromDate = [NSString stringWithFormat:@"%@ 01, %@ 00:00:01 AM",month,year];
        toDate = [NSString stringWithFormat:@"%@ 31, %@ 11:59:59 PM",month,year];
    }
    else // YEAR
    {
        fromDate = [NSString stringWithFormat:@"Jan 01, %@ 00:00:01 AM",year];
        toDate = [NSString stringWithFormat:@"Dec 31, %@ 11:59:59 PM",year];
    }
    
    [self getUserActivities:toDate fromDate:fromDate];

}


- (IBAction) getUserActivity:(id)sender
{
    NSInteger row = [self.datePicker selectedRowInComponent:0];
    NSString *year  = [self.yearsArray objectAtIndex:row];
    
    self.activityDate = [NSString stringWithFormat:@"%@",year];
    
    NSInteger monthRow = [self.datePicker selectedRowInComponent:1];
    NSString *month  = [self.monthsArray objectAtIndex:monthRow];
    
    NSInteger fromDayRow = [self.datePicker selectedRowInComponent:2];
    NSString *fromDay  = [self.fromDaysArray objectAtIndex:fromDayRow];
    
    
    NSInteger toDayRow = [self.datePicker selectedRowInComponent:3];
    NSString *toDay  = [self.toDaysArray objectAtIndex:toDayRow];
    
    
    if ( ((toDayRow != 0) || (fromDayRow != 0 )) && (monthRow == 0) )
        [Utils alertStatus:@"If you choose a 'To' or 'From' day, please select a month." :@"Oops!" :0];
    else if ((toDayRow !=0) && (toDayRow < fromDayRow))
       [Utils alertStatus:@"The 'To Day' must be greater than the 'From Day'." :@"Oops!" :0];
    else if ((toDayRow != 0) && (fromDayRow == 0))
        [Utils alertStatus:@"Please select a 'From Day', or remove the 'To Day'." :@"Oops!" :0];
    else
    {
        if ( (toDayRow != 0)  && (fromDayRow != 0))
            self.activityDate = [activityDate stringByAppendingString:[NSString stringWithFormat:@" from %@,%@ to %@,%@",month,fromDay,month,toDay]];
        else if ( (toDayRow == 0)  && (fromDayRow != 0))
            self.activityDate = [activityDate stringByAppendingString:[NSString stringWithFormat:@" %@,%@",month,fromDay]];
        else if ( (toDayRow == 0)  && (fromDayRow == 0) && (monthRow != 0))
            self.activityDate = [activityDate stringByAppendingString:[NSString stringWithFormat:@" %@",month]];
        
        NSString *fromMonth = month;
        NSString *toMonth = month;
        if( monthRow == 0)
        {
            fromMonth = @"Jan";
            toMonth = @"Dec";
        }
        
        if( toDayRow == 0)
            toDay = fromDay;
        
        if( fromDayRow == 0)
        {
            fromDay = @"1";
            toDay = @"31";
        }
        
        NSString *fromDate = [NSString stringWithFormat:@"%@ %@, %@ 00:00:01 AM",fromMonth,fromDay,year];
        NSString *toDate = [NSString stringWithFormat:@"%@ %@, %@ 11:59:59 PM",toMonth,toDay,year];
     
        [self getUserActivities:toDate fromDate:fromDate];
    }
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"user_activities"] )
    {
        ActivityViewController *controller = [segue destinationViewController];
        controller.userActivitiesByActivityJsonArray = self.userActivitiesArrayByActivity;
        controller.userActivitiesByTimeJsonArray = self.userActivitiesArrayByTime;
        controller.activityDateString = self.activityDate;
        controller.numberOfRestDays = self.numberOfRestDays;
    }
}

///// PICKER VIEW METHODS ////

- (NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 4;
}

- (NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0)
        return [self.yearsArray count];
    else if (component == 1)
        return [self.monthsArray count];
    else if (component == 2)
        return [self.fromDaysArray count];
    else
        return [self.toDaysArray count];
    
}

- (NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == 0)
        return self.yearsArray[row];
    else if (component == 1)
        return self.monthsArray[row];
    else if (component == 2)
        return self.fromDaysArray[row];
    else
        return self.toDaysArray[row];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    switch(component)
    {
        case 0: return 60;
        case 1: return 80;
        case 2: return 100;
        case 3: return 40;
        default: return 30;
    }
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont fontWithName:@"Trebuchet MS" size:15];
    
    if (component == 0)
        label.text =  self.yearsArray[row];
    else if (component == 1)
        label.text =  self.monthsArray[row];
    else if (component == 2)
        label.text =  self.fromDaysArray[row];
    else
        label.text = self.toDaysArray[row];
    
    return label;
}


@end
