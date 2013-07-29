
#import "Kiwi.h"

#import "HTTPExpress.h"
#import "HTTPServer.h"

SPEC_BEGIN(HTTPExpressErrorSpec)
describe(@"HTTPExpressErrorSpec", ^{
    context(@"Issue 2", ^{
        // Matching should be Relative not absoluteURL
        // https://github.com/mgchris/CocoaHTTPServerExpress/issues/2
        it(@"bad url string", ^{
            NSString* responseString = @"Hello";
            NSURL* url = [[HTTPExpressManager defaultManager] urlWithPath:@"/test"];
            
            // This will create an incorrect url something like 127.0.0.1test
            NSString* key = [[HTTPExpressManager defaultManager] connectEvaluateBlock:HEBEvalString(@"test")
                                                                    withResponseBlock:HEBResponse(responseString)];
            
            
            NSHTTPURLResponse* response = nil;
            NSData* returnData = [NSURLConnection sendSynchronousRequest:[NSURLRequest requestWithURL:url]
                                                       returningResponse:&response
                                                                   error:nil];
            [[theValue([returnData length]) should] equal:theValue(0)];
            
            [HEM removeBlocksForKey:key];
        });
        
        it(@"simple relative", ^{
            
            NSString* responseString = @"Hello";
            NSURL* url = [[HTTPExpressManager defaultManager] urlWithPath:@"/test"];
            NSString* key = [[HTTPExpressManager defaultManager] connectEvaluateBlock:HEBEvalString(@"/test")
                                                                    withResponseBlock:HEBResponse(responseString)];
            
            
            NSHTTPURLResponse* response = nil;
            NSData* returnData = [NSURLConnection sendSynchronousRequest:[NSURLRequest requestWithURL:url]
                                                       returningResponse:&response
                                                                   error:nil];
            
            NSString* returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
            [[returnString should] equal:responseString];
            
            [HEM removeBlocksForKey:key];
        });
    });
});
SPEC_END
