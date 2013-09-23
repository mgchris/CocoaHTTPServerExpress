
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
            HTTPExpressManager* manager = HEM;
            
            [manager shouldNotBeNil];
            [manager.httpServer shouldNotBeNil];
            [[manager.httpServer.connectionClass should] equal:[HTTPExpressConnection class]];
            [[manager should] equal:HEM];
            [[manager.activeConfiguration should] equal:kHTTPExpressManagerDefaultConfigurationKey];
        });
        
        it(@"Create unique key", ^{
            NSString* key1 = [HEM generateKey];
            NSString* key2 = [HEM generateKey];
            
            [[key1 shouldNot] equal:key2];
        });
    
        it(@"correct host", ^{
            NSString* host = [NSString stringWithFormat:@"http://127.0.0.1:%d", HEM.httpServer.listeningPort];
            [[host should] equal:[HEM urlStringForHost]];
        });
        
        it(@"Build path", ^{
            NSString* host = [NSString stringWithFormat:@"http://127.0.0.1:%d/helloWorld", HEM.httpServer.listeningPort];
            [[host should] equal:[HEM urlWithPath:@"/helloWorld"].absoluteString];
        });
        
        context(@"managing express blocks", ^{
            it(@"Add and remove block", ^{
                
                HTTPExpressEvaluateBlock eval = HEBEvalString(@"/url");
                HTTPExpressResponseBlock response = HEBResponse(@"response");
                
                NSString* key = [HEM connectEvaluateBlock:eval
                                        withResponseBlock:response];
                [key shouldNotBeNil];
                NSDictionary* blocks = [HEM blocksForKey:key];
                
                [blocks shouldNotBeNil];
                [[[blocks objectForKey:kHTTPExpressManagerDictionaryKeyEvaluate] should] equal:eval];
                [[[blocks objectForKey:kHTTPExpressManagerDictionaryKeyResponse] should] equal:response];
                
                [HEM removeBlocksForKey:key];
                [[HEM blocksForKey:key] shouldBeNil];
            });
            
            it(@"blocks for default configuration", ^{
                
                [[HEM allBlocksForConfiguration:kHTTPExpressManagerDefaultConfigurationKey] shouldBeNil];
                
                [HEM connectEvaluateBlock:HEBEvalString(@"/url") withResponseBlock:HEBResponse(@"response")];
                [HEM connectEvaluateBlock:HEBEvalString(@"/url") withResponseBlock:HEBResponse(@"response")];
                [HEM connectEvaluateBlock:HEBEvalString(@"/url") withResponseBlock:HEBResponse(@"response")];
            
                [[theValue([HEM allBlocksForConfiguration:kHTTPExpressManagerDefaultConfigurationKey].count) should] equal:theValue(3)];
                
                [HEM removeAllExpressBlocks];

                [[HEM allBlocksForConfiguration:kHTTPExpressManagerDefaultConfigurationKey] shouldBeNil];
            });
            
            
            it(@"Add blocks with custom config", ^{
                NSString* config = @"config";
                HTTPExpressEvaluateBlock eval = HEBEvalString(@"/url");
                HTTPExpressResponseBlock response = HEBResponse(@"response");
                
                [HEM connectEvaluateBlock:eval
                        withResponseBlock:response
                         forConfiguration:config];
                
                [[theValue([HEM allBlocksForConfiguration:config].count) should] equal:theValue(1)];
                [HEM removeBlocksForConfiguration:config];
                [[theValue([HEM allBlocksForConfiguration:config].count) should] equal:theValue(0)];
            });
            
            it(@"remove only block with key", ^{
                [[HEM allBlocksForConfiguration:kHTTPExpressManagerDefaultConfigurationKey] shouldBeNil];
                
                NSString* keepResponse = @"Keep Response";
                NSURL* keepURL = [HEM urlWithPath:@"/keep"];
                
                NSString* key = [HEM connectEvaluateBlock:HEBEvalString(@"/removeMe") withResponseBlock:HEBResponse(@"deleted")];
                [HEM connectEvaluateBlock:HEBEvalUrl(keepURL) withResponseBlock:HEBResponse(keepResponse)];
                
                [[theValue([HEM allBlocksForConfiguration:kHTTPExpressManagerDefaultConfigurationKey].count) should] equal:theValue(2)];
                [HEM removeBlocksForKey:key];
                [[theValue([HEM allBlocksForConfiguration:kHTTPExpressManagerDefaultConfigurationKey].count) should] equal:theValue(1)];
                
                NSString* content = [NSString stringWithContentsOfURL:keepURL
                                                             encoding:NSUTF8StringEncoding error:nil];
                [[keepResponse shouldEventually] equal:content];
                
                [HEM removeAllExpressBlocks];
            });
        });
        
        context(@"Response", ^{
            it(@"returns string", ^{
                __block NSURL* url = [HEM urlWithPath:@"/helloWord"];
                __block NSString* responseString = @"You are so predictable!";
                NSString* key = [HEM connectEvaluateBlock:HEBEvalUrl(url) withResponseBlock:HEBResponse(responseString)];
                
                NSHTTPURLResponse* response = nil;
                NSError* error = nil;
                NSData* data = [NSURLConnection sendSynchronousRequest:[NSURLRequest requestWithURL:url]
                                                        returningResponse:&response
                                                                    error:&error];
                NSString* content = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                [error shouldBeNil];
                [[responseString shouldEventually] equal:content];
                
                [HEM removeBlocksForKey:key];
            });
            
            it(@"return data", ^{
                __block NSURL* url = [HEM urlWithPath:@"/dataFile"];
                __block NSString* filePath = [bundle pathForResource:@"TestData" ofType:@"plist"];
                NSString* key = [HEM connectEvaluateBlock:HEBEvalUrl(url) withResponseBlock:HEBResponseFile(filePath)];
                
                NSData* data = [NSData dataWithContentsOfFile:filePath];
                
                NSHTTPURLResponse* response = nil;
                NSError* error = nil;
                NSData* content = [NSURLConnection sendSynchronousRequest:[NSURLRequest requestWithURL:url]
                                                        returningResponse:&response
                                                                    error:&error];
                [error shouldBeNil];
                [[data should] equal:content];
                
                [HEM removeBlocksForKey:key];
            });
            
            context(@"Error", ^{
                __block NSURLRequest* request = nil;
                __block NSURL* url = nil;
                
                beforeAll(^{
                    url = [HEM urlWithPath:@"/helloWord"];
                    request = [NSURLRequest requestWithURL:url];
                });
                
                it(@"returns string", ^{
                    NSString* key = [HEM connectEvaluateBlock:HEBEvalUrl(url)
                                            withResponseBlock:[HERBF responseWithErrorNotFound]];
                    NSHTTPURLResponse* response = nil;
                    NSError* error = nil;
                    [NSURLConnection sendSynchronousRequest:request
                                          returningResponse:&response
                                                      error:&error];
                    [error shouldBeNil];
                    [[theValue(response.statusCode) should] equal:theValue(404)];
                    
                    [HEM removeBlocksForKey:key];
                });
            });
        });
        
        context(@"Deeper Configuration Test", ^{
            it(@"Same url different config", ^{
                
                NSURL* url = [HEM urlWithPath:@"/configURL"];
                HTTPExpressEvaluateBlock eval = HEBEvalUrl(url);
                
                NSString* config1 = @"config1";
                NSString* config1Response = @"response for config 1";
                HTTPExpressResponseBlock response1 = HEBResponse(config1Response);
                [HEM connectEvaluateBlock:eval
                        withResponseBlock:response1
                         forConfiguration:config1];
            
                
                NSString* config2 = @"config2";
                NSString* config2Response = @"response for config 2";
                HTTPExpressResponseBlock response2 = HEBResponse(config2Response);
                [HEM connectEvaluateBlock:eval
                        withResponseBlock:response2
                         forConfiguration:config2];
                
                [[theValue([HEM allBlocksForConfiguration:config1].count) should] equal:theValue(1)];
                [[theValue([HEM allBlocksForConfiguration:config2].count) should] equal:theValue(1)];
                
                
                HEM.activeConfiguration = config1;
                NSData* data = [NSURLConnection sendSynchronousRequest:[NSURLRequest requestWithURL:url]
                                                     returningResponse:nil
                                                                 error:nil];
                NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                [[responseString should] equal:config1Response];

                HEM.activeConfiguration = config2;
                data = [NSURLConnection sendSynchronousRequest:[NSURLRequest requestWithURL:url]
                                             returningResponse:nil
                                                         error:nil];
                responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                [[responseString should] equal:config2Response];
                
                [HEM removeAllExpressBlocks];
                [[HEM allBlocksForConfiguration:config1] shouldBeNil];
                [[HEM allBlocksForConfiguration:config2] shouldBeNil];
            });
        });
    });
});

SPEC_END