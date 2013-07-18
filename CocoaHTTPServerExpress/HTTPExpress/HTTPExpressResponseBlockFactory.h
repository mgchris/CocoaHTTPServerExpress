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


@end
