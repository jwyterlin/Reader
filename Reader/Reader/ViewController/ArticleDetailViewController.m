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
#import "CellHelper.h"
#import "Constants.h"
#import "JWMacros.h"
#import "UITableView+Helper.h"

@interface ArticleDetailViewController()<UITableViewDataSource,UITableViewDelegate,CellHelperDelegate>

@property(nonatomic,strong) IBOutlet UITableView *tableView;
@property(nonatomic,strong) IBOutlet UIImageView *articleImage;
@property(nonatomic) BOOL hasImage;
@property(nonatomic,strong) IBOutlet NSLayoutConstraint *tableViewTop;
@property(nonatomic,strong) IBOutlet NSLayoutConstraint *articleImageTop;

@end

@implementation ArticleDetailViewController

#pragma mark - View Lifecycle

-(void)viewDidLoad {
    
    [super viewDidLoad];
    
    if ( self.article.image )
        self.hasImage = YES;
    
    if ( self.hasImage )
        self.articleImage.image = [UIImage imageWithData:self.article.image];
    
    [self setupTableView];
    
}

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.navigationItem.title = @"Article Detail";
    
    if ( self.navigationController ) {
        
        self.articleImageTop.constant = self.navigationController.navigationBar.frame.size.height+20;
        self.tableViewTop.constant = self.navigationController.navigationBar.frame.size.height+20;
        
        [self.articleImage setNeedsUpdateConstraints];
        [self.tableView setNeedsUpdateConstraints];
        
    }
    
}

-(void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    self.navigationItem.title = @"";
    
}

-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDataSource methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.hasImage?4:3;

}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ( indexPath.row == (self.hasImage?0:-1) ) {
        // Image
        return [[ImageCell new] imageCellAtIndexPath:indexPath tableView:tableView];
    } else if ( indexPath.row == (self.hasImage?1:0) ) {
        // Title
        return [[TitleCell new] titleCellAtIndexPath:indexPath tableView:tableView title:self.article.title];
    } else if ( indexPath.row == (self.hasImage?2:1) ) {
        // Content
        return [[ContentCell new] contentCellAtIndexPath:indexPath tableView:tableView content:self.article.content];
    } else if ( indexPath.row == (self.hasImage?3:2) ) {
        // Site, Author and Date
        return [[FooterCell new] footerCellAtIndexPath:indexPath tableView:tableView article:self.article];
    }
    
    return [UITableViewCell new];
    
}

#pragma mark - UITableViewDelegate methods

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *identifier;
    
    if ( indexPath.row == (self.hasImage?0:-1) ) {
        // Image
        return 240;
    } else if ( indexPath.row == (self.hasImage?1:0) ) {
        // Title
        identifier = kNibNameTitleCell;
    } else if ( indexPath.row == (self.hasImage?2:1) ) {
        // Content
        identifier = kNibNameContentCell;
    } else if ( indexPath.row == (self.hasImage?3:2) ) {
        // Site, Author and Date
        identifier = kNibNameFooterCell;
    }
    
    CGFloat height = [[CellHelper new] heightForCellAtIndexPath:indexPath
                                                      tableView:tableView
                                                 cellIdentifier:identifier
                                                       delegate:self];

    if ( height == 0 )
        height = 42;

    return height;
    
}

#pragma mark - UIScrollViewDelegate methods

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {

    if ( self.hasImage ) {

        // Parallax effect
        float offset = scrollView.contentOffset.y;

        if ( offset > 0 && offset < self.articleImage.frame.size.height+64 ) {

            CGRect f = self.articleImage.frame;
            f.origin.y = -offset/2;
            self.articleImage.frame = f;

        }

    }

}

#pragma mark - CellHelperDelegate methods

-(void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    if ( indexPath.row == (self.hasImage?0:-1) ) {
        // Do nothing
        return;
    } else if ( indexPath.row == (self.hasImage?1:0) ) {
        // Title
        TitleCell *customCell = (TitleCell *)cell;
        [[TitleCell new] configureTitleCell:customCell tableView:self.tableView atIndexPath:indexPath title:self.article.title];
    } else if ( indexPath.row == (self.hasImage?2:1) ) {
        // Content
        ContentCell *customCell = (ContentCell *)cell;
        [[ContentCell new] configureContentCell:customCell tableView:self.tableView atIndexPath:indexPath content:self.article.content];
    } else if ( indexPath.row == (self.hasImage?3:2) ) {
        // Site, Author and Date
        FooterCell *customCell = (FooterCell *)cell;
        [[FooterCell new] configureFooterCell:customCell tableView:self.tableView atIndexPath:indexPath article:self.article];
    }

}

#pragma mark - Private methods

-(void)setupTableView {
    
    [self.tableView cleanTableFooter];
    [self.tableView removeSeparator];
    
    [self.tableView registerNibsForCellReuseIdentifiers:@[kNibNameContentCell,kNibNameFooterCell,kNibNameImageCell,kNibNameTitleCell]];
    
}

@end
