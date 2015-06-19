CocoaHTTPServerExpress
======================

The goal is to be an embedded HTTP Server used for testing. The idea is for your test you create an instance of a server, give it a set of conditions to watch for and the response when a condition is met.

Here is a simple testing example:

```objective-c
- (void)testGetStringFromServer {
    
    // Create Manager
    HTTPExpressManager* server = [[HTTPExpressManager alloc] init]; // Create instead of manager (server)
    
    // Connect request and response to server
    NSURL* expectedURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/string.media", [server urlStringForHost]]];
    NSString* expectedString = @"This is what we expect to get back";
    [server connectURL:expectedURL withString:expectedString];
    
    // Test
    NSString* string = [NSString stringWithContentsOfURL:expectedURL encoding:NSUTF8StringEncoding error:nil]; // Make server call
    XCTAssertTrue([expectedString isEqualToString:string], @"Strings do not match! expected: %@  got: %@", expectedString, string);
}
```

### CocoaPods

1. Add CocoaHTTPServerExpress to your project's `Podfile`:

	```ruby
	target :MyApp do
	# Your app's dependencies
	end

	target :MyAppTests do
	  pod 'CocoaHTTPServerExpress', '~> 0.0.3.1'
	end
	```
	
2. Run `pod update` or `pod install` in your project directory.
