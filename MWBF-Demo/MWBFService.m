//
//  MusicStoreService.m
//  iMusic
//
//  Created by ARJUN MUKHERJEE.
//  Copyright (c) 2014 Arjun Mukherjee, LLC. All rights reserved.
//

#import "MWBFService.h"
#import "Activity.h"
#import "HTTPPostRequest.h"
#import "HTTPGetRequest.h"
#import "User.h"
#import "MWBFActivities.h"
#import "Friend.h"
#import "Challenge.h"


#define USER_LOGIN_ENDPOINT_FORMAT                      @"http://localhost:8080/MWBFServer/mwbf/user/login"
#define USER_FRIENDS_ENDPOINT_FORMAT                    @"http://localhost:8080/MWBFServer/mwbf/user/friends"
#define USER_FIND_FRIEND_ENDPOINT_FORMAT                @"http://localhost:8080/MWBFServer/mwbf/user/findFriend"
#define USER_ADD_FRIEND_ENDPOINT_FORMAT                 @"http://localhost:8080/MWBFServer/mwbf/user/addFriend"
#define FB_USER_LOGIN_ENDPOINT_FORMAT                   @"http://localhost:8080/MWBFServer/mwbf/user/fbLogin"
#define USER_HIGHS_ENDPOINT_FORMAT                      @"http://localhost:8080/MWBFServer/mwbf/user/allTimeHighs"
#define USER_ADD_ENDPOINT_FORMAT                        @"http://localhost:8080/MWBFServer/mwbf/user/add"
#define FB_USER_ADD_ENDPOINT_FORMAT                     @"http://localhost:8080/MWBFServer/mwbf/user/fbAdd"
#define LOG_ACTIVITY_ENDPOINT_FORMAT                    @"http://localhost:8080/MWBFServer/mwbf/user/activity/log"
#define ADD_CHALLENGE_ENDPOINT_FORMAT                   @"http://localhost:8080/MWBFServer/mwbf/user/challenge/add"
#define DELETE_CHALLENGE_ENDPOINT_FORMAT                @"http://localhost:8080/MWBFServer/mwbf/user/challenge/delete"
#define GET_CHALLENGES_ENDPOINT_FORMAT                  @"http://localhost:8080/MWBFServer/mwbf/user/challenge/getAll"
#define USER_ACTIVITIES_BY_ACTIVITY_ENDPOINT_FORMAT     @"http://localhost:8080/MWBFServer/mwbf/user/activitiesByActivity"
#define USER_ACTIVITIES_BY_TIME_ENDPOINT_FORMAT         @"http://localhost:8080/MWBFServer/mwbf/user/activitiesByTime"
#define MWBF_ACTIVITY_LIST_ENDPOINT_FORMAT              @"http://localhost:8080/MWBFServer/mwbf/mwbf/activities"
#define DELETE_USER_ACTIVITIES_ENDPOINT_FORMAT          @"http://localhost:8080/MWBFServer/mwbf/user/deleteUserActivities"

/*
#define USER_LOGIN_ENDPOINT_FORMAT                      @"http://mwbf.herokuapp.com/mwbf/user/login"
#define USER_FRIENDS_ENDPOINT_FORMAT                    @"http://mwbf.herokuapp.com/mwbf/user/friends"
#define USER_FIND_FRIEND_ENDPOINT_FORMAT                @"http://mwbf.herokuapp.com/mwbf/user/findFriend"
#define USER_ADD_FRIEND_ENDPOINT_FORMAT                 @"http://mwbf.herokuapp.com/mwbf/user/addFriend"
#define FB_USER_LOGIN_ENDPOINT_FORMAT                   @"http://mwbf.herokuapp.com/mwbf/user/fbLogin"
#define USER_HIGHS_ENDPOINT_FORMAT                      @"http://mwbf.herokuapp.com/mwbf/user/allTimeHighs"
#define USER_ADD_ENDPOINT_FORMAT                        @"http://mwbf.herokuapp.com/mwbf/user/add"
#define FB_USER_ADD_ENDPOINT_FORMAT                     @"http://mwbf.herokuapp.com/mwbf/user/fbAdd"
#define LOG_ACTIVITY_ENDPOINT_FORMAT                    @"http://mwbf.herokuapp.com/mwbf/user/activity/log"
#define ADD_CHALLENGE_ENDPOINT_FORMAT                   @"http://mwbf.herokuapp.com/mwbf/user/challenge/add"
#define DELETE_CHALLENGE_ENDPOINT_FORMAT                @"http://mwbf.herokuapp.com/mwbf/user/challenge/delete"
#define GET_CHALLENGES_ENDPOINT_FORMAT                  @"http://mwbf.herokuapp.com/mwbf/user/challenge/getAll"
#define USER_ACTIVITIES_BY_ACTIVITY_ENDPOINT_FORMAT     @"http://mwbf.herokuapp.com/mwbf/user/activitiesByActivity"
#define USER_ACTIVITIES_BY_TIME_ENDPOINT_FORMAT         @"http://mwbf.herokuapp.com/mwbf/user/activitiesByTime"
#define MWBF_ACTIVITY_LIST_ENDPOINT_FORMAT              @"http://mwbf.herokuapp.com/mwbf/mwbf/activities"
#define DELETE_USER_ACTIVITIES_ENDPOINT_FORMAT          @"http://mwbf.herokuapp.com/mwbf/user/deleteUserActivities"
*/


 
@implementation MWBFService


