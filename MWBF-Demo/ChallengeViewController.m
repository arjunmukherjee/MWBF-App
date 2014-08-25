//
//  ChallengeViewController.m
//  MWBF-Demo
//
//  Created by ARJUN MUKHERJEE on 8/5/14.
//  Copyright (c) 2014 ___Arjun Mukherjee___. All rights reserved.
//

#import "ChallengeViewController.h"
#import "ChallengeCell.h"
#import "User.h"
#import "Challenge.h"

@interface ChallengeViewController ()

@property NSMutableArray *currentChallengesArray;
@property NSMutableArray *pastChallengesArray;
@property NSMutableArray *upcomingChallengesArray;
@property User *user;

@end


@implementation ChallengeViewController

@synthesize currentChallengesArray, pastChallengesArray, upcomingChallengesArray;
@synthesize user;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.user = [User getInstance];
    
    self.currentChallengesArray = [NSMutableArray arrayWithArray:user.challengesList];
    
}



///////// UITABLEVIEW METHODS /////////

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.currentChallengesArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ChallengeDetailsCell";
    
    ChallengeCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    Challenge *challengeObj = [self.currentChallengesArray objectAtIndex:indexPath.row];
    cell.name.text = challengeObj.name;
    
    NSArray *tempDateArr = [challengeObj.startDate componentsSeparatedByString:@" "];
    cell.startDate.text = [NSString stringWithFormat:@"%@ %@%@  to",tempDateArr[0],tempDateArr[1],tempDateArr[2]];
    
    tempDateArr = [challengeObj.endDate componentsSeparatedByString:@" "];
    cell.endDate.text = [NSString stringWithFormat:@"%@ %@%@",tempDateArr[0],tempDateArr[1],tempDateArr[2]];
    
    
    
    // Parse the string and sort the points
    NSMutableArray *pointsArr = [NSMutableArray array];
    NSString *myPoints;
    for (id playerPoints in challengeObj.playersSet)
    {
        NSArray *tempArr = [playerPoints componentsSeparatedByString:@","];
        [pointsArr addObject:tempArr[1]];
        if ([tempArr[0] isEqualToString:user.userEmail] )
            myPoints = tempArr[1];
    }
    
    // Sort the activites by the total points
    NSSortDescriptor *sd = [[NSSortDescriptor alloc] initWithKey:nil ascending:YES];
    NSArray *sortedPointsArr = [pointsArr sortedArrayUsingDescriptors:@[sd]];
    
    int myPosition = 0;
    for (myPosition=0; myPosition < [sortedPointsArr count]; myPosition++)
    {
        if ( [sortedPointsArr[myPosition] isEqualToString:myPoints])
            break;
    }
    
    cell.myPosition.text = [NSString stringWithFormat:@"%d(%lu)",(myPosition+1),(unsigned long)[sortedPointsArr count]];
    
    return cell;
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}


@end
