//
//  CellHelper.m
//  Reader
//
//  Created by Jhonathan Wyterlin on 02/07/15.
//  Copyright © 2015 Jhonathan Wyterlin. All rights reserved.
//

#import "CellHelper.h"

@implementation CellHelper

@synthesize delegate = _delegate;

-(CGFloat)calculateHeightForConfiguredSizingCell:(UITableViewCell *)sizingCell {
    
    [sizingCell setNeedsLayout];
    [sizingCell layoutIfNeeded];
    
    CGSize size = [sizingCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    
    return size.height;
    
}

-(CGFloat)heightForCellAtIndexPath:(NSIndexPath *)indexPath
                         tableView:(UITableView *)tableView
                    cellIdentifier:(NSString *)cellIdentifier
                          delegate:(id)__delegate {
    
    self.delegate = __delegate;
    
    UITableViewCell *sizingCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if ( [self.delegate respondsToSelector:@selector(configureCell:atIndexPath:)] ) {
        
        [self.delegate performSelector:@selector(configureCell:atIndexPath:)
                            withObject:sizingCell
                            withObject:indexPath];
        
    }
    
    return [self calculateHeightForConfiguredSizingCell:sizingCell];
    
}

@end