- (BOOL) loginFaceBookUser:(NSString *) email withFirstName:(NSString *)firstName withLastName:(NSString*) lastName withProfileId:(NSString *)profileId withResponse:(NSString**) response;
{
    
    NSString *post =[[NSString alloc] initWithFormat:@"{\"email\"=\"%@\",\"firstName\"=\"%@\",\"lastName\"=\"%@\",\"profileId\"=\"%@\"}",email,firstName,lastName,profileId];
    NSURL *url=[NSURL URLWithString:FB_USER_LOGIN_ENDPOINT_FORMAT];
    
    HTTPPostRequest *service = [[HTTPPostRequest alloc] init];
    NSData *urlData = [service sendPostRequest:post toURL:url];
    
    NSError *error = nil;
    NSDictionary *jsonData = [NSJSONSerialization
                              JSONObjectWithData:urlData
                              options:NSJSONReadingMutableContainers
                              error:&error];
    
    *response = (NSString *) jsonData[@"message"];
    NSInteger success = [jsonData[@"success"] integerValue];
    if(success == 1)
        return YES;
    else
        return NO;
    
    return NO;
}

/////////////////////////////
// ACTIVITY /////////////////
/////////////////////////////
- (BOOL) logActivity:(NSString*) post withResponse:(NSString**)response
{
    NSURL *url=[NSURL URLWithString:LOG_ACTIVITY_ENDPOINT_FORMAT];
    
    HTTPPostRequest *service = [[HTTPPostRequest alloc] init];
    NSData *urlData = [service sendPostRequest:post toURL:url];
    
    NSError *error = nil;
    NSDictionary *jsonData = [NSJSONSerialization
                              JSONObjectWithData:urlData
                              options:NSJSONReadingMutableContainers
                              error:&error];
    
    *response = (NSString *) jsonData[@"message"];
    NSInteger success = [jsonData[@"success"] integerValue];
    if(success == 1)
        return YES;
    else
        return NO;
    
    return NO;
}

// Send a request to the server to get the list of all the activities
- (NSMutableDictionary*) getActivityListWithResponseUsingPost
{
    NSURL *url = [NSURL URLWithString:MWBF_ACTIVITY_LIST_ENDPOINT_FORMAT];
    NSString *post =[[NSString alloc] initWithFormat:@"{\"email\"=\"\"}"];
    
    HTTPPostRequest *service = [[HTTPPostRequest alloc] init];
    NSData *urlData = [service sendPostRequest:post toURL:url];
    
    NSError *error = nil;
    NSMutableDictionary *returnDict = [NSMutableDictionary dictionary];
    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:urlData options:0 error:&error];
    if (jsonArray)
    {
        for (id activity in jsonArray)
        {
            MWBFActivities *mwbfActivity = [[MWBFActivities alloc] init];
            
            mwbfActivity.activityName = [activity objectForKey:@"activityName"];
            mwbfActivity.activityId = [[activity objectForKey:@"id"] integerValue];
            mwbfActivity.measurementUnits = [activity objectForKey:@"measurementUnit"];
            mwbfActivity.pointsPerUnit = [[activity objectForKey:@"pointsPerUnit"] doubleValue];
            mwbfActivity.wholeUnit = [[activity objectForKey:@"wholeUnit"] doubleValue];
            
            [returnDict setObject:mwbfActivity forKey:mwbfActivity.activityName];
        }
    }
    
    return returnDict;
}


