
//HTTPExpressIntegrationSpec


#import "Kiwi.h"
#import "HTTPExpress.h"

SPEC_BEGIN(HTTPExpressIntegrationSpec)
describe(@"Integration", ^{
   
    context(@"POST with body", ^{
        it(@"Accept All POST supported", ^{
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
        
        it(@"Eval Block POST supported", ^{
            HEM.supportedAllMethods = NO;
            
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
            
            HEM.supportedAllMethods = YES;
        });
        
        it(@"POST Not supported", ^{
            HEM.supportedAllMethods = NO;
            
            __block NSURL* url = [HEM urlWithPath:@"/failedPOSTBody"];
            __block NSString* responseString = @"You should not get this response!";
            NSString* key = [HEM connectEvaluateBlock:[HEEBF evaluateUrlMatch:url
                                                                  requestBody:[@"accepted=YES" dataUsingEncoding:NSUTF8StringEncoding]]
                                    withResponseBlock:HEBResponse(responseString)];
            
            NSHTTPURLResponse* response = nil;
            NSError* error = nil;
            NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:url];
            [request setHTTPBody:[@"accepted=NO" dataUsingEncoding:NSUTF8StringEncoding]];
            [request setHTTPMethod:@"POST"];
            
            NSData* data = [NSURLConnection sendSynchronousRequest:request
                                                 returningResponse:&response
                                                             error:&error];
            [[theValue(response.statusCode) should] equal:theValue(404)];
            [[theValue(data.length) should] equal:theValue(0)];
            
            [HEM removeBlocksForKey:key];
            HEM.supportedAllMethods = YES;
        });
    });
    
    
    context(@"Headers", ^{
        it(@"GET With headers", ^{
            __block NSURL* url = [HEM urlWithPath:@"/headerSupport"];
            __block NSString* responseString = @"The are found";
            NSString* key = [HEM connectEvaluateBlock:^BOOL(HTTPMessage *message) {
                BOOL match = NO;
                if( [[message headerField:@"Etag"] isEqualToString:@"ThisIsMyETag"] ) {
                    match = YES;
                }
                return match;
            } withResponseBlock:HEBResponse(responseString)];
                   
            NSHTTPURLResponse* response = nil;
            NSError* error = nil;
            NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:url];
            [request addValue:@"ThisIsMyETag" forHTTPHeaderField:@"Etag"];
            [request setHTTPMethod:@"GET"];
           
            NSData* data = [NSURLConnection sendSynchronousRequest:request
                                                returningResponse:&response
                                                            error:&error];
            NSString* content = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            [error shouldBeNil];
            [[responseString shouldEventually] equal:content];

            [HEM removeBlocksForKey:key];
       });
        
        it(@"POST with Header", ^{
            __block NSURL* url = [HEM urlWithPath:@"/POSTHeader"];
            __block NSString* responseString = @"You like cake!";
            __block NSString* headerField = @"Authorization";
            __block NSString* headerFieldValue = @"Basic somethingSomethingSomething";
            
            NSString* requestBody = @"pie=0&cake=1";
            NSString* key = [HEM connectEvaluateBlock:^BOOL(HTTPMessage *message) {
                BOOL match = NO;
                if( [message.url.relativePath isEqual:url.relativePath] ) {
                    if( [[message headerField:headerField] isEqualToString:headerFieldValue] ) {
                        match = YES;
                    }
                }
                return match;
            }                       withResponseBlock:HEBResponse(responseString)];
            
            NSHTTPURLResponse* response = nil;
            NSError* error = nil;
            NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:url];
            [request setHTTPBody:[requestBody dataUsingEncoding:NSUTF8StringEncoding]];
            [request addValue:headerFieldValue forHTTPHeaderField:headerField];
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
    
    
    
});
SPEC_END

