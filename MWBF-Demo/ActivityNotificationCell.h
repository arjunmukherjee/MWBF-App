//
//  ActivityNotificationCell.h
//  MWBF
//
//  Created by ARJUN MUKHERJEE on 9/18/14.
//  Copyright (c) 2014 ___Arjun Mukherjee___. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActivityNotificationCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *activityMessage;
@property (weak, nonatomic) IBOutlet UIButton *activityPic;

@end
