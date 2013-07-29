//
//  HTTPExpressEvaluationBlockFactory.m
//  CocoaHTTPServerExpress
//
//  Created by Christopher Evans on 7/17/13.
//  Copyright (c) 2013 Christopher Evans. All rights reserved.
//

#import "HTTPExpressEvaluationBlockFactory.h"

@implementation HTTPExpressEvaluationBlockFactory

+ (HTTPExpressEvaluateBlock)evaluateUrlMatch:(NSURL*)url {
    NSURL* blockUrl = [url copy];
    HTTPExpressEvaluateBlock block = ^BOOL(HTTPMessage *message) {
        BOOL fire = NO;
        if( [[message.url relativePath] isEqualToString:[blockUrl relativePath]] ) {
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
        if( [[message.url relativePath] isEqualToString:[blockUrl relativePath]] && [message.method isEqualToString:blockMethod] ) {
            fire = YES;
        }
        return fire;
    };
    return block;
}


@end
