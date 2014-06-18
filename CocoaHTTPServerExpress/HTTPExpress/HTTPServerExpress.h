//
//  HTTPServerExpress.h
//  CocoaHTTPServerExpress
//
//  Created by Christopher Evans on 6/17/14.
//  Copyright (c) 2014 Christopher Evans. All rights reserved.
//

#import "HTTPServer.h"

@protocol HTTPServerExpressDelegate;
@class HTTPExpressManager;


@interface HTTPServerExpress : HTTPServer
@property (nonatomic, retain) id expressConnection;
@property (nonatomic, assign) id<HTTPServerExpressDelegate> expressDelegate;
@end


@protocol HTTPServerExpressDelegate <NSObject>
- (HTTPExpressManager*)connectionNeedExpressManager;
@end
