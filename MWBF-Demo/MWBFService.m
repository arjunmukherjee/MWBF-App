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

/*
#define USER_LOGIN_ENDPOINT_FORMAT                      @"http://localhost:8080/MWBFServer/mwbf/user/login"
#define USER_FRIENDS_ENDPOINT_FORMAT                    @"http://localhost:8080/MWBFServer/mwbf/user/friends"
#define FRIENDS_ACTIVITIES_ENDPOINT_FORMAT              @"http://localhost:8080/MWBFServer/mwbf/user/friends/activities"
#define FRIENDS_FEEDS_ENDPOINT_FORMAT                   @"http://localhost:8080/MWBFServer/mwbf/user/friends/feed"
#define USER_FIND_FRIEND_ENDPOINT_FORMAT                @"http://localhost:8080/MWBFServer/mwbf/user/findFriend"
#define USER_FIND_FRIEND_V1_ENDPOINT_FORMAT             @"http://localhost:8080/MWBFServer/mwbf/user/v1/findFriends"
#define USER_ADD_FRIEND_ENDPOINT_FORMAT                 @"http://localhost:8080/MWBFServer/mwbf/user/addFriend"
#define FB_USER_LOGIN_ENDPOINT_FORMAT                   @"http://localhost:8080/MWBFServer/mwbf/user/fbLogin"
#define USER_INFO_ENDPOINT_FORMAT                       @"http://localhost:8080/MWBFServer/mwbf/user/userInfo"
#define LEADER_HIGHS_ENDPOINT_FORMAT                    @"http://localhost:8080/MWBFServer/mwbf/user/leaderAllTimeHighs"
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
*/

#define USER_LOGIN_ENDPOINT_FORMAT                      @"http://mwbf.herokuapp.com/mwbf/user/login"
#define USER_FRIENDS_ENDPOINT_FORMAT                    @"http://mwbf.herokuapp.com/mwbf/user/friends"
#define FRIENDS_ACTIVITIES_ENDPOINT_FORMAT              @"http://mwbf.herokuapp.com/mwbf/user/friends/activities"
#define FRIENDS_FEEDS_ENDPOINT_FORMAT                   @"http://mwbf.herokuapp.com/mwbf/user/friends/feed"
#define USER_FIND_FRIEND_ENDPOINT_FORMAT                @"http://mwbf.herokuapp.com/mwbf/user/findFriend"
#define USER_FIND_FRIEND_V1_ENDPOINT_FORMAT             @"http://mwbf.herokuapp.com/mwbf/user/v1/findFriends"
#define USER_ADD_FRIEND_ENDPOINT_FORMAT                 @"http://mwbf.herokuapp.com/mwbf/user/addFriend"
#define FB_USER_LOGIN_ENDPOINT_FORMAT                   @"http://mwbf.herokuapp.com/mwbf/user/fbLogin"
#define USER_INFO_ENDPOINT_FORMAT                       @"http://mwbf.herokuapp.com/mwbf/user/userInfo"
#define LEADER_HIGHS_ENDPOINT_FORMAT                    @"http://mwbf.herokuapp.com/mwbf/user/leaderAllTimeHighs"
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


#define RANDOM_QUOTE_ENDPOINT @"http://www.iheartquotes.com/api/v1/random?source=oneliners&max_lines=1&show_source=0&format=json"
 
@implementation MWBFService

