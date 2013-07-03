//
//  HTTPExpressManager+HTTPExpressEvaluationBlocks.m
//  CocoaHTTPServerExpress
//
//  Created by chrise26 on 7/1/13.
//  Copyright (c) 2013 mgchris. All rights reserved.
//

#import "HTTPExpressManager+HTTPExpressEvaluationBlocks.h"
#import "HTTPMessage.h"

@implementation HTTPExpressManager (HTTPExpressEvaluationBlocks)

+ (HTTPExpressEvaluateBlock)evaluateUrlMatch:(NSURL*)url {
    NSURL* blockUrl = [url copy];
    HTTPExpressEvaluateBlock block = ^BOOL(HTTPMessage *message) {
        BOOL fire = NO;
        if( [[message.url absoluteURL] isEqual:blockUrl] ) {
            fire = YES;
        }
        return fire;
    };
    return block;
}

+ (HTTPExpressEvaluateBlock)evaluateUrlMatch:(NSURL*)url withMethod:(NSString*)method {
    NSURL* blockUrl = [url copy];
    NSString* blockMethod = [method copy];
    HTTPExpressEvaluateBlock block = ^BOOL(HTTPMessage *message) {
        BOOL fire = NO;
        if( [[message.url absoluteURL] isEqual:blockUrl] && [message.method isEqualToString:blockMethod] ) {
            fire = YES;
        }
        return fire;
    };
    return block;
}

@end
