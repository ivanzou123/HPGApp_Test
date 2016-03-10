//
//  AddCustomerController.h
//  Test
//
//  Created by 邱健 on 14/11/5.
//  Copyright (c) 2014年 邱健. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CBTextView.h"
#import "DropDownList.h"
#import "BaseViewController.h"
#import "CustEntity.h"
@interface EditCustomerController :  BaseViewController<UITableViewDataSource,UITableViewDelegate>
{
   NSMutableArray *checkboxes;
}
@property (nonatomic, strong) NSMutableArray *checkboxes;
#pragma mark 用户名
@property (nonatomic,retain) UITextField *TName;
#pragma mark 密码
@property (nonatomic,retain) UITextField *TTel;
#pragma mark 意向单位
@property (nonatomic,retain) UITextField *TPrefer;
#pragma mark 证件号码
@property (nonatomic,retain) UITextField *TIC;

#pragma mark 背景
@property (strong, nonatomic) UITextView *TRemark;
#pragma mark 背景
@property (strong, nonatomic) CBTextView *TFollowRemark;
#pragma mark 来源
@property (strong, nonatomic) DropDownList *ddSource;
#pragma mark 来源
@property (strong, nonatomic) DropDownList *ddType;
#pragma mark 来源
@property (strong, nonatomic) DropDownList *ddLevel;
#pragma mark
@property (strong, nonatomic) DropDownList *ddCity;
#pragma mark 来源
@property (strong, nonatomic) DropDownList *TFollowType;
@property(nonatomic,retain)NSArray *dataList;
@property(nonatomic,retain)UITableView *myTableView;
@property(nonatomic,retain)CustEntity *custEntity;

@end
