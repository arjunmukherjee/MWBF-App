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


/*
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
#define GET_CHALLENGES_ENDPOINT_FORMAT                  @"http://localhost:8080/MWBFServer/mwbf/user/challenge/getAll"
#define USER_ACTIVITIES_BY_ACTIVITY_ENDPOINT_FORMAT     @"http://localhost:8080/MWBFServer/mwbf/user/activitiesByActivity"
#define USER_ACTIVITIES_BY_TIME_ENDPOINT_FORMAT         @"http://localhost:8080/MWBFServer/mwbf/user/activitiesByTime"
#define MWBF_ACTIVITY_LIST_ENDPOINT_FORMAT              @"http://localhost:8080/MWBFServer/mwbf/mwbf/activities"
#define DELETE_USER_ACTIVITIES_ENDPOINT_FORMAT          @"http://localhost:8080/MWBFServer/mwbf/user/deleteUserActivities"
*/

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
#define GET_CHALLENGES_ENDPOINT_FORMAT                  @"http://mwbf.herokuapp.com/mwbf/user/challenge/getAll"
#define USER_ACTIVITIES_BY_ACTIVITY_ENDPOINT_FORMAT     @"http://mwbf.herokuapp.com/mwbf/user/activitiesByActivity"
#define USER_ACTIVITIES_BY_TIME_ENDPOINT_FORMAT         @"http://mwbf.herokuapp.com/mwbf/user/activitiesByTime"
#define MWBF_ACTIVITY_LIST_ENDPOINT_FORMAT              @"http://mwbf.herokuapp.com/mwbf/mwbf/activities"
#define DELETE_USER_ACTIVITIES_ENDPOINT_FORMAT          @"http://mwbf.herokuapp.com/mwbf/user/deleteUserActivities"

 
 
@implementation MWBFService


- (BOOL) loginUser:(NSString *) email withPassword: (NSString *) password withResponse:(NSString**) response
{
    NSString *post =[[NSString alloc] initWithFormat:@"{\"email\"=\"%@\",\"password\"=\"%@\"}",email,password];
    NSURL *url=[NSURL URLWithString:USER_LOGIN_ENDPOINT_FORMAT];
    
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

- (BOOL) loginFaceBookUser:(NSString *) email withFirstName:(NSString *)firstName withLastName:(NSString*) lastName withResponse:(NSString**) response;
{
    NSString *post =[[NSString alloc] initWithFormat:@"{\"email\"=\"%@\",\"firstName\"=\"%@\",\"lastName\"=\"%@\"}",email,firstName,lastName];
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


- (BOOL) registerUser:(NSString *) email withPassword: (NSString *) password withFirstName:(NSString*) firstName withLastName:(NSString*) lastName withResponse:(NSString**) response
{
    NSString *post =[[NSString alloc] initWithFormat:@"{\"email\"=\"%@\",\"password\"=\"%@\",\"firstName\"=\"%@\",\"lastName\"=\"%@\"}",email,password,firstName,lastName];
    NSURL *url=[NSURL URLWithString:USER_ADD_ENDPOINT_FORMAT];
    
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

- (BOOL) registerFaceBookUser:(NSString *) email withResponse:(NSString**) response
{
    NSString *post =[[NSString alloc] initWithFormat:@"{\"email\"=\"%@\"}",email];
    NSURL *url=[NSURL URLWithString:FB_USER_ADD_ENDPOINT_FORMAT];
    
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
- (void) getActivityListWithResponse:(NSString**)response completionBlock:(ServiceCompletionBlock) completionBlock
{
    NSURL *url = [NSURL URLWithString:MWBF_ACTIVITY_LIST_ENDPOINT_FORMAT];
    
    SuccessBlock successBlock = ^(NSData *response){
        NSError *error;
        NSMutableDictionary *returnDict = [NSMutableDictionary dictionary];
        NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:response options:0 error:&error];
        if (jsonArray)
        {
            for (id activity in jsonArray)
            {
                MWBFActivities *mwbfActivity = [[MWBFActivities alloc] init];
                
                mwbfActivity.activityName = [activity objectForKey:@"activityName"];
                mwbfActivity.activityId = [[activity objectForKey:@"id"] integerValue];
                mwbfActivity.measurementUnits = [activity objectForKey:@"measurementUnit"];
                mwbfActivity.pointsPerUnit = [[activity objectForKey:@"pointsPerUnit"] doubleValue];
                
                [returnDict setObject:mwbfActivity forKey:mwbfActivity.activityName];
            }
            completionBlock(returnDict,nil);
        }
        else
            completionBlock(nil,error);
    };
    
    FailureBlock failureBlock = ^(NSError *error){
        completionBlock(nil,error);
    };
    
    HTTPGetRequest *request = [[HTTPGetRequest alloc] initWithUrl:url successBlock:successBlock failureBlock:failureBlock];
    [request startRequest];
    
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
        friend.name = [NSString stringWithFormat:@"%@ %@",[friendDict objectForKey:@"firstName"],[friendDict objectForKey:@"lastName"]];
        
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

- (NSMutableArray*) getChallenges
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
    
    return jsonData;
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
