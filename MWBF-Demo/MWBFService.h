//
//  MusicStoreService.h
//  iMusic
//
//  Created by ARJUN MUKHERJEE.
//  Copyright (c) 2014 Arjun Mukherjee, LLC. All rights reserved.
//

#import "Friend.h"

typedef void(^ServiceCompletionBlock)(id result, NSError *error);

@interface MWBFService : NSObject

// RANDOM QUOTE
- (void) getRandomQuote;

// LOGIN
- (BOOL) loginFaceBookUser:(NSString *) email withFirstName:(NSString *)firstName withLastName:(NSString*) lastName withProfileId:(NSString *)profileId withResponse:(NSString**) response;
- (BOOL) loginEmailUser:(NSString *) email withFirstName:(NSString *)firstName withLastName:(NSString*) lastName withResponse:(NSString**) response;

// STATS
- (void) getUserInfo;
- (void) getLeaderAllTimeHighs;

// ACTIVITIES
- (BOOL) logActivity:(NSString *) message withResponse:(NSString**)response;
- (NSArray*) getActivitiesForUserByActivityFromDate:(NSString *) fromDate toDate:(NSString*) toDate;
- (NSArray*) getActivitiesForUserByTimeFromDate:(NSString *) fromDate toDate:(NSString*) toDate;
- (BOOL) deleteAllActivitiesForUser;
- (NSMutableDictionary*) getActivityListWithResponseUsingPost;
- (BOOL) deleteUserActivityWithId:(NSString*) activityId;

// FRIENDS
- (void) getFriendsList;
- (BOOL) addFriendWithId:(NSString*) friendId;
- (BOOL) actionFriendRequestWithId:(NSString*) requestId withAction: (NSString *) action;
- (void) getPendingFriendRequests;
- (NSMutableArray*) findFriendWithId:(NSString*) friendId;
- (NSArray*) getActivitiesForFriend:(Friend*)friend byActivityFromDate:(NSString *) fromDate toDate:(NSString*) toDate;
- (NSArray*) getActivitiesForFriend:(Friend*)friend byTimeFromDate:(NSString *) fromDate toDate:(NSString*) toDate;
- (void) getFeed;


// CHALLENGES
- (BOOL) addChallenge:(NSString*) post;
- (void) getChallenges;
- (BOOL) deleteChallenge:(NSString*)challenge_id;

// NOTIFICATIONS
- (void) postNotifications:(NSString*) post;

@end
