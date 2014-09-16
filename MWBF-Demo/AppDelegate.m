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
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    // Call FBAppCall's handleOpenURL:sourceApplication to handle Facebook app responses
    BOOL wasHandled = [FBAppCall handleOpenURL:url sourceApplication:sourceApplication];
    
    // You can add your app-specific url handling code here if needed
    
    return wasHandled;
}

// Background refresh (Will refresh all the user data from the server in the background, scheduled by iOS)
-(void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    User *user = [User getInstance];
    
    NSInteger numberOfFriendsBefore = [user.friendsList count];
    NSInteger numberOfChallengesBefore = [user.challengesList count];
    
    NSArray *friendsListOld = [NSArray arrayWithArray:user.friendsList];
    NSArray *challengeListOld = [NSArray arrayWithArray:user.challengesList];
    
    // Refresh the user's data
    [self refreshUserData];
    
    NSInteger numberOfFriendsAfter = [user.friendsList count];
    NSInteger numberOfChallengesAfter = [user.challengesList count];
    
    NSInteger newFriends = numberOfFriendsAfter - numberOfFriendsBefore;
    NSInteger newChallenges = numberOfChallengesAfter - numberOfChallengesBefore;
    
    self.numberOfMessages = (newChallenges + newFriends);
    
    // Set up Local Notifications
    if (self.numberOfMessages > 0 )
    {
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
        UILocalNotification *localNotification = [[UILocalNotification alloc] init];
        NSDate *now = [NSDate date];
        localNotification.fireDate = now;
        
        // Account for grammar (singular vs plural)
        NSString *friendStr = @"friends";
        if (newFriends == 1)
            friendStr = @"friend";
        
        NSString *challengeStr = @"challenges";
        if (newChallenges == 1)
            challengeStr = @"challenge";
        
        NSString *messageBody = [[NSString alloc] init];
        if (newFriends > 0 && newChallenges > 0)
            messageBody = [NSString stringWithFormat:@"You have %ld new %@ and %ld new %@.",(long)newFriends,friendStr,(long)newChallenges,challengeStr];
        else if (newFriends > 0 )
            messageBody = [NSString stringWithFormat:@"You have %ld new %@.",(long)newFriends,friendStr];
        else
            messageBody = [NSString stringWithFormat:@"You have %ld new %@.",(long)newChallenges,challengeStr];
        
        
        // Populate the users message and friend notification lists
        NSArray *friendsListNew = [NSArray arrayWithArray:user.friendsList];
        for (int i = 0; i < [friendsListNew count]; i++)
        {
            Friend *friendObj = friendsListNew[i];
            if ( ! [friendsListOld containsObject:friendObj] )
                [user.friendsMessageList addObject:[NSString stringWithFormat:@"%@ has added you as a friend.",friendObj.firstName]];
        }
        
        NSArray *challengeListNew = [NSArray arrayWithArray:user.challengesList];
        for (int i = 0; i < [challengeListNew count]; i++)
        {
            Challenge *challengeObj = challengeListNew[i];
            if ( ! [challengeListOld containsObject:challengeObj] )
                [user.challengesMessageList addObject:[NSString stringWithFormat:@"%@ has created a new challenge %@.",challengeObj.creatorId,challengeObj.name]];
        }
        
        
        localNotification.alertBody = messageBody;
        localNotification.soundName = UILocalNotificationDefaultSoundName;
        localNotification.applicationIconBadgeNumber = self.numberOfMessages;
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    }
    
    completionHandler(UIBackgroundFetchResultNewData);
        
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
