//
//  Friend.h
//  MWBF-Demo
//
//  Created by ARJUN MUKHERJEE on 8/19/14.
//  Copyright (c) 2014 ___Arjun Mukherjee___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserStats.h"

@interface Friend : NSObject

@property (strong,nonatomic) NSString *email;
@property (strong,nonatomic) NSString *userName;
@property (strong,nonatomic) NSString *firstName;
@property (strong,nonatomic) NSString *lastName;
@property (strong,nonatomic) NSString *fbProfileID;
@property (strong,nonatomic) UserStats *stats;

- (NSMutableDictionary *)toNSDictionary;

@end
