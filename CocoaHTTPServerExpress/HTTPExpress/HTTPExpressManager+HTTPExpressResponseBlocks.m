//
//  HTTPExpressManager+HTTPExpressResponseBlocks.m
//  CocoaHTTPServerExpress
//
//  Created by chrise26 on 7/1/13.
//  Copyright (c) 2013 mgchris. All rights reserved.
//

#import "HTTPExpressManager+HTTPExpressResponseBlocks.h"
#import "HTTPDataResponse.h"

@implementation HTTPExpressManager (HTTPExpressResponseBlocks)

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
