//
//  HTTPExpressResponseData.h
//  CocoaHTTPServerExpress
//
//  Created by chrise26 on 7/24/13.
//  Copyright (c) 2013 Christopher Evans. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "HTTPDataResponse.h"
#import "HTTPMessage.h"

@interface HTTPExpressResponse : NSObject

@property (nonatomic, assign) BOOL isError;
@property (nonatomic, strong) HTTPMessage* messageObject;
@property (nonatomic, assign) BOOL terminateConnection;

@property (nonatomic, assign) BOOL isResponse;
@property (nonatomic, strong) NSObject<HTTPResponse>* responseObject;


- (id)initWithMessage:(HTTPMessage*)message;
- (id)initWithResponse:(NSObject<HTTPResponse>*)response;

@end
