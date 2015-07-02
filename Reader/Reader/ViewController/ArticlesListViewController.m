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
#import "DeviceInfo.h"
#import "UITableView+Helper.h"

// ViewController
#import "ArticleDetailViewController.h"

@interface ArticlesListViewController()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UISearchDisplayDelegate>

@property(nonatomic,strong) IBOutlet UITableView *tableView;
@property(nonatomic,strong) NSArray *articleList;
@property(nonatomic,strong) NSMutableArray *filtered;
@property(nonatomic,strong) NSArray *aux;
@property(nonatomic) BOOL isChangedNoResults;
@property(nonatomic,strong) UIView *bgSearchBarView;

@end

@implementation ArticlesListViewController

#pragma mark - View Lifecycle

-(void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self setupTableView];
    
    [self downloadList];
    
    [self prepareForFilter];
    
}

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.navigationItem.title = @"Articles";
    
}

-(void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
    
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
    return self.articleList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ArticleModel *articleModel = self.articleList[indexPath.row];
    
    return [[ArticleCell new] articleCellAtIndexPath:indexPath tableView:tableView article:articleModel];
    
}

#pragma mark - UITableViewDelegate methods

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 110;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ArticleModel *article = self.articleList[indexPath.row];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:kStoryboardMain bundle:nil];
    
    ArticleDetailViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:kNibArticleDetailViewController];
    viewController.article = article;
    
    [self.navigationController pushViewController:viewController animated:YES];

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
    
    self.tableView.tableHeaderView = self.searchDisplayController.searchBar;
    
    [self hideSearchBarUntilScroll];
    
}

-(void)hideSearchBarUntilScroll {
    
    // Hide the search bar until user scrolls up
    CGRect newBounds = self.tableView.bounds;
    newBounds.origin.y = newBounds.origin.y + self.searchDisplayController.searchBar.bounds.size.height;
    self.tableView.bounds = newBounds;
    
}

-(void)prepareForFilter {
    
    self.aux = [self.articleList copy];
    
    // Initialize the filtered with a capacity equal to the list's capacity
    self.filtered = [NSMutableArray arrayWithCapacity:self.articleList.count];
    
}

-(void)showBgSearchBarView {
    
    if ( ! [self.bgSearchBarView isDescendantOfView:self.view] )
        [self.view addSubview:self.bgSearchBarView];
    
    self.bgSearchBarView.hidden = NO;
    [self.view bringSubviewToFront:self.bgSearchBarView];
    
}

-(void)dismissBgSearchBarView {
    
    if ( [self.bgSearchBarView isDescendantOfView:self.view] )
        self.bgSearchBarView.hidden = YES;
    
}

#pragma mark - Creating components

-(UIView *)bgSearchBarView {
    
    if ( ! _bgSearchBarView ) {
        
        _bgSearchBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [DeviceInfo width], 20 )];
        
    }
    
    return _bgSearchBarView;
    
}

@end
