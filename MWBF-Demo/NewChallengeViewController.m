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
@property (weak, nonatomic) IBOutlet UITextField *startDateTextField;
@property (weak, nonatomic) IBOutlet UITextField *endDateTextField;
@property (weak, nonatomic) IBOutlet UIButton *pickActivityButton;

@property (strong,nonatomic) NSMutableArray *activityListArray;
@property (strong,nonatomic) NSMutableArray *addedActivityArray;
@property (strong,nonatomic) NSMutableArray *addedFriendsArray;

@property (strong,nonatomic) NSMutableArray *friendsList;
@property (strong,nonatomic) NSMutableArray *pickedFriendsArray;

@property (nonatomic,strong) UIActivityIndicatorView *activityIndicator;

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

}
- (IBAction)showFriendsViewButton:(id)sender
{
    if (self.addFriendsView.hidden == YES)
        self.addFriendsView.hidden = NO;
    else
        self.addFriendsView.hidden = YES;
}

- (IBAction)pickActivityButtonClicked:(id)sender
{
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
    [self.view endEditing:YES];
    self.activityPicker.hidden = YES;
    self.addActivityButton.hidden = YES;
}

- (IBAction)createChallengeButtonClicked:(id)sender
{
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
        [Utils alertStatus:@"Please choose a challenge name without commas." :@"Oops! Not allowed ?" :0];
    else
    {
        // Year
        NSDate *currentTime = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"YYYY"];
        NSString *year = [dateFormatter stringFromDate: currentTime] ;
        
        // Month
        [dateFormatter setDateFormat:@"MM"];
        NSInteger monthInteger = [[dateFormatter stringFromDate: currentTime] integerValue];
        NSString *month  = [Utils getMonthStringFromInt:monthInteger];
        
        NSString *fromDate = fromDate = [NSString stringWithFormat:@"%@ 01, %@ 00:00:01 AM",month,year];
        NSString *toDate = [NSString stringWithFormat:@"%@ 31, %@ 11:59:59 PM",month,year];
        
        // Construct the new challenge object
        Challenge *newChallenge = [[Challenge alloc] init];
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
                    
                    [self.activityIndicator stopAnimating];
                    self.activityIndicator.hidden = YES;
                    self.view.userInteractionEnabled = YES;
                    
                    if ([service addChallenge:jsonString] )
                    {
                        [Utils alertStatus:@"Now, it's time to get to work." :@"Wohoo! Challenge created." :0];
                        [self performSegueWithIdentifier:@"NewChallengeAdded" sender:self];
                    }
                    else
                        [Utils alertStatus:@"Unable to create challenge. Please try again." :@"Oops! Embarassing" :0];
                });
            });
        }
    }
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
