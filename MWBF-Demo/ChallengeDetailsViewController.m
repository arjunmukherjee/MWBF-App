//
//  ChallengeDetailsViewController.m
//  MWBF-Demo
//
//  Created by ARJUN MUKHERJEE on 8/24/14.
//  Copyright (c) 2014 ___Arjun Mukherjee___. All rights reserved.
//

#import "ChallengeDetailsViewController.h"
#import "EColumnChart.h"
#import "EFloatBox.h"
#import "Friend.h"
#import "ActivityNotificationCell.h"

#define PROGRESS_INDEX 0
#define DETAILS_INDEX 1
#define MESSAGE_BOARD_INDEX 2



@interface ChallengeDetailsViewController ()
@property (weak, nonatomic) IBOutlet UINavigationItem *navigationBar;
@property (strong, nonatomic) EColumnChart *eColumnChart;
@property (weak, nonatomic) IBOutlet UIView *activityBarView;
@property (nonatomic, strong) NSArray *data;
@property (nonatomic, strong) EFloatBox *eFloatBox;
@property (nonatomic, strong) EColumn *eColumnSelected;
@property (nonatomic, strong) UIColor *tempColor;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet UITableView *activityTableView;
@property (weak, nonatomic) IBOutlet UILabel *endDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *startDateLabel;
@property (weak, nonatomic) IBOutlet UIView *challengeDetailsView;
@property (weak, nonatomic) IBOutlet UILabel *positionLabel;
@property (weak, nonatomic) IBOutlet UITableView *messageTableView;
@property (strong, nonatomic) NSMutableArray *messagesArray;
@property (strong, nonatomic) NSString *userFirstName;
@property (nonatomic) NSInteger todayIndex;
@property (nonatomic) NSInteger yesterdayIndex;

@end

@implementation ChallengeDetailsViewController

@synthesize challenge;
@synthesize navigationBar;
@synthesize activityBarView, data, eColumnChart, eColumnSelected,eFloatBox,tempColor;
@synthesize activityTableView;
@synthesize startDateLabel,endDateLabel,challengeDetailsView;
@synthesize positionLabel;
@synthesize messagesArray;
@synthesize userFirstName;
@synthesize yesterdayIndex;
@synthesize todayIndex;

@synthesize messageTableView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Initializers
    self.navigationBar.title = self.challenge.name;
    self.messagesArray = self.challenge.messageList;
    [Utils changeAbsoluteDateToRelativeDays:self.messagesArray];
    
    // Get the first name only
    NSArray *tempArray = [[User getInstance].userName componentsSeparatedByString:@" "];
    self.userFirstName = tempArray[0];
    
    self.challengeDetailsView.hidden = YES;
    self.messageTableView.hidden = YES;
    
    self.todayIndex = 0;
    self.yesterdayIndex = 0;
    
    // Set the start and end dates
    NSArray *tempDateArr = [self.challenge.startDate componentsSeparatedByString:@" "];
    self.startDateLabel.text = [NSString stringWithFormat:@"%@ %@%@",tempDateArr[0],tempDateArr[1],tempDateArr[2]];
    tempDateArr = [self.challenge.endDate componentsSeparatedByString:@" "];
    self.endDateLabel.text = [NSString stringWithFormat:@"%@ %@%@",tempDateArr[0],tempDateArr[1],tempDateArr[2]];
    
    // Set your position
    self.positionLabel.text = self.challenge.yourPosition;
    
    // Get the list of friends
    NSArray *friendsList = [NSArray arrayWithArray:[User getInstance].friendsList];
    
    // Parse the string and sort the points
    NSMutableArray *pointsArr = [NSMutableArray array];
    NSMutableArray *playersArr = [NSMutableArray array];
    for (id playerPoints in self.challenge.playersSet)
    {
        NSArray *tempArr = [playerPoints componentsSeparatedByString:@","];
        CGFloat points =[tempArr[1] floatValue];
        NSNumber *num = [NSNumber numberWithFloat:points];
        [pointsArr addObject:num];
        
        NSString *friendEmail = [NSString stringWithFormat:@"%@",tempArr[0]];
        // Get the friends first name from the friends list
        for (Friend *friend in friendsList)
        {
            if ( [friendEmail isEqualToString:friend.email] )
               [playersArr addObject:friend.firstName];
        }
        
        if ( [friendEmail isEqualToString:[User getInstance].userEmail])
            [playersArr addObject:@"You"];
    }
    
    
    // COLUMN CHART by Progress
    NSMutableArray *tempAct = [NSMutableArray array];
    for (int i = 0; i < [pointsArr count]; i++)
    {
        EColumnDataModel *eColumnDataModel = [[EColumnDataModel alloc] initWithLabel:playersArr[i] value:[pointsArr[i] floatValue] index:i unit:@""];
        [tempAct addObject:eColumnDataModel];
    }
    self.data = [NSArray arrayWithArray:tempAct];
    self.eColumnChart = [[EColumnChart alloc] initWithFrame:self.activityBarView.bounds];
    [self.eColumnChart setNormalColumnColor:[UIColor purpleColor]];
    [self.eColumnChart setColumnsIndexStartFromLeft:YES];
    [self.eColumnChart setDelegate:self];
    [self.eColumnChart setDataSource:self];
    [self.activityBarView addSubview:self.eColumnChart];
}

