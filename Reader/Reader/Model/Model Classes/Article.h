//
//  Article.h
//  Reader
//
//  Created by Jhonathan Wyterlin on 05/07/15.
//  Copyright (c) 2015 Jhonathan Wyterlin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface Article : NSManagedObject

@property (nonatomic, retain) NSNumber * identifier;
@property (nonatomic, retain) NSString * website;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * imageUrl;
@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSString * author;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSData * image;
@property (nonatomic, retain) NSNumber * wasRead;

@end
