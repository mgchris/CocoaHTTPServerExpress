//
//  HTTPExpressManager+Additions.m
//  CocoaHTTPServerExpress
//
//  Created by Christopher Evans on 6/19/15.
//  Copyright (c) 2015 Christopher Evans. All rights reserved.
//

#import "HTTPExpressManager+Additions.h"
#import "HTTPExpress.h"

@implementation HTTPExpressManager (Additions)


- (NSString *)connectURL:(NSURL *)url
                withFile:(NSString *)filePath
        forConfiguration:(NSString*)configuration;
{
    return [self connectEvaluateBlock:[HTTPExpressEvaluationBlockFactory evaluateUrlMatch:url] withResponseBlock:[HTTPExpressResponseBlockFactory responseWithFilePath:filePath] forConfiguration:configuration];
}

- (NSString *)connectURL:(NSURL*)url
               withFileName:(NSString*)fileName {
    NSString* filePath = [[NSBundle bundleForClass:[self class]] pathForResource:fileName ofType:nil];
    return [self connectEvaluateBlock:[HTTPExpressEvaluationBlockFactory evaluateUrlMatch:url]
                    withResponseBlock:[HTTPExpressResponseBlockFactory responseWithFilePath:filePath]
                     forConfiguration:self.activeConfiguration];
}

- (NSString *)connectURL:(NSURL*)url
              withString:(NSString*)string {
    return [self connectEvaluateBlock:[HTTPExpressEvaluationBlockFactory evaluateUrlMatch:url]
                    withResponseBlock:[HTTPExpressResponseBlockFactory responseWithString:string]
                     forConfiguration:self.activeConfiguration];
}


- (BOOL)doRelativePathMatch:(HTTPMessage*)message
                  relativePath:(NSString*)path {
    BOOL match = NO;
    
    if( [[message.url relativePath] isEqualToString:path] ) {
        match = YES;
    }
    
    return match;
}

- (BOOL)hasCorrectRequestMethod:(HTTPMessage*)message withMethod:(NSString*)method {
    BOOL match = NO;
    
    if ([message.method isEqualToString:method]) {
        match = YES;
    }
    
    return match;
}

@end
