//
//  SearchContactViewController.m
//  HwpgMobile
//
//  Created by hwpl hwpl on 14-11-24.
//  Copyright (c) 2014年 hwpl hwpl. All rights reserved.
//

#import "SearchContactViewController.h"
#import "CommUtilHelper.h"
#import "CustomLoadingView.h"
#import "ContactNetServiceUtil.h"
#import "ResponseModel.h"
#import "SearchContactResultViewController.h"
@interface SearchContactViewController ()
{
    NSMutableArray *resultArr;
}
@property (nonatomic,retain)UIView *loadingView;
/**
 *  搜索框
 */
@property (nonatomic, strong) UISearchBar *aSearchBar;

/**
 *  搜索框绑定的控制器
 */
@property (nonatomic) UISearchDisplayController *searchController;

/**
 *  查找搜索框目前文本是否为搜索目标文本
 *
 *  @param searchText 搜索框的文本
 *  @param scope      搜索范围
 */
- (void)filterContentForSearchText:(NSString *)searchText scope:(NSString *)scope;

@end


@implementation SearchContactViewController
@synthesize loadingView;
@synthesize type;
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Propertys

- (NSMutableArray *)filteredDataSource {
    if (!_filteredDataSource) {
        _filteredDataSource = [[NSMutableArray alloc] initWithCapacity:1];
    }
    return _filteredDataSource;
}

- (UISearchBar *)aSearchBar {
    if (!_aSearchBar) {
        _aSearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 44)];
        _aSearchBar.delegate = self;
        _aSearchBar.placeholder=@"Search";
        _searchController = [[UISearchDisplayController alloc] initWithSearchBar:_aSearchBar contentsController:self];
        _searchController.delegate = self;
        _searchController.searchResultsDelegate = self;
        _searchController.searchResultsDataSource = self;
    }
    return _aSearchBar;
}

- (NSString *)getSearchBarText {
    return self.searchDisplayController.searchBar.text.lowercaseString;
}

#pragma mark - Life Cycle

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self loadDataSource];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    
    self.tableView.tableHeaderView = self.aSearchBar;
    [[CommUtilHelper sharedInstance] setExtraCellLineHidden:self.tableView type:@"1"];
    [[CommUtilHelper sharedInstance] setExtraCellLineHidden:self.searchDisplayController.searchResultsTableView type:@"1"];
    if (type && [@"聊天" isEqualToString:type]){
        UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(dismissViewController)];
        self.navigationItem.leftBarButtonItem = barButton;
    }
    self.navigationItem.title=@"Add Contacts";
}
-(void)dismissViewController
{
    
    [UIView  beginAnimations:nil context:NULL];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.6];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.navigationController.view cache:NO];
    [UIView commitAnimations];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelay:0.5];
    [self.navigationController popViewControllerAnimated:NO];
    [UIView commitAnimations];
}

#pragma mark Content Filtering


- (void)filterContentForSearchText:(NSString *)searchText scope:(NSString *)scope {
    [self.filteredDataSource removeAllObjects];
    if (searchText && ![searchText isEqualToString:@""]) {
         [self.filteredDataSource addObject:searchText];
        [self.tableView reloadData];
    }
   
}

#pragma mark - SearchTableView Helper Method

- (BOOL)enableForSearchTableView:(UITableView *)tableView {
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return YES;
    }
    return NO;
}

