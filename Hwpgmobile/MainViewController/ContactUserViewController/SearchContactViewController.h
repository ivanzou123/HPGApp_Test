//
//  SearchContactViewController.h
//  HwpgMobile
//
//  Created by hwpl hwpl on 14-11-24.
//  Copyright (c) 2014年 hwpl hwpl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XHBaseSearchTableViewController.h"
@interface SearchContactViewController :XHBaseTableViewController<UISearchDisplayDelegate, UISearchBarDelegate>

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
- (NSString *)getSearchBarText;

/**
 *  获取搜索框的文本
 *
 *  @return 入口类型
 */
@property (nonatomic, retain) NSString *type;
@end
