//
//  UserEntity.h
//  M_CRM
//
//  Created by 邱健 on 14/11/25.
//  Copyright (c) 2014年 邱健. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CustEntity : NSObject
{
    NSString *custId;
    NSString *custName;
    NSString *custPhone;
    NSString *sex;
    int age;
    NSString *OverViewType;
}
@property(nonatomic,retain) NSString *custId;//客户id
@property(nonatomic,retain) NSString *custName;//客户姓名
@property(nonatomic,retain) NSString *custPhone;//客户电话
@property(nonatomic,retain) NSString *sex;//客户性别
@property(assign) int age;//年龄
@property(nonatomic,retain) NSString *OverViewText;//总览页面中选中的类型描述
@property(nonatomic,retain) NSString *OverViewType;//总览页面中选中的类型

@end
