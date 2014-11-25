//
//  FBFriendNotificationCell.h
//  MWBF
//
//  Created by ARJUN MUKHERJEE on 11/23/14.
//  Copyright (c) 2014 ___Arjun Mukherjee___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@interface FBFriendNotificationCell : UITableViewCell

@property (weak, nonatomic) IBOutlet FBProfilePictureView *friendFbProfilePicView;
@property (weak, nonatomic) IBOutlet UILabel *notificationMessage;

@end
