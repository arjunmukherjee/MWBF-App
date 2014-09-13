//
//  NewChallengeViewController.m
//  MWBF-Demo
//
//  Created by ARJUN MUKHERJEE on 8/9/14.
//  Copyright (c) 2014 ___Arjun Mukherjee___. All rights reserved.
//

#import "NewChallengeViewController.h"
#import "Activity.h"
#import "Utils.h"
#import "User.h"
#import "Friend.h"
#import "MWBFService.h"
#import "Challenge.h"
#import "PMCalendar.h"


@interface NewChallengeViewController ()

@property (weak, nonatomic) IBOutlet UIPickerView *activityPicker;
@property (weak, nonatomic) IBOutlet UIView *addFriendsView;
@property (weak, nonatomic) IBOutlet UITableView *playersTable;
@property (weak, nonatomic) IBOutlet UITableView *activityTable;
@property (weak, nonatomic) IBOutlet UIButton *createChallengeButton;
@property (weak, nonatomic) IBOutlet UIButton *addActivityButton;
@property (weak, nonatomic) IBOutlet UIButton *showFriendsListViewButton;
@property (weak, nonatomic) IBOutlet UITableView *friendsPickerTable;
@property (weak, nonatomic) IBOutlet UITextField *challengeNameTextField;
@property (weak, nonatomic) IBOutlet UIButton *pickActivityButton;
@property (weak, nonatomic) IBOutlet UIButton *startDateCallendarButton;
@property (weak, nonatomic) IBOutlet UIButton *endDateCallendarButton;

@property (weak, nonatomic) IBOutlet UIButton *infoButton;
@property (weak, nonatomic) IBOutlet UITextView *infoView;

@property (strong,nonatomic) NSMutableArray *activityListArray;
@property (strong,nonatomic) NSMutableArray *addedActivityArray;
@property (strong,nonatomic) NSMutableArray *addedFriendsArray;

@property (strong,nonatomic) NSMutableArray *friendsList;
@property (strong,nonatomic) NSMutableArray *pickedFriendsArray;

@property (nonatomic,strong) UIActivityIndicatorView *activityIndicator;

// Calendar
@property (nonatomic, strong) PMCalendarController *startDateCalendar;
@property (nonatomic, strong) PMCalendarController *endDateCalendar;
@property (weak, nonatomic) IBOutlet UITextField *startDateTextField;
@property (weak, nonatomic) IBOutlet UITextField *endDateTextField;

@end

@implementation NewChallengeViewController


@synthesize activityListArray, addedActivityArray, addedFriendsArray;
@synthesize activityPicker,addActivityButton,addFriendsView;
@synthesize playersTable,activityTable;
@synthesize createChallengeButton,showFriendsListViewButton;
@synthesize friendsList;
@synthesize pickedFriendsArray;
@synthesize challengeNameTextField;
@synthesize pickActivityButton;
@synthesize activityIndicator;
@synthesize startDateCallendarButton,endDateCallendarButton,startDateCalendar,endDateCalendar;
@synthesize startDateTextField,endDateTextField;
@synthesize infoButton,infoView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Initializers
    self.addedActivityArray = [NSMutableArray array];
    self.friendsList = [NSMutableArray arrayWithArray:[User getInstance].friendsList];
    self.pickedFriendsArray = [NSMutableArray array];
    self.challengeNameTextField.delegate = self;
    self.activityPicker.hidden = YES;
    self.addActivityButton.hidden = YES;
    
    // Help/Info button & View
    self.infoView.hidden = YES;
    [Utils setMaskTo:self.infoView byRoundingCorners:UIRectCornerAllCorners];
    
    // Activity Indicator
    self.activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.activityIndicator.center = self.view.center;
    self.activityIndicator.color = [UIColor blueColor];
    [self.view addSubview: self.activityIndicator];
    
    [Utils setMaskTo:self.addFriendsView byRoundingCorners:UIRectCornerAllCorners];
    
    Activity *localActivityObj = [Activity getInstance];
    if ( [localActivityObj.activityDict count] == 0 )
        NSLog(@"Waiting to download the list of activities form the server.");
    
    
    self.activityListArray = [NSMutableArray arrayWithArray:[localActivityObj.activityDict allKeys]];
    [self.activityPicker reloadAllComponents];
    
    // Calendar startDate
    self.startDateCalendar = [[PMCalendarController alloc] initWithThemeName:@"default"];
    self.startDateCalendar.delegate = self;
    
    self.startDateCalendar.mondayFirstDayOfWeek = NO;
    self.startDateCalendar.allowsPeriodSelection = NO;
    
    // Calendar endDate
    self.endDateCalendar = [[PMCalendarController alloc] initWithThemeName:@"default"];
    self.endDateCalendar.delegate = self;
    
    self.endDateCalendar.mondayFirstDayOfWeek = NO;
    self.endDateCalendar.allowsPeriodSelection = NO;

}

