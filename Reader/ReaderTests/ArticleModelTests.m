//
//  ArticleModelTests.m
//  Reader
//
//  Created by Jhonathan Wyterlin on 18/08/15.
//  Copyright (c) 2015 Jhonathan Wyterlin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "ArticleModel.h"

@interface ArticleModelTests : XCTestCase

@end

@implementation ArticleModelTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

-(void)testSetupWithJson {
    
    NSDictionary *articleDictionary = @{
                                        @"website":@"http://www.test.com",
                                        @"title":@"A title for the article",
                                        @"image":@"http://www.test.com/image.png",
                                        @"content":@"Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
                                        @"authors":@"Jhonathan Wyterlin",
                                        @"date":@"11/26/1987"
                                        };
    
    ArticleModel *articleModel = [[ArticleModel new] setupWithJson:articleDictionary];
    
    XCTAssert( articleModel, @"setupWithJson is not working in ArticleModel" );
    
    if ( articleModel ) {
        
        XCTAssert( articleModel.identifier, @"identifier was not defined in ArticleModel" );
        XCTAssert( articleModel.website, @"website was not defined in ArticleModel" );
        XCTAssert( articleModel.title, @"title was not defined in ArticleModel" );
        XCTAssert( articleModel.imageUrl, @"imageUrl was not defined in ArticleModel" );
        XCTAssert( articleModel.content, @"content was not defined in ArticleModel" );
        XCTAssert( articleModel.author, @"author was not defined in ArticleModel" );
        XCTAssert( articleModel.date, @"date was not defined in ArticleModel" );
        
    }
    
}

@end
