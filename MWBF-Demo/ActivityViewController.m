//
//  ActivityViewController.m
//  MWBF-Demo
//
//  Created by ARJUN MUKHERJEE on 8/5/14.
//  Copyright (c) 2014 ___Arjun Mukherjee___. All rights reserved.
//

#import "ActivityViewController.h"
#import "DLPieChart.h"
#import "Activity.h"
#import "MWBFActivities.h"
#import "ActivityStatCell.h"
#import "UserActivity.h"
#import "EColumnChart.h"
#import "EFloatBox.h"

#define PIE_INDEX 0
#define BAR_INDEX 1
#define TABLE_INDEX 2

#define EXERCISE_INDEX 0
#define COLUMNS_TO_DISPLAY 7

@interface ActivityViewController ()
@property (strong,nonatomic) IBOutlet DLPieChart *activityPieView;
@property (strong,nonatomic) IBOutlet DLPieChart *activityPieViewByTime;


@property (weak, nonatomic) IBOutlet UIView *activityBarView;
@property (weak, nonatomic) IBOutlet UIView *activityBarViewByTime;
@property (weak, nonatomic) IBOutlet UISegmentedControl *chartTypeSegmentedControl;
@property (weak, nonatomic) IBOutlet UISegmentedControl *aggregationTypeSegmentedControl;

@property (strong,nonatomic) NSMutableArray *userActivityArray;

@property (weak, nonatomic) IBOutlet UILabel *barResultsLabel;
@property (weak, nonatomic) IBOutlet UITableView *activityTable;
@property (weak, nonatomic) IBOutlet UILabel *activityNameHeaderLabel;
@property (weak, nonatomic) IBOutlet UILabel *activityValueHeaderLabel;
@property (weak, nonatomic) IBOutlet UILabel *pointsHeaderLabel;

@property (strong, nonatomic) EColumnChart *eColumnChart;
@property (nonatomic, strong) NSArray *data;
@property (nonatomic, strong) EFloatBox *eFloatBox;
@property (nonatomic, strong) EColumn *eColumnSelected;
@property (nonatomic, strong) UIColor *tempColor;

@property (strong, nonatomic) EColumnChart *eColumnChartByTime;
@property (nonatomic, strong) NSArray *columnChartdataByTime;
@property (nonatomic, strong) EFloatBox *eFloatBoxByTime;
@property (nonatomic, strong) EColumn *eColumnSelectedByTime;
@property (nonatomic, strong) UIColor *tempColorByTime;

@property (nonatomic,strong) NSMutableArray *pointsArray;
@property (nonatomic,strong) NSMutableArray *labelArray;
@property (nonatomic,strong) NSMutableArray *labelArrayWithValues;
@property (nonatomic,strong) NSMutableArray *unitsArray;

@property (nonatomic,strong) NSMutableArray *pointsArrayByTime;
@property (nonatomic,strong) NSMutableArray *labelArrayByTime;

@property (weak, nonatomic) IBOutlet UINavigationItem *navigationBar;
@property (weak, nonatomic) IBOutlet UILabel *totalHeaderLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalValueLabel;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;
@property (weak, nonatomic) IBOutlet UIButton *leftButton;
@property (weak, nonatomic) IBOutlet UILabel *restDaysHeaderLabel;
@property (weak, nonatomic) IBOutlet UILabel *restDaysValueLabel;

// Individual activity details
@property (weak, nonatomic) IBOutlet UIView *activityDetailsView;

// Multiple labels
@property (weak, nonatomic) IBOutlet UILabel *activityOneHeaderLabel;
@property (weak, nonatomic) IBOutlet UILabel *activityTwoHeaderLabel;
@property (weak, nonatomic) IBOutlet UILabel *activityThreeHeaderLabel;
@property (weak, nonatomic) IBOutlet UILabel *activityFourHeaderLabel;
@property (weak, nonatomic) IBOutlet UILabel *activityFiveHeaderLabel;
@property (weak, nonatomic) IBOutlet UILabel *activitySixHeaderLabel;
@property (weak, nonatomic) IBOutlet UILabel *activitySevenHeaderLabel;
@property (weak, nonatomic) IBOutlet UILabel *activityEightHeaderLabel;
@property (weak, nonatomic) IBOutlet UILabel *activityNineHeaderLabel;
@property (weak, nonatomic) IBOutlet UILabel *activityTenHeaderLabel;

