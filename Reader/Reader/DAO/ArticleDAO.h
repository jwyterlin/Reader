//
//  ArticleDAO.h
//  Reader
//
//  Created by Jhonathan Wyterlin on 01/07/15.
//  Copyright © 2015 Jhonathan Wyterlin. All rights reserved.
//

#import "GenericDAO.h"

@interface ArticleDAO : GenericDAO

// Get a list of articles
-(void)articleListWithSuccess:(void(^)(NSArray *articleList))success
                      failure:(void(^)(BOOL hasNoConnection, NSError *error))failure;

-(void)articleListWithSuccess:(void(^)(NSArray *articleList))success
                      failure:(void(^)(BOOL hasNoConnection, NSError *error))failure
                         test:(void(^)(id responseData, NSError *error))test;

@end
