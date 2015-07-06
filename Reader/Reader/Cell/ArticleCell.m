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
@property(nonatomic,strong) UILabel *noPhoto;

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
    
    cell.title.text = [NSString stringWithFormat:@"%@: %@",NSLocalizedString(@"TITLE", nil), article.title];
    cell.author.text = [NSString stringWithFormat:@"%@: %@", NSLocalizedString(@"AUTHOR", nil), article.author];
    
    NSString *dateString = [DateHelper dateFormattedMonthDayYear:article.date];
    
    cell.date.text = [NSString stringWithFormat:@"%@: %@", NSLocalizedString(@"DATE", nil), dateString];
    
    // Check font to represent if this article was read or not
    [self checkWasReadInCell:cell wasRead:[article.wasRead boolValue]];
    
    // Image
    cell.image.layer.borderColor = [UIColor colorWithRed:230.0/256.0
                                                   green:230.0/256.0
                                                    blue:230.0/256.0 alpha:1.0].CGColor;
    cell.image.layer.borderWidth = 1.0;
    
    [self downloadImageWithArticleCell:cell tableView:tableView indexPath:indexPath article:article];
    
}

#pragma mark - Private methods

-(void)checkWasReadInCell:(ArticleCell *)cell wasRead:(BOOL)wasRead {
    
    UIFont *font;
    
    if ( wasRead )
        font = [UIFont systemFontOfSize:17.0];
    else
        font = [UIFont boldSystemFontOfSize:17.0];
    
    cell.title.font = font;
    cell.author.font = font;
    cell.date.font = font;
    
}

-(void)downloadImageWithArticleCell:(ArticleCell *)cell
                          tableView:(UITableView *)tableView
                          indexPath:(NSIndexPath *)indexPath
                            article:(ArticleModel *)article {
    
    cell.tag = indexPath.row;
    
    if ( article.image ) {
        
        if ( cell ) {
            
            if ( cell.loading.isAnimating )
                [cell.loading stopAnimating];
            
            if ( [cell.noPhoto isDescendantOfView:cell.image] )
                [cell.noPhoto removeFromSuperview];
            
            if ( cell.tag == indexPath.row ) {

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
            
            // Download image
            [[ImageDAO new] defineImageById:[article.identifier stringValue]
                                 folderName:kFolderNameArticle
                                   filename:article.imageUrl
                                 completion:^(UIImage *image) {
                                     
                                     cell.isDownloading = NO;
                                     
                                     if ( ! image )
                                         image = [UIImage imageNamed:@""];
                                     
                                     NSData *imageDownloaded = UIImageJPEGRepresentation( image, 1.0 );
                                     
                                     if ( imageDownloaded ) {
                                         
                                         article.image = imageDownloaded;
                                         
                                         [article toArticle];
                                         [Database saveEntity];
                                         
                                         ArticleCell *updateCell = (id)[tableView cellForRowAtIndexPath:indexPath];
                                         
                                         if ( updateCell ) {
                                             
                                             if ( [updateCell.noPhoto isDescendantOfView:updateCell.image] )
                                                 [updateCell.noPhoto removeFromSuperview];
                                             
                                             [cell.loading stopAnimating];
                                             
                                             updateCell.image.alpha = 0;
                                             updateCell.image.image = image;
                                             
                                             [UIView animateWithDuration:0.7 animations:^{
                                                 updateCell.image.alpha = 1.0;
                                             }];
                                             
                                         }
                                         
                                     } else {
                                         
                                         ArticleCell *updateCell = (id)[tableView cellForRowAtIndexPath:indexPath];
                                         
                                         if ( updateCell ) {
                                             
                                             [cell.loading stopAnimating];
                                             [updateCell.loading stopAnimating];
                                             
                                             if ( ! [updateCell.noPhoto isDescendantOfView:updateCell.image] )
                                                 [updateCell.image addSubview:cell.noPhoto];
                                             
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

-(UILabel *)noPhoto {
    
    if ( ! _noPhoto ) {
        
        int height = 21;
        int y = ( self.image.frame.size.height / 2 ) - ( height / 2 );
        
        _noPhoto = [[UILabel alloc] initWithFrame:CGRectMake( 0, y, self.image.frame.size.width, height )];
        _noPhoto.numberOfLines = 0;
        _noPhoto.text = NSLocalizedString(@"NO_IMAGE", nil);
        _noPhoto.textAlignment = NSTextAlignmentCenter;
        _noPhoto.textColor = [UIColor colorWithRed:210.0/256.0 green:210.0/256.0 blue:210.0/256.0 alpha:1.0];
        
    }
    
    return _noPhoto;
    
}

@end
