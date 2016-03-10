//
//  MessageUtilHelper.h
//  HwpgMobile
//
//  Created by hwpl hwpl on 14-12-4.
//  Copyright (c) 2014年 hwpl hwpl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SocketIO.h"

@interface MessageUtilHelper : NSObject
//消息业务本地插入处理
+(MessageUtilHelper *)sharedInstance;
-(NSMutableArray *)getMessageUUID;
-(void)setMessageUUID:(NSString *)UUID;
-(BOOL)MessageHandle:(SocketIOPacket *)packet DicData:(NSMutableDictionary *) dictReceivedMsg  GroupId:(NSString *)groupId delegate:(UIViewController *)controller isCalculteCount:(BOOL)isCalculteCount ;
//未发送消息 数组
-(void)setUnSendMessageID:(NSString *)sessionId;
-(NSMutableArray *)getUnSendMessage;
-(void)sendMessageFun:(NSMutableArray *)messageUUIDArr SendDic:(NSDictionary *)dic UUID:(NSString *)uuid Suceess:(BOOL)success;
@end
