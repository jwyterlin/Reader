//
//  Constants.h
//  Reader
//
//  Created by Jhonathan Wyterlin on 01/07/15.
//  Copyright © 2015 Jhonathan Wyterlin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Constants : NSObject

// Date Formats
extern NSString *const kDateFormatISO8601;
extern NSString *const kDateTimeFormatISO8601;
extern NSString *const kDateFormatBrazil;
extern NSString *const kDateFormatMonthDayYear;

// TimeZone
extern NSString *const kTimeZoneAmericaSaoPaulo;
extern NSString *const kTimeZoneGreenwich;

// Cell Nib Names
extern NSString *const kNibNameArticleCell;

extern NSString *const kCachedImages;
extern NSString *const kDateLastEmptyCache;

// Folder Names
extern NSString *const kFolderNameArticle;

@end
