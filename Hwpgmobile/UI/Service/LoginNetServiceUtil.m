//
//  UtilDAO.m
//  MFS
//
//  Created by hwpl hwpl on 14-9-4.
//  Copyright (c) 2014年 hwpl hwpl. All rights reserved.
//

#import "HttpClient.h"
#import "LoginNetServiceUtil.h"
#import "ErrorModel.h"
#import "ResponseModel.h"
#import "JSON.h"
#import "CommUtilHelper.h"
#import "SocketIOJSONSerialization.h"
static LoginNetServiceUtil *instance;
@interface LoginNetServiceUtil()
@property(nonatomic,retain) HttpClient *listClient;

@end
@implementation LoginNetServiceUtil
@synthesize  listClient;

+(LoginNetServiceUtil *)sharedInstance
{
    @synchronized(self)
    {
        if(instance ==nil)
        {
        instance = [[LoginNetServiceUtil alloc] init];
        }
    }
    return instance;
}
//
+(id)startRecommandGetUser:(NSString *)userCode password:(NSString *)password
{
    @try {
        
        
        
        [self sharedInstance].listClient = [[HttpClient alloc] init];
        NSString *url =[NSString stringWithFormat:@"%@/appMobilePlatform/login?userName=%@&password=%@&deviceId=%@",charUrl,userCode ,password,[CommUtilHelper getDeviceId]];
        NSString *data =[[self sharedInstance].listClient getRequestFromUrl:url error:nil];
        
        id jsonData=nil;
        if (data && ![@"" isEqualToString:data]) {
            jsonData = [data JSONValue];
        }
        ResponseModel *response = [[ResponseModel alloc] init];
        response.error = [self sharedInstance].listClient.error;
        response.resultInfo = jsonData;
        return response;
    }
    @catch (NSException *exception){
        NSLog(@"startRecommandGetUser error:%@",exception);
        return nil;
    }
    @finally{
    }
}


+ (NSString*)encodeURL:(NSString *)string
{
    NSString *newString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
                                                                                                 kCFAllocatorDefault,
                                                                                                 (CFStringRef)string, NULL, CFSTR(":/?#[]@!$&'()*+,;=\"<>%{}|\\^~`"),
                                                                                                 kCFStringEncodingUTF8)) ;
    if (newString) {
        return newString;
    }
    return @"";
}

+(id)LoginChat:(NSString *)user Password:(NSString *)password
{
    @try {
        
        
        
        [self sharedInstance].listClient = [[HttpClient alloc] init];
        
        
        

        password= [LoginNetServiceUtil encodeURL:password];
        NSString *url =[NSString stringWithFormat:@"%@/appMobilePlatform/login?userName=%@&password=%@&deviceId=%@&deviceType=IOS",charUrl,user ,password,[CommUtilHelper getDeviceId]];
        
        
        NSString *data =[[self sharedInstance].listClient getRequestFromUrl:url error:nil isUrlEncoding:NO];
        
        id jsonData=nil;
        if (data && ![@"" isEqualToString:data]){
            jsonData = [data JSONValue];
        }
        ResponseModel *response = [[ResponseModel alloc] init];
        response.error = [self sharedInstance].listClient.error;
        response.resultInfo = jsonData;
        return response;
    }
    @catch (NSException *exception){
        NSLog(@"startRecommandGetUser error:%@",exception);
        return nil;
    }
    @finally{
    }

}

-(NSString*)URLencode:(NSString *)originalString
        stringEncoding:(NSStringEncoding)stringEncoding {
    //!  @  $  &  (  )  =  +  ~  `  ;  '  :  ,  /  ?
    //%21%40%24%26%28%29%3D%2B%7E%60%3B%27%3A%2C%2F%3F
    NSArray *escapeChars = [NSArray arrayWithObjects:@"&" , nil];
    
    NSArray *replaceChars = [NSArray arrayWithObjects:@"%26", nil];
    
    int len = [escapeChars count];
    
    NSMutableString *temp = [[originalString
                              stringByAddingPercentEscapesUsingEncoding:stringEncoding]
                             mutableCopy];
    
    int i;
    for (i = 0; i < len; i++) {
        
        [temp replaceOccurrencesOfString:[escapeChars objectAtIndex:i]
                              withString:[replaceChars objectAtIndex:i]
                                 options:NSLiteralSearch
                                   range:NSMakeRange(0, [temp length])];
    }
    
    NSString *outStr = [NSString stringWithString: temp];
    
    return outStr;
}

