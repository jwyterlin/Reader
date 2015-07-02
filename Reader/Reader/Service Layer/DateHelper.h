//
//  DateHelper.h
//  Reader
//
//  Created by Jhonathan Wyterlin on 01/07/15.
//  Copyright © 2015 Jhonathan Wyterlin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateHelper : NSObject

+(NSDate *)dateFromString:(NSString *)dateString;
+(NSString *)dateFormattedBrazilStandard:(NSDate *)date;
+(NSString *)dateFormattedISO8601Standard:(NSDate *)date;
+(NSString *)dateTimeFormattedISO8601Standard:(NSDate *)date;
-(NSString *)getCurrentDate;
-(NSString *)dateTimeFormat:(NSDate *)date;

@end
