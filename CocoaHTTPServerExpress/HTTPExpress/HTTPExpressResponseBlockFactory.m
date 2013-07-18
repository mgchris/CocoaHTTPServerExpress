//
//  HTTPExpressResponseBlockFactory.m
//  CocoaHTTPServerExpress
//
//  Created by Christopher Evans on 7/17/13.
//  Copyright (c) 2013 Christopher Evans. All rights reserved.
//

#import "HTTPExpressResponseBlockFactory.h"
#import "HTTPDataResponse.h"

@implementation HTTPExpressResponseBlockFactory

+ (HTTPExpressResponseBlock)responseWithString:(NSString*)string {
    return [self responseWithString:string encoding:NSUTF8StringEncoding];
}

+ (HTTPExpressResponseBlock)responseWithString:(NSString*)string encoding:(NSStringEncoding)encoding {
    NSString* blockString = [string copy];
    HTTPExpressResponseBlock block = ^NSObject<HTTPResponse> *(HTTPMessage *request) {
        return [[HTTPDataResponse alloc] initWithData:[blockString dataUsingEncoding:encoding]];
    };
    return block;
}

+ (HTTPExpressResponseBlock)responseWithFilePath:(NSString*)filePath {
    NSString* blockPath = [filePath copy];
    HTTPExpressResponseBlock block = ^NSObject<HTTPResponse> *(HTTPMessage *request) {
        return [[HTTPDataResponse alloc] initWithData:[NSData dataWithContentsOfFile:blockPath]];
    };
    return block;
}

@end
