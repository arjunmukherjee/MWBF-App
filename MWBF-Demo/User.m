//
//  User.m
//  MWBF-Demo
//
//  Created by ARJUN MUKHERJEE on 8/1/14.
//  Copyright (c) 2014 ___Arjun Mukherjee___. All rights reserved.
//

#import "User.h"

@implementation User

@synthesize userId = _userId;
@synthesize userEmail = _userEmail;
@synthesize userName = _userName;
@synthesize friendsList = _friendsList;

+ (User *) getInstance
{
    static User *theUser =nil;
    
    if (!theUser )
    {
        theUser = [[super allocWithZone:nil] init];
    }
    
    return theUser;
}

+ (id) allocWithZone:(struct _NSZone *)zone
{
    return [self getInstance];
}

- (id) init
{
    self = [super init];
    if (self)
    {
        // Set the instance varialbles
    }
    
    return self;
}

- (NSMutableDictionary *)toNSDictionary
{
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setValue:self.userId forKey:@"id"];
    
    return dictionary;
}

@end
