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
    NSInteger numberOfFriendsBefore = [friendsListOld count];
    
    // Refresh the user's data
    [self refreshUserData];
    
    NSInteger numberOfFriendsAfter = [user.friendsList count];
    NSInteger newFriends = numberOfFriendsAfter - numberOfFriendsBefore;
    
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
    
    // Populate all the activities
    [Utils populateFriendsActivities];
    
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

    self.numberOfMessages = (newChallengeCount + newFriends);
    
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
        
        NSString *messageBody = [[NSString alloc] init];
        if (newFriendCount > 0 && newChallengeCount > 0)
            messageBody = [NSString stringWithFormat:@"You have %ld new %@ and %ld new or removed %@.",(long)newFriendCount,friendStr,(long)newChallengeCount,challengeStr];
        else if (newFriendCount > 0 )
            messageBody = [NSString stringWithFormat:@"You have %ld new %@.",(long)newFriendCount,friendStr];
        else
            messageBody = [NSString stringWithFormat:@"You have %ld new or removed %@.",(long)newChallengeCount,challengeStr];

        
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

- (void) refreshUserData
{
    MWBFService *service = [[MWBFService alloc] init];
    
    // Get the list of friends
    [User getInstance].friendsList = [service getFriendsList];
    
    // Get the all time highs
    [service getAllTimeHighs];
    
    // Get all the challenges the user is involved in
    [service getChallenges];
}


@end
