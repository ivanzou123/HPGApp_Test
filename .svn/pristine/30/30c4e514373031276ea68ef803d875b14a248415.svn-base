//
//  EmotionHelper.m
//  Chat
//
//  Created by hwpl hwpl on 14-11-5.
//  Copyright (c) 2014年 hwpl hwpl. All rights reserved.
//

#import "EmotionHelper.h"
#import "NSString+Emoji.h"
@implementation EmotionHelper

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */
-(NSString *)emotionToUnicode:(NSString *)Emotioncode
{
    
    return nil;
}

+(NSString *)codeToEmotion:(NSString *)code
{ 
    NSString *tempStr = @"";
    code = [code stringByReplacingOccurrencesOfString:@"\\" withString:@""];
    code = [code stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    NSMutableArray *arr = [[NSMutableArray alloc] initWithArray: [code componentsSeparatedByString:@"_"]];
    if ([arr count]>1) {
        tempStr =  [tempStr stringByAppendingString:arr[1]];
    }else
    {
        tempStr = code;
    }
    
    
    NSString *reValue = [tempStr stringByReplacingEmojiStringCodesWithUnicode];
    
    return reValue;
}

+(NSString *)disposalTextAndFace:(NSString *)text
{
    NSString *reValue =@"";
    //处理android发出来的文字的换行问题
    NSString *temp = [text stringByReplacingOccurrencesOfString:@"<div><br></div>" withString:@"\n"];
    temp = [temp stringByReplacingOccurrencesOfString:@"</div>" withString:@""];
    temp = [temp stringByReplacingOccurrencesOfString:@"<div>" withString:@"\n"];
    temp = [temp stringByReplacingOccurrencesOfString:@"\n\n" withString:@"\n"];
    //
    temp = [temp stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
    temp = [temp stringByReplacingOccurrencesOfString:@"&#63;" withString:@"?"];
    NSArray *temparr = [temp componentsSeparatedByString:@"<span class=\""];
    NSMutableArray *tempMuarr = [[NSMutableArray alloc] initWithArray:temparr];
    if ([tempMuarr count] >1) {
        for (int i=0; i<[tempMuarr count]; i++) {
            NSString *str = [tempMuarr objectAtIndex:i];
            NSString *temStr = str;
            NSArray *spanArr =[str componentsSeparatedByString:@"\""];
            str =[spanArr objectAtIndex:0];
            NSString *faceStr = @"";
            if ([str hasPrefix:@"emoji emoji"]) {
                
                faceStr = [[str componentsSeparatedByString:@"emoji emoji"] objectAtIndex:1];
                if (!faceStr || [@"" isEqualToString:faceStr]) {
                    faceStr=@"error emoji";
                }
                faceStr = [EmotionHelper codeToEmotion:faceStr];
                reValue =  [reValue stringByAppendingString:faceStr];
                NSMutableArray *textFaceArr =[[NSMutableArray alloc] initWithArray:[temStr componentsSeparatedByString:@"</span>"]];
                if ([textFaceArr count] >1) {
                    reValue= [reValue stringByAppendingString:[textFaceArr objectAtIndex:[textFaceArr count]-1]];
                }
            }else
            {
                reValue = [reValue stringByAppendingString:str];
            }
        }
    }else
    {
        reValue = temp;
    }
    return  reValue;
    
}
//
+(NSArray *)getEmojis
{
    NSArray *array = [[NSArray alloc] initWithObjects:@"1f636",@"1f635",@"1f637",@"270c",@"270b",@"1f631",@"1f630",@"1f632",@"1f634",@"1f633",@"1f606",@"1f605",@"1f607",@"1f609",@"1f608",@"1f601",@"1f600",@"1f602",@"1f604",@"1f603",@"1f616",@"1f615",@"1f617",@"1f619",@"1f618",@"1f611",@"1f610",@"1f612",@"1f614",@"1f613",@"1f626",@"1f625",@"1f627",@"1f629",@"1f628",@"1f621",@"1f620",@"1f622",@"1f624",@"1f623",nil];
    return array;
}
@end
