//
//  ArticleCell.m
//  Reader
//
//  Created by Jhonathan Wyterlin on 01/07/15.
//  Copyright © 2015 Jhonathan Wyterlin. All rights reserved.
//

#import "ArticleCell.h"

// DAO
#import "ImageDAO.h"

@interface ArticleCell()

@property(nonatomic,strong) IBOutlet UILabel *title;
@property(nonatomic,strong) IBOutlet UILabel *date;
@property(nonatomic,strong) IBOutlet UILabel *author;
@property(nonatomic,strong) IBOutlet UIImageView *image;
@property(nonatomic,strong) UIActivityIndicatorView *loading;
@property(nonatomic) BOOL isDownloading;

@end

@implementation ArticleCell

-(void)awakeFromNib {
    // Initialization code
}

-(void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

#pragma mark - Public methods

-(ArticleCell *)articleCellAtIndexPath:(NSIndexPath *)indexPath
                             tableView:(UITableView *)tableView
                               article:(ArticleModel *)article {
    
    ArticleCell *cell = [tableView dequeueReusableCellWithIdentifier:kNibNameArticleCell forIndexPath:indexPath];
    [self configureArticleCell:cell tableView:tableView atIndexPath:indexPath article:article];
    
    return cell;
    
}

-(void)configureArticleCell:(ArticleCell *)cell
                  tableView:(UITableView *)tableView
                atIndexPath:(NSIndexPath *)indexPath
                    article:(ArticleModel *)article {
    
    cell.title.text = [NSString stringWithFormat:@"Title: %@", article.title];
    cell.author.text = [NSString stringWithFormat:@"Author: %@", article.author];
    
    NSString *dateString = [DateHelper dateFormattedBrazilStandard:article.date];
    
    cell.date.text = [NSString stringWithFormat:@"Date: %@", dateString];
    
    cell.image.layer.borderColor = [UIColor colorWithRed:230.0/256.0
                                                   green:230.0/256.0
                                                    blue:230.0/256.0 alpha:1.0].CGColor;
    cell.image.layer.borderWidth = 1.0;
    
    [self downloadImageWithArticleCell:cell tableView:tableView indexPath:indexPath article:article];
    
    
}

-(void)downloadImageWithArticleCell:(ArticleCell *)cell
                          tableView:(UITableView *)tableView
                          indexPath:(NSIndexPath *)indexPath
                            article:(ArticleModel *)article {
    
    cell.tag = indexPath.row;
    
    if ( article.image ) {
        
        if ( cell ) {
            
            if ( cell.tag == indexPath.row ) {
                
                if ( cell.loading.isAnimating )
                    [cell.loading stopAnimating];
                
                cell.image.image = [[UIImage alloc] initWithData:article.image];
                [cell setNeedsDisplay];
                
            } else {
                
                cell.image.image = nil;
                
            }
            
        }
        
    } else {
        
        if ( ! [cell.loading isDescendantOfView:cell.image] )
            [cell.image addSubview:cell.loading];
        
        [cell.loading startAnimating];
        
        cell.image.image = nil;
        
        if ( ! cell.isDownloading ) {
            
            cell.isDownloading = YES;
            
            [[ImageDAO new] defineImageById:[article.identifier stringValue]
                                 folderName:kFolderNameArticle
                                   filename:article.imageUrl
                                 completion:^(UIImage *image) {
                                     
                                     cell.isDownloading = NO;
                                     
                                     NSData *imageDownloaded = UIImageJPEGRepresentation( image, 1.0 );
                                     
                                     if ( imageDownloaded ) {
                                         
                                         article.image = imageDownloaded;
                                         
                                         ArticleCell *updateCell = (id)[tableView cellForRowAtIndexPath:indexPath];
                                         
                                         if ( updateCell ) {
                                             
                                             [cell.loading stopAnimating];
                                             
                                             updateCell.image.alpha = 0;
                                             updateCell.image.image = image;
                                             
                                             [UIView animateWithDuration:0.7 animations:^{
                                                 updateCell.image.alpha = 1.0;
                                             }];
                                             
                                         }
                                         
                                     }
                                     
                                     
                                 }];
            
        }
        
    }
    
}

-(UIActivityIndicatorView *)loading {
    
    if ( ! _loading ) {
        
        _loading = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _loading.center = CGPointMake( self.image.frame.size.width/2, self.image.frame.size.height/2 );
        _loading.hidesWhenStopped = YES;
        
    }
    
    return _loading;
    
}

@end
