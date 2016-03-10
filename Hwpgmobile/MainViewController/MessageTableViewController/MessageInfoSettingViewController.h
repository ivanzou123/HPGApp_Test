//
//  MessageInfoSettingViewController.h
//  HwpgMobile
//
//  Created by hwpl hwpl on 14-11-26.
//  Copyright (c) 2014年 hwpl hwpl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIGridViewDelegate.h"
#import "UIGridView.h"
@interface MessageInfoSettingViewController : UIViewController<UIGridViewDelegate,UIActionSheetDelegate>


@property (nonatomic, retain)  UIGridView *gridView;
@property(nonatomic,retain) NSString *groupId;
@property(nonatomic,retain) NSString * chatGroupName;

-(void)addContactUserReloadData:(NSMutableArray *)arr;
@end
