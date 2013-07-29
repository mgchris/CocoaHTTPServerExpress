//
//  HTTPExpressReponseManager.m
//  CocoaHTTPServerForTesting
//
//  Created by Christopher Evans on 6/26/13.
//  Copyright (c) 2013 Christopher Evans. All rights reserved.
//

#import "HTTPExpressManager.h"

#import "HTTPMessage.h"
#import "HTTPDataResponse.h"
#import "HTTPFileResponse.h"

#import "HTTPServer.h"
#import "HTTPExpressConnection.h"

#import "HTTPExpressEvaluationBlockFactory.h"


static HTTPExpressManager * httpExpressManagerDefaultManagerInstance = nil;
static NSString * const kHTTPExpressManagerDictionaryKeyResponse = @"response";
static NSString * const kHTTPExpressManagerDictionaryKeyEvaluate = @"evaluate";

@interface HTTPExpressManager ()
@property (nonatomic, strong) NSMutableDictionary* responseBlocks;
@end


@implementation HTTPExpressManager

+ (HTTPExpressManager*)defaultManager {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        httpExpressManagerDefaultManagerInstance = [[HTTPExpressManager alloc] init];
        
        HTTPServer* server = [[HTTPServer alloc] init];
        [server setType:@"_http._tcp."];
        [server setConnectionClass:[HTTPExpressConnection class]];
        
        NSAssert([server start:nil] == YES, @"Failed to create server!");
        httpExpressManagerDefaultManagerInstance.httpServer = server;
    });
    
    return httpExpressManagerDefaultManagerInstance;
}


#pragma mark -
- (id)init {
    self = [super init];
    if( self ) {
        _responseBlocks = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)dealloc {
    [_httpServer stop];
}


#pragma mark -
- (NSString*)generateKey {
    return [[NSUUID UUID] UUIDString];
}

- (NSString*)urlStringForHost {
    return [NSString stringWithFormat:@"http://127.0.0.1:%d", self.httpServer.listeningPort];
}

- (NSURL*)urlWithPath:(NSString*)urlPath {
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [self urlStringForHost], urlPath]];
}


#pragma mark -
- (NSString*)connectEvaluateBlock:(HTTPExpressEvaluateBlock)evaluate withResponseBlock:(HTTPExpressResponseBlock)response {
    NSString* key = nil;
    if( evaluate  && response ) {
        key = [self generateKey];
        NSDictionary* dict = @{kHTTPExpressManagerDictionaryKeyEvaluate:evaluate, kHTTPExpressManagerDictionaryKeyResponse:response};
        [self.responseBlocks setObject:dict forKey:key];
    }
    return key;
}

- (void)removeBlocksForKey:(NSString*)key {
    NSDictionary* dict = [self.responseBlocks objectForKey:key];
    if( dict ) {
        [self.responseBlocks removeObjectForKey:key];
    }
}

- (void)removeAllExpressBlocks {
    [self.responseBlocks removeAllObjects];
}

- (HTTPExpressResponse*)responseForMessage:(HTTPMessage*)message {
    HTTPExpressResponse* httpResponse = nil;
    NSArray* allValues = self.responseBlocks.allValues;
    for(NSDictionary* dict in allValues) {
        HTTPExpressEvaluateBlock evaluate = [dict objectForKey:kHTTPExpressManagerDictionaryKeyEvaluate];
        HTTPExpressResponseBlock response = [dict objectForKey:kHTTPExpressManagerDictionaryKeyResponse];
        if( evaluate && response ) {
            if( evaluate(message) ) {
                httpResponse = response(message);
                break;
            }
        }
    }
    return httpResponse;
}


/**
 * Returns whether or not the server will accept messages of a given method
 * at a httpmessage.
 **/
- (BOOL)supportsMethod:(HTTPMessage*)message
{
    bool supportsMethod = false;

    NSArray* allValues = self.responseBlocks.allValues;
    for(NSDictionary* dict in allValues) {
        HTTPExpressEvaluateBlock evaluate = [dict objectForKey:kHTTPExpressManagerDictionaryKeyEvaluate];
        if( evaluate ) {
            if( evaluate(message) ) {
                supportsMethod = true;
                break;
            }
        }
    }

    return supportsMethod;
    
}

@end
