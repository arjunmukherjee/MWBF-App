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

@interface StatsViewController ()

@property (weak, nonatomic) IBOutlet UIButton *getActivityButton;
@property (weak, nonatomic) IBOutlet UIPickerView *datePicker;
@property (nonatomic,strong) IBOutlet UIActivityIndicatorView *activityIndicator;


@property NSMutableArray *yearsArray;
@property NSArray *monthsArray;
@property NSMutableArray *fromDaysArray;
@property NSMutableArray *toDaysArray;
@property NSArray *userActivitiesArrayByActivity;
@property NSArray *userActivitiesArrayByTime;
@property NSString *activityDate;

@end


@implementation StatsViewController

@synthesize datePicker,getActivityButton;
@synthesize yearsArray, monthsArray, fromDaysArray, toDaysArray, userActivitiesArrayByActivity, userActivitiesArrayByTime, activityDate;
@synthesize activityIndicator;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Initializers
    self.yearsArray = [NSMutableArray array];
    self.monthsArray = [NSMutableArray array];
    self.fromDaysArray = [NSMutableArray array];
    self.toDaysArray = [NSMutableArray array];
    self.activityIndicator = [[UIActivityIndicatorView alloc] init];
    
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
    self.monthsArray = @[@"--",@"Jan",@"Feb",@"Mar",@"Apr",@"May",@"Jun",@"Jul",@"Aug",@"Sept",@"Oct",@"Nov",@"Dec"];
    
    // Date days : From & To
    [self.fromDaysArray addObject:@"--"];
    [self.toDaysArray addObject:@"--"];
    for(int i=1; i <32; i++)
    {
        NSString *value = [NSString stringWithFormat:@"%d",i];
        [self.fromDaysArray addObject:value];
        [self.toDaysArray addObject:value];
    }
    
}


- (IBAction)getUserActivity:(id)sender
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
    
    if ((toDayRow !=0) && (toDayRow < fromDayRow))
    {
       [Utils alertStatus:@"The 'To Day' must be greater than the 'From Day'." :@"Oops!" :0];
    }
    else if ((toDayRow != 0) && (fromDayRow == 0))
    {
        [Utils alertStatus:@"Please select a 'From Day', or remove the 'To Day'." :@"Oops!" :0];
    }
    else
    {
        [self.activityIndicator startAnimating];
        
        if ( (toDayRow != 0)  && (fromDayRow != 0))
            self.activityDate = [activityDate stringByAppendingString:[NSString stringWithFormat:@" from %@,%@ to %@,%@",month,fromDay,month,toDay]];
        else if ( (toDayRow == 0)  && (fromDayRow != 0))
            self.activityDate = [activityDate stringByAppendingString:[NSString stringWithFormat:@" for %@,%@",month,fromDay]];
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
        
        // Get the list of activities from the server
        MWBFService *service = [[MWBFService alloc] init];
        self.userActivitiesArrayByActivity = [service getActivitiesForUserByActivityFromDate:fromDate toDate:toDate];
        self.userActivitiesArrayByTime = [service getActivitiesForUserByTimeFromDate:fromDate toDate:toDate];
        
        if ([self.userActivitiesArrayByActivity count] <= 0 )
            [Utils alertStatus:[NSString stringWithFormat:@"No activity found for %@.",self.activityDate] :@"Get to work!" :0];
        else
            [self performSegueWithIdentifier:@"user_activities" sender:self];
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
