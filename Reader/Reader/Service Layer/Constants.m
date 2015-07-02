//
//  Constants.m
//  Reader
//
//  Created by Jhonathan Wyterlin on 01/07/15.
//  Copyright © 2015 Jhonathan Wyterlin. All rights reserved.
//

#import "Constants.h"

@implementation Constants

// Date Formats
NSString *const kDateFormatISO8601 = @"yyyy-MM-dd";
NSString *const kDateTimeFormatISO8601 = @"yyyy-MM-dd HH:mm:ss";
NSString *const kDateFormatBrazil = @"dd/MM/yyyy";
NSString *const kDateFormatMonthDayYear = @"MM/dd/yyyy";

// TimeZone
NSString *const kTimeZoneAmericaSaoPaulo = @"America/Sao_Paulo";
NSString *const kTimeZoneGreenwich = @"Greenwich";

// Cell Nib Names
NSString *const kNibNameArticleCell = @"ArticleCell";
NSString *const kNibNameImageCell = @"ImageCell";
NSString *const kNibNameTitleCell = @"TitleCell";
NSString *const kNibNameContentCell = @"ContentCell";
NSString *const kNibNameFooterCell = @"FooterCell";

NSString *const kCachedImages = @"cachedImages";
NSString *const kDateLastEmptyCache = @"dateLastEmptyCache";

// Folder Names
NSString *const kFolderNameArticle = @"article";

@end
