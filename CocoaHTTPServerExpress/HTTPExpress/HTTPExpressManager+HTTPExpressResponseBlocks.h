//
//  HTTPExpressManager+HTTPExpressResponseBlocks.h
//  CocoaHTTPServerExpress
//
//  Created by chrise26 on 7/1/13.
//  Copyright (c) 2013 mgchris. All rights reserved.
//

#import "HTTPExpressManager.h"

@interface HTTPExpressManager (HTTPExpressResponseBlocks)

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
