//
//  ContactNetServiceUtil.h
//  HwpgMobile
//
//  Created by hwpl hwpl on 14-11-24.
//  Copyright (c) 2014年 hwpl hwpl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ContactNetServiceUtil : NSObject
+(ContactNetServiceUtil *)sharedInstance;
//获取全球通讯录
-(id)getSearchContact:(NSString *)searchText Min:(int) min Max:(int) max From:(NSString *) from;
//获取用户信息
-(id)getOtherUserContactDeatail:(NSString *) otherUser From:(NSString *) from;
//添加好友到通讯录
-(id)addFrineds:(NSString *) otherUser From:(NSString *) from;
//删除通讯录
-(id)deleteFrineds:(NSString *) otherUser From:(NSString *) from;
//删除组成员
-(id)deleteMember:(NSString *) otherUser From:(NSString *) from GroupId:(NSString *)groupId;

//添加组成员
-(id)addMember:(NSString *) contactUser From:(NSString *) from GroupId:(NSString *)groupId NickUser:(NSString *)nickUser;

-(id)saveGroupTitleFun:(NSString *)groupId Name: (NSString *)groupName User:(NSString *)user;
//检测是否群聊
-(id)checkIsSingleChat:(NSString *)groupId;
//获取全球通讯，并且登陆过的 是好友的
-(id)getWCForGroupByGroupId:(NSString *)groupId From:(NSString *)from Val:(NSString *)val min:(NSInteger)min max:(NSInteger)max;

-(id)inviteUserFrom:(NSString *)fromUser ToUser:(NSString *)toUser;
@end
