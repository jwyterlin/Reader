//
//  Connection.h
//  Reader
//
//  Created by Jhonathan Wyterlin on 01/07/15.
//  Copyright © 2015 Jhonathan Wyterlin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Connection : NSObject

typedef enum {
    RequestMethodGet=0,
    RequestMethodPost,
    RequestMethodDelete,
    RequestMethodPut
} RequestMethod;

// Complete request method to the WebService
-(void)connectWithMethod:(RequestMethod)method
                     url:(NSString *)url
              parameters:(NSDictionary *)parameters
             credentials:(BOOL)hasCredentials
                 success:(void (^)(id responseData))success
                 failure:(void (^)(BOOL hasNoConnection, NSError *error))failure;

// Search the size in bytes of the file without download it from the server to verify that we update our cache.
+(void)contentLengthForPath:(NSString*)path completion:(void(^)(long long length))completion;

@end