- (void) getRandomQuote
{
    NSURL *url=[NSURL URLWithString:RANDOM_QUOTE_ENDPOINT];
    
    HTTPPostRequest *service = [[HTTPPostRequest alloc] init];
    NSData *urlData = [service sendPostRequest:nil toURL:url];
    
    NSError *error = nil;
    NSDictionary *jsonData;
    if ( urlData )
        jsonData = [NSJSONSerialization
                    JSONObjectWithData:urlData
                    options:NSJSONReadingMutableContainers
                    error:&error];
    
    NSString *quote = jsonData[@"quote"];
    User *user = [User getInstance];
    if ( [quote length] > 0)
        user.randomQuote = quote;
}

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
    NSArray *jsonData = nil;
    @try
    {
        jsonData = [NSJSONSerialization
                         JSONObjectWithData:urlData
                         options:NSJSONReadingMutableContainers
                         error:&error];
        id temp = jsonData[0];
    }
    @catch (NSException *exception)
    {
        NSLog(@"Exception: %@", exception);
        jsonData = [NSArray array];
    }
    
    return jsonData;
}

// Send a request to the server to get the friends activites
- (void) getFeed
{
    User *user = [User getInstance];
    NSString *post =[[NSString alloc] initWithFormat:@"{\"user_id\"=\"%@\"}",user.userId];
    NSURL *url=[NSURL URLWithString:FRIENDS_FEEDS_ENDPOINT_FORMAT];
    
    HTTPPostRequest *service = [[HTTPPostRequest alloc] init];
    NSData *urlData = [service sendPostRequest:post toURL:url];
    
    NSError *error = nil;
    
    @try
    {
        NSArray *jsonData;
        if ( urlData )
            jsonData = [NSJSONSerialization
                             JSONObjectWithData:urlData
                             options:NSJSONReadingMutableContainers
                             error:&error];
        [user.friendsActivitiesList removeAllObjects];
        user.friendsActivitiesList = [NSMutableArray arrayWithArray:jsonData];
    }
    @catch (NSException * e)
    {
        NSLog(@"Exception: %@", e);
    }
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


- (void) getFriendsList
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
    @try
    {
        for (int i=0; i < [jsonData count]; i++)
        {
            NSDictionary *friendDict = [jsonData[i] objectForKey:@"user"];
        
            Friend *friend = [[Friend alloc] init];
            friend.email = [friendDict objectForKey:@"email"];
            friend.firstName = [friendDict objectForKey:@"firstName"];
            friend.lastName = [friendDict objectForKey:@"lastName"];
            friend.fbProfileID = [friendDict objectForKey:@"fbProfileId"];
            
            NSDictionary *bestDayDict = [jsonData[i] objectForKey:@"bestDay"];
            NSDictionary *bestWeekDict = [jsonData[i] objectForKey:@"bestWeek"];
            NSDictionary *bestMonthDict = [jsonData[i] objectForKey:@"bestMonth"];
            NSDictionary *bestYearDict = [jsonData[i] objectForKey:@"bestYear"];
            
            UserStats *stats = [[UserStats alloc] init];
            stats.bestDay = bestDayDict[@"date"];
            stats.bestWeek = bestWeekDict[@"date"];
            stats.bestMonth = bestMonthDict[@"date"];
            stats.bestYear = bestYearDict[@"date"];
            
            stats.bestDayPoints = bestDayDict[@"points"];
            stats.bestWeekPoints = bestWeekDict[@"points"];
            stats.bestMonthPoints = bestMonthDict[@"points"];
            stats.bestYearPoints = bestYearDict[@"points"];
            
            float bestDayPointsFloat = [stats.bestDayPoints floatValue];
            stats.bestDayPoints = [NSString stringWithFormat:@"%0.1f",bestDayPointsFloat];
            
            float bestWeekPointsFloat = [stats.bestWeekPoints floatValue];
            stats.bestWeekPoints = [NSString stringWithFormat:@"%0.1f",bestWeekPointsFloat];
            
            float bestMonthPointsFloat = [stats.bestMonthPoints floatValue];
            stats.bestMonthPoints = [NSString stringWithFormat:@"%0.1f",bestMonthPointsFloat];
            
            float bestYearPointsFloat = [stats.bestYearPoints floatValue];
            stats.bestYearPoints = [NSString stringWithFormat:@"%0.1f",bestYearPointsFloat];
            
            stats.currentWeekPoints = [jsonData[i] objectForKey:@"currentWeekPoints"];
            stats.currentMonthPoints = [jsonData[i] objectForKey:@"currentMonthPoints"];
            stats.currentYearPoints = [jsonData[i] objectForKey:@"currentYearPoints"];
            
            stats.numberOfTotalChallenges = [jsonData[i] objectForKey:@"numberOfTotalChallenges"];
            stats.numberOfActiveChallenges = [jsonData[i] objectForKey:@"numberOfActiveChallenges"];
            stats.numberOfWonChallenges = [jsonData[i] objectForKey:@"numberOfWonChallenges"];
            
            friend.stats = stats;
            
            [returnFriendsArray addObject:friend];
        }
    }
    @catch (NSException * e)
    {
        NSLog(@"Exception: %@", e);
    }
    
    user.friendsList = returnFriendsArray;
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

- (NSMutableArray*) findFriendV1WithId:(NSString*) friendId
{
    NSString *post =[[NSString alloc] initWithFormat:@"{\"userIdentification\"=\"%@\"}",friendId];
    NSURL *url=[NSURL URLWithString:USER_FIND_FRIEND_V1_ENDPOINT_FORMAT];
    
    HTTPPostRequest *service = [[HTTPPostRequest alloc] init];
    NSData *urlData = [service sendPostRequest:post toURL:url];
    
    NSError *error = nil;
    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:urlData options:NSJSONReadingMutableContainers error:&error];
    
    NSMutableArray *searchResults = [NSMutableArray array];
    @try
    {
        for (id key in jsonArray)
        {
            Friend *friend = [[Friend alloc] init];
            
            friend.email = [key objectForKey:@"email"];
            friend.fbProfileID = [key objectForKey:@"fbProfileId"];
            friend.firstName = [key objectForKey:@"firstName"];
            friend.lastName = [key objectForKey:@"lastName"];
            
            [searchResults addObject:friend];
        }
    }
    @catch (NSException * e)
    {
        NSLog(@"Exception: %@", e);
    }

    return searchResults;
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
    
    @try
    {
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
    }
    @catch (NSException * e)
    {
        NSLog(@"Exception: %@", e);
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

- (void) getUserInfo
{
    
    User *user = [User getInstance];
    
    NSString *post =[[NSString alloc] initWithFormat:@"{\"user_id\"=\"%@\"}",user.userId];
    NSURL *url=[NSURL URLWithString:USER_INFO_ENDPOINT_FORMAT];
    
    HTTPPostRequest *service = [[HTTPPostRequest alloc] init];
    NSData *urlData = [service sendPostRequest:post toURL:url];
    
    NSError *error = nil;
    NSDictionary *jsonData = [NSJSONSerialization
                         JSONObjectWithData:urlData
                         options:0
                         error:&error];
    
    UserStats *stats = [[UserStats alloc] init];
    
    NSDictionary *bestDayDict = [jsonData objectForKey:@"bestDay"];
    NSDictionary *bestWeekDict = [jsonData objectForKey:@"bestWeek"];
    NSDictionary *bestMonthDict = [jsonData objectForKey:@"bestMonth"];
    NSDictionary *bestYearDict = [jsonData objectForKey:@"bestYear"];
    
    stats.bestDay = bestDayDict[@"date"];
    stats.bestWeek = bestWeekDict[@"date"];
    stats.bestMonth = bestMonthDict[@"date"];
    stats.bestYear = bestYearDict[@"date"];
    
    stats.bestDayPoints = bestDayDict[@"points"];
    stats.bestWeekPoints = bestWeekDict[@"points"];
    stats.bestMonthPoints = bestMonthDict[@"points"];
    stats.bestYearPoints = bestYearDict[@"points"];
    
    float bestDayPointsFloat = [stats.bestDayPoints floatValue];
    stats.bestDayPoints = [NSString stringWithFormat:@"%0.1f",bestDayPointsFloat];
    
    float bestWeekPointsFloat = [stats.bestWeekPoints floatValue];
    stats.bestWeekPoints = [NSString stringWithFormat:@"%0.1f",bestWeekPointsFloat];
    
    float bestMonthPointsFloat = [stats.bestMonthPoints floatValue];
    stats.bestMonthPoints = [NSString stringWithFormat:@"%0.1f",bestMonthPointsFloat];
    
    float bestYearPointsFloat = [stats.bestYearPoints floatValue];
    stats.bestYearPoints = [NSString stringWithFormat:@"%0.1f",bestYearPointsFloat];
    
    stats.currentWeekPoints = [jsonData objectForKey:@"currentWeekPoints"];
    stats.currentMonthPoints = [jsonData objectForKey:@"currentMonthPoints"];
    stats.currentYearPoints = [jsonData objectForKey:@"currentYearPoints"];
    
    stats.numberOfTotalChallenges = [jsonData objectForKey:@"numberOfTotalChallenges"];
    stats.numberOfActiveChallenges = [jsonData objectForKey:@"numberOfActiveChallenges"];
    stats.numberOfWonChallenges = [jsonData objectForKey:@"numberOfWonChallenges"];
    
    NSDictionary *weeklyComparisons = [jsonData objectForKey:@"weeklyComparisons"];
    user.weeklyPointsUser = weeklyComparisons[@"userPoints"];
    user.weeklyPointsFriendsAverage = weeklyComparisons[@"friendsPointsAverage"];
    user.weeklyPointsLeader = weeklyComparisons[@"leaderPoints"];
    
    user.userStats = stats;
}

- (void) getLeaderAllTimeHighs
{
    
    User *user = [User getInstance];
    
    NSString *post =[[NSString alloc] initWithFormat:@"{\"user_id\"=\"%@\"}",user.userId];
    NSURL *url=[NSURL URLWithString:LEADER_HIGHS_ENDPOINT_FORMAT];
    
    HTTPPostRequest *service = [[HTTPPostRequest alloc] init];
    NSData *urlData = [service sendPostRequest:post toURL:url];
    
    NSError *error = nil;
    NSArray *jsonData = [NSJSONSerialization
                         JSONObjectWithData:urlData
                         options:0
                         error:&error];
    
    if (jsonData != nil)
    {
        for (id key in jsonData)
        {
            NSString *date = [key objectForKey:@"date"];
            NSString *points = [key objectForKey:@"points"];
            NSString *aggUnit = [key objectForKey:@"aggUnit"];
            
            NSDictionary *leaderDict = [key objectForKey:@"user"];
            NSString *email = [leaderDict objectForKey:@"email"];
            NSString *fbProfileId = [leaderDict objectForKey:@"fbProfileId"];
            NSString *firstName = [leaderDict objectForKey:@"firstName"];
            NSString *lastName = [leaderDict objectForKey:@"lastName"];
            Friend *leader = [[Friend alloc] init];
            leader.email = email;
            leader.fbProfileID = fbProfileId;
            leader.firstName = firstName;
            leader.lastName = lastName;
            
            
            if ([aggUnit isEqualToString:@"day"])
            {
                user.dayLeader = leader;
                user.bestDayLeader = date;
                user.bestDayLeaderPoints = points;
            }
            else if ([aggUnit isEqualToString:@"week"])
            {
                user.weekLeader = leader;
                user.bestWeekLeader = date;
                user.bestWeekLeaderPoints = points;
            }
            else if ([aggUnit isEqualToString:@"month"])
            {
                user.monthLeader = leader;
                user.bestMonthLeader = date;
                user.bestMonthLeaderPoints = points;
            }
            else if ([aggUnit isEqualToString:@"year"])
            {
                user.yearLeader = leader;
                user.bestYearLeader = date;
                user.bestYearLeaderPoints = points;
            }
        }
    }
}


@end
