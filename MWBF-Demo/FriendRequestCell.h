//
//  FriendRequestCell.h
//  MWBF
//
//  Created by ARJUN MUKHERJEE on 11/12/14.
//  Copyright (c) 2014 ___Arjun Mukherjee___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>


@interface FriendRequestCell : UITableViewCell

@property (weak, nonatomic) IBOutlet FBProfilePictureView *friendFbProfilePicView;
@property (weak, nonatomic) IBOutlet UILabel *friendNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *notificationTextLabel;
@property (weak, nonatomic) IBOutlet UIButton *acceptButton;
@property (weak, nonatomic) IBOutlet UIButton *rejectButton;


@end
