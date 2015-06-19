//
//  HTTPExpressSimpleExampleTest.m
//  CocoaHTTPServerExpress
//
//  Created by Christopher Evans on 6/19/15.
//  Copyright (c) 2015 Christopher Evans. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "HTTPExpress.h"
#import "HTTPExpressManager+Additions.h"

@interface HTTPExpressSimpleExampleTest : XCTestCase


@end

@implementation HTTPExpressSimpleExampleTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testGetStringFromServer {
    
    // Setup Manager
    HTTPExpressManager* server = [[HTTPExpressManager alloc] init]; // Create instead of manager (server)
    NSURL* expectedURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/string.media", [server urlStringForHost]]];
    NSString* expectedString = @"This is what we expect to get back";
    
    // Connect request with response
    [server connectURL:expectedURL withString:expectedString];
    
    // Test
    NSString* string = [NSString stringWithContentsOfURL:expectedURL encoding:NSUTF8StringEncoding error:nil]; // Make server call
    XCTAssertTrue([expectedString isEqualToString:string], @"Strings do not match! expected: %@  got: %@", expectedString, string);
}


@end
