//
//  XHBaseSearchTableViewController.h
//  MessageDisplayExample
//
//  Created by ivan on 14-10-28.
//  Copyright (c) 2014年 hwpl hwpl. All rights reserved./

#import "XHBaseTableViewController.h"

@interface XHBaseSearchTableViewController : XHBaseTableViewController

/**
 *  搜索结果数据源
 */
@property (nonatomic, strong) NSMutableArray *filteredDataSource;

/**
 *  TableView右边的IndexTitles数据源
 */
@property (nonatomic, strong) NSArray *sectionIndexTitles;

/**
 *  判断TableView是否为搜索控制器的TableView
 *
 *  @param tableView 被判断的目标TableView对象
 *
 *  @return 返回是否为预想结果
 */
- (BOOL)enableForSearchTableView:(UITableView *)tableView;

/**
 *  获取搜索框的文本
 *
 *  @return 返回文本对象
 */
@property (nonatomic, assign)BOOL isShowingSearchBar;
- (NSString *)getSearchBarText;

@end
