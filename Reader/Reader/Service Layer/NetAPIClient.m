//
//  NetAPIClient.m
//  Reader
//
//  Created by Jhonathan Wyterlin on 01/07/15.
//  Copyright © 2015 Jhonathan Wyterlin. All rights reserved.
//

#import "NetAPIClient.h"

// Service Layer
#import "Routes.h"

@implementation NetAPIClient

+(instancetype)sharedClient {
    
    static NetAPIClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _sharedClient = [[NetAPIClient alloc] initWithBaseURL:[NSURL URLWithString:[Routes BASEAPI_URL]]];
    });
    
    return _sharedClient;
}

@end