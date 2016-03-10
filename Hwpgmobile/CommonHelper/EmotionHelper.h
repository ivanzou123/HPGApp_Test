//
//  EmotionHelper.h
//  Chat
//
//  Created by hwpl hwpl on 14-11-5.
//  Copyright (c) 2014年 hwpl hwpl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EmotionHelper : NSObject

-(NSString *)emotionToUnicode:(NSString *)Emotioncode;
+(NSString *)codeToEmotion:(NSString *)code;
+(NSString *)disposalTextAndFace:(NSString *)text;
+(NSArray *)getEmojis;
@end