@property (weak, nonatomic) IBOutlet UILabel *activityOneValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *activityTwoValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *activityThreeValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *activityFourValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *activityFiveValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *activitySixValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *activitySevenValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *activityEightValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *activityNineValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *activityTenValueLabel;

@property (strong,nonatomic) NSMutableDictionary *activityLabelsDict;
@property (strong,nonatomic) NSMutableDictionary *activityHeaderLabelsDict;



@property float totalPoints;

@end

@implementation ActivityViewController

@synthesize userActivitiesByActivityJsonArray;
@synthesize userActivitiesByTimeJsonArray;
@synthesize activityDateRangeLabel;
@synthesize activityDateString;
@synthesize activityPieView,activityPieViewByTime, activityBarView;
@synthesize userActivityArray;
@synthesize chartTypeSegmentedControl;
@synthesize aggregationTypeSegmentedControl;
@synthesize barResultsLabel;

@synthesize eColumnChart, eColumnChartByTime;
@synthesize data,eFloatBox,eColumnSelected,tempColor, pointsArray, labelArray, labelArrayWithValues, unitsArray;
@synthesize pointsArrayByTime,labelArrayByTime;

@synthesize activityBarViewByTime;
@synthesize columnChartdataByTime,eFloatBoxByTime,eColumnSelectedByTime,tempColorByTime;
@synthesize title;
@synthesize navigationBar;
@synthesize totalPoints,totalHeaderLabel,totalValueLabel;
@synthesize rightButton,leftButton;
@synthesize restDaysHeaderLabel,restDaysValueLabel,numberOfRestDays;
@synthesize activityLabelsDict;
@synthesize activityHeaderLabelsDict;

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ( [self.title length] > 0 )
        self.navigationBar.title = self.title;
    else
        self.navigationBar.title = @"My Stats";
    
    self.activityPieView.hidden = NO;
    self.activityPieViewByTime.hidden = YES;
    self.activityBarView.hidden = YES;
    self.barResultsLabel.hidden = YES;
    self.activityBarViewByTime.hidden = YES;
    self.activityDetailsView.hidden = YES;
    
    // Hide the table
    [self hideTableDislplay];
    
    [self resetActivityLabels];
    self.activityLabelsDict = [NSMutableDictionary dictionary];
    self.activityHeaderLabelsDict = [NSMutableDictionary dictionary];
    [self.activityLabelsDict setObject:self.activityOneValueLabel forKey:@"1"];
    [self.activityHeaderLabelsDict setObject:self.activityOneHeaderLabel forKey:@"1"];
    [self.activityLabelsDict setObject:self.activityTwoValueLabel forKey:@"2"];
    [self.activityHeaderLabelsDict setObject:self.activityTwoHeaderLabel forKey:@"2"];
    [self.activityLabelsDict setObject:self.activityThreeValueLabel forKey:@"3"];
    [self.activityHeaderLabelsDict setObject:self.activityThreeHeaderLabel forKey:@"3"];
    [self.activityLabelsDict setObject:self.activityFourValueLabel forKey:@"4"];
    [self.activityHeaderLabelsDict setObject:self.activityFourHeaderLabel forKey:@"4"];
    [self.activityLabelsDict setObject:self.activityFiveValueLabel forKey:@"5"];
    [self.activityHeaderLabelsDict setObject:self.activityFiveHeaderLabel forKey:@"5"];
    [self.activityLabelsDict setObject:self.activitySixValueLabel forKey:@"6"];
    [self.activityHeaderLabelsDict setObject:self.activitySixHeaderLabel forKey:@"6"];
    [self.activityLabelsDict setObject:self.activitySevenValueLabel forKey:@"7"];
    [self.activityHeaderLabelsDict setObject:self.activitySevenHeaderLabel forKey:@"7"];
    [self.activityLabelsDict setObject:self.activityEightValueLabel forKey:@"8"];
    [self.activityHeaderLabelsDict setObject:self.activityEightHeaderLabel forKey:@"8"];
    [self.activityLabelsDict setObject:self.activityNineValueLabel forKey:@"9"];
    [self.activityHeaderLabelsDict setObject:self.activityNineHeaderLabel forKey:@"9"];
    [self.activityLabelsDict setObject:self.activityTenValueLabel forKey:@"10"];
    [self.activityHeaderLabelsDict setObject:self.activityTenHeaderLabel forKey:@"10"];
    
    // Initializations
    self.userActivityArray = [NSMutableArray array];
    self.pointsArray = [NSMutableArray array];
    self.labelArray = [NSMutableArray array];
    self.labelArrayWithValues = [NSMutableArray array];
    self.unitsArray = [NSMutableArray array];
    self.pointsArrayByTime = [NSMutableArray array];
    self.labelArrayByTime = [NSMutableArray array];
    activityDateRangeLabel.text = activityDateString;
    self.restDaysValueLabel.text = self.numberOfRestDays;
    
    // The total points
    self.totalPoints = 0;
    
    // Right button to move the bar chart
    self.rightButton.hidden = YES;
    self.leftButton.hidden = YES;
    
    
    Activity *activityList = [Activity getInstance];
    
    // Convert the jsonArrays to object arrays
    self.userActivityArray = [Utils convertJsonArrayByActivityToActivityObjectArrayWith:self.userActivitiesByActivityJsonArray];
    
    //NSLog(@"ArrActNorm [%@]",self.userActivityArray);
    //NSLog(@"ArrAct [%@]",self.userActivitiesByActivityJsonArray);
    
    [Utils convertJsonArrayByTimeToActivityObjectArrayWith:self.userActivitiesByTimeJsonArray withLabelArray:self.labelArrayByTime withPointsArray:self.pointsArrayByTime];
    
    // Sort the activites by the total points
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"points" ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    NSArray *sortedArray = [self.userActivityArray sortedArrayUsingDescriptors:sortDescriptors];
    self.userActivityArray = [NSMutableArray arrayWithArray:sortedArray];
    
    for (UserActivity *uaObj in self.userActivityArray)
    {
        NSString *label = [NSString stringWithFormat:@"%@ %@",uaObj.activity,uaObj.activityValue];
        MWBFActivities *mwbfActivity = [activityList.activityDict objectForKey:uaObj.activity];
        
        [self.pointsArray addObject:uaObj.points];
        [self.labelArrayWithValues addObject:label];
        [self.labelArray addObject:uaObj.activity];
        
        if ( mwbfActivity != nil )
            [self.unitsArray addObject:mwbfActivity.measurementUnits];
        else
            [self.unitsArray addObject:@" "];
        
        float points = [uaObj.points floatValue];
        self.totalPoints = self.totalPoints + points;
    }

    // COLUMN CHART by Activity
    NSMutableArray *tempAct = [NSMutableArray array];
    for (int i = 0; i < [self.userActivityArray count]; i++)
    {
        EColumnDataModel *eColumnDataModel = [[EColumnDataModel alloc] initWithLabel:self.labelArray[i] value:[self.pointsArray[i] floatValue] index:i unit:@""];
        [tempAct addObject:eColumnDataModel];
    }
    self.data = [NSArray arrayWithArray:tempAct];
    self.eColumnChart = [[EColumnChart alloc] initWithFrame:self.activityBarView.bounds];
    [self.eColumnChart setNormalColumnColor:[UIColor purpleColor]];
    [self.eColumnChart setColumnsIndexStartFromLeft:YES];
    [self.eColumnChart setDelegate:self];
    [self.eColumnChart setDataSource:self];
    [self.activityBarView addSubview:self.eColumnChart];
    
   
    // COLUMN CHART by Time
    NSMutableArray *tempTime = [NSMutableArray array];
    for (int i = 0; i < [self.labelArrayByTime count]; i++)
    {
        EColumnDataModel *eColumnDataModel = [[EColumnDataModel alloc] initWithLabel:self.labelArrayByTime[i] value:[self.pointsArrayByTime[i] floatValue] index:i unit:@""];
        [tempTime addObject:eColumnDataModel];
    }
    if ([self.labelArrayByTime count] > 0)
    {
        self.columnChartdataByTime = [NSArray arrayWithArray:tempTime];
        self.eColumnChartByTime = [[EColumnChart alloc] initWithFrame:self.activityBarViewByTime.bounds];
        [self.eColumnChartByTime setNormalColumnColor:[UIColor purpleColor]];
        [self.eColumnChartByTime setColumnsIndexStartFromLeft:YES];
        [self.eColumnChartByTime setDelegate:self];
        [self.eColumnChartByTime setDataSource:self];
        [self.activityBarViewByTime addSubview:self.eColumnChartByTime];
    }
    
    // PIE CHART by Activity
    [self.activityPieView renderInLayer:self.activityPieView dataArray:self.pointsArray labelArray:self.labelArrayWithValues];
    
    // PIE CHART by Time
    if ([self.labelArrayByTime count] > 0)
        [self.activityPieViewByTime renderInLayer:self.activityPieViewByTime dataArray:self.pointsArrayByTime labelArray:self.labelArrayByTime];
}

