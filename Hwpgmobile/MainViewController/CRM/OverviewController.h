//
//  OverviewController.h
//  M_CRM
//
//  Created by 邱健 on 14/11/5.
//  Copyright (c) 2014年 邱健. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "CustomRootRefreshTableViewController.h"
#import "CrmRootViewController.h"

@interface OverviewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>
{
    
}
@property(nonatomic,retain)NSArray *dataListHead;
#pragma mark section1的数据
@property(nonatomic,retain)NSArray *dataList;
@property(nonatomic,retain)NSArray *secDateList;
@property(nonatomic,retain)NSArray *thirdDateList;
@property(nonatomic,retain)NSArray *projectDateList;
@property(nonatomic,retain)UITableView *myTableView;
#pragma mark 用户数据
@property(nonatomic,retain)NSArray *userList;
#pragma mark 项目切换按钮
@property (nonatomic,retain) UIButton *selectProjectBtn;
#pragma mark 用户名切换按钮
@property (nonatomic,retain) UIButton *selectUserBtn;
#pragma mark 客户信息统计数据
@property(nonatomic,retain)NSArray *custTotalList;
#pragma mark 客户信息统计数据第一部分
@property(nonatomic,retain)NSArray *fistCustTotalList;
#pragma mark 客户信息统计数据第二部分
@property(nonatomic,retain)NSArray *secondCustTotalList;
#pragma mark 客户信息统计数据第三部分
@property(nonatomic,retain)NSArray *thirdCustTotalList;
@end

