//
//  HTTPExpressReponseManager.h
//  CocoaHTTPServerForTesting
//
//  Created by chrise26 on 6/26/13.
//  Copyright (c) 2013 chrise26. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HTTPExpressReponseManager;
@class HTTPMessage;
@class HTTPServer;
@protocol HTTPResponse;

/**
 Should evaluate the message to see if connected response should fire
 */
typedef BOOL(^HTTPExpressEvaluateBlock)(HTTPMessage *message);

/**
 Return an object 
 */
typedef NSObject<HTTPResponse>*(^HTTPExpressResponseBlock)(HTTPMessage *request);



#pragma mark -
@interface HTTPExpressManager : NSObject

/**
 Instance of HttpServer that is used by the defaultManager
 */
@property (nonatomic, strong) HTTPServer* httpServer;

/**
 Hold all of the response blocks, managed by this object
 */
@property (nonatomic, readonly, strong) NSMutableDictionary* responseBlocks;

/**
 Access a singleton object that has default value setup for testing
 */
+ (HTTPExpressManager*)defaultManager;

/**
 Return a string that can be used to create a url
 */
- (NSString*)urlStringForHost;

/**
 Build a url with 
 */
- (NSURL*)urlWithPath:(NSString*)urlPath;

/**
 Create the key for referencing a evaluate and response block
 */
- (NSString*)generateKey;


#pragma mark Response Methods
/**
 Add response block that will be fired when evaluate block return YES
 @return The key used to reference connected response and evaluate block.
 @discussion The evaluate blocks gets checked everytime responseForMessage: is called.
 */
- (NSString*)connectEvaluateBlock:(HTTPExpressEvaluateBlock)evaluate withResponseBlock:(HTTPExpressResponseBlock)response;

/**
 Remove blocks that match the key, that is generated from connectEvaluateBlock:withResponseBlock:
 */
- (void)removeBlocksForKey:(NSString*)key;

/**
 Remove all evaluate and response blocks.
 */
- (void)removeAllExpressBlocks;

/**
 Who ever response to this method needs to return a response.  You may return nil
 */
- (NSObject<HTTPResponse>*)responseForMessage:(HTTPMessage*)message;
@end