- (void) resetActivityLabels
{
    self.activityOneValueLabel.text = @"";
    self.activityTwoValueLabel.text = @"";
    self.activityThreeValueLabel.text = @"";
    self.activityFourValueLabel.text = @"";
    self.activityFiveValueLabel.text = @"";
    self.activitySixValueLabel.text = @"";
    self.activitySevenValueLabel.text = @"";
    self.activityEightValueLabel.text = @"";
    self.activityNineValueLabel.text = @"";
    self.activityTenValueLabel.text = @"";
    
    self.activityOneValueLabel.hidden = YES;
    self.activityTwoValueLabel.hidden = YES;
    self.activityThreeValueLabel.hidden = YES;
    self.activityFourValueLabel.hidden = YES;
    self.activityFiveValueLabel.hidden = YES;
    self.activitySixValueLabel.hidden = YES;
    self.activitySevenValueLabel.hidden = YES;
    self.activityEightValueLabel.hidden = YES;
    self.activityNineValueLabel.hidden = YES;
    self.activityTenValueLabel.hidden = YES;
    
    self.activityOneHeaderLabel.hidden = YES;
    self.activityTwoHeaderLabel.hidden = YES;
    self.activityThreeHeaderLabel.hidden = YES;
    self.activityFourHeaderLabel.hidden = YES;
    self.activityFiveHeaderLabel.hidden = YES;
    self.activitySixHeaderLabel.hidden = YES;
    self.activitySevenHeaderLabel.hidden = YES;
    self.activityEightHeaderLabel.hidden = YES;
    self.activityNineHeaderLabel.hidden = YES;
    self.activityTenHeaderLabel.hidden = YES;
}

