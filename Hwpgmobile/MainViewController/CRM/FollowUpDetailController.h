//
//  FollowUpDetailController.h
//  M_CRM
//
//  Created by 邱健 on 14/11/22.
//  Copyright (c) 2014年 邱健. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "CBTextView.h"
#import "CustEntity.h"
#import <CoreTelephony/CTCallCenter.h>
#import <CoreTelephony/CTCall.h>

@interface FollowUpDetailController : BaseViewController<UITableViewDataSource,UITableViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource>
{
    UIPickerView *pickerView;
    NSArray *pickerData;
    UIActionSheet* pickerSheet;
    bool isPickerShow;
    UILabel *ddlSorce;
    
}

@property (nonatomic,retain) UITableView *followUpDetailView;
#pragma mark 返回按钮
@property (nonatomic,retain) UIButton *returnBtn;
@property(nonatomic,retain)NSArray *followUpDetailDataList;
#pragma mark 跟进输入框
@property (strong, nonatomic) CBTextView *TFollowRemark;
#pragma mark 提交按钮
@property (strong, nonatomic) UIButton *submitBtn;
@property (retain,nonatomic) CustEntity *custEntity;

@property (retain,nonatomic) CTCallCenter *callCenter;
@end
