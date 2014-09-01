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
#import "ChallengeDetailsViewController.h"
#import "SVSegmentedControl.h"
#import <QuartzCore/QuartzCore.h>
#import "MWBFService.h"

#define CURRENT_INDEX 0
#define PAST_INDEX 1
#define FUTURE_INDEX 2

@interface ChallengeViewController ()

@property NSMutableArray *currentChallengesArray;
@property NSMutableArray *pastChallengesArray;
@property NSMutableArray *futureChallengesArray;
@property User *user;
@property Challenge *chosenChallenge;
@property (weak, nonatomic) IBOutlet UITableView *currentChallengesTableView;
@property (weak, nonatomic) IBOutlet UITableView *pastChallengesTableView;
@property (weak, nonatomic) IBOutlet UITableView *futureChallengesTableView;

@end


@implementation ChallengeViewController

@synthesize currentChallengesArray, pastChallengesArray, futureChallengesArray;
@synthesize user;
@synthesize chosenChallenge;
@synthesize currentChallengesTableView,pastChallengesTableView,futureChallengesTableView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.user = [User getInstance];
    self.currentChallengesArray = [NSMutableArray array];
    self.pastChallengesArray = [NSMutableArray array];
    self.futureChallengesArray = [NSMutableArray array];
    
    // Hidden views
    self.pastChallengesTableView.hidden = YES;
    self.futureChallengesTableView.hidden = YES;
    
    // Assign the challengs to the correct arrays
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MMM d, yyyy hh:mm:ss a"];
    for (Challenge *challengeObj in user.challengesList)
    {
        
        NSDate *startDate = [dateFormat dateFromString:challengeObj.startDate];
        NSDate *endDate = [dateFormat dateFromString:challengeObj.endDate];
        
        components = [gregorianCalendar components:NSDayCalendarUnit
                                            fromDate:[NSDate date]
                                            toDate:endDate
                                           options:0];
        NSInteger daysRemaining = [components day];
        
        // Look for challenges in the past
        if (daysRemaining < 0)
            [self.pastChallengesArray addObject:challengeObj];
        else
        {
            // Look for challenges in the future
            components = [gregorianCalendar components:NSDayCalendarUnit
                                             fromDate:[NSDate date]
                                               toDate:startDate
                                              options:0];
            NSInteger daysToStart = [components day];
            if (daysToStart > 0)
                [self.futureChallengesArray addObject:challengeObj];
            else
                [self.currentChallengesArray addObject:challengeObj];
        }
    }
    
    // Get the new segmentedController
    SVSegmentedControl *quickDateSelector = [[SVSegmentedControl alloc] initWithSectionTitles:[NSArray arrayWithObjects:@"Current", @"Past", @"Upcoming", nil]];
    [quickDateSelector addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
	quickDateSelector.crossFadeLabelsOnDrag = YES;
    quickDateSelector.textColor = [UIColor lightGrayColor];
	[quickDateSelector setSelectedSegmentIndex:0 animated:NO];
	quickDateSelector.thumb.tintColor = [UIColor colorWithRed:0.999 green:0.889 blue:0.312 alpha:1.000];
	quickDateSelector.thumb.textColor = [UIColor blackColor];
	quickDateSelector.thumb.textShadowColor = [UIColor colorWithWhite:1 alpha:0.5];
	quickDateSelector.thumb.textShadowOffset = CGSizeMake(0, 1);
	quickDateSelector.center = CGPointMake(160, 100);
	[self.view addSubview:quickDateSelector];
}

- (void)viewWillAppear:(BOOL)animated
{
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ChallengeDetails"])
    {
        ChallengeDetailsViewController *controller = [segue destinationViewController];
        controller.challenge = self.chosenChallenge;
    }
}