- (IBAction)segmentedControlClicked
{
    [self hideTableDislplay];
    
    // Buttons only applicable to the bar chart
    self.rightButton.hidden = YES;
    self.leftButton.hidden = YES;
    
    if (self.chartTypeSegmentedControl.selectedSegmentIndex == PIE_INDEX)
    {
        self.activityBarView.hidden = YES;
        self.activityBarViewByTime.hidden = YES;
        
        if (self.aggregationTypeSegmentedControl.selectedSegmentIndex == EXERCISE_INDEX)
        {
            self.activityPieView.hidden = NO;
            self.activityPieViewByTime.hidden = YES;
        }
        else
        {
            self.activityPieView.hidden = YES;
            self.activityPieViewByTime.hidden = NO;
            self.activityDetailsView.hidden = NO;
        }
    }
    else if (self.chartTypeSegmentedControl.selectedSegmentIndex == BAR_INDEX)
    {
        self.activityPieView.hidden = YES;
        self.activityPieViewByTime.hidden = YES;
        self.rightButton.hidden = NO;
        self.leftButton.hidden = NO;
        
        
        if (self.aggregationTypeSegmentedControl.selectedSegmentIndex == EXERCISE_INDEX)
        {
            self.activityBarView.hidden = NO;
            self.barResultsLabel.hidden = NO;
            
            self.activityBarViewByTime.hidden = YES;
        }
        else
        {
            self.activityBarViewByTime.hidden = NO;
            self.activityBarView.hidden = YES;
            self.barResultsLabel.hidden = YES;
            self.activityDetailsView.hidden = NO;
        }
    }
    else // Table
    {
        self.activityPieView.hidden = YES;
        self.activityPieViewByTime.hidden = YES;
        self.activityBarView.hidden = YES;
        self.activityBarViewByTime.hidden = YES;
        [self showTableDislplay];
        
        self.aggregationTypeSegmentedControl.selectedSegmentIndex = 0;
    }
}

