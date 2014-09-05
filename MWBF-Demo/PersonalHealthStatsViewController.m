//
//  PersonalHealthStatsViewController.m
//  MWBF-Demo
//
//  Created by ARJUN MUKHERJEE on 8/20/14.
//  Copyright (c) 2014 ___Arjun Mukherjee___. All rights reserved.
//

#import "PersonalHealthStatsViewController.h"
#import "User.h"

@interface PersonalHealthStatsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *bestDayLabel;
@property (weak, nonatomic) IBOutlet UILabel *bestMonthLabel;
@property (weak, nonatomic) IBOutlet UILabel *bestYearLabel;
@property (weak, nonatomic) IBOutlet UILabel *bestDayPointsLabel;
@property (weak, nonatomic) IBOutlet UILabel *bestMonthPointsLabel;
@property (weak, nonatomic) IBOutlet UILabel *bestYearPointsLabel;

@end

@implementation PersonalHealthStatsViewController

@synthesize bestDayLabel,bestMonthLabel,bestYearLabel;
@synthesize bestDayPointsLabel,bestMonthPointsLabel,bestYearPointsLabel;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self loadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self loadData];
}

- (void) loadData
{
    User *user = [User getInstance];
    self.bestDayLabel.text = [NSString stringWithFormat:@"%@",user.bestDay];
    self.bestMonthLabel.text = [NSString stringWithFormat:@"%@",user.bestMonth];
    self.bestYearLabel.text = [NSString stringWithFormat:@"%@",user.bestYear];
    
    self.bestDayPointsLabel.text = [NSString stringWithFormat:@"%@ pts",user.bestDayPoints];
    self.bestMonthPointsLabel.text = [NSString stringWithFormat:@"%@ pts",user.bestMonthPoints];
    self.bestYearPointsLabel.text = [NSString stringWithFormat:@"%@ pts",user.bestYearPoints];
}

@end
