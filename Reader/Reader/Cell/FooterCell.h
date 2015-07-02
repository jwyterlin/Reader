//
//  FooterCell.h
//  Reader
//
//  Created by Jhonathan Wyterlin on 02/07/15.
//  Copyright © 2015 Jhonathan Wyterlin. All rights reserved.
//

#import <UIKit/UIKit.h>

// Cell
#import "GenericCell.h"

// Model
#import "ArticleModel.h"

@interface FooterCell : GenericCell

-(FooterCell *)footerCellAtIndexPath:(NSIndexPath *)indexPath
                           tableView:(UITableView *)tableView
                             article:(ArticleModel *)article;

-(void)configureFooterCell:(FooterCell *)cell
                 tableView:(UITableView *)tableView
               atIndexPath:(NSIndexPath *)indexPath
                   article:(ArticleModel *)article;

@end
