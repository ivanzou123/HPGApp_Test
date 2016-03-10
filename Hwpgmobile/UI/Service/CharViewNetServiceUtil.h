//
//  CharViewNetServiceUtil.h
//  Chart
//
//  Created by hwpl hwpl on 14-10-29.
//  Copyright (c) 2014年 hwpl hwpl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CharViewNetServiceUtil : NSObject
+(id)GetCharListData:(NSString *)user;
+(id)startRecommandGetListInfo:(NSString *)groupId MinNumber:(NSInteger)minNumber maxNumber:(NSInteger)maxNumber;
+(id)PostUploadVoice:(NSString *)fileName;
+(id)downLoadVoice:(NSString *)filePath fileName:(NSString *)fileName ;
+(id)downLoadImg:(NSString *)filePath targetFilePath:(NSString *)fileName;
+(id)asynDownLoadImg:(NSString *)filePath targetFilePath:(NSString *)targetFilePath;
+(id)synDownLoadImg:(NSString *)filePath targetFilePath:(NSString *)targetFilePath;

+(id)getMsipData:(NSString *)user deviceId:(NSString *)deviceId;
+(id)getMenu:(NSString *)user deviceId:(NSString *)deviceId;
+(id)getHeadPhotoByUrl:(NSString *)url;
+(id)getEhrNum:(NSString *)user;


+(id)getMoreMessageInfo:(NSString *)userName GroupSessionId:(NSString *)groupSessionId groupId:(NSString *)groupId row:(NSInteger )row;
@end