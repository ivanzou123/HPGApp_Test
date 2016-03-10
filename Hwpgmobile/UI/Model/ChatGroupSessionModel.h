//
//  ChatGroupSessionModel.h
//  HwpgMobile
//
//  Created by hwpl hwpl on 14-11-21.
//  Copyright (c) 2014年 hwpl hwpl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChatGroupSessionModel : NSObject
@property(nonatomic,assign) NSInteger autoId;
@property(nonatomic,retain) NSString  *group_sessionId;

@property(nonatomic,retain) NSString  *chatGroupId;

@property(nonatomic,retain) NSString  *UserPrincalName;

@property(nonatomic,retain) NSString  *createDate;

@property(nonatomic,assign) NSInteger  delFlag;

@property(nonatomic,retain) NSString  *FilePath;

@property(nonatomic,retain) NSString  *ChatSamllPic;

@property(nonatomic,retain) NSString  *sessioId;

@property(nonatomic,retain) NSString  *lastSyncTime;


@end
