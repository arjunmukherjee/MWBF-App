//
//  ChallengeCell.h
//  MWBF-Demo
//
//  Created by ARJUN MUKHERJEE on 8/24/14.
//  Copyright (c) 2014 ___Arjun Mukherjee___. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChallengeCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *startDate;
@property (weak, nonatomic) IBOutlet UILabel *endDate;
@property (weak, nonatomic) IBOutlet UILabel *myPosition;
@property (weak, nonatomic) IBOutlet UIProgressView *challengeProgressBar;
@property (weak, nonatomic) IBOutlet UIButton *trophyButton;

@end
