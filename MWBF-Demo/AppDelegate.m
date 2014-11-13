//
//  AppDelegate.m
//  MWBF-Demo
//
//  Created by ARJUN MUKHERJEE on 7/25/14.
//  Copyright (c) 2014 ___Arjun Mukherjee___. All rights reserved.
//

#import "AppDelegate.h"
#import <FacebookSDK/FacebookSDK.h>
#import "MWBFService.h"
#import "User.h"
#import "Challenge.h"
#import "Utils.h"


@interface AppDelegate ()
@property (nonatomic) NSInteger numberOfMessages;

@end

@implementation AppDelegate

@synthesize window = _window;
@synthesize numberOfMessages;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Load the FBProfilePictureView
    // You can find more information about why you need to add this line of code in our troubleshooting guide
    // https://developers.facebook.com/docs/ios/troubleshooting#objc
    [FBProfilePictureView class];
    
    self.numberOfMessages = 0;
    
    return YES;
}

// In order to process the response you get from interacting with the Facebook login process,
// you need to override application:openURL:sourceApplication:annotation:
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    // Call FBAppCall's handleOpenURL:sourceApplication to handle Facebook app responses
    BOOL wasHandled = [FBAppCall handleOpenURL:url sourceApplication:sourceApplication];
    
    // You can add your app-specific url handling code here if needed
    
    return wasHandled;
}

// Background refresh (Will refresh all the user data from the server in the background, scheduled by iOS)
-(void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    User *user = [User getInstance];
    
    NSMutableArray *messageListOld = [NSMutableArray array];
    for (int i=0; i < [user.friendsActivitiesList count]; i++)
         [messageListOld addObject:user.friendsActivitiesList[i][@"feedPrettyString"]];
    
    // Refresh the user's data
    [Utils refreshUserData];
    
    // Look for new messages
    int newMessageCount = 0;
    NSString *newMessage = [[NSString alloc] init];
    NSMutableArray *messageListNew = [NSMutableArray array];
    for (int i=0; i < [user.friendsActivitiesList count]; i++)
        [messageListNew addObject:user.friendsActivitiesList[i][@"feedPrettyString"]];
    
    for (int i=0; i <[messageListNew count]; i++)
    {
        NSString *message = messageListNew[i];
        if (![messageListOld containsObject:message])
        {
            newMessage = message;
            newMessageCount++;
        }
    }
    
    self.numberOfMessages = (newMessageCount);
    
    // Set up Local Notifications
    if (self.numberOfMessages > 0 )
    {
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
        UILocalNotification *localNotification = [[UILocalNotification alloc] init];
        NSDate *now = [NSDate date];
        localNotification.fireDate = now;
        
        // Account for grammar (singular vs plural)
        NSString *notificationStr = @"activity notifications";
        if (newMessageCount == 1)
            notificationStr = @"activity notification";
        
        // Convert the new feed message into relative days (today, yesterday)
        NSMutableArray *tempArray = [NSMutableArray array];
        [tempArray addObject:newMessage];
        [Utils changeAbsoluteDateToRelativeDays:tempArray];
        newMessage = tempArray[0];
        
        // Construct the notification string
        NSString *messageBody = [[NSString alloc] init];
        if (newMessageCount > 0 )
            {
                // If there is only one message then just display that
                if (newMessageCount == 1 )
                    messageBody = newMessage;
                else
                    messageBody = [NSString stringWithFormat:@"You have %d new %@.",newMessageCount,notificationStr];
            }
        
        
        localNotification.alertBody = messageBody;
        localNotification.soundName = UILocalNotificationDefaultSoundName;
        localNotification.applicationIconBadgeNumber = self.numberOfMessages;
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    }
    
    completionHandler(UIBackgroundFetchResultNewData);
}

- (Friend*) findFriendWithId:(NSString*) friendId
{
    NSArray *friendsList = [User getInstance].friendsList;
    
    for (int i=0; i < [friendsList count]; i++)
    {
        Friend *friendObj = friendsList[i];
        if ([friendObj.email isEqual:friendId])
            return friendObj;
    }
    
    return nil;
}

-(BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[UIApplication sharedApplication] setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalMinimum];
    return true;
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    application.applicationIconBadgeNumber = 0;
    self.numberOfMessages = 0;
}


@end
