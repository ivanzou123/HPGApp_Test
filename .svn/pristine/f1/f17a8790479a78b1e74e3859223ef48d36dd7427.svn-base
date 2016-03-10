//
//  UtilDAO.h
//  MFS
//
//  Created by hwpl hwpl on 14-9-4.
//  Copyright (c) 2014年 hwpl hwpl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoginNetServiceUtil : NSObject
+(id)startRecommandGetUser:(NSString *)userCode password:(NSString *)password;
+(id)regDevice:(NSString *) userPrincipalName;
+(id)GetSyncInfo:(NSString *)user SyncTime:(NSString *)snctTime methodName:(NSString *)method;
+(LoginNetServiceUtil *)sharedInstance;
+(id)clearMessage:(NSString *)user deviceId:(NSString *)deviceId successIds:(NSString *)successids;
+(id)LoginChat:(NSString *)user Password:(NSString *)password;
+(id)GetVersion;
-(id)jsonToDicByUtf8:(NSString *)str;
@end
