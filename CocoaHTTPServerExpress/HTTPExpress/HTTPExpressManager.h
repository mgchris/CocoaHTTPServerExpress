//
//  HTTPExpressReponseManager.h
//  CocoaHTTPServerForTesting
//
//  Created by Christopher Evans on 6/26/13.
//  Copyright (c) 2013 Christopher Evans. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "HTTPExpressContant.h"

@class HTTPExpressReponseManager;
@class HTTPServerExpress;

/**
 This is the default configuration key used for grouping evaluation and response blocks
 @see activeConfiguration
 */
static NSString * const kHTTPExpressManagerDefaultConfigurationKey = @"default";


#pragma mark - Dictionary Keys
/**
 Key for retrieving Evaluate block in Dictionary.
 @see blocksForKey:
 */
static NSString * const kHTTPExpressManagerDictionaryKeyEvaluate = @"evaluate";

/**
 Key for retrieving Response block in Dictionary.
 @see blocksForKey:
 */
static NSString * const kHTTPExpressManagerDictionaryKeyResponse = @"response";

/**
 Key for retrieving configuration block in Dictionary.
 @see blocksForKey:
 */
static NSString * const kHTTPExpressManagerDictionaryKeyConfiguration = @"configuration";



#pragma mark -
@interface HTTPExpressManager : NSObject

/**
 Instance of HttpServer that is used by the defaultManager
 */
@property (nonatomic, strong) HTTPServerExpress* httpServer;

/**
 The configuration that is currently being used for selecting evaluate and response blocks.  Defaults to kHTTPExpressManagerDefaultConfigurationKey
 @see kHTTPExpressManagerDefaultConfigurationKey
 */
@property (nonatomic, copy) NSString* activeConfiguration;

/**
 *  If connection should accept all connects.
 *  @discussion When a connect has a PUT / POST request, the server need to determine if it will handle the request.  If this is set to NO, it will called the evaluation blocks.  Default is YES.
 */
@property (nonatomic, assign) BOOL supportedAllMethods;

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


#pragma mark blocks Methods
/**
 Calls connectEvaluateBlock:withResponseBlock:forConfiguration: uses the current activeConfiguration
 */
- (NSString*)connectEvaluateBlock:(HTTPExpressEvaluateBlock)evaluate withResponseBlock:(HTTPExpressResponseBlock)response;

/**
 Add response block that will be fired when evaluate block return YES
 @param evaluate The block use to see if a request should fire response
 @param response The block called when evaluate block returns ture.
 @param configurationKey What configuration this evaluate and response block belong too
 @return The key used to reference connected response and evaluate block.
 @discussion The evaluate blocks gets checked everytime responseForMessage: is called.
 */
- (NSString*)connectEvaluateBlock:(HTTPExpressEvaluateBlock)evaluate
                withResponseBlock:(HTTPExpressResponseBlock)response
                 forConfiguration:(NSString*)configuration;

/**
 Returns blocks that match the given key
 @param key The key created when added blocks
 @return dictionary that will at least have the the follow keys: 
        kHTTPExpressManagerDictionaryKeyEvaluate,
        kHTTPExpressManagerDictionaryKeyResponse,
        kHTTPExpressManagerDictionaryKeyConfiguration
 */
- (NSDictionary*)blocksForKey:(NSString*)key;


/**
 All blocks that are connected to a configuration.
 @param config The configuration to use
 @return Array of NSDictionary that have the same structure as those from blockForKey:
 @see blockForKey:
 */
- (NSArray*)allBlocksForConfiguration:(NSString*)config;


/**
 Remove blocks that match the key, that is generated from connectEvaluateBlock:withResponseBlock:
 */
- (void)removeBlocksForKey:(NSString*)key;

/**
 Remove all evaluate and response blocks.
 */
- (void)removeAllExpressBlocks;

/**
 Remove all blocks that are grouped with a target configuration
 */
- (void)removeBlocksForConfiguration:(NSString*)config;

/**
 Who ever response to this method needs to return a response.  You may return nil
 */
- (HTTPExpressResponse*)responseForMessage:(HTTPMessage*)message;

/**
 Check to see if we support the method for the message
 */
- (BOOL)supportsMethod:(HTTPMessage*)message;

@end



