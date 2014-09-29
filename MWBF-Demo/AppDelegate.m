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
    
    // Get the data before the refresh
    NSArray *friendsListOld = [NSArray arrayWithArray:user.friendsList];
    NSArray *challengeListOld = [NSArray arrayWithArray:user.challengesList];
    
    NSMutableArray *messageListOld = [NSMutableArray array];
    for (int i=0; i < [user.friendsActivitiesList count]; i++)
         [messageListOld addObject:user.friendsActivitiesList[i][@"feedPrettyString"]];
    
    NSInteger numberOfFriendsBefore = [friendsListOld count];
    
    // Refresh the user's data
    [Utils refreshUserData];
    
    NSInteger numberOfFriendsAfter = [user.friendsList count];
    NSInteger newFriendsCount = numberOfFriendsAfter - numberOfFriendsBefore;
    
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
    
    // Look for new challenges
    NSArray *challengeListNew = [NSArray arrayWithArray:user.challengesList];
    int newChallengeCount = 0;
    for (int i = 0; i < [challengeListNew count]; i++)
    {
        Challenge *challengeObj = challengeListNew[i];
        if ( ! [challengeListOld containsObject:challengeObj] )
        {
            Friend *friendObj = [self findFriendWithId:challengeObj.creatorId];
            if (friendObj)
                [user.notificationsList addObject:[NSString stringWithFormat:@"%@ has created a challenge \"%@\".",friendObj.firstName,challengeObj.name]];
            else
                [user.notificationsList addObject:[NSString stringWithFormat:@"%@ has created a challenge \"%@\".",challengeObj.creatorId,challengeObj.name]];
            
            newChallengeCount++;
        }
    }
    
    // Look for removed challenges
    for (int i = 0; i < [challengeListOld count]; i++)
    {
        Challenge *challengeObj = challengeListOld[i];
        if ( ! [challengeListNew containsObject:challengeObj] )
        {
            Friend *friendObj = [self findFriendWithId:challengeObj.creatorId];
            if (friendObj)
                [user.notificationsList addObject:[NSString stringWithFormat:@"%@ has removed a challenge \"%@\".",friendObj.firstName,challengeObj.name]];
            else
                [user.notificationsList addObject:[NSString stringWithFormat:@"%@ has removed a challenge \"%@\".",challengeObj.creatorId,challengeObj.name]];
            
            newChallengeCount++;
        }
    }

    self.numberOfMessages = (newChallengeCount + newFriendsCount + newMessageCount);
    
    // Set up Local Notifications
    if (self.numberOfMessages > 0 )
    {
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
        UILocalNotification *localNotification = [[UILocalNotification alloc] init];
        NSDate *now = [NSDate date];
        localNotification.fireDate = now;
        
        // Populate the users notification list
        // Look for new friends
        NSArray *friendsListNew = [NSArray arrayWithArray:user.friendsList];
        int newFriendCount = 0;
        for (int i = 0; i < [friendsListNew count]; i++)
        {
            Friend *friendObj = friendsListNew[i];
            if ( ! [friendsListOld containsObject:friendObj] )
            {
                [user.notificationsList addObject:[NSString stringWithFormat:@"%@ has added you as a friend.",friendObj.firstName]];
                newFriendCount++;
            }
        }
        
        // Account for grammar (singular vs plural)
        NSString *friendStr = @"friends";
        if (newFriendCount == 1)
            friendStr = @"friend";
        NSString *challengeStr = @"challenges";
        if (newChallengeCount == 1)
            challengeStr = @"challenge";
        NSString *notificationStr = @"activity notifications";
        if (newMessageCount == 1)
            notificationStr = @"activity notification";
        
        
        // Construct the notification string
        NSString *messageBody = [[NSString alloc] init];
        if (user.activityNotifications && user.friendsAndChallengesNotifications)
        {
            if (newFriendCount > 0 && newChallengeCount > 0 && newMessageCount > 0)
                messageBody = [NSString stringWithFormat:@"You have %d new %@ and %d new or removed %@ and %d new %@.",newFriendCount,friendStr,newChallengeCount,challengeStr,newMessageCount,notificationStr];
            
            else if (newFriendCount > 0 && newChallengeCount > 0)
                messageBody = [NSString stringWithFormat:@"You have %ld new %@ and %ld new or removed %@.",(long)newFriendCount,friendStr,(long)newChallengeCount,challengeStr];
            
            else if (newChallengeCount > 0 && newMessageCount > 0)
                messageBody = [NSString stringWithFormat:@"You have %d new or removed %@ and %d new %@.",newChallengeCount,challengeStr,newMessageCount,notificationStr];
            
            else if (newFriendCount > 0 && newMessageCount > 0)
                messageBody = [NSString stringWithFormat:@"You have %d new %@ and %d new %@.",newFriendCount,friendStr,newMessageCount,notificationStr];
            
            else if (newFriendCount > 0 )
                messageBody = [NSString stringWithFormat:@"You have %d new %@.",newFriendCount,friendStr];
            
            else if (newMessageCount > 0 )
            {
                // If there is only one message then just display that
                if (newMessageCount == 1 )
                    messageBody = newMessage;
                else
                    messageBody = [NSString stringWithFormat:@"You have %d new %@.",newMessageCount,notificationStr];
            }
            else
                messageBody = [NSString stringWithFormat:@"You have %ld new or removed %@.",(long)newChallengeCount,challengeStr];
        }
        else if (user.friendsAndChallengesNotifications)
        {
            if (newFriendCount > 0 && newChallengeCount > 0)
                messageBody = [NSString stringWithFormat:@"You have %ld new %@ and %ld new or removed %@.",(long)newFriendCount,friendStr,(long)newChallengeCount,challengeStr];
            
            else if (newFriendCount > 0 )
                messageBody = [NSString stringWithFormat:@"You have %d new %@.",newFriendCount,friendStr];
            
            else
                messageBody = [NSString stringWithFormat:@"You have %ld new or removed %@.",(long)newChallengeCount,challengeStr];
        }
        else
        {
            if (newMessageCount > 0 )
            {
                // If there is only one message then just display that
                if (newMessageCount == 1 )
                    messageBody = newMessage;
                else
                    messageBody = [NSString stringWithFormat:@"You have %d new %@.",newMessageCount,notificationStr];
            }
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
