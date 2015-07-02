//
//  Routes.m
//  Reader
//
//  Created by Jhonathan Wyterlin on 01/07/15.
//  Copyright © 2015 Jhonathan Wyterlin. All rights reserved.
//

#import "Routes.h"

@implementation Routes

+(NSString *)BASE_URL {
    return @"http://www.ckl.io/";
}

+(NSString *)BASEAPI_URL {
    return [NSString stringWithFormat:@"%@",[Routes BASE_URL]];
}

+(NSString *)WS_ARTICLE_LIST {
    return @"challenge/";
}

@end
