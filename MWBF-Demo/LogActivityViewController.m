//
//  LogActivityViewController.m
//  MWBF-Demo
//
//  Created by ARJUN MUKHERJEE on 7/29/14.
//  Copyright (c) 2014 ___Arjun Mukherjee___. All rights reserved.
//

#import "LogActivityViewController.h"
#import "MWBFService.h"
#import "UserActivity.h"
#import "LogActivityListCell.h"
#import "User.h"
#import "MWBFActivities.h"

#define MONTH_COMPONENT_INDEX 3
#define DAY_COMPONENT_INDEX 4

@interface LogActivityViewController ()

@property NSArray *activityListArray;
@property NSMutableArray *activityValueArray;
@property NSMutableArray *activityValueDecimalArray;
@property NSMutableArray *addedActivityArray;
@property NSMutableArray *monthsArray;
@property NSMutableArray *daysArray;

@property (nonatomic,strong) UIActivityIndicatorView *activityIndicator;

@end

@implementation LogActivityViewController

@synthesize activityPicker = _activityPicker;
@synthesize activityNameHeaderLable = _activityNameHeaderLable;
@synthesize unitsHeaderLable = _unitsHeaderLable;
@synthesize dateHeaderLable = _dateHeaderLable;
@synthesize pointsHeaderLable = _pointsHeaderLable;
@synthesize user = _user;
@synthesize activity = _activity;
@synthesize activityIndicator;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.user  = [User getInstance];
    
    self.activityPickerButton.hidden = NO;
 
    // Hidden components
    self.logActivityButton.hidden = NO;
    self.addActivityButton.hidden = NO;
    self.activityTable.hidden = NO;
    self.activityNameHeaderLable.hidden = NO;
    self.unitsHeaderLable.hidden = NO;
    self.dateHeaderLable.hidden = NO;
    self.pointsHeaderLable.hidden = NO;
    self.activityPicker.hidden = NO;
    
    // Initializers
    self.addedActivityArray = [NSMutableArray array];
    self.activityValueArray = [NSMutableArray array];
    self.monthsArray = [NSMutableArray array];
    self.activityValueDecimalArray = [NSMutableArray array];
    self.daysArray = [NSMutableArray array];
  
    // Activity whole number value
    for(int i=0; i <201; i++)
    {
        NSString *value = [NSString stringWithFormat:@"%d",i];
        [self.activityValueArray addObject:value];
    }
    
    // Activity decimal number value
    for(int i=0; i <100; i++)
    {
        NSString *value = [NSString stringWithFormat:@"%d",i];
        [self.activityValueDecimalArray addObject:value];
    }
 
    // Date month : Only display months until the current month
    NSDate *currentDate =[NSDate date ];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM"];
    int currentMonth = [[dateFormatter stringFromDate: currentDate] intValue];
    
    NSArray *tempMonthsArray = @[@"Jan",@"Feb",@"Mar",@"Apr",@"May",@"Jun",@"Jul",@"Aug",@"Sep",@"Oct",@"Nov",@"Dec"];
    for (int i=0;i<currentMonth; i++)
        [self.monthsArray addObject:tempMonthsArray[i]];
    
    // Date days number value
    for(int i=1; i <32; i++)
    {
        NSString *value = [NSString stringWithFormat:@"%d",i];
        [self.daysArray addObject:value];
    }
    
    [self pickActivityClicked:self];

    // Activity Indicator
    self.activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.activityIndicator.center = self.view.center;
    self.activityIndicator.color = [UIColor blueColor];
    [self.view addSubview: self.activityIndicator];

}

