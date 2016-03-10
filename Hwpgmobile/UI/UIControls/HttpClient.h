//
//  HttpClient.h
//  MFS
//
//  Created by hwpl hwpl on 14-9-4.
//  Copyright (c) 2014年 hwpl hwpl. All rights reserved.
//
@class ErrorModel;
#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
#import "ResponseModel.h"
#import "ASIFormDataRequest.h"
#import "ErrorModel.h"
@interface HttpClient : NSObject<ASIHTTPRequestDelegate>
@property(nonatomic,retain)ErrorModel *error;
@property(nonatomic,retain) NSString *status;
-(NSString *)getRequestFromUrl:(NSString *)url error:(ErrorModel *) error;
-(NSString *)postRequestFromUrl:(NSString *)url Parmeter:(NSMutableDictionary *) parm error:(ErrorModel *) error;
-(NSString *)requestFromUrl:(NSString *) url method:(NSString *)method error:(ErrorModel *)error;
-(void)cancelRequest;
-(NSString *)getRequestFromUrl:(NSString *)url  error:(ErrorModel *)error isUrlEncoding:(BOOL) isUrlEncoding;
-(NSString *)postRequestVoiceFromUrl:(NSString *)url fileName:(NSString *)fileName error:(ErrorModel *)error;

@end
