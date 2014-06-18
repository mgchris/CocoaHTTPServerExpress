//
//  HTTPExpress.h
//  CocoaHTTPServerExpress
//
//  Created by Christopher Evans on 7/1/13.
//  Copyright (c) 2013 Christopher Evans. All rights reserved.
//

#ifndef CocoaHTTPServerExpress_HTTPExpress_h
#define CocoaHTTPServerExpress_HTTPExpress_h

#import "HTTPExpressManager.h"
#import "HTTPExpressConnection.h"
#import "HTTPExpressEvaluationBlockFactory.h"
#import "HTTPExpressResponseBlockFactory.h"
#import "HTTPServerExpress.h"

#pragma mark - Reduce typing Helpers
/*
 Want to reduce the amount of type that is required to do common tasks.  Don't know if this helps or not. CLE 09/19/2013
 */
#define HEM [HTTPExpressManager defaultManager]
#define HEEBF HTTPExpressEvaluationBlockFactory
#define HERBF HTTPExpressResponseBlockFactory

// Evaluation Helpers
#define HEBEvalUrl(url) [HEEBF evaluateUrlMatch:url]
#define HEBEvalString(string) [HEEBF evaluateUrlMatch:[NSURL URLWithString:string]]

#define HEBEvalMethodUrl(url, method) [HEEBF evaluateUrlMatch:url withMethod:method]
#define HEBEvalMethodString(string, method) HEBEvalMethodUrl([NSURL URLWithString:string], method)

// Response Helpers
#define HEBResponseEncoding(string, stringEncoding) [HERBF responseWithString:string encoding:stringEncoding]
#define HEBResponse(string) [HERBF responseWithString:string]
#define HEBResponseFile(path) [HERBF responseWithFilePath:path]

#endif
