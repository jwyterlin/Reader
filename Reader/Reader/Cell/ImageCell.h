//
//  ImageCell.h
//  Reader
//
//  Created by Jhonathan Wyterlin on 02/07/15.
//  Copyright © 2015 Jhonathan Wyterlin. All rights reserved.
//

#import <UIKit/UIKit.h>

// Cell
#import "GenericCell.h"

@interface ImageCell : GenericCell

-(ImageCell *)imageCellAtIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView;

@end
