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

@end

@implementation ArticlesListViewController

#pragma mark - View Lifecycle

-(void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self setupTableView];
    
    [self downloadList];
    
    [self prepareForFilter];
    
    [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setTintColor:[UIColor lightGrayColor]];
    
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
    
    NSArray *list = [self rightListInTableView:tableView];
    
    return list.count;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSArray *list = [self rightListInTableView:tableView];
    
    ArticleModel *articleModel = list[indexPath.row];
    
    return [[ArticleCell new] articleCellAtIndexPath:indexPath tableView:tableView article:articleModel];
    
}

#pragma mark - UITableViewDelegate methods

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 110;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSArray *list = [self rightListInTableView:tableView];
    
    ArticleModel *article = list[indexPath.row];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:kStoryboardMain bundle:nil];
    
    ArticleDetailViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:kNibArticleDetailViewController];
    viewController.article = article;
    
    [self.navigationController pushViewController:viewController animated:YES];

}

#pragma mark - UISearchDisplayDelegate Methods

-(void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller {
    
    [controller.searchBar setShowsCancelButton:YES animated:NO];
    
    for ( UIView *subview in [controller.searchBar subviews] ) {
        
        if ([subview isKindOfClass:[UIButton class]]) {
            
            [(UIButton *)subview setTitle:@"Cancel" forState:UIControlStateNormal];
            
        } else if ( [subview isKindOfClass:[UIView class]] ) {
            
            for (UIView *otherSubview in subview.subviews )
                if ( [otherSubview isKindOfClass:[UIButton class]] )
                    [(UIButton *)otherSubview setTitle:@"Cancel" forState:UIControlStateNormal];
            
        }
        
    }
    
}

-(void)searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller {

}

-(void)searchDisplayController:(UISearchDisplayController *)controller didLoadSearchResultsTableView:(UITableView *)tableView {
    if ( ! self.isChangedNoResults )
        if ( [self.filtered count] == 0 )
            [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(translateNoResultsText:) userInfo:nil repeats:YES];
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {

    // Tells the table data source to reload when text changes
    NSUInteger index = [self.searchDisplayController.searchBar selectedScopeButtonIndex];
    
    [self filterContentForSearchText:searchString scope:[self.searchDisplayController.searchBar scopeButtonTitles][index]];
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
    
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption {

    // Tells the table data source to reload when scope bar selection changes
    [self filterContentForSearchText:self.searchDisplayController.searchBar.text
                               scope:[self.searchDisplayController.searchBar scopeButtonTitles][searchOption]];
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
    
}

#pragma mark - Content Filtering

-(void)filterContentForSearchText:(NSString *)searchText scope:(NSString *)scope {
    
    // Update the filtered array based on the search text and scope.
    // Remove all objects from the filtered search array
    [self.filtered removeAllObjects];
    
    // Filter the array using NSPredicate
    NSPredicate *predicate;
    
    if ( [scope isEqualToString:@"Title"] ) {
        predicate = [NSPredicate predicateWithFormat:@"SELF.title contains[c] %@",searchText];
    } else if ( [scope isEqualToString:@"Content"] ) {
        predicate = [NSPredicate predicateWithFormat:@"SELF.content contains[c] %@",searchText];
    } else if ( [scope isEqualToString:@"Date"] ) {
        NSDate *searchDate = [DateHelper dateFromString:searchText];
        predicate = [NSPredicate predicateWithFormat:@"SELF.date == %@", searchDate];
    } else if ( [scope isEqualToString:@"Website"] ) {
        predicate = [NSPredicate predicateWithFormat:@"SELF.website contains[c] %@",searchText];
    } else if ( [scope isEqualToString:@"Author"] ) {
        predicate = [NSPredicate predicateWithFormat:@"SELF.author contains[c] %@",searchText];
    }
    
    NSMutableArray *listingsTemp = [NSMutableArray new];

    listingsTemp = [[self.aux filteredArrayUsingPredicate:predicate] copy];
    
    self.filtered = [listingsTemp mutableCopy];
    
}

#pragma mark - Private methods

-(NSArray *)rightListInTableView:(UITableView *)tableView {
    
    NSArray *list;
    
    if ( tableView == self.searchDisplayController.searchResultsTableView )
        list = self.filtered;
    else
        list = self.articleList;
    
    return list;
    
}

-(void)translateNoResultsText:(NSTimer *)timer {
    
    if ( self.isChangedNoResults ) {
        
        [timer invalidate];
        
    } else {
        
        for ( UIView *subview in [self.searchDisplayController.searchResultsTableView subviews] ) {
            
            if ( [subview isKindOfClass:[UILabel class]] ) {
                
                UILabel *targetLabel = (UILabel *)subview;
                
                if ( [targetLabel.text isEqualToString:@"No Results"] ) {
                    
                    [targetLabel setText:@"No Results"];
                    self.isChangedNoResults = YES;
                    [timer invalidate];
                    
                }
                
            }
            
        }
        
    }
    
}

-(void)downloadList {
    
    [[ArticleDAO new] articleListWithSuccess:^(NSArray *articleList) {
        
        self.articleList = articleList;
        
        [self prepareForFilter];
        
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
    
    [self.searchDisplayController.searchResultsTableView cleanTableFooter];
    [self.searchDisplayController.searchResultsTableView removeSeparator];
    [self.searchDisplayController.searchResultsTableView registerNibForCellReuseIdentifier:kNibNameArticleCell];
    
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

@end