- (void) showTableDislplay
{
    self.activityTable.hidden = NO;
    self.activityNameHeaderLabel.hidden = NO;
    self.activityValueHeaderLabel.hidden = NO;
    self.pointsHeaderLabel.hidden = NO;
    self.totalValueLabel.hidden = NO;
    self.totalHeaderLabel.hidden = NO;
    self.restDaysHeaderLabel.hidden = NO;
    self.restDaysValueLabel.hidden = NO;
}
- (void) hideTableDislplay
{
    self.activityTable.hidden = YES;
    self.activityNameHeaderLabel.hidden = YES;
    self.activityValueHeaderLabel.hidden = YES;
    self.pointsHeaderLabel.hidden = YES;
    self.totalValueLabel.hidden = YES;
    self.totalHeaderLabel.hidden = YES;
    self.restDaysHeaderLabel.hidden = YES;
    self.restDaysValueLabel.hidden = YES;
}

///////// COLUMN CHART DELEGATE METHODS
#pragma -mark- EColumnChartDataSource

- (IBAction) rightButtonPressed:(id)sender
{
    if (self.eColumnChart == nil && self.eColumnChartByTime == nil)
        return;
    
    if (self.activityBarView.hidden == NO)
        [self.eColumnChart moveRight];
    else
        [self.eColumnChartByTime moveRight];
    
    self.leftButton.hidden = NO;
}

- (IBAction) leftButtonPressed:(id)sender
{
    if (self.eColumnChart == nil && self.eColumnChartByTime == nil)
        return;
    
    if (self.activityBarView.hidden == NO)
        [self.eColumnChart moveLeft];
    else
        [self.eColumnChartByTime moveLeft];
}



- (NSInteger)numberOfColumnsInEColumnChart:(EColumnChart *)eColumnChartLcl
{
    NSArray *tempData = [NSArray array];
    if (eColumnChartLcl == self.eColumnChart)
        tempData = self.data;
    else
        tempData = self.columnChartdataByTime;
    
    return [tempData count];
}

- (NSInteger)numberOfColumnsPresentedEveryTime:(EColumnChart *) eColumnChartLcl
{
    NSArray *tempData = [NSArray array];
    if (eColumnChartLcl == self.eColumnChart)
        tempData = self.data;
    else
        tempData = self.columnChartdataByTime;
    
    NSInteger numberOfColumns = [tempData count];
    
    if (numberOfColumns > COLUMNS_TO_DISPLAY)
        numberOfColumns = COLUMNS_TO_DISPLAY;
    else
    {
        self.rightButton.hidden = YES;
        self.leftButton.hidden = YES;
    }
    
    return numberOfColumns;
}

- (EColumnDataModel *)highestValueEColumnChart:(EColumnChart *)eColumnChartLcl
{
    EColumnDataModel *maxDataModel = nil;
    float maxValue = -FLT_MIN;
    
    NSArray *tempData = [NSArray array];
    if (eColumnChartLcl == self.eColumnChart)
        tempData = self.data;
    else
        tempData = self.columnChartdataByTime;
    
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
    if (eColumnChartLcl == self.eColumnChart)
        tempData = self.data;
    else
        tempData = self.columnChartdataByTime;
    
    if (index >= [tempData count] || index < 0) return nil;
    return [tempData objectAtIndex:index];
}

