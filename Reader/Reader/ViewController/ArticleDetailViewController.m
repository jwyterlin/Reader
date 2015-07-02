//
//  ArticleDetailViewController.m
//  Reader
//
//  Created by Jhonathan Wyterlin on 02/07/15.
//  Copyright © 2015 Jhonathan Wyterlin. All rights reserved.
//

#import "ArticleDetailViewController.h"

// Cell
#import "ImageCell.h"
#import "TitleCell.h"
#import "ContentCell.h"
#import "FooterCell.h"

// Service Layer
#import "Constants.h"
#import "UITableView+Helper.h"

@interface ArticleDetailViewController()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong) IBOutlet UITableView *tableView;
@property(nonatomic,strong) IBOutlet UIImageView *articleImage;
@property(nonatomic) BOOL hasImage;

@end

@implementation ArticleDetailViewController

#pragma mark - View Lifecycle

-(void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.hasImage = ( self.article.image );
    
    if ( self.hasImage )
        self.articleImage.image = [UIImage imageWithData:self.article.image];
    
    [self setupTableView];
    
}

-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDataSource methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.hasImage?4:3;

}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ( indexPath.row == self.hasImage?0:-1 ) {
        // Image
        return [[ImageCell new] imageCellAtIndexPath:indexPath tableView:tableView];
    } else if ( indexPath.row == self.hasImage?1:0 ) {
        // Title
        return [[TitleCell new] titleCellAtIndexPath:indexPath tableView:tableView title:self.article.title];
    } else if ( indexPath.row == self.hasImage?2:1 ) {
        // Content
        return [[ContentCell new] contentCellAtIndexPath:indexPath tableView:tableView content:self.article.content];
    } else if ( indexPath.row == self.hasImage?3:2 ) {
        // Site, Author and Date
        return [[FooterCell new] footerCellAtIndexPath:indexPath tableView:tableView article:self.article];
    }
    
    return [UITableViewCell new];
    
}

#pragma mark - UITableViewDelegate methods

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ( indexPath.row == self.hasImage?0:-1 ) {
        // Image
        return 240;
    } else if ( indexPath.row == self.hasImage?1:0 ) {
        // Title
        return 42;
    } else if ( indexPath.row == self.hasImage?2:1 ) {
        // Content
        return 42;
    } else if ( indexPath.row == self.hasImage?3:2 ) {
        // Site, Author and Date
        return 42;
    }
    
    return 110;
    
}

#pragma mark - UIScrollViewDelegate methods

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {

    if ( self.hasImage ) {

        // Parallax effect
        float offset = scrollView.contentOffset.y;

        if ( offset > 0 && offset < self.articleImage.frame.size.height ) {

            CGRect f = self.articleImage.frame;
            f.origin.y = -offset/2;
            self.articleImage.frame = f;

        }

    }

}

#pragma mark - Private methods

-(void)setupTableView {
    
    [self.tableView cleanTableFooter];
    [self.tableView removeSeparator];
    
    [self.tableView registerNibsForCellReuseIdentifiers:@[kNibNameContentCell,kNibNameFooterCell,kNibNameImageCell,kNibNameTitleCell]];
    
}

@end
