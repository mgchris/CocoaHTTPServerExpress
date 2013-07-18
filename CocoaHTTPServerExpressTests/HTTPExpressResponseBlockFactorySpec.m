
//HTTPExpressResponseBlockFactorySpec

#import "Kiwi.h"

#import "HTTPExpress.h"
#import "HTTPDataResponse.h"


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
            NSObject<HTTPResponse>* response = block(request);
            
            [response shouldNotBeNil];
            NSData* responseData = [response readDataOfLength:[response contentLength]];
            [[[responseString dataUsingEncoding:NSUTF8StringEncoding] should] equal:responseData];
        });
        
        it(@"responseWithString:encoding:", ^{
            HTTPExpressResponseBlock block = HEBResponseEncoding(responseString, NSUTF16StringEncoding);    // a different encoding
            NSObject<HTTPResponse>* response = block(request);
            
            [response shouldNotBeNil];
            NSData* responseData = [response readDataOfLength:[response contentLength]];
            [[[responseString dataUsingEncoding:NSUTF16StringEncoding] should] equal:responseData];
        });
        
        it(@"responseWithFilePath:", ^{
            NSString* path = [[NSBundle bundleForClass:[self class]] pathForResource:@"TestData" ofType:@"plist"];
            HTTPExpressResponseBlock block = HEBResponseFile(path);
            NSObject<HTTPResponse>* response = block(request);
            
            [response shouldNotBeNil];
            NSData* responseData = [response readDataOfLength:[response contentLength]];
            [[[NSData dataWithContentsOfFile:path] should] equal:responseData];
        });
    });
});

SPEC_END