// Send a request to the server to get the users activites for a given date
- (NSArray*) getActivitiesForUserByActivityFromDate:(NSString *) fromDate toDate:(NSString*) toDate
{
    User *user = [User getInstance];
    
    NSString *post =[[NSString alloc] initWithFormat:@"{\"user_id\"=\"%@\",\"from_date\"=\"%@\",\"to_date\"=\"%@\"}",user.userId,fromDate,toDate];
    NSURL *url=[NSURL URLWithString:USER_ACTIVITIES_BY_ACTIVITY_ENDPOINT_FORMAT];
    
    HTTPPostRequest *service = [[HTTPPostRequest alloc] init];
    NSData *urlData = [service sendPostRequest:post toURL:url];
    
    NSError *error = nil;
    NSArray *jsonData = [NSJSONSerialization
                              JSONObjectWithData:urlData
                              options:NSJSONReadingMutableContainers
                              error:&error];
    
    return jsonData;
}

// Send a request to the server to get the users activites for a given date
- (NSArray*) getActivitiesForUserByTimeFromDate:(NSString *) fromDate toDate:(NSString*) toDate
{
    User *user = [User getInstance];
    
    NSString *post =[[NSString alloc] initWithFormat:@"{\"user_id\"=\"%@\",\"from_date\"=\"%@\",\"to_date\"=\"%@\"}",user.userId,fromDate,toDate];
    NSURL *url=[NSURL URLWithString:USER_ACTIVITIES_BY_TIME_ENDPOINT_FORMAT];
    
    HTTPPostRequest *service = [[HTTPPostRequest alloc] init];
    NSData *urlData = [service sendPostRequest:post toURL:url];
    
    NSError *error = nil;
    NSArray *jsonData = [NSJSONSerialization
                         JSONObjectWithData:urlData
                         options:NSJSONReadingMutableContainers
                         error:&error];
    
    return jsonData;
}

- (BOOL) deleteAllActivitiesForUser
{
    User *user = [User getInstance];
    
    NSString *post =[[NSString alloc] initWithFormat:@"{\"email\"=\"%@\",\"user_id\"=\"%@\"}",user.userEmail,user.userId];
    NSURL *url=[NSURL URLWithString:DELETE_USER_ACTIVITIES_ENDPOINT_FORMAT];
    
    HTTPPostRequest *service = [[HTTPPostRequest alloc] init];
    NSData *urlData = [service sendPostRequest:post toURL:url];
    
    NSError *error = nil;
    NSDictionary *jsonData = [NSJSONSerialization
                              JSONObjectWithData:urlData
                              options:NSJSONReadingMutableContainers
                              error:&error];
    
    NSInteger success = [jsonData[@"success"] integerValue];
    if(success == 1)
        return YES;
    else
        return NO;
    
    return NO;
}

//////////////// FRIENDS //////////////////////

// Send a request to the server to get the friends activites for a given date
- (NSArray*) getActivitiesForFriend:(Friend*)friend byActivityFromDate:(NSString *) fromDate toDate:(NSString*) toDate
{
    NSString *post =[[NSString alloc] initWithFormat:@"{\"user_id\"=\"%@\",\"from_date\"=\"%@\",\"to_date\"=\"%@\"}",friend.email,fromDate,toDate];
    NSURL *url=[NSURL URLWithString:USER_ACTIVITIES_BY_ACTIVITY_ENDPOINT_FORMAT];
    
    HTTPPostRequest *service = [[HTTPPostRequest alloc] init];
    NSData *urlData = [service sendPostRequest:post toURL:url];
    
    NSError *error = nil;
    NSArray *jsonData = [NSJSONSerialization
                         JSONObjectWithData:urlData
                         options:NSJSONReadingMutableContainers
                         error:&error];
    
    return jsonData;
}

