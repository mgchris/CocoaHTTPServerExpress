//
//  HTTPExpressResponseData.m
//  CocoaHTTPServerExpress
//
//  Created by chrise26 on 7/24/13.
//  Copyright (c) 2013 Christopher Evans. All rights reserved.
//

#import "HTTPExpressResponse.h"

@implementation HTTPExpressResponse

- (id)initWithResponse:(NSObject<HTTPResponse>*)response {
    self = [super init];
    if( self ) {
        _isResponse = YES;
        _responseObject = response;
    }
    return self;
}

- (id)initWithMessage:(HTTPMessage*)message {
    self = [super init];
    if( self ) {
        _isError = YES;
        _messageObject = message;
    }
    return self;
}


@end
