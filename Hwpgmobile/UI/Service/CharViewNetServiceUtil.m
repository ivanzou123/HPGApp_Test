//
//  CharViewNetServiceUtil.m
//  Chart
//
//  Created by hwpl hwpl on 14-10-29.
//  Copyright (c) 2014年 hwpl hwpl. All rights reserved.
//

#import "CharViewNetServiceUtil.h"
#import "ErrorModel.h"
#import "ResponseModel.h"
#import "JSON.h"
#import "HttpClient.h"
#import "LoginNetServiceUtil.h"
static CharViewNetServiceUtil *instance;
@interface CharViewNetServiceUtil()
@property(nonatomic,retain) HttpClient *listClient;

@end

@implementation CharViewNetServiceUtil
+(CharViewNetServiceUtil *)sharedInstance
{
    if(instance ==nil)
    {
        instance = [[CharViewNetServiceUtil alloc] init];
    }
    return instance;
}

+(id)startRecommandGetListInfo:(NSString *)groupId MinNumber:(NSInteger)minNumber maxNumber:(NSInteger)maxNumber
{
    @try {
        [self sharedInstance].listClient = [[HttpClient alloc] init];
        NSString *url =[NSString stringWithFormat:@"%@/chatroom?groupid=%@&min=%li&max=%li",charUrl,groupId,minNumber,maxNumber];
        NSString *data =[[self sharedInstance].listClient getRequestFromUrl:url error:nil];
        id jsonData=nil;
        if (data) {
            jsonData = [data JSONValue];
        }
        ResponseModel *response = [[ResponseModel alloc] init];
        //response.status = [self sharedInstance].listClient.
        response.error = [self sharedInstance].listClient.error;
        response.resultInfo = jsonData;
        return response;
    }
    @catch (NSException *exception) {
        NSLog(@"startRecommandGetListInfo error:%@",exception);
        return nil;
    }
    @finally {
    }
}


