//
//  HTTPExpressEvaluationBlockFactory.h
//  CocoaHTTPServerExpress
//
//  Created by Christopher Evans on 7/17/13.
//  Copyright (c) 2013 Christopher Evans. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTTPExpressContant.h"


#pragma mark -
@interface HTTPExpressEvaluationBlockFactory : NSObject

/**
 Will return YES if URL match
 */
+ (HTTPExpressEvaluateBlock)evaluateUrlMatch:(NSURL*)url;

/**
 Will return YES if URL and request method Match
 */
+ (HTTPExpressEvaluateBlock)evaluateUrlMatch:(NSURL*)url withMethod:(NSString*)method;


@end
