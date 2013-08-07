
//HTTPExpressIntegrationSpec


#import "Kiwi.h"
#import "HTTPExpress.h"

SPEC_BEGIN(HTTPExpressIntegrationSpec)
describe(@"Integration", ^{
   
    it(@"POST", ^{
        __block NSURL* url = [HEM urlWithPath:@"/helloWord"];
        __block NSString* responseString = @"You, mean Hello World!";
        NSString* requestBody = @"param1=Hello&param2=World";
        NSString* key = [HEM connectEvaluateBlock:[HEEBF evaluateUrlMatch:url
                                                              requestBody:[requestBody dataUsingEncoding:NSUTF8StringEncoding]]
                                withResponseBlock:HEBResponse(responseString)];
        
        NSHTTPURLResponse* response = nil;
        NSError* error = nil;
        NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:url];
        [request setHTTPBody:[requestBody dataUsingEncoding:NSUTF8StringEncoding]];
        [request setHTTPMethod:@"POST"];
        
        NSData* data = [NSURLConnection sendSynchronousRequest:request
                                             returningResponse:&response
                                                         error:&error];
        NSString* content = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        [error shouldBeNil];
        [[responseString shouldEventually] equal:content];
        
        [HEM removeBlocksForKey:key];
    });
});
SPEC_END

