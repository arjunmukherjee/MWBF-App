//
//  FriendCell.h
//  MWBF
//
//  Created by ARJUN MUKHERJEE on 9/11/14.
//  Copyright (c) 2014 ___Arjun Mukherjee___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>


@interface FriendCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *friendNameLabel;
@property (weak, nonatomic) IBOutlet FBProfilePictureView *friendFbProfilePicView;

@end
