//
//  HTTPExpressResponseBlockFactory.h
//  CocoaHTTPServerExpress
//
//  Created by Christopher Evans on 7/17/13.
//  Copyright (c) 2013 Christopher Evans. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTTPExpressContant.h"


@interface HTTPExpressResponseBlockFactory : NSObject

/**
 String is encoded with NSUTF8StringEncoding
 */
+ (HTTPExpressResponseBlock)responseWithString:(NSString*)string;

/**
 Block that returns a HTTPDataResponse object, with provided string
 */
+ (HTTPExpressResponseBlock)responseWithString:(NSString*)string encoding:(NSStringEncoding)encoding;

/**
 Return a file at path
 */
+ (HTTPExpressResponseBlock)responseWithFilePath:(NSString*)filePath;


#pragma mark - Server Errors
/**
 Returns an error response
 @param statusCode the error for response
 @param description additional message
 @param version HTTP version
 @param headFields header to be applied to the response
 */
+ (HTTPExpressResponseBlock)responseWithErrorCode:(NSInteger)statusCode
                                      description:(NSString*)description
                                          version:(NSString*)version
                                     headerFields:(NSDictionary*)header
                              terminateConnection:(BOOL)terminate;

+ (HTTPExpressResponseBlock)responseWithErrorNotFound;
+ (HTTPExpressResponseBlock)responseWithErrorAuthenticationFailed;
+ (HTTPExpressResponseBlock)responseWithErrorBadRequest;
+ (HTTPExpressResponseBlock)responseWithErrorServerError;

@end
