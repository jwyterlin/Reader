//
//  ContentCell.m
//  Reader
//
//  Created by Jhonathan Wyterlin on 02/07/15.
//  Copyright © 2015 Jhonathan Wyterlin. All rights reserved.
//

#import "ContentCell.h"

// Service Layer
#import "DeviceInfo.h"
#import "JWLabel.h"

@interface ContentCell()

@property(nonatomic,strong) IBOutlet NSLayoutConstraint *contentWidth;
@property(nonatomic,strong) IBOutlet JWLabel *content;

@end

@implementation ContentCell

-(void)awakeFromNib {
    // Initialization code
}

-(void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

#pragma mark - Public methods

-(ContentCell *)contentCellAtIndexPath:(NSIndexPath *)indexPath
                             tableView:(UITableView *)tableView
                               content:(NSString *)content {
    
    ContentCell *cell = [tableView dequeueReusableCellWithIdentifier:kNibNameContentCell forIndexPath:indexPath];
    [self configureContentCell:cell tableView:tableView atIndexPath:indexPath content:content];
    
    return cell;
    
}

-(void)configureContentCell:(ContentCell *)cell
                  tableView:(UITableView *)tableView
                atIndexPath:(NSIndexPath *)indexPath
                    content:(NSString *)content {
    
    cell.content.text = content;
    
    cell.contentWidth.constant = [DeviceInfo width]-16;
    [cell.content setNeedsUpdateConstraints];
    
}

@end
