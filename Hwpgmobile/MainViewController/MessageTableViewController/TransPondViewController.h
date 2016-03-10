//
//  TransPondViewController.h
//  HwpgMobile
//
//  Created by hwpl hwpl on 14-12-6.
//  Copyright (c) 2014年 hwpl hwpl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XHMessageModel.h"
@interface TransPondViewController : UITableViewController<UIAlertViewDelegate>
@property(nonatomic,retain) id<XHMessageModel> message;
@property(nonatomic,retain) NSString *groupId;
@end
