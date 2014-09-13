//
//  PointsSchemeController.m
//  MWBF
//
//  Created by ARJUN MUKHERJEE on 9/12/14.
//  Copyright (c) 2014 ___Arjun Mukherjee___. All rights reserved.
//

#import "PointsSchemeController.h"
#import "PointsSchemeCell.h"
#import "Activity.h"
#import "MWBFActivities.h"

@interface PointsSchemeController ()
@property (weak, nonatomic) IBOutlet UITableView *pointsSchemeTable;
@property (strong,nonatomic) NSArray *activityList;

@end

@implementation PointsSchemeController
@synthesize pointsSchemeTable;


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.activityList = [[Activity getInstance].activityDict allValues];
    
    // Sort the activites by the total points
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"measurementUnits" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    NSArray *sortedArray = [self.activityList sortedArrayUsingDescriptors:sortDescriptors];
    self.activityList = [NSMutableArray arrayWithArray:sortedArray];
}

///////// UITABLEVIEW METHODS /////////

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.activityList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"PointsSchemeCell";
    
    PointsSchemeCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    MWBFActivities *activityObj = [self.activityList objectAtIndex:indexPath.row];
    cell.activityLabel.text = activityObj.activityName;
    cell.activityValueLabel.text = [NSString stringWithFormat:@"%d",activityObj.wholeUnit];
    cell.unitsLabel.text = activityObj.measurementUnits;
    
    double pointsPerWholeUnitDouble = activityObj.wholeUnit * activityObj.pointsPerUnit;
    int roundedUp = ceilf(pointsPerWholeUnitDouble);
    
    double calValue = 0.0;
    if (roundedUp - pointsPerWholeUnitDouble > 0.5)
        calValue = floor(pointsPerWholeUnitDouble);
    else if (roundedUp - pointsPerWholeUnitDouble < 0.5)
        calValue = ceil(pointsPerWholeUnitDouble);
    else
        calValue = pointsPerWholeUnitDouble;

    cell.pointsLabel.text = [NSString stringWithFormat:@"%.1f",calValue];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}



@end
