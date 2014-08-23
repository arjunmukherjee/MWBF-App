//
//  MusicStoreService.h
//  iMusic
//
//  Created by ARJUN MUKHERJEE.
//  Copyright (c) 2014 Arjun Mukherjee, LLC. All rights reserved.
//

typedef void(^ServiceCompletionBlock)(id result, NSError *error);

@interface MWBFService : NSObject

// LOGIN
- (BOOL) loginUser:(NSString *) email withPassword: (NSString *) password withResponse:(NSString**)response;
- (BOOL) loginFaceBookUser:(NSString *) email withFirstName:(NSString *)firstName withLastName:(NSString*) lastName withResponse:(NSString**) response;

// STATS
- (void) getAllTimeHighs;

// REGISTER
- (BOOL) registerUser:(NSString *) email withPassword: (NSString *) password withFirstName:(NSString*) firstName withLastName:(NSString*) lastName withResponse:(NSString**)response;
- (BOOL) registerFaceBookUser:(NSString *) email withResponse:(NSString**) response;

// ACTIVITIES
- (BOOL) logActivity:(NSString *) message withResponse:(NSString**)response;
- (NSArray*) getActivitiesForUserByActivityFromDate:(NSString *) fromDate toDate:(NSString*) toDate;
- (NSArray*) getActivitiesForUserByTimeFromDate:(NSString *) fromDate toDate:(NSString*) toDate;
- (BOOL) deleteAllActivitiesForUser;
- (void) getActivityListWithResponse:(NSString**)response completionBlock:(ServiceCompletionBlock) completionBlock;
- (NSMutableDictionary*) getActivityListWithResponseUsingPost;

// FRIENDS
- (NSMutableArray*) getFriendsList;
- (BOOL) addFriendWithId:(NSString*) friendId;
- (NSDictionary*) findFriendWithId:(NSString*) friendId;


// CHALLENGES
- (BOOL) addChallenge:(NSString*) post;
- (NSMutableArray*) getChallenges;

@end
