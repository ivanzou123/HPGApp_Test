//
//  SearchContactResultViewController.h
//  HwpgMobile
//
//  Created by hwpl hwpl on 14-11-25.
//  Copyright (c) 2014年 hwpl hwpl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CustomRootRefreshTableViewController.h"
@interface SearchContactResultViewController : CustomRootRefreshTableViewController;
@property(nonatomic,retain) NSMutableArray *resultArr;
@property(nonatomic,retain) UIView *loadingView;
@property(nonatomic,retain) NSString *searchText;
@property(nonatomic,assign) NSInteger pageIndex;
@end
