//
//  eChatDAO.h
//  HwpgMobile
//
//  Created by hwpl hwpl on 14-11-13.
//  Copyright (c) 2014年 hwpl hwpl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NativeCacheHandle.h"
@interface eChatDAO :NativeCacheHandle
+(eChatDAO *) sharedChatDao;
//创建默认table
-(BOOL) creteTable;
//初始化数据
-(BOOL)initChatGroupList:(NSMutableArray *)listArr;
-(NSString *)getLastSyncTimeByTable:(NSString *)table;
-(NSMutableArray *)iniChatSessionList:(NSMutableArray *)listArr;
-(BOOL)initChatUserList:(NSMutableArray *)listArr;
-(BOOL)initChatPersonList:(NSMutableArray *)listArr;
-(BOOL)initADUser:(NSMutableArray *)listArr;
//增删改查数据

-(NSMutableArray *) getChatGroupList;
-(NSMutableArray *) getCHatGroupSessionByminPage:(NSInteger) minCount toMax:(NSInteger) maxCout GroupId:(NSString *)groupId;
-(NSMutableArray *) getCHatGroupSessionbySessionId:(NSString *)sessionId;
//插入本地数据

-(NSInteger) insertNativeMsg:(NSMutableArray *)sessionArr;
-(BOOL)updateGroupSession:(NSDictionary *)dic;
-(BOOL)insertMsgFromServer:(NSMutableArray *)sessionArr;
-(BOOL)insertHisMsgFromServer:(NSMutableArray *)arr;
-(NSMutableArray *)getNatvieContact:(NSString *)user;

-(BOOL)insertChatUser:(NSMutableArray *)userArr;
-(BOOL)deleteChatUser:(NSString *)user;
//添加ad user
-(BOOL)insertChatAdUser:(NSMutableArray *)userArr;
// 获取组内所有成员
-(NSMutableArray *)getAllGroupUserByGroupId:(NSString *)groupId CurrUser:(NSString *)curruser;
//删除组成员
-(BOOL)deleteChatUserByGroupId:(NSString *)groupId User:(NSString *)user;
-(BOOL)deleteChatUserByGroupId:(NSString *)groupId;
//添加组成员本地成员
-(NSMutableArray *)getNotInGroupUserByGroupId:(NSString *)groupId User:(NSString *)user;
//插入group Pserson
-(BOOL)insertGroupPerson:(NSMutableArray *)userArr;

//插入组
-(BOOL)insertChatGroup:(NSMutableArray *)userArr;
//删除组
-(BOOL)deleteChatGroup:(NSString *)groupId;
-(BOOL)deleteGroupSession:(NSString *)groupId;

//检查是否 存在单聊天并返回chatGroupId
-(NSString *)isExistOneByOneChatByUser:(NSString *)user;
-(NSMutableArray *)getUserInfo:(NSString *)user;


//删除聊天列表中的信息
-(BOOL)updateChatGroup:(NSString *)msg From:(NSString *)from ResysDttm:(NSString *)reSysDttm GroupId:(NSString *)groupID;
-(void)updateChatGroupFlag:(NSString *)chatGroupId;

-(void)updateChatGroupName:(NSString *)name GroupId:(NSString *)groupId;
//是否好友
-(BOOL)isFriend:(NSString *)user;
//更新用户头像文件路径

//获取单人头像
-(NSString *)getSingleContactHead:(NSString *)groupid myUser:(NSString *)myUser;

-(BOOL)updateHeadPhoto:(NSString *)user ImagePath:(NSString *) imagePath;
//取得某一个组的信息
-(NSMutableArray *)getChatGroup:(NSString *) groupId;
//更新群头像文件路径
-(BOOL)updateGroupHeadPhoto:(NSString *)groupId ImagePath:(NSString *) imagePath;
-(BOOL)updateChatAdUserHeadnPhotoDate:(NSString *)date from :(NSString *)from;
-(BOOL)updateChatGroupHeadDate:(NSString *)date groupId:(NSString *)groupId;

-(NSString *)getHeadPhotoNameByUser:(NSString *)user;
-(NSInteger *)getTotalNumberByGroup:(NSString *) groupId;

//更新群聊状态
-(BOOL)updateGroupStatus:(NSString *)chatGroupId;
//更改消息的本地时间
-(BOOL)updateTimeBySessionId:(NSString *)sessionId;

-(NSMutableArray *)getAddChatGroupMember:(NSString *)user;

-(int)getMaxSessionId:(NSString *)groupId;

-(NSString *)getCreatePersonName:(NSString *)groupid;
//获取转发 组
-(NSMutableArray *)getTransChatGroupList;
@end