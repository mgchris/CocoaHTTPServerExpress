
#import "Kiwi.h"

#import "HTTPExpress.h"
#import "HTTPServer.h"

SPEC_BEGIN(HTTPExpressConnectionSpec)

describe(@"HTTPExpressConnectionSpec", ^{
    __block NSBundle* bundle = nil;
    
    beforeAll(^{
        bundle = [NSBundle bundleForClass:[self class]];
    });
    
    context(@"use", ^{
        
        it(@"New Manager", ^{
            HTTPExpressManager* manager = [HTTPExpressManager defaultManager];
            
            [manager shouldNotBeNil];
            [manager.httpServer shouldNotBeNil];
            [[manager.httpServer.connectionClass should] equal:[HTTPExpressConnection class]];
            [[manager should] equal:[HTTPExpressManager defaultManager]];
        });
        
        it(@"Create unique key", ^{
            NSString* key1 = [[HTTPExpressManager defaultManager] generateKey];
            NSString* key2 = [[HTTPExpressManager defaultManager] generateKey];
            
            [[key1 shouldNot] equal:key2];
        });
    
        it(@"correct host", ^{
            NSString* host = [NSString stringWithFormat:@"http://127.0.0.1:%d", [HTTPExpressManager defaultManager].httpServer.listeningPort];
            [[host should] equal:[[HTTPExpressManager defaultManager] urlStringForHost]];
        });
        
        it(@"Build path", ^{
            NSString* host = [NSString stringWithFormat:@"http://127.0.0.1:%d/helloWorld", [HTTPExpressManager defaultManager].httpServer.listeningPort];
            [[host should] equal:[[HTTPExpressManager defaultManager] urlWithPath:@"/helloWorld"].absoluteString];
        });
        
        context(@"managing express blocks", ^{
            it(@"Add and remove block", ^{
                
                [[theValue([[[HTTPExpressManager defaultManager] responseBlocks] count]) should] equal:theValue(0)];
                
                NSString* key = [[HTTPExpressManager defaultManager] connectEvaluateBlock:[HTTPExpressManager evaluateUrlMatch:[NSURL URLWithString:@"/url"]]
                                                                        withResponseBlock:[HTTPExpressManager responseWithString:@"response"]];
                [key shouldNotBeNil];
                [[theValue([[[HTTPExpressManager defaultManager] responseBlocks] count]) should] equal:theValue(1)];
                
                [[HTTPExpressManager defaultManager] removeBlocksForKey:key];
                [[theValue([[[HTTPExpressManager defaultManager] responseBlocks] count]) should] equal:theValue(0)];
            });
            
            it(@"remove all blocks", ^{
                [[theValue([[[HTTPExpressManager defaultManager] responseBlocks] count]) should] equal:theValue(0)];
                
                [[HTTPExpressManager defaultManager] connectEvaluateBlock:[HTTPExpressManager evaluateUrlMatch:[NSURL URLWithString:@"/url"]]
                                                        withResponseBlock:[HTTPExpressManager responseWithString:@"response"]];
                [[HTTPExpressManager defaultManager] connectEvaluateBlock:[HTTPExpressManager evaluateUrlMatch:[NSURL URLWithString:@"/url"]]
                                                        withResponseBlock:[HTTPExpressManager responseWithString:@"response"]];
                [[HTTPExpressManager defaultManager] connectEvaluateBlock:[HTTPExpressManager evaluateUrlMatch:[NSURL URLWithString:@"/url"]]
                                                        withResponseBlock:[HTTPExpressManager responseWithString:@"response"]];
                
                [[theValue([[[HTTPExpressManager defaultManager] responseBlocks] count]) should] equal:theValue(3)];
                
                [[HTTPExpressManager defaultManager] removeAllExpressBlocks];
                [[theValue([[[HTTPExpressManager defaultManager] responseBlocks] count]) should] equal:theValue(0)];
            });
            
            it(@"remove only block with key", ^{
                [[theValue([[[HTTPExpressManager defaultManager] responseBlocks] count]) should] equal:theValue(0)];
                NSString* keepResponse = @"Keep Response";
                NSURL* keepURL = [[HTTPExpressManager defaultManager] urlWithPath:@"/keep"];
                
                NSString* key = [[HTTPExpressManager defaultManager] connectEvaluateBlock:[HTTPExpressManager evaluateUrlMatch:[NSURL URLWithString:@"/url"]]
                                                                        withResponseBlock:[HTTPExpressManager responseWithString:@"response"]];
                [[HTTPExpressManager defaultManager] connectEvaluateBlock:[HTTPExpressManager evaluateUrlMatch:keepURL]
                                                        withResponseBlock:[HTTPExpressManager responseWithString:keepResponse]];
                
                [[theValue([[[HTTPExpressManager defaultManager] responseBlocks] count]) should] equal:theValue(2)];
                [[HTTPExpressManager defaultManager] removeBlocksForKey:key];
                [[theValue([[[HTTPExpressManager defaultManager] responseBlocks] count]) should] equal:theValue(1)];
                
                NSString* content = [NSString stringWithContentsOfURL:keepURL
                                                             encoding:NSUTF8StringEncoding error:nil];
                [[keepResponse shouldEventually] equal:content];
                
                [[HTTPExpressManager defaultManager] removeAllExpressBlocks];
            });
        });
        
        it(@"returns string", ^{
            __block NSURL* url = [[HTTPExpressManager defaultManager] urlWithPath:@"/helloWord"];
            __block NSString* responseString = @"You are so predictable!";
            NSString* key = [[HTTPExpressManager defaultManager] connectEvaluateBlock:[HTTPExpressManager evaluateUrlMatch:url]
                                                                    withResponseBlock:[HTTPExpressManager responseWithString:responseString]];
            
            NSString* content = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
            [[responseString shouldEventually] equal:content];
            
            [[HTTPExpressManager defaultManager] removeBlocksForKey:key];
        });
        
        it(@"return data", ^{
            __block NSURL* url = [[HTTPExpressManager defaultManager] urlWithPath:@"/video"];
            __block NSString* filePath = [bundle pathForResource:@"video20" ofType:@"m4v"];
            NSString* key = [[HTTPExpressManager defaultManager] connectEvaluateBlock:[HTTPExpressManager evaluateUrlMatch:url]
                                                                    withResponseBlock:[HTTPExpressManager responseWithFilePath:filePath]];
            
            NSData* data = [NSData dataWithContentsOfFile:filePath];
            NSData* content = [NSData dataWithContentsOfURL:url];       // hits the server
            
            [[data shouldEventually] equal:content];
            
            [[HTTPExpressManager defaultManager] removeBlocksForKey:key];
        });
    });
});

SPEC_END