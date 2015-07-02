//
//  ArticleCell.h
//  Reader
//
//  Created by Jhonathan Wyterlin on 01/07/15.
//  Copyright © 2015 Jhonathan Wyterlin. All rights reserved.
//

#import <UIKit/UIKit.h>

// Cell
#import "GenericCell.h"

// Model
#import "ArticleModel.h"

@interface ArticleCell : GenericCell

-(ArticleCell *)articleCellAtIndexPath:(NSIndexPath *)indexPath
                             tableView:(UITableView *)tableView
                               article:(ArticleModel *)article;

-(void)configureArticleCell:(ArticleCell *)cell
                  tableView:(UITableView *)tableView
                atIndexPath:(NSIndexPath *)indexPath
                    article:(ArticleModel *)article;

@end
