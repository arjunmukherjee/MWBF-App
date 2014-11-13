//
//  FriendRequest.m
//  MWBF
//
//  Created by ARJUN MUKHERJEE on 11/12/14.
//  Copyright (c) 2014 ___Arjun Mukherjee___. All rights reserved.
//

#import "FriendRequest.h"

@implementation FriendRequest

@synthesize userId,friend,requestId;

- (NSString*) description
{
    return [NSString stringWithFormat:@"%@, %@, %@",self.requestId,self.userId,self.friend];
}

@end
