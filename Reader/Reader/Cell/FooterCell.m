//
//  FooterCell.m
//  Reader
//
//  Created by Jhonathan Wyterlin on 02/07/15.
//  Copyright © 2015 Jhonathan Wyterlin. All rights reserved.
//

#import "FooterCell.h"

@interface FooterCell()

@property(nonatomic,strong) IBOutlet UILabel *site;
@property(nonatomic,strong) IBOutlet UILabel *author;
@property(nonatomic,strong) IBOutlet UILabel *date;

@end

@implementation FooterCell

-(void)awakeFromNib {
    // Initialization code
}

-(void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

#pragma mark - Public methods

-(FooterCell *)footerCellAtIndexPath:(NSIndexPath *)indexPath
                           tableView:(UITableView *)tableView
                             article:(ArticleModel *)article {
    
    FooterCell *cell = [tableView dequeueReusableCellWithIdentifier:kNibNameFooterCell forIndexPath:indexPath];
    [self configureFooterCell:cell tableView:tableView atIndexPath:indexPath article:article];
    
    return cell;
    
}

-(void)configureFooterCell:(FooterCell *)cell
                 tableView:(UITableView *)tableView
               atIndexPath:(NSIndexPath *)indexPath
                   article:(ArticleModel *)article {
    
    cell.site.text = article.website;

    cell.author.text = [NSString stringWithFormat:@"Author: %@", article.author];
    
    NSString *dateString = [DateHelper dateFormattedMonthDayYear:article.date];
    
    cell.date.text = [NSString stringWithFormat:@"Date: %@", dateString];
    
    
}

@end
