//
//  NetAPIClient.h
//  Reader
//
//  Created by Jhonathan Wyterlin on 01/07/15.
//  Copyright © 2015 Jhonathan Wyterlin. All rights reserved.
//

#import <Foundation/Foundation.h>

// Open Source Lib
#import "AFHTTPSessionManager.h"

@interface NetAPIClient : AFHTTPSessionManager

+(instancetype)sharedClient;

@end