- (void) viewWillDisappear:(BOOL)animated
{
    // TODO : Send the messages up to the server to save
}

- (void) viewWillAppear:(BOOL)animated
{
    self.todayIndex = 0;
    self.yesterdayIndex = 0;
    
    self.messagesArray = self.challenge.messageList;
    [Utils changeAbsoluteDateToRelativeDays:self.messagesArray];
    
    if ([self.messagesArray count] > 0)
        [self.messageTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:([self.messagesArray count]*2)-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:animated];
    [self.messageTableView reloadData];
}



// Dismiss the keyboard when the background is tapped
- (IBAction)backgroundTap:(id)sender
{
    [self.view endEditing:YES];
}

- (IBAction)segmentedControlClicked
{
    if (self.segmentedControl.selectedSegmentIndex == PROGRESS_INDEX)
    {
        self.activityBarView.hidden = NO;
        self.challengeDetailsView.hidden = YES;
        self.messageTableView.hidden = YES;
    }
    else if (self.segmentedControl.selectedSegmentIndex == DETAILS_INDEX)
    {
        self.activityBarView.hidden = YES;
        self.challengeDetailsView.hidden = NO;
        self.messageTableView.hidden = YES;
    }
    else
    {
        self.activityBarView.hidden = YES;
        self.challengeDetailsView.hidden = YES;
        self.messageTableView.hidden = NO;
    }
}

///////// UITABLEVIEW METHODS /////////

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.activityTableView)
        return [self.challenge.activitySet count];
    else
        return ([self.messagesArray count]*2);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.messageTableView)
    {
        if (indexPath.row % 2 == 1)
            return 50.0;
        else
            return 4.0;
    }
    else
        return 37;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.activityTableView)
    {
        static NSString *CellIdentifier = @"ActivityCell";

        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        NSString *activity = [self.challenge.activitySet objectAtIndex:indexPath.row];
        cell.textLabel.text = activity;
        cell.textLabel.textColor = [UIColor blueColor];
        return cell;
    }
    else
    {
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        if (indexPath.row % 2 == 1)
        {
            static NSString *CellIdentifier = @"MessageCell";
            ActivityNotificationCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            cell.backgroundColor = CELL_COLOR;
            cell.activityMessage.font = [UIFont fontWithName:@"Trebuchet MS" size:13];
            NSString *message = [self.messagesArray objectAtIndex:(indexPath.row/2)];
            
            NSRange start = [message rangeOfString:@" "];
            NSString *activityMessage = @"";
            NSString *name = @"";
            if (start.location != NSNotFound)
            {
                activityMessage = [message substringFromIndex:start.location+1];
                name = [message substringToIndex:start.location];
            }
            
            cell.activityMessage.text = activityMessage;
            cell.userName.text = name;
            cell.activityMessage.textColor = [UIColor purpleColor];
            NSString *imageName = [Utils getImageNameFromMessage:[self.messagesArray objectAtIndex:(indexPath.row/2)]];
            UIImage *activityImg = [UIImage imageNamed:imageName];
            [cell.activityPic setImage:activityImg forState:UIControlStateNormal];
            [cell.activityPic setBackgroundImage:activityImg forState:UIControlStateNormal];
            
            return cell;
        }
        else
        {
            static NSString *CellIdentifier2 = @"cell2";
            UITableViewCell *cell2 = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier2];
            if (cell2 == nil)
                cell2 = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                               reuseIdentifier:CellIdentifier2];
            cell2.backgroundColor = [UIColor clearColor];
            
            // Mark to differentiate the today cells
            if (self.todayIndex == 0)
            {
               NSString *nextMessage = [self.messagesArray objectAtIndex:(indexPath.row/2)];
               NSRange today = [nextMessage rangeOfString:@" today"];
               if (today.location != NSNotFound)
               {
                   cell2.backgroundColor = TODAY_COLOR;
                   self.todayIndex = (indexPath.row/2);
               }
            }
            else if( (indexPath.row/2) == self.todayIndex)
               cell2.backgroundColor = TODAY_COLOR;
            
            return cell2;
        }
    }
}



- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}