#pragma -mark- EColumnChartDelegate
- (void)eColumnChart:(EColumnChart *) columnChartLcl didSelectColumn:(EColumn *)eColumn
{
    if (columnChartLcl == self.eColumnChart)
    {
        if (self.eColumnSelected)
            self.eColumnSelected.barColor = self.tempColor;
      
        self.eColumnSelected = eColumn;
        self.tempColor = eColumn.barColor;
        eColumn.barColor = [UIColor purpleColor];
        
        UserActivity *ua = self.userActivityArray[eColumn.eColumnDataModel.index];
        NSString *title = [NSString stringWithFormat:@"%@",ua.activityValue];
        
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
    else
    {
        if (self.eColumnSelectedByTime)
            self.eColumnSelectedByTime.barColor = self.tempColorByTime;
        
        self.eColumnSelectedByTime = eColumn;
        self.tempColorByTime = eColumn.barColor;
        eColumn.barColor = [UIColor purpleColor];
        
       // NSString *title = [NSString stringWithFormat:@"%@ points",self.pointsArrayByTime[eColumn.eColumnDataModel.index]];
        CGFloat eFloatBoxX = eColumn.frame.origin.x + eColumn.frame.size.width * 1;
        CGFloat eFloatBoxY = eColumn.frame.origin.y + eColumn.frame.size.height * (1-eColumn.grade);
        
        if (self.eFloatBoxByTime)
            [self.eFloatBoxByTime removeFromSuperview];
        
        self.eFloatBoxByTime = [[EFloatBox alloc] initWithPosition:CGPointMake(eFloatBoxX, eFloatBoxY) value:eColumn.eColumnDataModel.value unit:@"Points" title:@""];
        self.eFloatBoxByTime.alpha = 0.0;
        [columnChartLcl addSubview:self.eFloatBoxByTime];
        
        eFloatBoxY -= (self.eFloatBoxByTime.frame.size.height + eColumn.frame.size.width * 0.25);
        self.eFloatBoxByTime.frame = CGRectMake(eFloatBoxX, eFloatBoxY, self.eFloatBoxByTime.frame.size.width, self.eFloatBoxByTime.frame.size.height);
        self.eFloatBoxByTime.alpha = 1.0;
        [columnChartLcl addSubview:self.eFloatBoxByTime];
        
        /*
         NSLog(@"Column selected");
         
         [self resetActivityLabels];
         NSDictionary *aggActDict = [self.challenge.aggregateActivityMap objectForKey:self.friendEmailArr[eColumn.eColumnDataModel.index]];
         
         int i = 1;
         for (NSString *activityName in aggActDict )
         {
         UILabel *activityValueLabel = [self.activityLabelsDict objectForKey:[NSString stringWithFormat:@"%d",i]];
         UILabel *activityHeaderLabel = [self.activityHeaderLabelsDict objectForKey:[NSString stringWithFormat:@"%d",i]];
         
         activityValueLabel.text = [NSString stringWithFormat:@"%@", [Utils reducePrecisionOfFloat:[aggActDict objectForKey:activityName]]];
         activityHeaderLabel.text = activityName;
         
         activityValueLabel.hidden = NO;
         activityHeaderLabel.hidden = NO;
         
         i++;
         }
         */
    }
 }

- (void)eColumnChart:(EColumnChart *) columnChartLcl fingerDidEnterColumn:(EColumn *)eColumn
{
    if (columnChartLcl == self.eColumnChart)
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
            UserActivity *ua = self.userActivityArray[eColumn.eColumnDataModel.index];
            NSString *title = [NSString stringWithFormat:@"%@",ua.activityValue];
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
    else
    {
        CGFloat eFloatBoxX = eColumn.frame.origin.x + eColumn.frame.size.width * 1;
        CGFloat eFloatBoxY = eColumn.frame.origin.y + eColumn.frame.size.height * (1-eColumn.grade);
        if (self.eFloatBoxByTime)
        {
            [self.eFloatBoxByTime removeFromSuperview];
            self.eFloatBoxByTime.frame = CGRectMake(eFloatBoxX, eFloatBoxY, self.eFloatBoxByTime.frame.size.width, self.eFloatBoxByTime.frame.size.height);
            [self.eFloatBoxByTime setValue:eColumn.eColumnDataModel.value];
            [columnChartLcl addSubview:self.eFloatBoxByTime];
        }
        else
        {
            //NSString *title = [NSString stringWithFormat:@"%@",self.pointsArrayByTime[eColumn.eColumnDataModel.index]];
            self.eFloatBoxByTime = [[EFloatBox alloc] initWithPosition:CGPointMake(eFloatBoxX, eFloatBoxY) value:eColumn.eColumnDataModel.value unit:@"Points" title:@""];
            self.eFloatBoxByTime.alpha = 0.0;
            [columnChartLcl addSubview:self.eFloatBoxByTime];
        }
        
        eFloatBoxY -= (self.eFloatBoxByTime.frame.size.height + eColumn.frame.size.width * 0.25);
        self.eFloatBoxByTime.frame = CGRectMake(eFloatBoxX, eFloatBoxY, self.eFloatBoxByTime.frame.size.width, self.eFloatBoxByTime.frame.size.height);
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionTransitionNone animations:^{
            self.eFloatBoxByTime.alpha = 1.0;
        } completion:^(BOOL finished) {
        }];
    }
}