- (IBAction) logActivityClicked:(id)sender
{
    // Check to ensure an activity is selected
    if (!self.addedActivityArray || !self.addedActivityArray.count)
    {
        [self alertStatus:@"Please select an activity." :@"Forget something ?" :0];
        return;
    }
    
    NSError *error = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:[self toNSArray] options:NSJSONWritingPrettyPrinted error:&error];
    
    if ([jsonData length] > 0 && error == nil)
    {
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
       
        self.activityIndicator.hidden = NO;
        [self.activityIndicator startAnimating];
        self.view.userInteractionEnabled = NO;
        
        dispatch_queue_t queue = dispatch_get_global_queue(0,0);
        
        dispatch_async(queue, ^{
            
            BOOL success = NO;
            NSString *response = nil;
            MWBFService *service = [[MWBFService alloc] init];
            success = [service logActivity:jsonString withResponse:&response];
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                [self.activityIndicator stopAnimating];
                self.activityIndicator.hidden = YES;
                self.view.userInteractionEnabled = YES;
                
                if ( !success )
                {
                    if ([jsonData length] == 0 && error == nil)
                        NSLog(@"No data was returned after serialization.");
                    else if (error != nil)
                        NSLog(@"An error happened = %@", error);
                    
                    [self alertStatus:@"Unable to log activity, please try again." :@"Oops!!" :0];
                }
                else
                {
                    [self alertStatus:@"Activity logged." :@"Wohoo!!" :0];
                    
                    self.addActivityButton.hidden = NO;
                    self.activityPicker.hidden = NO;
                    
                    // Hidden components
                    self.activityPickerButton.hidden = YES;
                    
                    self.logActivityButton.hidden = NO;
                    self.activityTable.hidden = NO;
                    self.activityNameHeaderLable.hidden = NO;
                    self.unitsHeaderLable.hidden = NO;
                    self.dateHeaderLable.hidden = NO;
                    self.pointsHeaderLable.hidden = NO;
                    
                    self.addedActivityArray = [[NSMutableArray alloc] init];
                    [self.activityTable reloadData];
                    
                    [self resetActivityPicker];
                }
            });
        });
    }
}

- (NSMutableArray *) toNSArray
{
    NSMutableArray *myActivityList = [[NSMutableArray alloc] init];
    for(UserActivity *userActivity in self.addedActivityArray)
    {
        [myActivityList addObject:[userActivity toNSDictionary]];
    }
    
    return myActivityList;
}


- (IBAction) addActivityClicked:(id)sender
{
    NSInteger row = [self.activityPicker selectedRowInComponent:0];
    NSString *activity  = [self.activityListArray objectAtIndex:row];
    
    row = [self.activityPicker selectedRowInComponent:1];
    NSString *value  = [self.activityValueArray objectAtIndex:row];
    
    row = [self.activityPicker selectedRowInComponent:2];
    NSString *decimal  = [self.activityValueDecimalArray objectAtIndex:row];
    
    row = [self.activityPicker selectedRowInComponent:3];
    NSString *month  = [self.monthsArray objectAtIndex:row];
    
    row = [self.activityPicker selectedRowInComponent:4];
    NSString *day  = [self.daysArray objectAtIndex:row];
    
    if ([value isEqualToString:@"0"] && [decimal isEqualToString:@"0"])
       [self alertStatus:@"Please pick a value for the exercise." :@"Oops! Miss something?" :0];
    else if([self isDateInTheFutureWithDay:day])
    {
        [self alertStatus:@"Don't log what you haven't yet done." :@"Hold your horses!" :0];
    }
    else
    {
        self.activityTable.hidden = NO;
        
        self.activityNameHeaderLable.hidden = NO;
        self.unitsHeaderLable.hidden = NO;
        self.dateHeaderLable.hidden = NO;
        self.pointsHeaderLable.hidden = NO;
        
        self.logActivityButton.hidden = NO;
        
        NSDate *currentTime = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy hh:mm:ss a"];
        NSString *yearTimeStr = [dateFormatter stringFromDate: currentTime];
        NSString *date = [NSString stringWithFormat:@"%@ %@, %@",month,day,yearTimeStr];
        
        NSString *activityValue = [NSString stringWithFormat:@"%@.%@",value,decimal];
        
        UserActivity *userActivityObj = [[UserActivity alloc] init];
        userActivityObj.activity = activity;
        userActivityObj.activityValue = activityValue;
        userActivityObj.date = date;
        
        MWBFActivities *mwbfActivities = [self.activity.activityDict objectForKey:activity];
        
        double pointsForExercise = mwbfActivities.pointsPerUnit * [activityValue doubleValue];
        NSString *pointsStr = [NSString stringWithFormat:@"%.2f",pointsForExercise];
        
        userActivityObj.points = pointsStr;
        userActivityObj.user = self.user;
        
        [self.addedActivityArray addObject:userActivityObj];
        
        [self.activityTable reloadData];
    }
}

- (Boolean) isDateInTheFutureWithDay:(NSString*) chosenDay
{
    NSDate *currentDate =[NSDate date ];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"d"];
    NSString *currentDay = [dateFormatter stringFromDate: currentDate];
    
    if ([chosenDay intValue] > [currentDay intValue])
        return YES;
    else
        return NO;
}

