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
#import "PMCalendar.h"

#define MONTH_COMPONENT_INDEX 3
#define DAY_COMPONENT_INDEX 4

@interface LogActivityViewController ()

@property NSArray *activityListArray;
@property NSMutableArray *addedActivityArray;
@property (weak, nonatomic) IBOutlet UIButton *infoButton;
@property (weak, nonatomic) IBOutlet UITextView *infoView;
@property (weak, nonatomic) IBOutlet UIButton *pickDateButton;
@property (weak, nonatomic) IBOutlet UITextField *activityValueTextField;
@property (weak, nonatomic) IBOutlet UILabel *unitsLabel;
@property (weak, nonatomic) IBOutlet UITextField *dateTextField;

@property float pointsEarned;

// Calendar
@property (nonatomic, strong) PMCalendarController *pmCC;

@end

@implementation LogActivityViewController

@synthesize activityPicker = _activityPicker;
@synthesize activityNameHeaderLable = _activityNameHeaderLable;
@synthesize unitsHeaderLable = _unitsHeaderLable;
@synthesize dateHeaderLable = _dateHeaderLable;
@synthesize pointsHeaderLable = _pointsHeaderLable;
@synthesize user = _user;
@synthesize activity = _activity;
@synthesize pmCC;
@synthesize pointsEarned;
@synthesize dateTextField;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.user  = [User getInstance];
    
    self.infoView.hidden = YES;
    [Utils setMaskTo:self.infoView byRoundingCorners:UIRectCornerAllCorners];
 
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
    self.pointsEarned = 0;
    
    [self pickActivityClicked:self];

    // Calendar
    self.pmCC = [[PMCalendarController alloc] initWithThemeName:@"default"];
    self.pmCC.delegate = self;
    
    self.pmCC.mondayFirstDayOfWeek = NO;
    self.pmCC.allowsPeriodSelection = NO;
    self.pmCC.title = @"Activity Date";
        
    // Set the default date value in the text box to today
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMM dd"];
    NSString *date = [dateFormatter stringFromDate: [NSDate date]];
    self.dateTextField.text = date;
}

- (IBAction)infoButtonClicked:(id)sender
{
    [self.view endEditing:YES];
    
    if (self.infoView.hidden == YES)
    {
        self.infoView.hidden = NO;
        [self.view bringSubviewToFront:self.infoView];
    }
    else
        self.infoView.hidden = YES;
}

- (IBAction) logActivityClicked:(id)sender
{
    [self.view endEditing:YES];
    
    // Check to ensure an activity is selected
    if (!self.addedActivityArray || !self.addedActivityArray.count)
    {
        [Utils alertStatus:@"Please select an activity." :@"Forget something ?" :0];
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
            
            // Refresh the users data
            [self refreshUserData];
            
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
                    
                    [Utils alertStatus:@"Unable to log activity, please try again." :@"Oops!!" :0];
                }
                else
                {
                    NSString *message = [NSString stringWithFormat:@"You just earned %.1f points.",self.pointsEarned];
                    [Utils alertStatus:message :@"Wohoo!!" :0];
                    
                    self.addActivityButton.hidden = NO;
                    self.activityPicker.hidden = NO;
                    
                    // Hidden components
                    
                    self.logActivityButton.hidden = NO;
                    self.activityTable.hidden = NO;
                    self.activityNameHeaderLable.hidden = NO;
                    self.unitsHeaderLable.hidden = NO;
                    self.dateHeaderLable.hidden = NO;
                    self.pointsHeaderLable.hidden = NO;
                    
                    self.addedActivityArray = [[NSMutableArray alloc] init];
                    [self.activityTable reloadData];
                }
            });
        });
    }
}

///////// Calendar METHODS ///////////////
- (void)calendarController:(PMCalendarController *)calendarController didChangePeriod:(PMPeriod *)newPeriod
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMM dd"];
    NSString *date = [dateFormatter stringFromDate: [calendarController.period startDate]];
    
    self.dateTextField.text = date;
}