+(id)GetCharListData:(NSString *)user
{
    @try {
        [self sharedInstance].listClient = [[HttpClient alloc] init];
        NSString *url =[NSString stringWithFormat:@"%@/chatroom_list?from=%@",charUrl,user ];
        NSString *data =[[self sharedInstance].listClient getRequestFromUrl:url error:nil];      id jsonData=nil;
        if (data) {
            jsonData = [data JSONValue];
        }
        ResponseModel *response = [[ResponseModel alloc] init];
        //response.status = [self sharedInstance].listClient.
        response.error = [self sharedInstance].listClient.error;
        response.resultInfo = jsonData;
        return response;
    }
    @catch (NSException *exception) {
        NSLog(@"GetCharListData error:%@",exception);
        return nil;
    }
    @finally {
    }

}
+(id)PostUploadVoice:(NSString *)fileName
{
    @try {
        [self sharedInstance].listClient = [[HttpClient alloc] init];
        NSString *url =[NSString stringWithFormat:@"%@/fileTransfer/upload",charUrl];
        NSString *data =[[self sharedInstance].listClient postRequestVoiceFromUrl:url fileName:fileName error:nil];
        id jsonData=nil;
        if (data) {
            jsonData = [data JSONValue];
        }
        ResponseModel *response = [[ResponseModel alloc] init];
        //response.status = [self sharedInstance].listClient.
        response.error = [self sharedInstance].listClient.error;
        response.resultInfo = jsonData;
        return response;
    }
    @catch (NSException *exception) {
        NSLog(@"PostUploadVoice error:%@",exception);
        return nil;
    }
    @finally {
    }
    
}
+(id)downLoadVoice:(NSString *)filePath fileName:(NSString *)path
{

    NSURL *url = [ NSURL URLWithString : filePath ];
    ASIHTTPRequest *request = [ ASIHTTPRequest requestWithURL :url];
    [request setDownloadDestinationPath :path];
    [request setRequestMethod:@"GET"];
    //[request setDownloadProgressDelegate : progressView ];
    [request setValidatesSecureCertificate:NO];
    [request startSynchronous ];
    ResponseModel *response = [[ResponseModel alloc] init];
    //response.status = [self sharedInstance].listClient.
    response.error = [self sharedInstance].listClient.error;
    if (response.error!=nil) {
        return @"error";
    }
    return path;
}
+(id)downLoadImg:(NSString *)filePath targetFilePath:(NSString *)targetFilePath
{
    NSURL *url = [ NSURL URLWithString : filePath ];
    ASIHTTPRequest *request = [ ASIHTTPRequest requestWithURL :url];
    [request setDownloadDestinationPath :targetFilePath];
    [request setRequestMethod:@"GET"];
    [request setValidatesSecureCertificate:NO];
    //[request setDownloadProgressDelegate : progressView ];
    [request startSynchronous ];
    ResponseModel *response = [[ResponseModel alloc] init];
    //response.status = [self sharedInstance].listClient.
    response.error = [self sharedInstance].listClient.error;
    if (response.error!=nil) {
        return @"error";
    }
    return targetFilePath;
}
//
+(id)asynDownLoadImg:(NSString *)filePath targetFilePath:(NSString *)targetFilePath
{
    NSURL *url = [ NSURL URLWithString : filePath ];
    ASIHTTPRequest *request = [ ASIHTTPRequest requestWithURL :url];
    [request setDownloadDestinationPath :targetFilePath];
    [request setRequestMethod:@"GET"];
    //[request setDownloadProgressDelegate : progressView ];
    [request startAsynchronous];
    ResponseModel *response = [[ResponseModel alloc] init];
    response.error = [self sharedInstance].listClient.error;
    if (response.error!=nil) {
        return @"error";
    }
    return targetFilePath;
}
+(id)synDownLoadImg:(NSString *)filePath targetFilePath:(NSString *)targetFilePath
{
    NSURL *url = [ NSURL URLWithString : filePath ];
    ASIHTTPRequest *request = [ ASIHTTPRequest requestWithURL :url];
    [request setValidatesSecureCertificate:NO];
    [request setDownloadDestinationPath :targetFilePath];
    [request setRequestMethod:@"GET"];
    //[request setDownloadProgressDelegate : progressView ];
    [request startSynchronous];
    ResponseModel *response = [[ResponseModel alloc] init];
    NSError *error = request.error;
    if (error!=nil) {
        return @"error";
    }
    return targetFilePath;
}
+(id)getMsipData:(NSString *)user deviceId:(NSString *)deviceId;
{
    @try {
        [self sharedInstance].listClient = [[HttpClient alloc] init];
        NSString *url =[NSString stringWithFormat:@"%@/otherWebService/getMsipList?userName=%@&deviceId=%@",charUrl,user,deviceId];
        NSString *data =[[self sharedInstance].listClient getRequestFromUrl:url error:nil];
        id jsonData=nil;
        if (data) {
            //jsonData = [data JSONValue];
            NSString *strData = [[CharViewNetServiceUtil sharedInstance] jsonToDic:data];
            jsonData = [[CharViewNetServiceUtil sharedInstance] jsonToDicByUtf8:strData];
            
        }
        ResponseModel *response = [[ResponseModel alloc] init];
        //response.status = [self sharedInstance].listClient.
        response.error = [self sharedInstance].listClient.error;
        response.resultInfo = jsonData;
        return response;
    }
    @catch (NSException *exception) {
        NSLog(@"PostUploadVoice error:%@",exception);
        return nil;
    }
    @finally {
    }
    
}
+(id)getEhrNum:(NSString *)user
{
    @try {
        [self sharedInstance].listClient = [[HttpClient alloc] init];
        NSString *url =[NSString stringWithFormat:@"%@/otherWebService/getPendingNum?userName=%@",charUrl,user];
        NSString *data =[[self sharedInstance].listClient getRequestFromUrl:url error:nil];
        id jsonData=nil;
        if (data) {
            //jsonData = [data JSONValue];
           // NSString *strData = [[CharViewNetServiceUtil sharedInstance] jsonToDic:data];
           // jsonData = [[CharViewNetServiceUtil sharedInstance] jsonToDicByUtf8:strData];
            jsonData = [data JSONValue];
            
        }
        ResponseModel *response = [[ResponseModel alloc] init];
        //response.status = [self sharedInstance].listClient.
        response.error = [self sharedInstance].listClient.error;
        response.resultInfo = jsonData;
        return response;
    }
    @catch (NSException *exception) {
        NSLog(@"PostUploadVoice error:%@",exception);
        return nil;
    }
    @finally {
    }
    
}
+(id)getMenu:(NSString *)user deviceId:(NSString *)deviceId;
{
    @try {
        [self sharedInstance].listClient = [[HttpClient alloc] init];
        NSString *url =[NSString stringWithFormat:@"%@/appMobilePlatform/getAppMenu?userName=%@&deviceId=%@",charUrl,user,deviceId];
        NSString *data =[[self sharedInstance].listClient getRequestFromUrl:url error:nil];
        id jsonData=nil;
        if (data) {
            NSString  *strData = [[LoginNetServiceUtil sharedInstance] jsonToDicByUtf8:data];
            jsonData = [[LoginNetServiceUtil sharedInstance] jsonToDicByUtf8:strData];

        }
        ResponseModel *response = [[ResponseModel alloc] init];
        //response.status = [self sharedInstance].listClient.
        response.error = [self sharedInstance].listClient.error;
        response.resultInfo = jsonData;
        return response;
    }
    @catch (NSException *exception) {
        NSLog(@"PostUploadVoice error:%@",exception);
        return nil;
    }
    @finally {
    }
    
}
-(id)jsonToDicByUtf8:(NSString *)str
{
    
    NSData* data2 = [str dataUsingEncoding:NSUTF8StringEncoding];
    __autoreleasing NSError* error1 = nil;
    id result1 = [NSJSONSerialization JSONObjectWithData:data2 options:NSJSONReadingAllowFragments error:&error1];
    return result1;
    
}
-(id)jsonToDic:(NSString *)str
{
    
    NSData* data2 = [str dataUsingEncoding:NSASCIIStringEncoding];
    __autoreleasing NSError* error1 = nil;
    id result1 = [NSJSONSerialization JSONObjectWithData:data2 options:NSJSONReadingAllowFragments error:&error1];
    return result1;
    
}
+(id)getHeadPhotoByUrl:(NSString *)url
{
    @try {
        [self sharedInstance].listClient = [[HttpClient alloc] init];
         NSString *data =[[self sharedInstance].listClient getRequestFromUrl:url error:nil];
         ResponseModel *response = [[ResponseModel alloc] init];
        //response.status = [self sharedInstance].listClient.
        response.error = [self sharedInstance].listClient.error;
        response.resultInfo = data;
        return response;
    }
    @catch (NSException *exception) {
        NSLog(@"PostUploadVoice error:%@",exception);
        return nil;
    }
    @finally {
    }

}

+(id)getMoreMessageInfo:(NSString *)userName GroupSessionId:(NSString *)groupSessionId groupId:(NSString *)groupId row:(NSInteger)row
{
    @try {
        [self sharedInstance].listClient = [[HttpClient alloc] init];
        NSString *url =[NSString stringWithFormat:@"%@/chatroom/getPastSession?username=%@&groupId=%@&sessionId=%@&rows=%li",charUrl,userName,groupId,groupSessionId,row];
        NSString *data =[[self sharedInstance].listClient getRequestFromUrl:url error:nil];
        id jsonData=nil;
        if (data) {
            jsonData = [data JSONValue];
            //NSString *strData = [[CharViewNetServiceUtil sharedInstance] jsonToDic:data];
            //jsonData = [[CharViewNetServiceUtil sharedInstance] jsonToDicByUtf8:strData];
            
        }
        ResponseModel *response = [[ResponseModel alloc] init];
        //response.status = [self sharedInstance].listClient.
        response.error = [self sharedInstance].listClient.error;
        response.resultInfo = jsonData;
        return response;
    }
    @catch (NSException *exception) {
        
        return nil;
    }
    @finally {
    }

}

@end
