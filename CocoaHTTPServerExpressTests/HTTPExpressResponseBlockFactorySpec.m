
//HTTPExpressResponseBlockFactorySpec

#import "Kiwi.h"

#import "HTTPExpress.h"
#import "HTTPDataResponse.h"
#import "HTTPExpressResponse.h"

SPEC_BEGIN(HTTPExpressResponseBlockFactorySpec)
describe(@"HTTPExpressResponseBlockFactorySpec", ^{
    context(@"Create", ^{
        it(@"responseWithString:", ^{
            HTTPExpressResponseBlock block = HEBResponse(@"A server response.");
            [block shouldNotBeNil];
        });
        
        it(@"responseWithString:encoding:", ^{
            HTTPExpressResponseBlock block = HEBResponseEncoding(@"A server response.", NSUTF8StringEncoding);
            [block shouldNotBeNil];
        });
        
        it(@"responseWithFilePath:", ^{
            HTTPExpressResponseBlock block = HEBResponseFile(@"/users/someone/something");
            [block shouldNotBeNil];
        });
    });
    
    context(@"Returned responses", ^{
        __block HTTPMessage *request = nil;
        __block NSString* responseString = nil;
        
        beforeAll(^{
            request = [[HTTPMessage alloc] initRequestWithMethod:@"GET"
                                                             URL:[NSURL URLWithString:@"http://fakeUrl.com"]
                                                         version:@"1.0"];
            responseString = @"A server response.";
        });
        
        it(@"responseWithString:", ^{
            HTTPExpressResponseBlock block = HEBResponse(responseString);
            HTTPExpressResponse* response = block(request);
            
            [response shouldNotBeNil];
            [[theValue(response.isResponse) should] beTrue];
            NSData* responseData = [response.responseObject readDataOfLength:[response.responseObject contentLength]];
            [[[responseString dataUsingEncoding:NSUTF8StringEncoding] should] equal:responseData];
        });
        
        it(@"responseWithString:encoding:", ^{
            HTTPExpressResponseBlock block = HEBResponseEncoding(responseString, NSUTF16StringEncoding);    // a different encoding
            HTTPExpressResponse* response = block(request);
            
            [response shouldNotBeNil];
            [[theValue(response.isResponse) should] beTrue];
            NSData* responseData = [response.responseObject readDataOfLength:[response.responseObject contentLength]];
            [[[responseString dataUsingEncoding:NSUTF16StringEncoding] should] equal:responseData];
        });
        
        it(@"responseWithFilePath:", ^{
            NSString* path = [[NSBundle bundleForClass:[self class]] pathForResource:@"TestData" ofType:@"plist"];
            HTTPExpressResponseBlock block = HEBResponseFile(path);
            HTTPExpressResponse* response = block(request);
            
            [response shouldNotBeNil];
            [[theValue(response.isResponse) should] beTrue];
            NSData* responseData = [response.responseObject readDataOfLength:[response.responseObject contentLength]];
            [[[NSData dataWithContentsOfFile:path] should] equal:responseData];
        });
        
        context(@"Errors", ^{
            it(@"file not found", ^{
                HTTPExpressResponseBlock block = [HERBF responseWithErrorNotFound];
                HTTPExpressResponse* response = block(request);
                
                [response shouldNotBeNil];
                [response.messageObject shouldNotBeNil];
                [[theValue(response.isError) should] beTrue];
                [[[[response.messageObject allHeaderFields] objectForKey:@"Content-Length"] should] equal:@"0"];
                [[theValue(response.messageObject.statusCode) should] equal:theValue(404)];
            });
            
            it(@"Unauthorized", ^{
                HTTPExpressResponseBlock block = [HERBF responseWithErrorAuthenticationFailed];
                HTTPExpressResponse* response = block(request);
                
                [response shouldNotBeNil];
                [response.messageObject shouldNotBeNil];
                [[theValue(response.isError) should] beTrue];
                [[[[response.messageObject allHeaderFields] objectForKey:@"Content-Length"] should] equal:@"0"];
                [[theValue(response.messageObject.statusCode) should] equal:theValue(401)];
            });
            
            it(@"Bad Request", ^{
                HTTPExpressResponseBlock block = [HERBF responseWithErrorBadRequest];
                HTTPExpressResponse* response = block(request);
                
                [response shouldNotBeNil];
                [response.messageObject shouldNotBeNil];
                [[theValue(response.isError) should] beTrue];
                [[[[response.messageObject allHeaderFields] objectForKey:@"Content-Length"] should] equal:@"0"];
                [[[[response.messageObject allHeaderFields] objectForKey:@"Connection"] should] equal:@"close"];
                [[theValue(response.terminateConnection) should] beYes];
                [[theValue(response.messageObject.statusCode) should] equal:theValue(400)];
            });
            
            it(@"Server error", ^{
                HTTPExpressResponseBlock block = [HERBF responseWithErrorServerError];
                HTTPExpressResponse* response = block(request);
                
                [response shouldNotBeNil];
                [response.messageObject shouldNotBeNil];
                [[theValue(response.isError) should] beTrue];
                [[[[response.messageObject allHeaderFields] objectForKey:@"Content-Length"] should] equal:@"0"];
                [[[[response.messageObject allHeaderFields] objectForKey:@"Connection"] should] equal:@"close"];
                [[theValue(response.terminateConnection) should] beYes];
                [[theValue(response.messageObject.statusCode) should] equal:theValue(500)];
            });
        });
    });
});

SPEC_END