- (IBAction) pickActivityClicked:(id)sender
{
    self.activity = [Activity getInstance];
    if ( [self.activity.activityDict count] == 0 )
        NSLog(@"Waiting to download the list of activities form the server.");
    
    self.activityListArray = [NSMutableArray arrayWithArray:[self.activity.activityDict allKeys]];
        [self.activityPicker reloadAllComponents];
        
    self.activityPickerButton.hidden = YES;
    self.addActivityButton.hidden = NO;
    
    if([self.activityPicker isHidden])
        self.activityPicker.hidden = NO;
    else
        self.activityPicker.hidden = NO;
    
    [UIView animateWithDuration:0.25 animations:^{
        
        self.activityPicker.alpha = 1.0f;
        
    }];
    
    NSDate *currentTime = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
   
    [dateFormatter setDateFormat:@"MM"];
    NSInteger monthInt = [[dateFormatter stringFromDate: currentTime] integerValue];
    
    [dateFormatter setDateFormat:@"dd"];
    NSInteger dayInt = [[dateFormatter stringFromDate: currentTime] integerValue];
    
    [self.activityPicker selectRow:(monthInt-1) inComponent:3 animated:NO];
    [self.activityPicker selectRow:(dayInt-1) inComponent:4 animated:NO];
}


- (void) resetActivityPicker
{
    int numberOfComponents = [self.activityPicker numberOfComponents];
    for (int i=0; i<numberOfComponents; i++)
        [self.activityPicker selectRow:0 inComponent:i animated:NO];
    
    NSDate *currentTime = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"MM"];
    NSInteger monthInt = [[dateFormatter stringFromDate: currentTime] integerValue];
    
    [dateFormatter setDateFormat:@"dd"];
    NSInteger dayInt = [[dateFormatter stringFromDate: currentTime] integerValue];
    
    [self.activityPicker selectRow:(monthInt-1) inComponent:MONTH_COMPONENT_INDEX animated:NO];
    [self.activityPicker selectRow:(dayInt-1) inComponent:DAY_COMPONENT_INDEX animated:NO];
    
    [self.activityPicker reloadAllComponents];
    
}

- (void) alertStatus:(NSString *)msg :(NSString *)title :(int) tag
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                        message:msg
                                                       delegate:self
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil, nil];
    alertView.tag = tag;
    [alertView show];
}

// Dismiss the keyboard when the background is tapped
- (IBAction)backgroundTap:(id)sender
{
    //[self.view endEditing:YES];
    //self.activityPicker.hidden = YES;
    //self.activityPickerButton.hidden = NO;
    //self.addActivityButton.hidden = YES;
}


///// PICKER VIEW METHODS ////

- (NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 5;
}

- (NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0)
        return [self.activityListArray count];
    else if (component == 1)
        return [self.activityValueArray count];
    else if (component == 2)
        return [self.activityValueDecimalArray count];
    else if (component == 3)
        return [self.monthsArray count];
    else
        return [self.daysArray count];
}

- (NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == 0)
        return self.activityListArray[row];
    else if (component == 1)
        return self.activityValueArray[row];
    else if (component == 2)
        return self.activityValueDecimalArray[row];
    else if (component == 3)
        return self.monthsArray[row];
    else
        return self.daysArray[row];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    switch(component)
    {
        case 0: return 115;
        case 1: return 50;
        case 2: return 34;
        case 3: return 52;
        case 4: return 34;
        default: return 30;
    }
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont fontWithName:@"Trebuchet MS" size:16];
    
    if (component == 0)
        label.text =  self.activityListArray[row];
    else if (component == 1)
        label.text =  self.activityValueArray[row];
    else if (component == 2)
        label.text = self.activityValueDecimalArray[row];
    else if (component == 3)
        label.text = self.monthsArray[row];
    else
        label.text = self.daysArray[row];
    
    
    return label;
}


///////// UITABLEVIEW METHODS /////////

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.addedActivityArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ActivityDetailsCell";
    
    LogActivityListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    UserActivity *activityObj = [self.addedActivityArray objectAtIndex:indexPath.row];
    
    cell.activityLabel.text = activityObj.activity;
    
    // To Display only the Day and Month
    //cell.dateLabel.text = activityObj.date;
    NSArray* foo = [activityObj.date componentsSeparatedByString: @","];
    cell.dateLabel.text = [foo objectAtIndex: 0];
    
    cell.activityValueLabel.text = activityObj.activityValue;
    cell.pointsLabel.text = activityObj.points;
    
    return cell;
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        // Delete the row from the array
        [self.addedActivityArray removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

@end
