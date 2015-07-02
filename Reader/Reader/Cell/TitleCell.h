//
//  TitleCell.h
//  Reader
//
//  Created by Jhonathan Wyterlin on 02/07/15.
//  Copyright © 2015 Jhonathan Wyterlin. All rights reserved.
//

#import <UIKit/UIKit.h>

// Cell
#import "GenericCell.h"

@interface TitleCell : GenericCell

-(TitleCell *)titleCellAtIndexPath:(NSIndexPath *)indexPath
                         tableView:(UITableView *)tableView
                             title:(NSString *)title;

-(void)configureTitleCell:(TitleCell *)cell
                tableView:(UITableView *)tableView
              atIndexPath:(NSIndexPath *)indexPath
                    title:(NSString *)title;

@end
