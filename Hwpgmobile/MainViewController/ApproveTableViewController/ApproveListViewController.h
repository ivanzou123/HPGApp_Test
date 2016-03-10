//
//  ApproveListViewController.h
//  Chat
//
//  Created by hwpl hwpl on 14-11-6.
//  Copyright (c) 2014年 hwpl hwpl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "XHRefreshControl.h"
@interface ApproveListViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
+(ApproveListViewController *)sharedInstance;
@property(nonatomic,retain) UITableView *approveTableView;
@property(nonatomic,strong) NSMutableArray *tempArr;
@property(nonatomic,retain) NSString *refreshAprId;
@property(nonatomic,retain) NSString *sysCode;
@end