//
+(id)regDevice:(NSString *) userPrincipalName
{
    @try {
        NSString *deviceId = [CommUtilHelper getDeviceId];
        [self sharedInstance].listClient = [[HttpClient alloc] init];
        NSString *url =[NSString stringWithFormat:@"%@/signin?userPrincipalName=%@&deviceId=%@&deviceType=%@&code=",charUrl,userPrincipalName,deviceId,@"IOS"];
        NSString *data =[[self sharedInstance].listClient getRequestFromUrl:url error:nil];
        id jsonData=nil;
        if (data) {
            jsonData = [data JSONValue];
        }
        ResponseModel *response = [[ResponseModel alloc] init];
        response.error = [self sharedInstance].listClient.error;
        response.resultInfo = jsonData;
        return response;
    }
    @catch (NSException *exception) {
        NSLog(@"regDevice error:%@",exception);
        return nil;
    }
    @finally {
    }
}
//
+(id)GetSyncInfo:(NSString *)user SyncTime:(NSString *)snctTime methodName:(NSString *)method
{
    @try {
        [self sharedInstance].listClient = [[HttpClient alloc] init];
        NSString *deviceId =  [CommUtilHelper getDeviceId];
        NSString *url =[NSString stringWithFormat:@"%@/sysServerData/%@?user=%@&sysTime=%@&deviceId=%@",charUrl,method,user,snctTime,deviceId];
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
        NSLog(@"GetSyncInfo error:%@",exception);
        return nil;
    }
    @finally {
    }
    
}
+(id)clearMessage:(NSString *)user deviceId:(NSString *)deviceId successIds:(NSString *)successids
{
    @try {
        [self sharedInstance].listClient = [[HttpClient alloc] init];
        NSString *deviceId =  [CommUtilHelper getDeviceId];
        NSString *url =[NSString stringWithFormat:@"%@/sysServerData/clearMessage",charUrl];
        //NSString *data =[[self sharedInstance].listClient getRequestFromUrl:url error:nil];
        
        //NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:successids,@"sucessDic", nil];
        
        NSMutableDictionary *mutabldic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:user,@"username",successids ,@"successIds",deviceId,@"deviceId", nil];
        NSString *data = [[self sharedInstance].listClient postRequestFromUrl:url Parmeter:mutabldic error: nil];
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
        NSLog(@"GetSyncInfo error:%@",exception);
        return nil;
    }
    @finally {
    }

}
+(id)GetVersion
{
  @try{
    [self sharedInstance].listClient = [[HttpClient alloc] init];
    NSString *url =[NSString stringWithFormat:@"%@/getVersion?deviceType=%@",charUrl,@"IOS"];
    NSString *data =[[self sharedInstance].listClient getRequestFromUrl:url error:nil];
    id jsonData=nil;
    if (data) {
        
      NSString  *strData = [[LoginNetServiceUtil sharedInstance] jsonToDic:data];
     jsonData = [[LoginNetServiceUtil sharedInstance] jsonToDic:strData];
        
    }
    ResponseModel *response = [[ResponseModel alloc] init];
    //response.status = [self sharedInstance].listClient.
    response.error = [self sharedInstance].listClient.error;
    response.resultInfo = jsonData;
    return response;
}
@catch (NSException *exception) {
    NSLog(@"GetSyncInfo error:%@",exception);
    return nil;
}
@finally {
}

}
-(id)jsonToDic:(NSString *)str
{
    
    NSData* data2 = [str dataUsingEncoding:NSASCIIStringEncoding];
    __autoreleasing NSError* error1 = nil;
    id result1 = [NSJSONSerialization JSONObjectWithData:data2 options:NSJSONReadingAllowFragments error:&error1];
    return result1;
    
}
-(id)jsonToDicByUtf8:(NSString *)str
{
    
    NSData* data2 = [str dataUsingEncoding:NSUTF8StringEncoding];
    __autoreleasing NSError* error1 = nil;
    id result1 = [NSJSONSerialization JSONObjectWithData:data2 options:NSJSONReadingAllowFragments error:&error1];
    return result1;
    
}
@end

