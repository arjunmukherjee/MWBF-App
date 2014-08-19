//
//  HTTPPost.h
//  MWBF-Demo
//
//  Created by ARJUN MUKHERJEE on 7/28/14.
//  Copyright (c) 2014 ___Arjun Mukherjee___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTTPPostRequest : NSObject

- (NSData*) sendPostRequest:(NSString *) post toURL:(NSURL*) url;

@end
