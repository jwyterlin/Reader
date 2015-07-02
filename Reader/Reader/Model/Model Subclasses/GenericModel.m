//
//  GenericModel.m
//  Reader
//
//  Created by Jhonathan Wyterlin on 7/1/15.
//  Copyright © 2015 Jhonathan Wyterlin. All rights reserved.
//

#import "GenericModel.h"

@implementation GenericModel

-(NSArray *)setupListWithJson:(NSArray *)list {
    
    if ( ! list )
        return nil;
    
    NSMutableArray *listResult;
    
    if ( list.count > 0 ) {
        
        if ( [list[0] isKindOfClass:[NSDictionary class]] ) {
            
            listResult = [NSMutableArray new];
            
            for ( NSDictionary *obj in list ) {
                
                id objCreated = [self setupWithJson:obj];
                [listResult addObject:objCreated];
                
            }
            
        }
        
    }
    
    return listResult;
    
}

-(id)setupWithJson:(NSDictionary *)json {
    return self;
}

-(NSString *)receiveString:(NSString *)string {

    if ( [Validator isEmptyString:string] )
        return @"";
    else
        return string;

}

-(NSDate *)receiveDate:(NSString *)string {
    
    if ( [Validator isEmptyString:string] )
        return nil;
    else
        return [DateHelper dateFromString:string];
    
}

@end
