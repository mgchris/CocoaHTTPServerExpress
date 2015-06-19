//
//  HTTPExpressManager+Additions.h
//  CocoaHTTPServerExpress
//
//  Created by Christopher Evans on 6/19/15.
//  Copyright (c) 2015 Christopher Evans. All rights reserved.
//

#import "HTTPExpressManager.h"

@interface HTTPExpressManager (Additions)


#pragma mark - Connections
/*!
 Create a evaluation and response block for the given configuration.
 @param url The relative url path to watch for
 @param filePath The file path to open once we get a reponse
 @param configuration The configuration this should be grouped under
 @return The connection key for this block pair
 */
- (NSString *)connectURL:(NSURL *)url
                withFile:(NSString *)filePath
        forConfiguration:(NSString*)configuration;

/*!
 Shortcut method that connects a reponse and eval block.
 @param url The relative url to be watching "/something/some/" that is used in the evaluation.
 @param fileName The file name like "response.json" that should be return if eval is correct
 @return A key that can be use to access this block group directly.
 @discussion This uses the current configuration of the manager.
 */
- (NSString *)connectURL:(NSURL*)url
            withFileName:(NSString*)fileName;


/*!
 Shortcut method that connects a reponse and eval block.
 @param url The relative url to be watching "/something/some/" that is used in the evaluation.
 @param string The string data to return if eval is correct
 @return A key that can be use to access this block group directly.
 @discussion This uses the current configuration of the manager, and server user.
 */
- (NSString *)connectURL:(NSURL*)url
              withString:(NSString*)string;

#pragma mark - Matches
/*!
 See if the relative path of the url matches.
 @param message Hold the request data
 @param path URL path (not host) to compare with such as '/fake/url'
 @return If URL matches return YES else NO
 */
- (BOOL)doRelativePathMatch:(HTTPMessage*)message relativePath:(NSString*)path;

/*!
 Check if the given message has the correct method type
 @param message Hold the request data
 @param method The request method such as POST, GET, PUT, etc
 @return If method type matches return YES else NO
 */
- (BOOL)hasCorrectRequestMethod:(HTTPMessage*)message withMethod:(NSString*)method;


@end
