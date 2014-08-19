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

@interface NewChallengeViewController ()
@property (weak, nonatomic) IBOutlet UIPickerView *activityPicker;
@property (weak, nonatomic) IBOutlet UIView *addFriendsView;
@property (weak, nonatomic) IBOutlet UITableView *playersTable;
@property (weak, nonatomic) IBOutlet UITableView *activityTable;
@property (weak, nonatomic) IBOutlet UIButton *createChallengeButton;
@property (weak, nonatomic) IBOutlet UIButton *addActivityButton;
@property (weak, nonatomic) IBOutlet UIButton *addFriendsButton;
@property (weak, nonatomic) IBOutlet UIButton *showFriendsListViewButton;

@property (strong,nonatomic) NSMutableArray *activityListArray;
@property (strong,nonatomic) NSMutableArray *addedActivityArray;
@property (strong,nonatomic) NSMutableArray *addedFriendsArray;

@end

@implementation NewChallengeViewController


@synthesize activityListArray, addedActivityArray, addedFriendsArray;
@synthesize activityPicker,addActivityButton,addFriendsButton,addFriendsView;
@synthesize playersTable,activityTable;
@synthesize createChallengeButton,showFriendsListViewButton;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Initializers
    self.addedActivityArray = [NSMutableArray array];
    
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


- (IBAction) addActivityClicked:(id)sender
{
    NSInteger row = [self.activityPicker selectedRowInComponent:0];
    NSString *activity  = [self.activityListArray objectAtIndex:row];
 
    if ([self.addedActivityArray containsObject:activity])
    {
        [Utils alertStatus:@"Activity already added." :@"It's done" :0];
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
    self.addFriendsView.hidden = YES;
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
    return [self.addedActivityArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ActivityCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    NSString *text =[self.addedActivityArray objectAtIndex:indexPath.row];
    cell.textLabel.text = text;
    
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
        NSString *activity = [self.addedActivityArray objectAtIndex:indexPath.row];
        [self.addedActivityArray removeObject:activity];
      
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}



@end
