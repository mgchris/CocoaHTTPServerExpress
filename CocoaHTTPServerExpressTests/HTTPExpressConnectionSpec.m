
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
                
                [[theValue([[HEM responseBlocks] count]) should] equal:theValue(0)];
                
                NSString* key = [HEM connectEvaluateBlock:HEBEvalString(@"/url")
                                        withResponseBlock:HEBResponse(@"response")];
                [key shouldNotBeNil];
                [[theValue([[HEM responseBlocks] count]) should] equal:theValue(1)];
                
                [HEM removeBlocksForKey:key];
                [[theValue([[HEM responseBlocks] count]) should] equal:theValue(0)];
            });
            
            it(@"remove all blocks", ^{
                [[theValue([[HEM responseBlocks] count]) should] equal:theValue(0)];
                
                [HEM connectEvaluateBlock:HEBEvalString(@"/url") withResponseBlock:HEBResponse(@"response")];
                [HEM connectEvaluateBlock:HEBEvalString(@"/url") withResponseBlock:HEBResponse(@"response")];
                [HEM connectEvaluateBlock:HEBEvalString(@"/url") withResponseBlock:HEBResponse(@"response")];
                
                [[theValue([[HEM responseBlocks] count]) should] equal:theValue(3)];
                
                [HEM removeAllExpressBlocks];
                [[theValue([[HEM responseBlocks] count]) should] equal:theValue(0)];
            });
            
            it(@"remove only block with key", ^{
                [[theValue([[HEM responseBlocks] count]) should] equal:theValue(0)];
                NSString* keepResponse = @"Keep Response";
                NSURL* keepURL = [HEM urlWithPath:@"/keep"];
                
                NSString* key = [HEM connectEvaluateBlock:HEBEvalString(@"/url") withResponseBlock:HEBResponse(@"response")];
                [HEM connectEvaluateBlock:HEBEvalUrl(keepURL) withResponseBlock:HEBResponse(keepResponse)];
                
                [[theValue([[HEM responseBlocks] count]) should] equal:theValue(2)];
                [HEM removeBlocksForKey:key];
                [[theValue([[HEM responseBlocks] count]) should] equal:theValue(1)];
                
                NSString* content = [NSString stringWithContentsOfURL:keepURL
                                                             encoding:NSUTF8StringEncoding error:nil];
                [[keepResponse shouldEventually] equal:content];
                
                [HEM removeAllExpressBlocks];
            });
        });
        
        it(@"returns string", ^{
            __block NSURL* url = [HEM urlWithPath:@"/helloWord"];
            __block NSString* responseString = @"You are so predictable!";
            NSString* key = [HEM connectEvaluateBlock:HEBEvalUrl(url) withResponseBlock:HEBResponse(responseString)];
            
            NSString* content = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
            [[responseString shouldEventually] equal:content];
            
            [HEM removeBlocksForKey:key];
        });
        
        it(@"return data", ^{
            __block NSURL* url = [HEM urlWithPath:@"/dataFile"];
            __block NSString* filePath = [bundle pathForResource:@"TestData" ofType:@"plist"];
            NSString* key = [HEM connectEvaluateBlock:HEBEvalUrl(url) withResponseBlock:HEBResponseFile(filePath)];
            
            NSData* data = [NSData dataWithContentsOfFile:filePath];
            NSData* content = [NSData dataWithContentsOfURL:url];       // hits the server
            
            [[data shouldEventually] equal:content];
            
            [HEM removeBlocksForKey:key];
        });
    });
});

SPEC_END