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

- (NSUInteger)hash
{
    return [self.friend.email hash];
}

- (BOOL)isEqual:(id)other
{
    if (other == self)
        return YES;
    if ( !other || ![other isKindOfClass:[self class]])
        return NO;
    
    return [self isEqualToFriend:other];
}

- (BOOL)isEqualToFriend:(FriendRequest *) aFriendReq
{
    if (self == aFriendReq)
        return YES;
    if (![(id)[self friend] isEqual:[aFriendReq friend]])
        return NO;
    
    return YES;
}


@end
