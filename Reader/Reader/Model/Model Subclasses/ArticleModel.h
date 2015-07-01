//
//  ArticleModel.h
//  Reader
//
//  Created by Jhonathan Wyterlin on 7/1/15.
//  Copyright © 2015 Jhonathan Wyterlin. All rights reserved.
//

#import "GenericModel.h"

@interface ArticleModel : GenericModel

@property(nonatomic,strong) NSString *title;
@property(nonatomic,strong) NSDate *date;
@property(nonatomic,strong) NSString *author;
@property(nonatomic,strong) NSString *imageUrl;
@property(nonatomic,strong) NSData *image;

@end
