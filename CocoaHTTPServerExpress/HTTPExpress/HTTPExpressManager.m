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

/**
 The configurationBlocks key for all blocks.
 */
static NSString * const kHTTPExpressManagerConfigurationDictionaryKeyBlocks = @"block";

/**
 Key used to reference a eval and response block
 */
static NSString * const kHTTPExpressManagerConfigurationDictionaryKeyReference = @"key";


@interface HTTPExpressManager () {
    NSMutableDictionary* _configurationBlocks;
}

@end


@implementation HTTPExpressManager

+ (HTTPExpressManager*)defaultManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        httpExpressManagerDefaultManagerInstance = [[HTTPExpressManager alloc] init];
    });
    return httpExpressManagerDefaultManagerInstance;
}


#pragma mark -
- (id)init {
    self = [super init];
    if( self ) {
        _configurationBlocks = [[NSMutableDictionary alloc] init];
        
        HTTPServer* server = [[HTTPServer alloc] init];
        [server setType:@"_http._tcp."];
        [server setConnectionClass:[HTTPExpressConnection class]];
        _httpServer = server;
        _activeConfiguration = kHTTPExpressManagerDefaultConfigurationKey;
        NSError* error = nil;
        if( [server start:&error] == NO ) {
            NSLog(@"Starting Server Error: %@", error);
            self = nil;
        }
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
    return [self connectEvaluateBlock:evaluate
                    withResponseBlock:response
                     forConfiguration:self.activeConfiguration];
}

- (NSString*)connectEvaluateBlock:(HTTPExpressEvaluateBlock)evaluate
                withResponseBlock:(HTTPExpressResponseBlock)response
                 forConfiguration:(NSString*)configuration {
    NSString* key = nil;
    if( evaluate  && response ) {
        key = [self generateKey];
        NSDictionary* dict = @{kHTTPExpressManagerDictionaryKeyEvaluate:evaluate,
                               kHTTPExpressManagerDictionaryKeyResponse:response,
                               kHTTPExpressManagerConfigurationDictionaryKeyReference:key};
        
        NSMutableDictionary* configDict = _configurationBlocks[configuration];
        if( configDict ) {
            // configuration already found for block.  Just add block to array of blocks.
            NSMutableArray* array = configDict[kHTTPExpressManagerConfigurationDictionaryKeyBlocks];
            [array addObject:dict];
        } else {
            // Don't have a configuration for this key create a new one
            NSMutableDictionary* configurationDict = [[NSMutableDictionary alloc] init];
            configurationDict[kHTTPExpressManagerConfigurationDictionaryKeyBlocks] = [NSMutableArray arrayWithObject:dict];
            _configurationBlocks[configuration] = configurationDict;
        }
    }
    return key;
}

- (NSDictionary*)blocksForKey:(NSString*)key {
    NSArray* configKeys = _configurationBlocks.allKeys;
    NSMutableDictionary* dict = nil;
    
    for(NSString* config in configKeys) {
        NSMutableArray* blocks = _configurationBlocks[config][kHTTPExpressManagerConfigurationDictionaryKeyBlocks];
        for (NSMutableDictionary* blockDict in blocks) {
            if( blockDict[kHTTPExpressManagerConfigurationDictionaryKeyReference] ) {
                dict = [NSMutableDictionary dictionaryWithDictionary:blockDict];
                [dict setObject:config forKey:kHTTPExpressManagerDictionaryKeyConfiguration];
                break;
            }
        }
        if( dict ) {
            break;
        }
    }
    
    return dict;
}

- (NSArray*)allBlocksForConfiguration:(NSString*)config {
    NSMutableDictionary* configuration = _configurationBlocks[config];
    return configuration[kHTTPExpressManagerConfigurationDictionaryKeyBlocks];
}

- (void)removeBlocksForConfiguration:(NSString*)config {
    if( _configurationBlocks[config] ) {
        [_configurationBlocks removeObjectForKey:config];
    }
}

- (void)removeBlocksForKey:(NSString*)key {
    NSArray* configKeys = _configurationBlocks.allKeys;
    BOOL found = NO;
    
    for(NSString* config in configKeys) {
        NSMutableArray* blocks = _configurationBlocks[config][kHTTPExpressManagerConfigurationDictionaryKeyBlocks];
        for (NSMutableDictionary* blockDict in blocks) {
            if( blockDict[kHTTPExpressManagerConfigurationDictionaryKeyReference] ) {
                found = YES;
                [blocks removeObject:blockDict];
                if( blocks.count == 0 ) {
                    [_configurationBlocks removeObjectForKey:config];
                }
                break;
            }
        }
        
        if( found ) {
            break;
        }
    }
}

- (void)removeAllExpressBlocks {
    [_configurationBlocks removeAllObjects];
}

- (HTTPExpressResponse*)responseForMessage:(HTTPMessage*)message {
    HTTPExpressResponse* httpResponse = nil;
    if( self.activeConfiguration != nil ) {
        NSArray* allBlocks = _configurationBlocks[self.activeConfiguration][kHTTPExpressManagerConfigurationDictionaryKeyBlocks];
        for(NSDictionary* dict in allBlocks) {
            HTTPExpressEvaluateBlock evaluate = [dict objectForKey:kHTTPExpressManagerDictionaryKeyEvaluate];
            HTTPExpressResponseBlock response = [dict objectForKey:kHTTPExpressManagerDictionaryKeyResponse];
            if( evaluate && response ) {
                if( evaluate(message) ) {
                    httpResponse = response(message);
                    break;
                }
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

    if( self.activeConfiguration != nil ) {
        NSArray* allValues = _configurationBlocks[self.activeConfiguration][kHTTPExpressManagerConfigurationDictionaryKeyBlocks];
        for(NSDictionary* dict in allValues) {
            HTTPExpressEvaluateBlock evaluate = [dict objectForKey:kHTTPExpressManagerDictionaryKeyEvaluate];
            if( evaluate ) {
                if( evaluate(message) ) {
                    supportsMethod = true;
                    break;
                }
            }
        }
    }

    return supportsMethod;
    
}

@end
