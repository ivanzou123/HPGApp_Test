//
//  MessageModel.m
//  Chat
//
//  Created by ivan on 14-10-30.
//  Copyright (c) 2014年 hwpl hwpl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "XHMessageBubbleFactory.h"

@class XHMessage;

@protocol XHMessageModel <NSObject>

@required
- (NSString *)text;

- (UIImage *)photo;
- (NSString *)thumbnailUrl;
- (NSString *)originPhotoUrl;
-(UIImage *)nativePhoto;
- (NSString *) imageNativePath;
- (UIImage *)videoConverPhoto;
- (NSString *)videoPath;
- (NSString *)videoUrl;

- (NSString *)voicePath;
- (NSString *)voiceUrl;
- (NSString *)voiceDuration;

- (UIImage *)localPositionPhoto;
- (NSString *)geolocations;
- (CLLocation *)location;

- (NSString *)emotionPath;
- (NSString *)subType;
- (UIImage *)avator;
- (NSString *)avatorUrl;
- (NSMutableDictionary *) handleDic;
- (XHBubbleMessageMediaType)messageMediaType;
- (NSMutableDictionary *) messageDic;
- (XHBubbleMessageType)bubbleMessageType;
- (BOOL)isSending;

@optional

-(NSString *)sessionId;
- (NSString *)sender;
-(NSString *)senderStrId;
- (NSDate *)timestamp;

@end

