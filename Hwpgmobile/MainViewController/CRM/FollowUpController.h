//
//  FollowUpController.h
//  Test
//
//  Created by 邱健 on 14/11/5.
//  Copyright (c) 2014年 邱健. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface FollowUpController : BaseViewController
#pragma mark 跟进用户list
@property(nonatomic,retain)UITableView *custTabView;
@property(nonatomic,retain)NSArray *custDataList;
@end
