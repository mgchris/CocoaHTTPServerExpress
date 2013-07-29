//
//  HTTPConnectionExpress.m
//  CocoaHTTPServerForTesting
//
//  Created by Christopher Evans on 6/26/13.
//  Copyright (c) 2013 Christopher Evans. All rights reserved.
//

#import "HTTPExpressConnection.h"
#import "HTTPExpressManager.h"

#import "HTTPLogging.h"
#import "DDNumber.h"
#import "DDRange.h"
#import "DDData.h"
#import "GCDAsyncSocket.h"

// See HTTPConnection.m for more information
#define kHTTPExpressConnection_TIMEOUT_WRITE_ERROR      30
#define kHTTPExpressConnection_HTTP_RESPONSE            90
#define kHTTPExpressConnection_HTTP_FINAL_RESPONSE      91

@implementation HTTPExpressConnection

- (void)replyToHTTPRequest {
    HTTPExpressResponse* response = [[HTTPExpressManager defaultManager] responseForMessage:request];
    if ( response == nil ) {
		[self handleResourceNotFound];
	} else {
        if( response.isResponse ) {
            [self handleResponse:response];
        } else if( response.isError ) {
            [self handleErrorResponse:response];
        }
    }
}

- (void)handleResponse:(HTTPExpressResponse*)response {
    // The super class has these methods.   Not sure if there is a better way to handle this.
    if( response.isResponse && [super respondsToSelector:@selector(sendResponseHeadersAndBody)] ) {
        httpResponse = response.responseObject;
        [super performSelector:@selector(sendResponseHeadersAndBody)];
    }
}

- (void)handleErrorResponse:(HTTPExpressResponse*)response {
    if( response.isError ) {
        NSData *responseData = [self preprocessErrorResponse:response.messageObject];
        NSInteger tag = response.terminateConnection ? kHTTPExpressConnection_HTTP_FINAL_RESPONSE : kHTTPExpressConnection_HTTP_RESPONSE;
        [asyncSocket writeData:responseData
                   withTimeout:kHTTPExpressConnection_TIMEOUT_WRITE_ERROR
                           tag:tag];
    }
}

/**
 * Returns whether or not the server will accept messages of a given method
 * at a particular URI.
 **/
- (BOOL)supportsMethod:(NSString *)method atPath:(NSString *)path
{

    HTTPMessage * testMessage = [[HTTPMessage alloc] initRequestWithMethod:method URL:[[HTTPExpressManager defaultManager] urlWithPath:path] version:@""];

	return [[HTTPExpressManager defaultManager] supportsMethod:testMessage];
}

@end
