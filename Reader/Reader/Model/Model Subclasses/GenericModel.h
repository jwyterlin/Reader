//
//  GenericModel.h
//  Reader
//
//  Created by Jhonathan Wyterlin on 7/1/15.
//  Copyright © 2015 Jhonathan Wyterlin. All rights reserved.
//

#import <Foundation/Foundation.h>

// Service Layer
#import "Database.h"
#import "DateHelper.h"
#import "Validator.h"

#import <objc/runtime.h>

@interface GenericModel : NSObject

-(NSArray *)setupListWithJson:(NSArray *)list;
-(id)setupWithJson:(NSDictionary *)json;
-(NSString *)receiveString:(NSString *)string;
-(NSDate *)receiveDate:(NSString *)string;
-(NSArray *)allWithEntityName:(NSString *)entityName;
-(id)entityByIdentifier:(NSNumber *)identifier entityName:(NSString *)entityName;
-(void)setFieldsfromSource:(id)source toDestination:(id)destination class:(Class)class;
-(id)toEntityWithEntityName:(NSString *)entityName identifier:(NSNumber *)identifier;

@end
