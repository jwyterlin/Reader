//
//  DateHelper.m
//  Reader
//
//  Created by Jhonathan Wyterlin on 01/07/15.
//  Copyright © 2015 Jhonathan Wyterlin. All rights reserved.
//

#import "DateHelper.h"

// Service Layer
#import "Constants.h"

@implementation DateHelper

+(NSDate *)dateFromString:(NSString *)dateString {
    
    if ( ! dateString )
        return nil;
    
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    NSTimeZone *tz = [NSTimeZone timeZoneWithName:kTimeZoneGreenwich];
    [dateFormatter setDateFormat:kDateFormatMonthDayYear];
    [dateFormatter setTimeZone:tz];
    NSDate *date = [dateFormatter dateFromString:dateString];
    
    if ( date == nil ) {
        
        if ( dateString.length < 4 )
            return nil;
        
        // Get first 4 caracteres of dateString
        NSString *year = [dateString substringWithRange:NSMakeRange(0, 4)];
        
        if ( ! [year isEqualToString:@"0000"] ) {
            
            dateString = [NSString stringWithFormat:@"%@ %@", dateString, @"23:59:59"];
            date = [dateFormatter dateFromString:dateString];
            return date;
            
        }
        
        date = [dateFormatter dateFromString:dateString];
        
    }
    
    return date;
    
}

+(NSString *)dateFormattedBrazilStandard:(NSDate *)date {
    
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    NSTimeZone *tz = [NSTimeZone timeZoneWithName:kTimeZoneGreenwich];
    [dateFormatter setDateFormat:kDateFormatBrazil];
    [dateFormatter setTimeZone:tz];
    
    NSString *dateFormatted = [dateFormatter stringFromDate:date];
    
    if ( dateFormatted == nil ) {
        return @"0000-00-00";
    } else {
        return dateFormatted;
    }
    
}

+(NSString *)dateFormattedMonthDayYear:(NSDate *)date {
    
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    NSTimeZone *tz = [NSTimeZone timeZoneWithName:kTimeZoneGreenwich];
    [dateFormatter setDateFormat:kDateFormatMonthDayYear];
    [dateFormatter setTimeZone:tz];
    
    NSString *dateFormatted = [dateFormatter stringFromDate:date];
    
    if ( dateFormatted == nil ) {
        return @"0000-00-00";
    } else {
        return dateFormatted;
    }
    
}

+(NSString *)dateFormattedISO8601Standard:(NSDate *)date {
    
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    NSTimeZone *tz = [NSTimeZone timeZoneWithName:kTimeZoneGreenwich];
    [dateFormatter setDateFormat:kDateFormatISO8601];
    [dateFormatter setTimeZone:tz];
    
    NSString *dateFormatted = [dateFormatter stringFromDate:date];
    
    if ( dateFormatted == nil ) {
        return @"0000-00-00";
    } else {
        return dateFormatted;
    }
    
}

+(NSString *)dateTimeFormattedISO8601Standard:(NSDate *)date {
    
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    NSTimeZone *tz = [NSTimeZone timeZoneWithName:kTimeZoneGreenwich];
    [dateFormatter setDateFormat:kDateTimeFormatISO8601];
    [dateFormatter setTimeZone:tz];
    
    NSString *dateFormatted = [dateFormatter stringFromDate:date];
    
    if ( dateFormatted == nil ) {
        return @"0000-00-00 00:00:00";
    } else {
        return dateFormatted;
    }
    
}

-(NSString *)getCurrentDate {
    
    NSDateFormatter *formatter = [NSDateFormatter new];
    formatter.dateStyle = NSDateFormatterShortStyle;
    formatter.timeStyle = NSDateFormatterShortStyle;
    formatter.timeZone = [NSTimeZone timeZoneWithName:kTimeZoneAmericaSaoPaulo];
    formatter.dateFormat = kDateTimeFormatISO8601;
    
    NSDate *now = [NSDate date];
    
    return [formatter stringFromDate:now];
    
}

-(NSString *)dateTimeFormat:(NSDate *)date {
    
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    NSTimeZone *tz = [NSTimeZone timeZoneWithName:kTimeZoneGreenwich];
    [dateFormatter setDateFormat:@"dd/MM/yyyy - HH:mm"];
    [dateFormatter setTimeZone:tz];
    
    NSString *dateFormatted = [dateFormatter stringFromDate:date];
    
    return dateFormatted;
    
}

+(void)addNumberOfDays:(int)days onDate:(NSDate *)date {
    
    int seconds = 60;
    int minutes = 60;
    int hours   = 24;
    int daysToAdd = days*hours*minutes*seconds;
    
    date = [date dateByAddingTimeInterval:daysToAdd];
    
}

@end
