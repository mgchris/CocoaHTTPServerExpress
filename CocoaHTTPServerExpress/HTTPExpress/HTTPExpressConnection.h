//
//  HTTPConnectionExpress.h
//  CocoaHTTPServerForTesting
//
//  Created by Christopher Evans on 6/26/13.
//  Copyright (c) 2013 Christopher Evans. All rights reserved.
//

#import "HTTPConnection.h"
@class HTTPExpressManager;

@interface HTTPExpressConnection : HTTPConnection
@property (atomic, retain) HTTPExpressManager* expressManager;
@end
