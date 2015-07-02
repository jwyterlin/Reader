//
//  TitleCell.m
//  Reader
//
//  Created by Jhonathan Wyterlin on 02/07/15.
//  Copyright © 2015 Jhonathan Wyterlin. All rights reserved.
//

#import "TitleCell.h"

@interface TitleCell()

@property(nonatomic,strong) IBOutlet UILabel *title;

@end

@implementation TitleCell

-(void)awakeFromNib {
    // Initialization code
}

-(void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

#pragma mark - Public methods

-(TitleCell *)titleCellAtIndexPath:(NSIndexPath *)indexPath
                         tableView:(UITableView *)tableView
                             title:(NSString *)title {
    
    TitleCell *cell = [tableView dequeueReusableCellWithIdentifier:kNibNameTitleCell forIndexPath:indexPath];
    [self configureTitleCell:cell tableView:tableView atIndexPath:indexPath title:title];
    
    return cell;
    
}

-(void)configureTitleCell:(TitleCell *)cell
                tableView:(UITableView *)tableView
              atIndexPath:(NSIndexPath *)indexPath
                    title:(NSString *)title {
    
    cell.title.text = title;
    
}

@end
