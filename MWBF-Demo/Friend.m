//
//  Friend.m
//  MWBF-Demo
//
//  Created by ARJUN MUKHERJEE on 8/19/14.
//  Copyright (c) 2014 ___Arjun Mukherjee___. All rights reserved.
//

#import "Friend.h"

@implementation Friend

@synthesize firstName = _firstName;
@synthesize lastName = _lastName;
@synthesize email = _email;
@synthesize userName = _userName;
@synthesize fbProfileID = _fbProfileID;

- (NSString*) description
{
    return [NSString stringWithFormat:@"%@, %@, %@",self.firstName,self.email,self.userName];
}

- (NSMutableDictionary *)toNSDictionary
{
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setValue:self.email forKey:@"id"];
    
    return dictionary;
}

- (NSUInteger)hash
{
    return [self.email hash];
}

- (BOOL)isEqual:(id)other
{
    if (other == self)
        return YES;
    if (!other || ![other isKindOfClass:[self class]])
        return NO;
    return [self isEqualToFriend:other];
}

- (BOOL)isEqualToFriend:(Friend *)aFriend
{
    if (self == aFriend)
        return YES;
    if (![(id)[self email] isEqual:[aFriend email]])
        return NO;
    return YES;
}

@end