- (NSMutableArray *) toNSArray
{
    self.pointsEarned = 0;
    float points = 0;
    NSMutableArray *myActivityList = [[NSMutableArray alloc] init];
    for(UserActivity *userActivity in self.addedActivityArray)
    {
        [myActivityList addObject:[userActivity toNSDictionary]];
        points = points + [userActivity.points floatValue];
    }
    
    self.pointsEarned = points;
    
    return myActivityList;
}


- (IBAction) addActivityClicked:(id)sender
{
    [self.view endEditing:YES];
    
    NSInteger row = [self.activityPicker selectedRowInComponent:0];
    NSString *activity  = [self.activityListArray objectAtIndex:row];
    
    NSString *activityValue  = self.activityValueTextField.text;
    
    // Get the activity time
    NSDate *currentTime = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy hh:mm:ss a"];
    NSString *yearTimeStr = [dateFormatter stringFromDate: currentTime];
    
    
    NSDate *selectedDate = [self.pmCC.period startDate];
    if ( selectedDate == NULL )
        selectedDate = [NSDate date];
    [dateFormatter setDateFormat:@"MMM dd"];
    NSString *date = [dateFormatter stringFromDate: selectedDate];
    date = [NSString stringWithFormat:@"%@, %@",date,yearTimeStr];
    
    
    NSDate *today = [NSDate date];
    
    
    if ((activityValue == NULL) || ([activityValue length] <= 0 ))
       [Utils alertStatus:@"Please pick a value for the exercise." :@"Oops! Miss something?" :0];
    else if([[selectedDate earlierDate:today] isEqualToDate:today])
        [Utils alertStatus:@"Don't log what you haven't yet done." :@"Hold your horses!" :0];
    else
    {
        self.activityTable.hidden = NO;
        
        self.activityNameHeaderLable.hidden = NO;
        self.unitsHeaderLable.hidden = NO;
        self.dateHeaderLable.hidden = NO;
        self.pointsHeaderLable.hidden = NO;
        
        self.logActivityButton.hidden = NO;
        
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
        
        // Reset the activityValue field
        self.activityValueTextField.text = @"";
    }
}

- (void)  pickActivityClicked:(id)sender
{
    [self.view endEditing:YES];
    
    self.activity = [Activity getInstance];
    
    self.activityListArray = [NSMutableArray arrayWithArray:[self.activity.activityDict allKeys]];
    [self.activityPicker reloadAllComponents];
        
    self.addActivityButton.hidden = NO;
    
    if([self.activityPicker isHidden])
        self.activityPicker.hidden = NO;
    else
        self.activityPicker.hidden = NO;
    
    [UIView animateWithDuration:0.25 animations:^{
        self.activityPicker.alpha = 1.0f;
    }];
}


// Dismiss the keyboard when the background is tapped
- (IBAction)backgroundTap:(id)sender
{
    self.infoView.hidden = YES;
    [self.view endEditing:YES];
    [self.pmCC dismissCalendarAnimated:NO];
}


#pragma - Calendar methods
/////////// CALENDAR METHODS /////////////////

- (IBAction)pickDateClicked:(id)sender
{
    [self.pmCC presentCalendarFromView:sender
                  permittedArrowDirections:PMCalendarArrowDirectionAny
                                 isPopover:YES
                                  animated:YES];
}

///// PICKER VIEW METHODS ////

- (NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [self.activityListArray count];
}

- (NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return self.activityListArray[row];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    switch(component)
    {
        case 0: return 115;
        default: return 30;
    }
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont fontWithName:@"Trebuchet MS" size:16];
    
    label.text =  self.activityListArray[row];
   
    NSInteger index = [self.activityPicker selectedRowInComponent:0];
    MWBFActivities *activity = [self.activity.activityDict objectForKey:self.activityListArray[index]];
    self.unitsLabel.text = activity.measurementUnits;
  
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