// Send a request to the server to get the users activites for a given date
- (NSArray*) getActivitiesForFriend:(Friend*)friend byTimeFromDate:(NSString *) fromDate toDate:(NSString*) toDate
{
    NSString *post =[[NSString alloc] initWithFormat:@"{\"user_id\"=\"%@\",\"from_date\"=\"%@\",\"to_date\"=\"%@\"}",friend.email,fromDate,toDate];
    NSURL *url=[NSURL URLWithString:USER_ACTIVITIES_BY_TIME_ENDPOINT_FORMAT];
    
    HTTPPostRequest *service = [[HTTPPostRequest alloc] init];
    NSData *urlData = [service sendPostRequest:post toURL:url];
    
    NSError *error = nil;
    NSArray *jsonData = [NSJSONSerialization
                         JSONObjectWithData:urlData
                         options:NSJSONReadingMutableContainers
                         error:&error];
    
    return jsonData;
}


- (NSMutableArray*) getFriendsList
{
    User *user = [User getInstance];
    
    NSString *post =[[NSString alloc] initWithFormat:@"{\"user_id\"=\"%@\"}",user.userId];
    NSURL *url=[NSURL URLWithString:USER_FRIENDS_ENDPOINT_FORMAT];
    
    HTTPPostRequest *service = [[HTTPPostRequest alloc] init];
    NSData *urlData = [service sendPostRequest:post toURL:url];
    
    NSError *error = nil;
    NSArray *jsonData = [NSJSONSerialization
                         JSONObjectWithData:urlData
                         options:0
                         error:&error];
    
    NSMutableArray *returnFriendsArray = [NSMutableArray array];
    for (int i=0; i < [jsonData count]; i++)
    {
        NSDictionary *friendDict = [jsonData[i] objectForKey:@"friend"];
        
        Friend *friend = [[Friend alloc] init];
        friend.email = [friendDict objectForKey:@"email"];
        friend.firstName = [friendDict objectForKey:@"firstName"];
        friend.lastName = [friendDict objectForKey:@"lastName"];
        friend.fbProfileID = [friendDict objectForKey:@"fbProfileId"];
        
        [returnFriendsArray addObject:friend];
    }
    
    return returnFriendsArray;
}

- (BOOL) addFriendWithId:(NSString*) friendId
{
    User *user = [User getInstance];
    
    NSString *post =[[NSString alloc] initWithFormat:@"{\"user_id\"=\"%@\",\"friend_user_id\"=\"%@\"}",user.userEmail,friendId];
    NSURL *url=[NSURL URLWithString:USER_ADD_FRIEND_ENDPOINT_FORMAT];
    
    HTTPPostRequest *service = [[HTTPPostRequest alloc] init];
    NSData *urlData = [service sendPostRequest:post toURL:url];
    
    NSError *error = nil;
    NSDictionary *jsonData = [NSJSONSerialization
                              JSONObjectWithData:urlData
                              options:NSJSONReadingMutableContainers
                              error:&error];
    NSInteger success = [jsonData[@"success"] integerValue];
    if(success == 1)
        return YES;
    else
        return NO;
    
    return NO;
}

- (NSDictionary *) findFriendWithId:(NSString*) friendId
{
    NSString *post =[[NSString alloc] initWithFormat:@"{\"user_id\"=\"%@\"}",friendId];
    NSURL *url=[NSURL URLWithString:USER_FIND_FRIEND_ENDPOINT_FORMAT];
    
    HTTPPostRequest *service = [[HTTPPostRequest alloc] init];
    NSData *urlData = [service sendPostRequest:post toURL:url];
    
    NSError *error = nil;
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:urlData options:NSJSONReadingMutableContainers error:&error];
    
    return jsonDict;
}


////////////////// CHALLENGES ///////////////////

- (BOOL) addChallenge:(NSString*) post
{
    NSURL *url=[NSURL URLWithString:ADD_CHALLENGE_ENDPOINT_FORMAT];
    
    HTTPPostRequest *service = [[HTTPPostRequest alloc] init];
    NSData *urlData = [service sendPostRequest:post toURL:url];
    
    NSError *error = nil;
    NSDictionary *jsonData = [NSJSONSerialization
                              JSONObjectWithData:urlData
                              options:NSJSONReadingMutableContainers
                              error:&error];
    
    NSInteger success = [jsonData[@"success"] integerValue];
    if(success == 1)
        return YES;
    else
        return NO;
    
    return NO;
}

