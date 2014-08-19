//
//  HTTPGetRequest.h
//  MWBF-Demo
//
//  Created by ARJUN MUKHERJEE.
//  Copyright (c) 2014 Arjun Mukherjee. All rights reserved.
//

typedef void(^SuccessBlock)(NSData *response);
typedef void(^FailureBlock)(NSError *error);

@interface HTTPGetRequest : NSObject

- (id) initWithUrl:(NSURL *)requestURL successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock;
- (void) startRequest;

@end
