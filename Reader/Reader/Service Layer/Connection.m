//
//  Connection.m
//  Reader
//
//  Created by Jhonathan Wyterlin on 01/07/15.
//  Copyright © 2015 Jhonathan Wyterlin. All rights reserved.
//

#import "Connection.h"

// Open Source Lib
#import <AFNetworking/AFNetworking.h>
#import "Reachability.h"

// Service Layer
#import "NetAPIClient.h"

@implementation Connection

// Complete request method to the WebService
-(void)connectWithMethod:(RequestMethod)method
                     url:(NSString *)url
              parameters:(NSDictionary *)parameters
             credentials:(BOOL)hasCredentials
                 success:(void (^)(id responseData))success
                 failure:(void (^)(BOOL hasNoConnection, NSError *error))failure {
    
    if ( ! [self isNetworkReachable] ) {
        
        if ( failure )
            failure( YES, nil );
        
        return;
        
    }
    
    if ( method == RequestMethodGet ) {
        
        // Sents the GET to server and capture response object, giving back callbacks to consumer.
        [[NetAPIClient sharedClient] GET:url parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
            if (success)
                success(responseObject);
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            if (failure)
                failure(NO, error);
        }];
        
    } else if ( method == RequestMethodPost ) {
        
        // Sents the POST to server and capture response object, giving back callbacks to consumer.
        [[NetAPIClient sharedClient] POST:url parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
            if (success)
                success(responseObject);
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            if (failure)
                failure(NO, error);
        }];
        
    } else if ( method == RequestMethodDelete ) {
        
        // Sents the DELETE to server and capture response object, giving back callbacks to consumer.
        [[NetAPIClient sharedClient] DELETE:url parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
            if (success)
                success(responseObject);
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            if (failure)
                failure(NO, error);
        }];
        
    } else if ( method == RequestMethodPut ) {
        
        // Sents the PUT to server and capture response object, giving back callbacks to consumer.
        [[NetAPIClient sharedClient] PUT:url parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
            if (success)
                success(responseObject);
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            if (failure)
                failure(NO, error);
        }];
        
    }
}


// Search the size in bytes of the file without download it from the server to verify that we update our cache.
+(void)contentLengthForPath:(NSString *)path completion:(void(^)(long long length))completion {

    AFHTTPSessionManager *managerClient = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:path]];

    [managerClient HEAD:path parameters:nil success:^(NSURLSessionDataTask *task) {
        if (completion)
            completion(task.response.expectedContentLength);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (completion)
            completion(-1);
    }];

}

-(BOOL)isNetworkReachable {

    Reachability *reachability = [Reachability reachabilityForInternetConnection];

    NetworkStatus networkStatus = [reachability currentReachabilityStatus];

    if ( networkStatus == NotReachable || [reachability connectionRequired] )
        return NO;
    else
        return YES;

}


@end
