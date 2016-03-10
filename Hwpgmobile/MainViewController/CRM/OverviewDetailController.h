//
//  OverviewDetailControlle.h
//  Test
//
//  Created by 邱健 on 14/11/5.
//  Copyright (c) 2014年 邱健. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "CustEntity.h"

@interface OverviewDetailController : BaseViewController
#pragma mark 用户list
@property(nonatomic,retain) UITableView *custTabView;
@property(nonatomic,retain) NSArray *custDataList;
@property (retain,nonatomic) CustEntity *custEntity;
#pragma mark 返回按钮
@property (nonatomic,retain) UIButton *returnBtn;
@end