#pragma mark - UISearchDisplayController Delegate Methods

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    for(UIView *subview in _searchController.searchResultsTableView.subviews) {
        
        if([subview isKindOfClass:[UILabel class]]) {
            
            [(UILabel*)subview setText:@""];
            
        }
    }

    [self filterContentForSearchText:searchString scope:
     [self.searchDisplayController.searchBar scopeButtonTitles][[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    
    return YES;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption {
    [self filterContentForSearchText:[self.searchDisplayController.searchBar text] scope:
     [self.searchDisplayController.searchBar scopeButtonTitles][searchOption]];
    
    return YES;
}
-(void)searchBarClickedAction:(UISearchBar *)searchBar
{
    NSString *text = searchBar.text;
    [self searchNetContactAction:text];
}

-(void)searchNetContactAction:(NSString *)text
{
    NSDictionary *user = [[CommUtilHelper alloc] GetNativeUserInfo];
   // NSString *text = searchBar.text;
    ResponseModel *rs = [[ContactNetServiceUtil sharedInstance] getSearchContact:text Min:1 Max:20 From:[user objectForKey:@"user"]];
    resultArr = rs.resultInfo;
    dispatch_async(dispatch_get_main_queue(), ^(void){
        if (rs.error !=nil) {
            [loadingView removeFromSuperview];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Prompt" message:@"Network Error" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alertView show];
            return;
        }
        if (resultArr ==nil) {
            [loadingView removeFromSuperview];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"User is not exist" message:@"Please Check User" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alertView show];
            return;

            
        }
        if (resultArr && [resultArr count] == 0) {
            [loadingView removeFromSuperview];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"User is not exist" message:@"Please Check User" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alertView show];
            return;
        }
        [loadingView removeFromSuperview];
        SearchContactResultViewController *resultController = [[SearchContactResultViewController alloc] init];
        resultController.resultArr = resultArr;
        resultController.searchText=text;
        [self.navigationController pushViewController:resultController animated:YES];
        
    });
}
- (void)loadDataSource {
   
   // self.dataSource = [NSMutableArray arrayWithObject:[NSDictionary dictionaryWithObjectsAndKeys:@"11",@"SAM_ACCOUNT_NAME", nil]];
}
#pragma mark - SearchBar Delegate

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    
}
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    loadingView = [[[CustomLoadingView alloc] init] getLoaidngViewByText:@"Searching..." Frame:self.view.frame];
    [self.view addSubview:loadingView];
    
    [NSThread  detachNewThreadSelector:@selector(searchNetContactAction:) toTarget:self withObject:searchBar.text];
}
#pragma mark - UITableView DataSource



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ([self enableForSearchTableView:tableView]) {
        return 1;
    }
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([self enableForSearchTableView:tableView]) {
        return self.filteredDataSource.count;
    }
    return [self.dataSource count];
}


#pragma mark - UITableView DataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"contactTableViewCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        [cell.imageView setFrame:CGRectMake(0, 0, 40, 40)];
        [cell.imageView.layer setCornerRadius:CGRectGetHeight([cell.imageView bounds]) / 2];
        cell.imageView.layer.masksToBounds = YES;
        cell.imageView.layer.borderColor = [[UIColor whiteColor] CGColor];
        cell.imageView.backgroundColor = [UIColor whiteColor];
        //cell.imageView.layer.shadowColor = [UIColor grayColor].CGColor;
        //cell.imageView.layer.shadowOffset = CGSizeMake(4, 4);
        //cell.imageView.layer.shadowOpacity = 0.5;
        //cell.imageView.layer.shadowRadius = 2.0;
        //cell.imageView.layer.borderWidth = 2.0f;
    }
    NSInteger row = indexPath.row;
    
    // 判断是否是搜索tableView
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        cell.imageView.image = [UIImage imageNamed:@"WeChat.png"];
        cell.textLabel.text  =[@"Search:" stringByAppendingString:[self.filteredDataSource objectAtIndex:row]];
        [cell.textLabel setTextColor:[UIColor blueColor]];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    loadingView = [[[CustomLoadingView alloc] init] getLoaidngViewByText:@"Searching..." Frame:self.view.frame];
    [self.view addSubview:loadingView];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *text = cell.textLabel.text;
    NSString *searchText = [text substringFromIndex:7];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [NSThread detachNewThreadSelector:@selector(searchNetContactAction:) toTarget:self withObject:searchText];
}


#pragma mark - UITableView Delegate

//section 头部,为了IOS6的美化
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if ([self enableForSearchTableView:tableView]) {
        return nil;
    }
    BOOL showSection = [[self.dataSource objectAtIndex:section] count] != 0;
    //only show the section title if there are rows in the sections
    
    UIView *customHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 22.0f)];
    customHeaderView.backgroundColor = [UIColor colorWithRed:0.926 green:0.920 blue:0.956 alpha:1.000];
    
    UILabel *headerLabel = [[UILabel alloc]initWithFrame:CGRectMake(15.0f, 0, CGRectGetWidth(customHeaderView.bounds) - 15.0f, 22.0f)];
    headerLabel.text = (showSection) ? [[UILocalizedIndexedCollation.currentCollation sectionTitles] objectAtIndex:section] : nil;
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.font = [UIFont boldSystemFontOfSize:14.0f];
    headerLabel.textColor = [UIColor darkGrayColor];
    
    [customHeaderView addSubview:headerLabel];
    return customHeaderView;
}


@end
