//
//  WorkViewController.h
//  HwpgMobile
//
//  Created by hwpl hwpl on 14-12-1.
//  Copyright (c) 2014年 hwpl hwpl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ApproveViewController.h"
#import "CustomRootRefreshTableViewController.h"

@interface custLable : UILabel

@end

@interface CustWorkViewCell:UITableViewCell
@property(nonatomic,retain) UIImageView *custImageView;
@property(nonatomic,retain) UILabel *textLable;
@end

@interface WorkViewController :UITableViewController

@property(nonatomic,retain) NSCache *imageCache;

 -(void)loadData;
@end
