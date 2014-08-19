//
//  User.h
//  MWBF-Demo
//
//  Created by ARJUN MUKHERJEE on 8/1/14.
//  Copyright (c) 2014 ___Arjun Mukherjee___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property (strong,nonatomic) NSString *userId;
@property (strong,nonatomic) NSString *userEmail;
@property (strong,nonatomic) NSString *userName;
@property (strong,nonatomic) NSMutableArray *friendsList;

+ (User *) getInstance;
- (NSMutableDictionary *)toNSDictionary;

@end
