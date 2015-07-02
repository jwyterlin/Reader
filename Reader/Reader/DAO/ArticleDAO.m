//
//  ArticleDAO.m
//  Reader
//
//  Created by Jhonathan Wyterlin on 01/07/15.
//  Copyright © 2015 Jhonathan Wyterlin. All rights reserved.
//

#import "ArticleDAO.h"

// Model
#import "ArticleModel.h"

@implementation ArticleDAO

-(void)articleListWithSuccess:(void(^)(NSArray *articleList))success
                      failure:(void(^)(BOOL hasNoConnection, NSError *error))failure {
    
    [self articleListWithSuccess:^(NSArray *articleList) {
        if ( success )
            success( articleList );
    } failure:^(BOOL hasNoConnection, NSError *error) {
        if ( failure )
            failure( hasNoConnection, error );
    } test:^(id responseData, NSError *error) {
        // Do nothing
    }];
    
}

-(void)articleListWithSuccess:(void(^)(NSArray *articleList))success
                      failure:(void(^)(BOOL hasNoConnection, NSError *error))failure
                         test:(void(^)(id responseData, NSError *error))test {

    [[Connection new] connectWithMethod:RequestMethodGet url:[Routes WS_ARTICLE_LIST] parameters:nil success:^(id responseData) {

        NSArray *result = (NSArray *)[responseData copy];

        NSArray *articleList = [[ArticleModel new] setupListWithJson:result];

        if ( success )
            success( articleList );

    } failure:^( BOOL hasNoConnection, NSError *error ) {

        if ( failure )
            failure( hasNoConnection, error );

    }];

}

@end
