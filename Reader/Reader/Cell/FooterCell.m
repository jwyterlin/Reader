//
//  FooterCell.m
//  Reader
//
//  Created by Jhonathan Wyterlin on 02/07/15.
//  Copyright © 2015 Jhonathan Wyterlin. All rights reserved.
//

#import "FooterCell.h"

// Service Layer
#import "DeviceInfo.h"
#import "JWLabel.h"

@interface FooterCell()

@property(nonatomic,strong) IBOutlet JWLabel *site;
@property(nonatomic,strong) IBOutlet JWLabel *author;
@property(nonatomic,strong) IBOutlet JWLabel *date;

@property(nonatomic,strong) IBOutlet NSLayoutConstraint *siteWidth;
@property(nonatomic,strong) IBOutlet NSLayoutConstraint *authorWidth;
@property(nonatomic,strong) IBOutlet NSLayoutConstraint *dateWidth;

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

    cell.author.text = [NSString stringWithFormat:@"%@: %@", NSLocalizedString(@"AUTHOR", nil), article.author];
    
    NSString *dateString = [DateHelper dateFormattedMonthDayYear:article.date];
    
    cell.date.text = [NSString stringWithFormat:@"%@: %@", NSLocalizedString(@"DATE", nil), dateString];
    
    cell.siteWidth.constant = [DeviceInfo width]-16;
    cell.authorWidth.constant = [DeviceInfo width]-16;
    cell.dateWidth.constant = [DeviceInfo width]-16;
    
    [cell.site setNeedsUpdateConstraints];
    [cell.author setNeedsUpdateConstraints];
    [cell.date setNeedsUpdateConstraints];
    
}

@end
