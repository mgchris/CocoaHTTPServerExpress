//
//  HTTPConnectionExpress.m
//  CocoaHTTPServerForTesting
//
//  Created by chrise26 on 6/26/13.
//  Copyright (c) 2013 chrise26. All rights reserved.
//

#import "HTTPExpressConnection.h"
#import "HTTPExpressManager.h"

@implementation HTTPExpressConnection
- (NSObject<HTTPResponse> *)httpResponseForMethod:(NSString *)method URI:(NSString *)path {
	return [[HTTPExpressManager defaultManager] responseForMessage:request];
}
@end
