//
//  XHBaseTableViewController.h
//  MessageDisplayExample
//
//  Created by hwpl hwpl on 14-12-2.
//  Copyright (c) 2014年 hwpl hwpl. All rights reserved.
//

#import "XHBaseViewController.h"

@interface XHBaseTableViewController : XHBaseViewController <UITableViewDelegate, UITableViewDataSource>

/**
 *  显示大量数据的控件
 */
@property (nonatomic, strong) UITableView *tableView;
/**
 *  初始化init的时候设置tableView的样式才有效
 */
@property (nonatomic, assign) UITableViewStyle tableViewStyle;

/**
 *  大量数据的数据源
 */
@property (nonatomic, strong) NSMutableArray *dataSource;

/**
 *  去除iOS7新的功能api，tableView的分割线变成iOS6正常的样式
 */
- (void)configuraTableViewNormalSeparatorInset;

/**
 *  配置tableView右侧的index title 背景颜色，因为在iOS7有白色底色，iOS6没有
 *
 *  @param tableView 目标tableView
 */
- (void)configuraSectionIndexBackgroundColorWithTableView:(UITableView *)tableView;

/**
 *  加载本地或者网络数据源
 */
- (void)loadDataSource;

@end