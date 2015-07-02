//
//  ContentCell.h
//  Reader
//
//  Created by Jhonathan Wyterlin on 02/07/15.
//  Copyright © 2015 Jhonathan Wyterlin. All rights reserved.
//

#import <UIKit/UIKit.h>

// Cell
#import "GenericCell.h"

@interface ContentCell : GenericCell

-(ContentCell *)contentCellAtIndexPath:(NSIndexPath *)indexPath
                             tableView:(UITableView *)tableView
                               content:(NSString *)content;

-(void)configureContentCell:(ContentCell *)cell
                  tableView:(UITableView *)tableView
                atIndexPath:(NSIndexPath *)indexPath
                    content:(NSString *)content;

@end
