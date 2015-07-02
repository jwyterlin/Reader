//
//  ArticleModel.m
//  Reader
//
//  Created by Jhonathan Wyterlin on 7/1/15.
//  Copyright © 2015 Jhonathan Wyterlin. All rights reserved.
//

#import "ArticleModel.h"

@implementation ArticleModel

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

@end