- (void)eColumnChart:(EColumnChart *)eColumnChart fingerDidLeaveColumn:(EColumn *)eColumn
{
}

- (void)fingerDidLeaveEColumnChart:(EColumnChart *)eColumnChart
{
}


///////// UITABLEVIEW METHODS /////////


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.userActivityArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ActivityStatsCell";
    
    ActivityStatCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    UserActivity *activityObj = [self.userActivityArray objectAtIndex:indexPath.row];
    cell.activityLabel.text = activityObj.activity;
    cell.activityValueLabel.text = activityObj.activityValue;
    cell.pointsLabel.text = [NSString stringWithFormat:@"%@",activityObj.points];
    
    self.totalValueLabel.text = [NSString stringWithFormat:@"%.1f",self.totalPoints];
    
    return cell;
}

/////////////////// BUTTON ACTIONS //////////////
// Dismiss the info boxes when the background is tapped
- (IBAction)backgroundTap:(id)sender
{
    if (self.eFloatBox)
    {
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionTransitionNone animations:^{
            self.eFloatBox.alpha = 0.0;
            self.eFloatBox.frame = CGRectMake(self.eFloatBox.frame.origin.x, self.eFloatBox.frame.origin.y + self.eFloatBox.frame.size.height, self.eFloatBox.frame.size.width, self.eFloatBox.frame.size.height);
        } completion:^(BOOL finished) {
            [self.eFloatBox removeFromSuperview];
            self.eFloatBox = nil;
        }];
    }
    if (self.eFloatBoxByTime)
    {
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionTransitionNone animations:^{
            self.eFloatBoxByTime.alpha = 0.0;
            self.eFloatBoxByTime.frame = CGRectMake(self.eFloatBoxByTime.frame.origin.x, self.eFloatBoxByTime.frame.origin.y + self.eFloatBoxByTime.frame.size.height, self.eFloatBoxByTime.frame.size.width, self.eFloatBoxByTime.frame.size.height);
        } completion:^(BOOL finished) {
            [self.eFloatBoxByTime removeFromSuperview];
            self.eFloatBoxByTime = nil;
        }];
    }
    
    if (self.eColumnSelected)
        self.eColumnSelected.barColor = self.tempColor;
    
    if (self.eColumnSelectedByTime)
        self.eColumnSelectedByTime.barColor = self.tempColorByTime;
    
    [self resetActivityLabels];
}

@end