- (void) getChallenges
{
    User *user = [User getInstance];
    
    NSString *post =[[NSString alloc] initWithFormat:@"{\"user_id\"=\"%@\"}",user.userId];
    NSURL *url=[NSURL URLWithString:GET_CHALLENGES_ENDPOINT_FORMAT];
    
    HTTPPostRequest *service = [[HTTPPostRequest alloc] init];
    NSData *urlData = [service sendPostRequest:post toURL:url];
    
    NSError *error = nil;
    NSArray *jsonData = [NSJSONSerialization
                         JSONObjectWithData:urlData
                         options:0
                         error:&error];
    
    NSMutableArray *returnArray = [NSMutableArray array];
    //NSLog(@"Challenges [%@]",jsonData);
    for (id challenge in jsonData)
    {
        Challenge *ch = [[Challenge alloc] init];
        
        NSString *startDate = [challenge objectForKey:@"startDate"];
        NSString *endDate = [challenge objectForKey:@"endDate"];
        NSString *name = [challenge objectForKey:@"name"];
        NSString *ch_id = [challenge objectForKey:@"id"];
        NSString *creatorId = [challenge objectForKey:@"creatorId"];
        
        NSArray *playerPointsArr =[challenge objectForKey:@"playerPointsSet"];
        NSArray *activityArr =[challenge objectForKey:@"activitySet"];
        NSArray *messagesArr =[challenge objectForKey:@"messageList"];
    
        ch.name = name;
        ch.startDate = startDate;
        ch.endDate = endDate;
        ch.challenge_id = ch_id;
        ch.activitySet = [NSArray arrayWithArray:activityArr];
        ch.playersSet = [NSArray arrayWithArray:playerPointsArr];
        ch.messageList = [NSMutableArray arrayWithArray:messagesArr];
        ch.creatorId  = creatorId;
        
        [returnArray addObject:ch];
    }
    
    user.challengesList = [NSMutableArray arrayWithArray:returnArray];
}

- (BOOL) deleteChallenge:(NSString*)challenge_id
{
    User *user = [User getInstance];
    
    NSURL *url=[NSURL URLWithString:DELETE_CHALLENGE_ENDPOINT_FORMAT];
    NSString *post =[[NSString alloc] initWithFormat:@"{\"user_id\"=\"%@\",\"challenge_id\"=\"%@\"}",user.userId,challenge_id];
    
    HTTPPostRequest *service = [[HTTPPostRequest alloc] init];
    NSData *urlData = [service sendPostRequest:post toURL:url];
    
    NSError *error = nil;
    NSDictionary *jsonData = [NSJSONSerialization
                              JSONObjectWithData:urlData
                              options:NSJSONReadingMutableContainers
                              error:&error];
    
    NSInteger success = [jsonData[@"success"] integerValue];
    if(success == 1)
        return YES;
    else
        return NO;
    
    return NO;
}

- (void) getAllTimeHighs
{
    
    User *user = [User getInstance];
    
    NSString *post =[[NSString alloc] initWithFormat:@"{\"user_id\"=\"%@\"}",user.userId];
    NSURL *url=[NSURL URLWithString:USER_HIGHS_ENDPOINT_FORMAT];
    
    HTTPPostRequest *service = [[HTTPPostRequest alloc] init];
    NSData *urlData = [service sendPostRequest:post toURL:url];
    
    NSError *error = nil;
    NSArray *jsonData = [NSJSONSerialization
                         JSONObjectWithData:urlData
                         options:0
                         error:&error];
    
    int i = 0;
    for (id key in jsonData)
    {
        NSString *date = [key objectForKey:@"date"];
        NSString *points = [key objectForKey:@"points"];
        
        if (i == 0)
        {
            user.bestDay = date;
            user.bestDayPoints = points;
        }
        else if (i == 1)
        {
            user.bestMonth = date;
            user.bestMonthPoints = points;
        }
        else
        {
            user.bestYear = date;
            user.bestYearPoints = points;
        }
        
        i = i + 1;
    }
}


@end
