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

@interface ArticlesListViewController()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UISearchDisplayDelegate,UIPickerViewDataSource,UIPickerViewDelegate>

@property(nonatomic,strong) IBOutlet UITableView *tableView;
@property(nonatomic,strong) IBOutlet UIActivityIndicatorView *loading;
@property(nonatomic,strong) IBOutlet UILabel *loadingListLabel;

@property(nonatomic,strong) NSArray *articleList;
@property(nonatomic,strong) NSMutableArray *filtered;
@property(nonatomic,strong) NSArray *aux;
@property(nonatomic) BOOL isChangedNoResults;
@property(nonatomic) BOOL isDownloading;
@property(nonatomic,strong) UIRefreshControl *refresh;
@property(nonatomic,strong) NSArray *sortingOptions;

typedef enum SortingOption {
    SortingOptionTitle,
    SortingOptionContent,
    SortingOptionDate,
    SortingOptionWebsite,
    SortingOptionAuthor
} SortingOption;

@property(nonatomic) SortingOption sortingOptionSelected;

@property(nonatomic,strong) UIPickerView *pickerView;
@property(nonatomic,strong) UIView *viewPickerView;

@end

@implementation ArticlesListViewController

#pragma mark - View Lifecycle

-(void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.sortingOptions = @[@"Title",@"Content",@"Date",@"Website",@"Author"];
    
    self.articleList = [[ArticleModel new] allArticlesModel];
    
    if ( self.articleList.count != 0 ) {
        UIBarButtonItem *sortButton = [[UIBarButtonItem alloc] initWithTitle:@"Sort" style:UIBarButtonItemStyleDone target:self action:@selector(showSortPicker:)];
        self.navigationItem.rightBarButtonItem = sortButton;
    }
    
    [self populateArticlesList];
    
    [self setupTableView];
    
    [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setTintColor:[UIColor lightGrayColor]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(listenCheckArticleAsRead:) name:kNotificationNameCheckArticleAsRead object:nil];
    
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

#pragma mark - Notification methods

-(void)listenCheckArticleAsRead:(NSNotification *)notification {
    
    [self.tableView reloadData];
    
}

#pragma mark - IBAction Methods

-(IBAction)refresh:(id)sender {
    
    if ( ! self.isDownloading ) {
        
        self.isDownloading = YES;

        NSArray *list = [[ArticleModel new] allArticlesModel];
        
        if ( list.count > 0 )
            self.articleList = list;
        
        [self.tableView reloadData];
        
        [self populateArticlesList];
        
    }
    
}

-(IBAction)showSortPicker:(id)sender {
    [self showPickerWithAnimation:YES];
}

-(IBAction)onlyDismissPicker:(id)sender {
    [self showPickerWithAnimation:NO];
}

-(IBAction)closePicker:(id)sender {
    
    // Reorder List
    [self reorderList];
    
    // Update data
    [self.tableView reloadData];
    
    // Dismiss pickerView
    [self showPickerWithAnimation:NO];
    
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

#pragma mark - UIPickerViewDataSource methods

// returns the number of 'columns' to display.
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// returns the # of rows in each component..
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.sortingOptions.count;
}

#pragma mark - UIPickerViewDelegate methods

-(NSString *)pickerView:(UIPickerView *)pickerView
            titleForRow:(NSInteger)row
           forComponent:(NSInteger)component {
    
    NSString *title = self.sortingOptions[row];
    
    return title;
    
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    NSString *option = self.sortingOptions[row];
    
    if ( [option isEqualToString:@"Title"] )
        self.sortingOptionSelected = SortingOptionTitle;
    else if ( [option isEqualToString:@"Content"] )
        self.sortingOptionSelected = SortingOptionContent;
    else if ( [option isEqualToString:@"Date"] )
        self.sortingOptionSelected = SortingOptionDate;
    else if ( [option isEqualToString:@"Website"] )
        self.sortingOptionSelected = SortingOptionWebsite;
    else if ( [option isEqualToString:@"Author"] )
        self.sortingOptionSelected = SortingOptionAuthor;

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
    
    NSMutableArray *listTemp = [NSMutableArray new];

    listTemp = [[self.aux filteredArrayUsingPredicate:predicate] copy];
    
    self.filtered = [listTemp mutableCopy];
    
}

#pragma mark - Private methods

-(void)populateArticlesList {
    
    self.tableView.hidden = NO;
    
    if ( self.articleList.count == 0 ) {
        
        [self downloadList];
        
    } else {
        
        [self stopLoading];
        
        [self prepareForFilter];
        [self.tableView reloadData];
        
    }
    
}

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
    
    [self startLoading];
    
    self.loadingListLabel.text = @"Loading...";
    
    [[ArticleDAO new] articleListWithSuccess:^(NSArray *articleList) {
        
        [self stopLoading];
        
        self.articleList = articleList;
        
        if ( articleList != nil )
            if ( articleList.count != 0 ) {
                
                self.navigationItem.rightBarButtonItem = nil;
                
                self.articleList = [articleList mutableCopy];
                [self prepareForFilter];
                [self.tableView reloadData];
                
                return;
                
            }
        
        [self showNoArticles];
        
    } failure:^(BOOL hasNoConnection, NSError *error) {
        
        [self stopLoading];
        
        if ( hasNoConnection ) {
            [self showConnectionError:@"No Connection."];
            return;
        }
        
        if ( error ) {
            [self showConnectionError:@"Connection failed. Please, try again."];
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
    
    [self addRefreshInTableView];
    
}

-(void)addRefreshInTableView {
    
    self.refresh = [UIRefreshControl new];
    [self.refresh addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    
    self.refresh.tintColor = [UIColor lightGrayColor];
    
    [self.tableView addSubview:self.refresh];
    
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

-(void)startLoading {
    [self.loading startAnimating];
    self.loadingListLabel.hidden = NO;
}

-(void)stopLoading {
    self.isDownloading = NO;
    [self.loading stopAnimating];
    self.loadingListLabel.hidden = YES;
    [self.refresh endRefreshing];
}

-(void)showNoArticles {
    
    self.tableView.hidden = YES;
    
    self.loadingListLabel.hidden = NO;
    self.loadingListLabel.text = @"No article found";
    
}

-(void)showConnectionError:(NSString *)msg {
    
    [self stopLoading];
    
    self.tableView.hidden = YES;
    
    self.loadingListLabel.hidden = NO;
    self.loadingListLabel.text = msg;
    
}

-(void)showPicker:(UIPickerView *)pickerView viewOfPickerView:(UIView *)viewOfPickerView show:(BOOL)show {
    
    if ( show ) {
        
        if ( ! [viewOfPickerView isDescendantOfView:self.view] )
            [self.view addSubview:viewOfPickerView];
        
        viewOfPickerView.hidden = NO;
        
        int y = [UIScreen mainScreen].bounds.size.height - viewOfPickerView.frame.size.height;
        
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionLayoutSubviews animations:^{
            
            // Adjusts frame of viewPickerView
            CGRect frame = viewOfPickerView.frame;
            frame.origin.y = y;
            viewOfPickerView.frame = frame;
            
            // Set pickerView to row at textfield indicate
            int row = 0;
            
            // Init pickerView on row of current value of textfield
            [pickerView selectRow:row inComponent:0 animated:NO];
            
            [self.view bringSubviewToFront:viewOfPickerView];
            
        } completion:^(BOOL finished) {
            
            
        }];
        
    } else {
        
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionLayoutSubviews animations:^{
            
            CGRect frame = viewOfPickerView.frame;
            frame.origin.y = [UIScreen mainScreen].bounds.size.height;
            viewOfPickerView.frame = frame;
            
        } completion:^(BOOL finished) {
            
            viewOfPickerView.hidden = YES;
            
        }];
        
    }
    
}

-(void)showPickerWithAnimation:(BOOL)show {
    
    [self showPicker:self.pickerView viewOfPickerView:self.viewPickerView show:show];
    
}

-(void)reorderList {
    
    NSString *key;
    
    if ( self.sortingOptionSelected == SortingOptionTitle )
        key = @"title";
    else if ( self.sortingOptionSelected == SortingOptionContent )
        key = @"content";
    else if ( self.sortingOptionSelected == SortingOptionDate )
        key = @"date";
    else if ( self.sortingOptionSelected == SortingOptionWebsite )
        key = @"website";
    else if ( self.sortingOptionSelected == SortingOptionAuthor )
        key = @"author";
    
    NSSortDescriptor *sort;
    
    if ( [key isEqualToString:@"date"] ) {
        sort = [NSSortDescriptor sortDescriptorWithKey:key ascending:YES comparator:^NSComparisonResult(id obj1, id obj2) {
            return [(NSDate *)obj1 compare:(NSDate *)obj2];
        }];
    } else {
        sort = [NSSortDescriptor sortDescriptorWithKey:key ascending:YES comparator:^NSComparisonResult(id obj1, id obj2) {
            return [(NSString *)obj1 compare:(NSString *)obj2 options:NSNumericSearch];
        }];
    }
    
    NSArray *sortedArray = [self.articleList sortedArrayUsingDescriptors:@[sort]];
    
    self.articleList = sortedArray;
    
}

#pragma mark - Creating components

-(UIPickerView *)pickerView {
    
    if ( ! _pickerView ) {
        
        _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake( 0,
                                                                     44,
                                                                     [UIScreen mainScreen].bounds.size.width,
                                                                     162
                                                                     )];
        
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
        _pickerView.backgroundColor = [UIColor whiteColor];
        
    }
    
    return _pickerView;
    
}

-(UIView *)viewPickerView {
    
    if ( ! _viewPickerView ) {
        
        _viewPickerView = [[UIView alloc] initWithFrame:CGRectMake( 0, self.view.frame.size.height, self.view.frame.size.width, 206 )];
        _viewPickerView.backgroundColor = [UIColor darkGrayColor];
        _viewPickerView.clipsToBounds = YES;
        [_viewPickerView addSubview:self.pickerView];
        
        UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake( 0, 0, self.view.frame.size.width, 44 )];
        toolBar.translucent = YES;
        toolBar.barTintColor = [UIColor colorWithRed:240.0/256.0 green:240.0/256.0 blue:240.0/256.0 alpha:1.0];
        toolBar.backgroundColor = [UIColor colorWithRed:75.0/256.0 green:137.0/256.0 blue:208.0/256.0 alpha:1.0];
        
        UIBarButtonItem *fixedSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        fixedSpace.width = self.view.frame.size.width - 110;
        
        UIBarButtonItem *okButton = [[UIBarButtonItem alloc] initWithTitle:@"Ok"
                                                                     style:UIBarButtonItemStylePlain
                                                                    target:self
                                                                    action:@selector(closePicker:)];
        okButton.tintColor = [UIColor colorWithRed:0.0/256.0 green:122.0/256.0 blue:255.0/256.0 alpha:1.0];
        
        UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel"
                                                                         style:UIBarButtonItemStylePlain
                                                                        target:self
                                                                        action:@selector(onlyDismissPicker:)];
        cancelButton.tintColor = [UIColor colorWithRed:0.0/256.0 green:122.0/256.0 blue:255.0/256.0 alpha:1.0];
        
        [toolBar setItems:@[fixedSpace,cancelButton,okButton]];
        
        [_viewPickerView addSubview:toolBar];
        
    }
    
    return _viewPickerView;
    
}

@end
