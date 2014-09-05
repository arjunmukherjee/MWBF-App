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


@implementation AppDelegate

@synthesize window = _window;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Load the FBProfilePictureView
    // You can find more information about why you need to add this line of code in our troubleshooting guide
    // https://developers.facebook.com/docs/ios/troubleshooting#objc
    [FBProfilePictureView class];
    
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
    // Refresh the user's data
    [self refreshUserData];
    
    // Set up Local Notifications
    /*
     // TODO : Fire notifications if something has changed
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    NSDate *now = [NSDate date];
    localNotification.fireDate = now;
    localNotification.alertBody = @"You have 5 new messages.";
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    localNotification.applicationIconBadgeNumber = 5;
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    */
    completionHandler(UIBackgroundFetchResultNewData);
}

-(BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[UIApplication sharedApplication] setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalMinimum];
    return true;
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
