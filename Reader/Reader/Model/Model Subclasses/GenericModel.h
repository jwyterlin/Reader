//
//  GenericModel.h
//  Reader
//
//  Created by Jhonathan Wyterlin on 7/1/15.
//  Copyright © 2015 Jhonathan Wyterlin. All rights reserved.
//

#import <Foundation/Foundation.h>

// Service Layer
#import "DateHelper.h"
#import "Validator.h"

@interface GenericModel : NSObject

-(NSArray *)setupListWithJson:(NSArray *)list;
-(id)setupWithJson:(NSDictionary *)json;
-(NSString *)receiveString:(NSString *)string;
-(NSDate *)receiveDate:(NSString *)string;

@end
