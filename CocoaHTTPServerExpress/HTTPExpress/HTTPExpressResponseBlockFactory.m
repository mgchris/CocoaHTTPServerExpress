//
//  HTTPExpressResponseBlockFactory.m
//  CocoaHTTPServerExpress
//
//  Created by Christopher Evans on 7/17/13.
//  Copyright (c) 2013 Christopher Evans. All rights reserved.
//

#import "HTTPExpressResponseBlockFactory.h"
#import "HTTPDataResponse.h"
#import "HTTPExpressResponse.h"

@implementation HTTPExpressResponseBlockFactory

+ (HTTPExpressResponseBlock)responseWithString:(NSString*)string {
    return [self responseWithString:string encoding:NSUTF8StringEncoding];
}

+ (HTTPExpressResponseBlock)responseWithString:(NSString*)string encoding:(NSStringEncoding)encoding {
    NSString* blockString = [string copy];
    HTTPExpressResponseBlock block = ^HTTPExpressResponse *(HTTPMessage *request) {
        return [[HTTPExpressResponse alloc] initWithResponse:[[HTTPDataResponse alloc] initWithData:[blockString dataUsingEncoding:encoding]]];
    };
    return block;
}

+ (HTTPExpressResponseBlock)responseWithFilePath:(NSString*)filePath {
    NSString* blockPath = [filePath copy];
    HTTPExpressResponseBlock block = ^HTTPExpressResponse *(HTTPMessage *request) {
        return [[HTTPExpressResponse alloc] initWithResponse:[[HTTPDataResponse alloc] initWithData:[NSData dataWithContentsOfFile:blockPath]]];
    };
    return block;
}

+ (HTTPExpressResponseBlock)responseWithErrorCode:(NSInteger)statusCode
                                      description:(NSString*)description
                                          version:(NSString*)version
                                     headerFields:(NSDictionary*)header
                              terminateConnection:(BOOL)terminate {
    HTTPExpressResponseBlock block = ^HTTPExpressResponse *(HTTPMessage *request) {
        HTTPMessage* message = [[HTTPMessage alloc] initResponseWithStatusCode:statusCode
                                                                   description:description
                                                                       version:version];
        // Store the header value in the message
        NSArray* dictKeys = [header allKeys];
        for (NSString* key in dictKeys) {
            NSString* value = [header objectForKey:key];
            [message setHeaderField:key value:value];
        }
    
        HTTPExpressResponse* response = [[HTTPExpressResponse alloc] initWithMessage:message];
        response.terminateConnection = terminate;
        return response;
    };
    return block;
}

+ (HTTPExpressResponseBlock)responseWithErrorNotFound {

    NSDictionary* headers = @{@"Content-Length":@"0"};
    
    return [HTTPExpressResponseBlockFactory responseWithErrorCode:404
                                                      description:nil
                                                          version:HTTPVersion1_1
                                                     headerFields:headers
                                              terminateConnection:NO];
}

+ (HTTPExpressResponseBlock)responseWithErrorAuthenticationFailed {
    
    NSDictionary* headers = @{@"Content-Length":@"0"};
    
    return [HTTPExpressResponseBlockFactory responseWithErrorCode:401
                                                      description:nil
                                                          version:HTTPVersion1_1
                                                     headerFields:headers
                                              terminateConnection:NO];
}

+ (HTTPExpressResponseBlock)responseWithErrorBadRequest {
    
    NSDictionary* headers = @{@"Content-Length":@"0", @"Connection":@"close"};
    
    return [HTTPExpressResponseBlockFactory responseWithErrorCode:400
                                                      description:nil
                                                          version:HTTPVersion1_1
                                                     headerFields:headers
                                              terminateConnection:YES];
}

+ (HTTPExpressResponseBlock)responseWithErrorServerError {
    NSDictionary* headers = @{@"Content-Length":@"0", @"Connection":@"close"};
    
    return [HTTPExpressResponseBlockFactory responseWithErrorCode:500
                                                      description:nil
                                                          version:HTTPVersion1_1
                                                     headerFields:headers
                                              terminateConnection:YES];
}


@end