- (void) segmentedControlChangedValue:(SVSegmentedControl*)segmentedControl
{
    if (segmentedControl.selectedSegmentIndex == CURRENT_INDEX)
    {
        self.currentChallengesTableView.hidden = NO;
        self.pastChallengesTableView.hidden = YES;
        self.futureChallengesTableView.hidden = YES;
    }
    else if (segmentedControl.selectedSegmentIndex == PAST_INDEX)
    {
        self.currentChallengesTableView.hidden = YES;
        self.pastChallengesTableView.hidden = NO;
        self.futureChallengesTableView.hidden = YES;
    }
    else
    {
        self.currentChallengesTableView.hidden = YES;
        self.pastChallengesTableView.hidden = YES;
        self.futureChallengesTableView.hidden = NO;
    }
}


///////// UITABLEVIEW METHODS /////////

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.currentChallengesTableView)
        return [self.currentChallengesArray count];
    else if (tableView == self.pastChallengesTableView)
        return [self.pastChallengesArray count];
    else
        return [self.futureChallengesArray count];
        
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.futureChallengesTableView)
        return;
    
    Challenge *ch = [[Challenge alloc] init];
    if (tableView == self.currentChallengesTableView)
        ch = [self.currentChallengesArray objectAtIndex:indexPath.row];
    else
        ch = [self.pastChallengesArray objectAtIndex:indexPath.row];

    self.chosenChallenge = ch;
    [self performSegueWithIdentifier:@"ChallengeDetails" sender:self];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"CurrentChallengeDetailsCell";
    Challenge *challengeObj = [[Challenge alloc] init];
    
    if (tableView == self.currentChallengesTableView)
    {
        cellIdentifier = @"CurrentChallengeDetailsCell";
        challengeObj = [self.currentChallengesArray objectAtIndex:indexPath.row];
    }
    else if (tableView == self.pastChallengesTableView)
    {
        cellIdentifier = @"PastChallengeDetailsCell";
        challengeObj = [self.pastChallengesArray objectAtIndex:indexPath.row];
    }
    else
    {
        cellIdentifier = @"FutureChallengeDetailsCell";
        challengeObj = [self.futureChallengesArray objectAtIndex:indexPath.row];
    }
    
    ChallengeCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell.name.text = challengeObj.name;
    
    // Calculate the progress of the challenge
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MMM d, yyyy hh:mm:ss a"];
    NSDate *startDate = [dateFormat dateFromString:challengeObj.startDate];
    NSDate *endDate = [dateFormat dateFromString:challengeObj.endDate];
    
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [gregorianCalendar components:NSDayCalendarUnit
                                                        fromDate:startDate
                                                          toDate:endDate
                                                         options:0];
    NSInteger totalNumberOfDays = [components day];
    
    NSDate *today = [NSDate date];
    components = [gregorianCalendar components:NSDayCalendarUnit
                                      fromDate:today
                                        toDate:endDate
                                       options:0];
    NSInteger remainingDays = [components day];
  
    float progress = (float) ( 1 - (float)remainingDays/totalNumberOfDays);
    cell.challengeProgressBar.progress = progress;
    if (progress > 1)
        cell.challengeProgressBar.progressTintColor = [UIColor purpleColor];
    else if (progress > 0.75)
        cell.challengeProgressBar.progressTintColor = [UIColor redColor];
    else if (progress > 0.5)
        cell.challengeProgressBar.progressTintColor = [UIColor orangeColor];
   [cell.challengeProgressBar setTransform:CGAffineTransformMakeScale(1.0, 3.0)];
    
    NSArray *tempDateArr = [challengeObj.startDate componentsSeparatedByString:@" "];
    cell.startDate.text = [NSString stringWithFormat:@"%@ %@%@  to ",tempDateArr[0],tempDateArr[1],tempDateArr[2]];
    
    tempDateArr = [challengeObj.endDate componentsSeparatedByString:@" "];
    cell.endDate.text = [NSString stringWithFormat:@"%@ %@%@",tempDateArr[0],tempDateArr[1],tempDateArr[2]];
    
    // Parse the string and sort the points
    NSMutableArray *pointsArr = [NSMutableArray array];
    NSNumber *myPoints;
    for (id playerPoints in challengeObj.playersSet)
    {
        NSArray *tempArr = [playerPoints componentsSeparatedByString:@","];
        CGFloat points =[tempArr[1] floatValue];
        NSNumber *num = [NSNumber numberWithFloat:points];
        [pointsArr addObject:num];
        if ([tempArr[0] isEqualToString:user.userEmail] )
            myPoints = num;
    }
    
    // Sort the activites by the total points
    NSSortDescriptor *sd = [[NSSortDescriptor alloc] initWithKey:nil ascending:NO];
    NSArray *sortedPointsArr = [pointsArr sortedArrayUsingDescriptors:@[sd]];
    
    int myPosition = 0;
    for (myPosition=0; myPosition < [sortedPointsArr count]; myPosition++)
    {
        if ( sortedPointsArr[myPosition] == myPoints )
            break;
    }
    
    cell.myPosition.text = [NSString stringWithFormat:@"%d/%lu",(myPosition+1),(unsigned long)[sortedPointsArr count]];
    
    challengeObj.yourPosition = [NSString stringWithFormat:@"%d of %lu players",(myPosition+1),(unsigned long)[sortedPointsArr count]];
    
    // Show the tropy button , only if the challenge is in the past and also only if the player won it
    if ( (myPosition+1 == 1) && (tableView == self.pastChallengesTableView) )
        cell.trophyButton.hidden = NO;
    else
        cell.trophyButton.hidden = YES;
    
    UIColor *selectionColor = [[UIColor alloc] initWithRed:20.0 / 255 green:59.0 / 255 blue:102.0 / 255 alpha:0.5];
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = selectionColor;
    [cell setSelectedBackgroundView:bgColorView];
    
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
        Challenge *challengeObj = [[Challenge alloc] init];
        NSMutableArray *tempArray;
        
        if (tableView == self.currentChallengesTableView)
        {
            challengeObj = [self.currentChallengesArray objectAtIndex:indexPath.row];
            tempArray = self.currentChallengesArray;
            //[self.currentChallengesArray removeObject:challengeObj];
        }
        else if (tableView == self.pastChallengesTableView)
        {
            challengeObj = [self.pastChallengesArray objectAtIndex:indexPath.row];
            tempArray = self.pastChallengesArray;
            //[self.pastChallengesArray removeObject:challengeObj];
        }
        else
        {
            challengeObj = [self.futureChallengesArray objectAtIndex:indexPath.row];
            tempArray = self.futureChallengesArray;
            //[self.futureChallengesArray removeObject:challengeObj];
        }
        
        
        if ( ![challengeObj.creatorId isEqualToString:[User getInstance].userEmail])
        {
            [Utils alertStatus:@"Sorry, only the creator of a challenge can delete the challenge." :@"Nope.." :0];
            [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            return;
        }
        
        [tempArray removeObject:challengeObj];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        
        // Delete the challenge from the server
        self.activityIndicator.hidden = NO;
        [self.activityIndicator startAnimating];
        self.view.userInteractionEnabled = NO;
        
        dispatch_queue_t queue = dispatch_get_global_queue(0,0);
        
        dispatch_async(queue, ^{
            MWBFService *service = [[MWBFService alloc] init];
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                
                
                if ([service deleteChallenge:challengeObj.challenge_id] )
                    [Utils alertStatus:@"Challenge deleted." :@"It's done" :0];
                else
                    [Utils alertStatus:@"Unable to delete the challenge. Please try again." :@"Oops! Embarassing" :0];
                
                [self.activityIndicator stopAnimating];
                self.activityIndicator.hidden = YES;
                self.view.userInteractionEnabled = YES;
            });
        });
    }
}


@end
