//
//  ArticlesListViewController.m
//  Reader
//
//  Created by Jhonathan Wyterlin on 7/1/15.
//  Copyright © 2015 Jhonathan Wyterlin. All rights reserved.
//

#import "ArticlesListViewController.h"

// Cell
#import "ArticleCell.h"

// DAO
#import "ArticleDAO.h"

// Service Layer
#import "Constants.h"
#import "UITableView+Helper.h"

@interface ArticlesListViewController()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong) IBOutlet UITableView *tableView;
@property(nonatomic,strong) NSArray *articleList;

@end

@implementation ArticlesListViewController

#pragma mark - View Lifecycle

-(void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self setupTableView];
    
    [self downloadList];
    
}

-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDataSource methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.articleList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ArticleModel *articleModel = self.articleList[indexPath.row];
    
    return [[ArticleCell new] articleCellAtIndexPath:indexPath tableView:tableView article:articleModel];
    
}

#pragma mark - UITableViewDelegate methods

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 42; // Life, universe and everything else
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

#pragma mark - Private methods

-(void)downloadList {
    
    [[ArticleDAO new] articleListWithSuccess:^(NSArray *articleList) {
        
        self.articleList = articleList;
        
        [self.tableView reloadData];
        
    } failure:^(BOOL hasNoConnection, NSError *error) {
        
        if ( hasNoConnection ) {
            return;
        }
        
        if ( error ) {
            return;
        }
        
    }];
    
}

-(void)setupTableView {
    
    [self.tableView cleanTableFooter];
    [self.tableView removeSeparator];

    [self.tableView registerNibForCellReuseIdentifier:kNibNameArticleCell];
    
}

@end
