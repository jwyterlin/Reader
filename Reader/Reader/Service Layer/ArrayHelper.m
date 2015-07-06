//
//  ArrayHelper.m
//  Reader
//
//  Created by Jhonathan Wyterlin on 7/6/15.
//  Copyright © 2015 Jhonathan Wyterlin. All rights reserved.
//

#import "ArrayHelper.h"

@implementation ArrayHelper

-(NSArray *)sortingOptions {
    
    return @[NSLocalizedString(@"TITLE", nil),
             NSLocalizedString(@"CONTENT", nil),
             NSLocalizedString(@"DATE", nil),
             NSLocalizedString(@"WEBSITE", nil),
             NSLocalizedString(@"AUTHOR", nil)];
    
}

@end
