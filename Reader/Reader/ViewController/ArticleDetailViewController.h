//
//  ArticleDetailViewController.h
//  Reader
//
//  Created by Jhonathan Wyterlin on 02/07/15.
//  Copyright © 2015 Jhonathan Wyterlin. All rights reserved.
//

#import <UIKit/UIKit.h>

// Model
#import "ArticleModel.h"

@interface ArticleDetailViewController : UIViewController

@property(nonatomic,strong) ArticleModel *article;

@end
