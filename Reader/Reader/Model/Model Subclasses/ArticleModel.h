//
//  ArticleModel.h
//  Reader
//
//  Created by Jhonathan Wyterlin on 7/1/15.
//  Copyright © 2015 Jhonathan Wyterlin. All rights reserved.
//

// Model
#import "GenericModel.h"
#import "Article.h"

@interface ArticleModel : GenericModel

@property(nonatomic,strong) NSNumber *identifier;
@property(nonatomic,strong) NSString *website;
@property(nonatomic,strong) NSString *title;
@property(nonatomic,strong) NSString *imageUrl;
@property(nonatomic,strong) NSString *content;
@property(nonatomic,strong) NSString *author;
@property(nonatomic,strong) NSDate *date;
@property(nonatomic,strong) NSData *image;
@property(nonatomic,strong) NSNumber *wasRead;

-(Article *)toArticle;
-(ArticleModel *)articleModelFromArticle:(Article *)article;

@end
