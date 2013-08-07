

#import "Kiwi.h"

#import "HTTPExpress.h"

SPEC_BEGIN(HTTPExpressEvaluationBlockFactorySpec)
describe(@"HTTPExpressEvaluationBlockFactorySpec", ^{
    
    context(@"Create", ^{
        it(@"evaluateUrlMatch:", ^{
            HTTPExpressEvaluateBlock block = HEBEvalString(@"http://fakeUrl.com");
            [block shouldNotBeNil];
        });
        
        it(@"evaluateUrlMatch:withMethod:", ^{
            HTTPExpressEvaluateBlock block = HEBEvalMethodString(@"http://fakeUrl.com", @"GET");
            [block shouldNotBeNil];
        });
    });
    
    context(@"evaluateUrlMatch:", ^{
        it(@"matching url", ^{
            NSURL* url = [NSURL URLWithString:@"http://fakeUrl.com"];
            HTTPExpressEvaluateBlock block = HEBEvalUrl(url);
            HTTPMessage* mock = [HTTPMessage nullMock];
            [mock stub:@selector(url) andReturn:url];
            
            [[theValue(block(mock)) should] beTrue];
        });
        
        it(@"not matching url", ^{
            NSURL* url = [NSURL URLWithString:@"http://fakeUrl.com/test"];
            HTTPExpressEvaluateBlock block = HEBEvalString(@"http://fakeUrl.com/bob");
            HTTPMessage* mock = [HTTPMessage nullMock];
            [mock stub:@selector(url) andReturn:url];
            
            [[theValue(block(mock)) should] beFalse];
        });
    });
    
    context(@"evaluateUrlMatch:withMethod:", ^{
        it(@"matching url and method", ^{
            NSURL* url = [NSURL URLWithString:@"http://fakeUrl.com"];
            
            HTTPExpressEvaluateBlock block = HEBEvalMethodUrl(url, @"GET");
            HTTPMessage* mock = [HTTPMessage nullMock];
            [mock stub:@selector(url) andReturn:url];
            [mock stub:@selector(method) andReturn:@"GET"];
            
            [[theValue(block(mock)) should] beTrue];
        });
        
        it(@"not matching url", ^{
            NSURL* url = [NSURL URLWithString:@"http://fakeUrl.com"];
            
            HTTPExpressEvaluateBlock block = HEBEvalMethodString(@"http://fakeUrl.com/test", @"GET");
            HTTPMessage* mock = [HTTPMessage nullMock];
            [mock stub:@selector(url) andReturn:url];
            [mock stub:@selector(method) andReturn:@"GET"];
            
            [[theValue(block(mock)) should] beFalse];
        });
        
        it(@"not matching method", ^{
            HTTPExpressEvaluateBlock block = HEBEvalMethodString(@"http://fakeUrl.com", @"GET");
            
            HTTPMessage* mock = [HTTPMessage nullMock];
            [mock stub:@selector(url) andReturn:[NSURL URLWithString:@"http://fakeUrl.com"]];
            [mock stub:@selector(method) andReturn:@"POST"];
            
            [[theValue(block(mock)) should] beFalse];
        });
        
        it(@"not matching url or method", ^{
            HTTPExpressEvaluateBlock block = HEBEvalMethodString(@"http://fakeUrl.com/test", @"GET");
            
            HTTPMessage* mock = [HTTPMessage nullMock];
            [mock stub:@selector(url) andReturn:[NSURL URLWithString:@"http://fakeUrl.com"]];
            [mock stub:@selector(method) andReturn:@"POST"];
            
            [[theValue(block(mock)) should] beFalse];
        });
    });
    
    context(@"evaluateUrlMatch:requestBody:", ^{
        it(@"Matching url and body", ^{
            NSString* requestString = @"body=something&test=1";
            HTTPExpressEvaluateBlock block = [HEEBF evaluateUrlMatch:[NSURL URLWithString:@"http://fakeUrl.com/body"]
                                                         requestBody:[requestString dataUsingEncoding:NSUTF8StringEncoding]];
            
            HTTPMessage* mock = [HTTPMessage nullMock];
            [mock stub:@selector(url) andReturn:[NSURL URLWithString:@"http://fakeUrl.com/body"]];
            [mock stub:@selector(body) andReturn:[requestString dataUsingEncoding:NSUTF8StringEncoding]];
            
            [[theValue(block(mock)) should] beYes];
        });
        
        it(@"Not matching body", ^{
            NSString* requestString = @"body=something&test=1";
            NSString* requestTested = @"somethingelse=1";
            HTTPExpressEvaluateBlock block = [HEEBF evaluateUrlMatch:[NSURL URLWithString:@"http://fakeUrl.com/body"]
                                                         requestBody:[requestTested dataUsingEncoding:NSUTF8StringEncoding]];
            
            HTTPMessage* mock = [HTTPMessage nullMock];
            [mock stub:@selector(url) andReturn:[NSURL URLWithString:@"http://fakeUrl.com/body"]];
            [mock stub:@selector(body) andReturn:[requestString dataUsingEncoding:NSUTF8StringEncoding]];
            
            [[theValue(block(mock)) should] beNo];
        });
        
        it(@"Not matching url", ^{
            NSString* requestString = @"body=something&test=1";
            HTTPExpressEvaluateBlock block = [HEEBF evaluateUrlMatch:[NSURL URLWithString:@"http://fakeUrl.com/body"]
                                                         requestBody:[requestString dataUsingEncoding:NSUTF8StringEncoding]];
            
            HTTPMessage* mock = [HTTPMessage nullMock];
            [mock stub:@selector(url) andReturn:[NSURL URLWithString:@"http://fakeUrl.com/other"]];
            [mock stub:@selector(body) andReturn:[requestString dataUsingEncoding:NSUTF8StringEncoding]];
            
            [[theValue(block(mock)) should] beNo];
        });
    });
});

SPEC_END

