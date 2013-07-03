//
//  HTTPExpressManager+HTTPExpressEvaluationBlocks.h
//  CocoaHTTPServerExpress
//
//  Created by chrise26 on 7/1/13.
//  Copyright (c) 2013 mgchris. All rights reserved.
//

#import "HTTPExpressManager.h"

@interface HTTPExpressManager (HTTPExpressEvaluationBlocks)

/**
 Will return YES if URL match
 */
+ (HTTPExpressEvaluateBlock)evaluateUrlMatch:(NSURL*)url;

/**
 Will return YES if URL and request method Match
 */
+ (HTTPExpressEvaluateBlock)evaluateUrlMatch:(NSURL*)url withMethod:(NSString*)method;

@end
