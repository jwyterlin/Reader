//
//  JWMacros.m
//  Reader
//
//  Created by Jhonathan Wyterlin on 01/07/15.
//  Copyright © 2015 Jhonathan Wyterlin. All rights reserved.
//

#import "JWMacros.h"

void runOnMainQueueAsync(void (^block)(void)) {
    dispatch_async(dispatch_get_main_queue(), block);
}

void runOnMainQueueSync(void (^block)(void)) {
    
    if ( [NSThread isMainThread] )
        block();
    else
        dispatch_sync(dispatch_get_main_queue(), block);
    
}

void runOnBackgroundQueue(void (^block)(void)) {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),block);
}

@implementation JWMacros

@end