- (IBAction)pickDateClicked:(UIButton*)sender
{
    if (sender == self.startDateCallendarButton)
        [self.startDateCalendar presentCalendarFromView:sender
              permittedArrowDirections:PMCalendarArrowDirectionAny
                             isPopover:YES
                              animated:YES];
    else
        [self.endDateCalendar presentCalendarFromView:sender
                               permittedArrowDirections:PMCalendarArrowDirectionAny
                                              isPopover:YES
                                               animated:YES];
 }

///////// Calendar METHODS ///////////////
- (void)calendarController:(PMCalendarController *)calendarController didChangePeriod:(PMPeriod *)newPeriod
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMM dd"];
    NSString *date = [dateFormatter stringFromDate: [calendarController.period startDate]];
    if (calendarController == self.startDateCalendar)
        self.startDateTextField.text = date;
    else
        self.endDateTextField.text = date;
    
    [self hideStuff];
}

- (void) hideStuff
{
    [self.view endEditing:YES];
    self.activityPicker.hidden = YES;
    self.addActivityButton.hidden = YES;
}

- (IBAction)infoButtonClicked:(id)sender
{
    [self hideStuff];
    
    if (self.infoView.hidden == YES)
    {
        [self.view bringSubviewToFront:self.infoView];
        self.infoView.hidden = NO;
    }
    else
        self.infoView.hidden = YES;
}


- (IBAction)showFriendsViewButton:(id)sender
{
    [self hideStuff];
    
    if (self.addFriendsView.hidden == YES)
    {
        [self.view bringSubviewToFront:self.addFriendsView];
        [self.view bringSubviewToFront:self.showFriendsListViewButton];
        self.addFriendsView.hidden = NO;
    }
    else
        self.addFriendsView.hidden = YES;
}

- (IBAction)pickActivityButtonClicked:(id)sender
{
    [self.view endEditing:YES];
    self.addFriendsView.hidden = YES;
    
    if (self.activityPicker.hidden == YES)
    {
        self.activityPicker.hidden = NO;
        self.addActivityButton.hidden = NO;
    }
    else
    {
        self.activityPicker.hidden = YES;
        self.addActivityButton.hidden = YES;
    }
}

- (IBAction) addActivityClicked:(id)sender
{
    [self.view endEditing:YES];
    
    NSInteger row = [self.activityPicker selectedRowInComponent:0];
    NSString *activity  = [self.activityListArray objectAtIndex:row];
 
    if ([self.addedActivityArray containsObject:activity])
    {
        [Utils alertStatus:@"Activity already added." :@"Not again.." :0];
        return;
    }
    
    [self.addedActivityArray addObject:activity];
    [self.activityTable reloadData];
    
    if([self.activityListArray count] <=0 )
        self.addActivityButton.enabled = NO;
}

// Dismiss the keyboard when the background is tapped
- (IBAction)backgroundTap:(id)sender
{
    [self hideStuff];
}