///////// COLUMN CHART DELEGATE METHODS
#pragma -mark- EColumnChartDataSource
- (NSInteger)numberOfColumnsInEColumnChart:(EColumnChart *)eColumnChartLcl
{
    NSArray *tempData = [NSArray array];
    tempData = self.data;
    
    return [tempData count];
}

- (NSInteger)numberOfColumnsPresentedEveryTime:(EColumnChart *) eColumnChartLcl
{
    NSArray *tempData = [NSArray array];
    tempData = self.data;
    
    return [tempData count];
}

- (EColumnDataModel *)highestValueEColumnChart:(EColumnChart *)eColumnChartLcl
{
    EColumnDataModel *maxDataModel = nil;
    float maxValue = -FLT_MIN;
    
    NSArray *tempData = [NSArray array];
    tempData = self.data;
    
    for (EColumnDataModel *dataModel in tempData)
    {
        if (dataModel.value > maxValue)
        {
            maxValue = dataModel.value;
            maxDataModel = dataModel;
        }
    }
    return maxDataModel;
}

- (EColumnDataModel *)eColumnChart:(EColumnChart *)eColumnChartLcl valueForIndex:(NSInteger)index
{
    NSArray *tempData = [NSArray array];
    tempData = self.data;
    
    if (index >= [tempData count] || index < 0) return nil;
    return [tempData objectAtIndex:index];
}

#pragma -mark- EColumnChartDelegate
- (void)eColumnChart:(EColumnChart *) columnChartLcl didSelectColumn:(EColumn *)eColumn
{
    if (self.eColumnSelected)
        self.eColumnSelected.barColor = self.tempColor;
    
    self.eColumnSelected = eColumn;
    self.tempColor = eColumn.barColor;
    eColumn.barColor = [UIColor purpleColor];
    
    NSString *title = @"";
    
    CGFloat eFloatBoxX = eColumn.frame.origin.x + eColumn.frame.size.width * 1;
    CGFloat eFloatBoxY = eColumn.frame.origin.y + eColumn.frame.size.height * (1-eColumn.grade);
    
    if (self.eFloatBox)
        [self.eFloatBox removeFromSuperview];
    
    self.eFloatBox = [[EFloatBox alloc] initWithPosition:CGPointMake(eFloatBoxX, eFloatBoxY) value:eColumn.eColumnDataModel.value unit:@"Points" title:title];
    self.eFloatBox.alpha = 0.0;
    [columnChartLcl addSubview:self.eFloatBox];
    
    eFloatBoxY -= (self.eFloatBox.frame.size.height + eColumn.frame.size.width * 0.25);
    self.eFloatBox.frame = CGRectMake(eFloatBoxX, eFloatBoxY, self.eFloatBox.frame.size.width, self.eFloatBox.frame.size.height);
    self.eFloatBox.alpha = 1.0;
    [columnChartLcl addSubview:self.eFloatBox];
}

- (void)eColumnChart:(EColumnChart *) columnChartLcl fingerDidEnterColumn:(EColumn *)eColumn
{
    CGFloat eFloatBoxX = eColumn.frame.origin.x + eColumn.frame.size.width * 1;
    CGFloat eFloatBoxY = eColumn.frame.origin.y + eColumn.frame.size.height * (1-eColumn.grade);
    if (self.eFloatBox)
    {
        [self.eFloatBox removeFromSuperview];
        self.eFloatBox.frame = CGRectMake(eFloatBoxX, eFloatBoxY, self.eFloatBox.frame.size.width, self.eFloatBox.frame.size.height);
        [self.eFloatBox setValue:eColumn.eColumnDataModel.value];
        [columnChartLcl addSubview:self.eFloatBox];
    }
    else
    {
        NSString *title = @"";
        self.eFloatBox = [[EFloatBox alloc] initWithPosition:CGPointMake(eFloatBoxX, eFloatBoxY) value:eColumn.eColumnDataModel.value unit:@"Points" title:title];
        self.eFloatBox.alpha = 0.0;
        [columnChartLcl addSubview:self.eFloatBox];
    }
    
    eFloatBoxY -= (self.eFloatBox.frame.size.height + eColumn.frame.size.width * 0.25);
    self.eFloatBox.frame = CGRectMake(eFloatBoxX, eFloatBoxY, self.eFloatBox.frame.size.width, self.eFloatBox.frame.size.height);
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionTransitionNone animations:^{
        self.eFloatBox.alpha = 1.0;
    } completion:^(BOOL finished) {
    }];
}

- (void)eColumnChart:(EColumnChart *)eColumnChart fingerDidLeaveColumn:(EColumn *)eColumn
{
}

- (void)fingerDidLeaveEColumnChart:(EColumnChart *)eColumnChart
{
}




@end
