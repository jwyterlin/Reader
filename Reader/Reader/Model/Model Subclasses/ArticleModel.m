//
//  ArticleModel.m
//  Reader
//
//  Created by Jhonathan Wyterlin on 7/1/15.
//  Copyright © 2015 Jhonathan Wyterlin. All rights reserved.
//

#import "ArticleModel.h"

@implementation ArticleModel

#pragma mark - Overriding methods

-(ArticleModel *)setupWithJson:(NSDictionary *)j {
    
    if ( ! [Validator validateObject:j] )
        return nil;
    
    ArticleModel *articleModel = [ArticleModel new];
    
    articleModel.website = [self receiveString:j[@"website"]];
    articleModel.title = [self receiveString:j[@"title"]];
    articleModel.imageUrl = [self receiveString:j[@"image"]];
    articleModel.content = [self receiveString:j[@"content"]];
    articleModel.author = [self receiveString:j[@"authors"]];
    articleModel.date = [self receiveDate:j[@"date"]];
    
    return articleModel;
    
}

#pragma mark - Public methods

-(Article *)toArticle {
    
    Article *article = [self entityByIdentifier:self.identifier entityName:[Article description]];
    
    if ( article == nil ) {
        
        NSManagedObjectContext *context = [[Database sharedInstance] managedObjectContext];
        article = [NSEntityDescription insertNewObjectForEntityForName:[Article description] inManagedObjectContext:context];
        
    }
    
    // Attributes
    @autoreleasepool {
        
        unsigned int numberOfProperties = 0;
        
        objc_property_t *propertyArray = class_copyPropertyList([self class], &numberOfProperties);
        
        for ( NSUInteger i = 0; i < numberOfProperties; i++ ) {
            objc_property_t property = propertyArray[i];
            NSString *name = [[NSString alloc] initWithUTF8String:property_getName( property )];
            [article setValue:[self valueForKey:name] forKey:name];
        }
        
        free( propertyArray );
        
    }
    
    return article;
    
}

@end
