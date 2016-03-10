//
//  XHPullRefreshTableViewController.h
//  MessageDisplayExample
//
//  Created by hwpl hwpl on 14-12-2.
//  Copyright (c) 2014年 hwpl hwpl. All rights reserved.
//

#import "XHBaseTableViewController.h"

@interface XHPullRefreshTableViewController : XHBaseTableViewController

@property (nonatomic, assign) BOOL isDataLoading;

@property (nonatomic, assign) NSInteger requestCurrentPage;

- (void)startPullDownRefreshing;

- (void)endPullDownRefreshing;

- (void)endLoadMoreRefreshing;

@end
