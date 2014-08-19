//
//  Activity.m
//  MWBF-Demo
//
//  Created by ARJUN MUKHERJEE on 8/1/14.
//  Copyright (c) 2014 ___Arjun Mukherjee___. All rights reserved.
//

#import "Activity.h"
#import "MWBFService.h"

@implementation Activity

@synthesize activityDict = _activityDict;


+ (Activity *) getInstance
{
    static Activity *theActivity = nil;
    
    if (!theActivity )
        theActivity = [[super allocWithZone:nil] init];
    
    return theActivity;
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
        self.activityDict = [[NSMutableDictionary alloc] init];
        
        // Get the list of activities from the server
        
        MWBFService *service = [[MWBFService alloc] init];
        self.activityDict = [service getActivityListWithResponseUsingPost];
    }
    
    return self;
}


@end