- (IBAction)createChallengeButtonClicked:(id)sender
{
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [gregorianCalendar components:NSDayCalendarUnit
                                                        fromDate:[self.startDateCalendar.period startDate]
                                                          toDate:[self.endDateCalendar.period startDate]
                                                         options:0];
    NSInteger daysInChallenge = [components day];
    components = [gregorianCalendar components:NSDayCalendarUnit
                                      fromDate:[NSDate date]
                                        toDate:[self.endDateCalendar.period startDate]
                                       options:0];
    NSInteger daysFromToday = [components day];
    
    if ([self.addedActivityArray count] <= 0 )
        [Utils alertStatus:@"Please add atleast one activity to the challenge." :@"Oops! Miss something ?" :0];
    else if ( [self.pickedFriendsArray count] <= 0 )
        [Utils alertStatus:@"Please add atleast one friend to the challenge." :@"Oops! Miss something ?" :0];
    else if ( [self.challengeNameTextField.text length] <= 0 )
        [Utils alertStatus:@"Please name your challenge." :@"Oops! Miss something ?" :0];
    else if ( [self.startDateTextField.text length] <= 0 )
        [Utils alertStatus:@"Please choose a start date for your challenge." :@"Oops! Miss something ?" :0];
    else if ( [self.endDateTextField.text length] <= 0 )
        [Utils alertStatus:@"Please choose an end date for your challenge." :@"Oops! Miss something ?" :0];
    else if ( [self.challengeNameTextField.text rangeOfString:@","].location != NSNotFound )
        [Utils alertStatus:@"Please choose a challenge name without commas." :@"Oops!" :0];
    else if ( daysInChallenge < 1 )
        [Utils alertStatus:@"Please choose an end date that falls after the start date." :@"Oops! Date issues.." :0];
    else if ( daysFromToday < 0 )
        [Utils alertStatus:@"Please choose an end date in the future." :@"Oops! Date issues.." :0];
    else
    {
        // Year
        NSDate *currentTime = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"YYYY"];
        NSString *year = [dateFormatter stringFromDate: currentTime] ;
        
        [dateFormatter setDateFormat:@"MMM dd"];
        NSString *fromCalDate = [dateFormatter stringFromDate: [self.startDateCalendar.period startDate]];
        NSString *toCalDate = [dateFormatter stringFromDate: [self.endDateCalendar.period startDate]];
        
        NSString *fromDate = fromDate = [NSString stringWithFormat:@"%@, %@ 00:00:01 AM",fromCalDate,year];
        NSString *toDate = [NSString stringWithFormat:@"%@, %@ 11:59:59 PM",toCalDate,year];
        
        // Construct the new challenge object
        Challenge *newChallenge = [[Challenge alloc] init];
        newChallenge.creatorId = [User getInstance].userEmail;
        newChallenge.name = self.challengeNameTextField.text;
        newChallenge.startDate = fromDate;
        newChallenge.endDate = toDate;
        
        NSMutableArray *tempFriendEmailArray = [NSMutableArray array];
        for (Friend *friendObj in self.pickedFriendsArray)
             [tempFriendEmailArray addObject:friendObj.email];
       
        // Add the app user to the list of users too (the challenge creator gets automatically added 
        [tempFriendEmailArray addObject:[User getInstance].userEmail];
            
        newChallenge.playersSet = [NSArray arrayWithArray:tempFriendEmailArray];
        newChallenge.activitySet = [NSArray arrayWithArray:self.addedActivityArray];
        
        NSError *error = nil;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:[newChallenge toNSDictionary] options:NSJSONWritingPrettyPrinted error:&error];
        if ([jsonData length] > 0 && error == nil)
        {
            NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            
            self.activityIndicator.hidden = NO;
            [self.activityIndicator startAnimating];
            self.view.userInteractionEnabled = NO;
            
            dispatch_queue_t queue = dispatch_get_global_queue(0,0);
            
            dispatch_async(queue, ^{
                MWBFService *service = [[MWBFService alloc] init];
                
                dispatch_sync(dispatch_get_main_queue(), ^{
    
                    if ([service addChallenge:jsonString] )
                    {
                        // Refresh the challenges list
                        [service getChallenges];
                        
                        [self.activityIndicator stopAnimating];
                        self.activityIndicator.hidden = YES;
                        self.view.userInteractionEnabled = YES;
                        
                        [Utils alertStatus:@"Now, it's time to get to work." :@"Wohoo! Challenge created." :0];
                        
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                    else
                        [Utils alertStatus:@"Unable to create challenge. Please try again." :@"Oops! Embarassing" :0];
                });
            });
        }
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // TODO add the challenge to the ChallegeViewControllers list
}

// Dismiss the keyboard when the GO button is hit
- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
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
        case 0: return 90;
        default: return 30;
    }
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont fontWithName:@"Trebuchet MS" size:15];
    
    label.text = self.activityListArray[row];
    
    return label;
}

///////// UITABLEVIEW METHODS /////////

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.activityTable)
        return [self.addedActivityArray count];
    else if (tableView == self.friendsPickerTable)
        return [self.friendsList count];
    else
        return [self.pickedFriendsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.activityTable)
    {
        static NSString *CellIdentifier = @"ActivityCell";
    
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        NSString *text =[self.addedActivityArray objectAtIndex:indexPath.row];
        cell.textLabel.text = text;
    
        return cell;
    }
    else if (tableView == self.playersTable)
    {
        static NSString *CellIdentifier = @"FriendsPickedCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        Friend *friendObj = [self.pickedFriendsArray objectAtIndex:indexPath.row];
        cell.textLabel.text = friendObj.firstName;
        
        return cell;
    }
    else
    {
        static NSString *CellIdentifier = @"FriendsPickerCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        Friend *friendObj = [self.friendsList objectAtIndex:indexPath.row];
        cell.textLabel.text = friendObj.firstName;
        
        return cell;
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.friendsPickerTable)
        return NO;
    else
        return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.friendsPickerTable)
    {
        Friend *pickedFriend = [self.friendsList objectAtIndex:indexPath.row];
        
        [self.pickedFriendsArray addObject:pickedFriend];
        [self.playersTable reloadData];
        
        [self.friendsList removeObject:pickedFriend];
        [self.friendsPickerTable reloadData];
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.activityTable)
    {
        if (editingStyle == UITableViewCellEditingStyleDelete)
        {
            // Delete the row from the array
            NSString *activity = [self.addedActivityArray objectAtIndex:indexPath.row];
            [self.addedActivityArray removeObject:activity];
          
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
    }
    else if (tableView == self.playersTable)
    {
        if (editingStyle == UITableViewCellEditingStyleDelete)
        {
            // Delete the row from the array
            Friend *pickedFriend = [self.pickedFriendsArray objectAtIndex:indexPath.row];
            [self.pickedFriendsArray removeObject:pickedFriend];
            
            // Add the friend to the friends list
            [self.friendsList addObject:pickedFriend];
            [self.friendsPickerTable reloadData];
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
    }
}

@end
