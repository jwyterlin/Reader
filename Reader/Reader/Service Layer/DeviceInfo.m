//
//  DeviceInfo.m
//  Reader
//
//  Created by Jhonathan Wyterlin on 02/07/15.
//  Copyright © 2015 Jhonathan Wyterlin. All rights reserved.
//

#import "DeviceInfo.h"

@implementation DeviceInfo

static CGFloat height;
static CGFloat width;

+(CGFloat)height {
    
    if ( height == 0 ) {
        CGRect screenBounds = [[UIScreen mainScreen] bounds];
        height  = screenBounds.size.height;
    }
    
    return height;
    
}

+(CGFloat)width {
    
    if ( width == 0 ) {
        CGRect screenBounds = [[UIScreen mainScreen] bounds];
        width = screenBounds.size.width;
    }
    
    return width;
    
}


@end
