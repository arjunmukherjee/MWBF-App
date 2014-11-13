//
//  FriendRequest.h
//  MWBF
//
//  Created by ARJUN MUKHERJEE on 11/12/14.
//  Copyright (c) 2014 ___Arjun Mukherjee___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Friend.h"

@interface FriendRequest : NSObject
@property (strong,nonatomic) NSString *requestId;
@property (strong,nonatomic) NSString *userId;
@property (strong,nonatomic) Friend *friend;
@end
