//
//  HTTPServerExpress.m
//  CocoaHTTPServerExpress
//
//  Created by Christopher Evans on 6/17/14.
//  Copyright (c) 2014 Christopher Evans. All rights reserved.
//

#import "HTTPServerExpress.h"
#import "HTTPExpressConnection.h"

@implementation HTTPServerExpress

- (HTTPConfig *)config
{
	// Override me if you want to provide a custom config to the new connection.
	//
	// Generally this involves overriding the HTTPConfig class to include any custom settings,
	// and then having this method return an instance of 'MyHTTPConfig'.
	
	// Note: Think you can make the server faster by putting each connection on its own queue?
	// Then benchmark it before and after and discover for yourself the shocking truth!
	//
	// Try the apache benchmark tool (already installed on your Mac):
	// $  ab -n 1000 -c 1 http://localhost:<port>/some_path.html
	
	return [[HTTPConfig alloc] initWithServer:self documentRoot:documentRoot queue:connectionQueue];
}

- (void)socket:(GCDAsyncSocket *)sock didAcceptNewSocket:(GCDAsyncSocket *)newSocket
{
	HTTPExpressConnection *newConnection = [[HTTPExpressConnection alloc] initWithAsyncSocket:newSocket configuration:[self config]];
    
    if([self.expressDelegate respondsToSelector:@selector(connectionNeedExpressManager)]) {
        newConnection.expressManager = [self.expressDelegate connectionNeedExpressManager];
    }
    
	[connectionsLock lock];
	[connections addObject:newConnection];
	[connectionsLock unlock];
	
	[newConnection start];
}


@end

