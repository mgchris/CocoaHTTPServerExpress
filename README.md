CocoaHTTPServerExpress
======================

The goal is to be an embedded HTTP Server used for testing. The idea is for your test you create an instance of a server, give it a set of conditions to watch for and the response when a condition is met.

Here is a simple testing example:

```
- (void)testGetStringFromServer {
    
    // Setup Manager
    HTTPExpressManager* server = [[HTTPExpressManager alloc] init]; // Create instead of manager (server)
    NSURL* expectedURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/string.media", [server urlStringForHost]]];
    NSString* expectedString = @"This is what we expect to get back";
    
    // Connect request and response to the server
    [server connectURL:expectedURL withString:expectedString];
    
    // Test
    NSString* string = [NSString stringWithContentsOfURL:expectedURL encoding:NSUTF8StringEncoding error:nil]; // Make server call
    XCTAssertTrue([expectedString isEqualToString:string], @"Strings do not match! expected: %@  got: %@", expectedString, string);
}
```
