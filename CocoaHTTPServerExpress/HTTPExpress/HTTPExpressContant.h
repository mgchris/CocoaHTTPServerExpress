//
//  HTTPExpressContant.h
//  CocoaHTTPServerExpress
//
//  Created by Christopher Evans on 7/17/13.
//  Copyright (c) 2013 Christopher Evans. All rights reserved.
//

#ifndef CocoaHTTPServerExpress_HTTPExpressContant_h
#define CocoaHTTPServerExpress_HTTPExpressContant_h

#import "HTTPMessage.h"
#import "HTTPResponse.h"

/**
 Should evaluate the message to see if connected response should fire
 */
typedef BOOL(^HTTPExpressEvaluateBlock)(HTTPMessage *message);

/**
 Return an object
 */
typedef NSObject<HTTPResponse>*(^HTTPExpressResponseBlock)(HTTPMessage *request);


#endif
