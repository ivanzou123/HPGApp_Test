//
//  UserInfoHelper.h
//  Chat
//
//  Created by hwpl hwpl on 14-11-11.
//  Copyright (c) 2014年 hwpl hwpl. All rights reserved.
//
typedef enum _MessageCountType {
    addCounter = 0,
    deleteCounter = 1
} MessageCountType;

#import <Foundation/Foundation.h>


@interface CommUtilHelper : NSObject
+(CommUtilHelper *)sharedInstance;
+(UIColor *) getDefaultBackgroupColor;
+(BOOL) isSystemUser:(id) user;
+(NSString *) getDeviceId;

-(NSDictionary *)GetNativeUserInfo;

-(void)showAlertView:(NSString *)titile Message:(NSString *)message delegate:(UIViewController *)controller;
-(void)setBadageValue;
/***
 *获取唯一uuid
 */
-(NSString *)createUUID;
-(NSString *)createDiffUUID;
- (NSString *)dataVoicePath:(NSString *)file;

- (NSString *)dataImagePath:(NSString *)file;

- (void)setExtraCellLineHidden: (UITableView *)tableView type:(NSString *)type;

-(NSString *)getNickName;
-(NSString *)getUser;
-(NSString *)getCommonName;
-(NSString *)getLastSyncTime:(NSString *)key;
-(void)setValueDefaults:(NSString *) value key:(NSString *) key;
-(id)jsonToObject:(NSString *)jsonStr;
-(UIImage *)base64ToImage:(NSString *)base64Str;
-(NSString *)saveImageToPath:(NSString *)base64str;

-(UIImage *)getImageByImageName:(NSString *)imgaeName Size:(CGSize)size;

-(CGSize) scaleToSize:(CGSize) sourceSize MaxWidth:(float) maxWidth MaxHeight:(float) maxHeight;

////设置每个组的未读消息数量
//-(void) newMessageCounterByAll:(NSMutableArray *) newMessageAry;
////设置每个组的未读消息数量
//-(void) newMessageCounterByGroupId:(NSString *) groupId MessageCounter:(NSString *) messageCounter;
////取得每个组的未读消息数量
//-(NSString *) getNewMessageCounterByGroupId:(NSString *) groupId;

////设置每个组的未读消息数量
-(void)setMessageCountByGroupId:(NSString *)groupId withCount:(NSInteger)_count withType:(MessageCountType)type;
////取得每个组的未读消息数量
-(NSInteger)getMessageCountByGroupId:(NSString *)groupId;
//获取所有messageCount
-(NSInteger)getAllMessageCount;
-(NSInteger)getWorkBageNumber;

-(NSString *)changeNullToStr:(NSString *)str;

//检查是否有最新版本
-(BOOL)checkIsUpdate:(NSInteger )serverVersionNo;
//设置错误消息
-(void)setErrorMsg:(NSString *)errMsg;
//获取错误消息
-(NSMutableArray *)getErrorMsg;
//保存远程通知自定义参数
-(void)setRemoteNotic:(NSDictionary *) userInfo;
//清除远程通知自定义参数
-(void)clearRemoteNotic;
//根据用户点击的通知显示界面
-(void)pushVeiwByRemoteNotic:(UINavigationController *) nav;
//检查用户名 是否有改动 
-(BOOL)checkNeedLgoin;

-(NSString *)getFlatSaleMessage:(NSString *)msg;
-(NSMutableDictionary *)getFSJsonValue:(NSString *)msg;
-(void)startSyncData;

@end
