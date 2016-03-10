//
//  OverviewController.h
//  M_CRM
//
//  Created by 邱健 on 14/11/5.
//  Copyright (c) 2014年 邱健. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"


@interface UserCenterController : BaseViewController<UITableViewDataSource,UITableViewDelegate>
{
  
}
#pragma mark section标签数据
@property(nonatomic,retain)NSArray *sectionList;
#pragma mark section1的数据
@property(nonatomic,retain)NSArray *firstDataList;
@property(nonatomic,retain)NSArray *secDateList;
@property(nonatomic,retain)UITableView *myTableView;


@end

