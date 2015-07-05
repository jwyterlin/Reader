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
    
    [articleModel toArticle];
    [Database saveEntity];
    
    return articleModel;
    
}

#pragma mark - Public methods

-(Article *)toArticle {

    Article *article = (Article *)[self toEntityWithEntityName:[Article description] identifier:self.identifier];
    
    return article;
    
}

-(ArticleModel *)articleModelFromArticle:(Article *)article {
    
    if ( ! article )
        return nil;
    
    ArticleModel *articleModel = [ArticleModel new];
    
    // Attributes
    [self setFieldsfromSource:article toDestination:articleModel class:[self class]];
    
    return articleModel;
    
}

-(NSArray *)allArticles {
    
    return [self allWithEntityName:[Article description]];
    
}

-(NSArray *)allArticlesModel {
    
    NSArray *articles = [self allArticles];
    
    NSMutableArray *articleModels = [NSMutableArray new];
    
    for ( Article *article in articles ) {
        
        ArticleModel *articleModel = [[ArticleModel new] articleModelFromArticle:article];
        [articleModels addObject:articleModel];
        
    }
    
    return [articleModels mutableCopy];
    
}

@end
