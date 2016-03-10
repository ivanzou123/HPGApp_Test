//
//  HttpClient.m
//  MFS
//
//  Created by hwpl hwpl on 14-9-4.
//  Copyright (c) 2014年 hwpl hwpl. All rights reserved.
//

#import "HttpClient.h"
@interface HttpClient()
{
    BOOL _isFinished;
}
//@property(nonatomic,retain)ASIHTTPRequest *currentRequet;
@property(nonatomic,retain)ASIFormDataRequest *postRequet;
@end
@implementation HttpClient
@synthesize postRequet;
@synthesize error=_error;
@synthesize status;
-(NSString *)requestFromUrl:(NSString *)url method:(NSString *)method  Parmeter:(NSMutableDictionary *)parm error:(ErrorModel *)error isUrlEncoding:(BOOL) isUrlCodeing
{
    @try {
        if (isUrlCodeing) {
            url=[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        }
    
    if([method isEqualToString:@"GET"])
    {
        self.postRequet = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
        
    }else
    {
       // NSArray *urllist = [url componentsSeparatedByString:@"?"];
        //NSString *paramString = nil;
        self.postRequet = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
        NSEnumerator *enumerKey = [parm keyEnumerator];
        for (NSString *key in enumerKey) {
            
            [self.postRequet setPostValue:[parm objectForKey:key] forKey:key];
            
            //[self.postRequet setpo]
        }
               //[currentRequet set]
    }
    
    [self.postRequet setShouldAttemptPersistentConnection:NO];
     
    [self.postRequet setPersistentConnectionTimeoutSeconds:0];
    [self.postRequet setAuthenticationScheme:httpDelegate];
    [self.postRequet setValidatesSecureCertificate:NO];
    [self.postRequet setDelegate:self];
    [self.postRequet setTimeOutSeconds:20.0f];
    [self.postRequet setRequestMethod:method];
    [self.postRequet startSynchronous];
    //超时后的连接关闭不能 从新请求
    
    
    while (!_isFinished){
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    //格式化返回的json数据，解决中文乱码
    NSData *jsondata = [self.postRequet responseData];
    NSString *resultString = [[NSString alloc] initWithBytes:[jsondata bytes] length:[jsondata length] encoding:NSUTF8StringEncoding];
    return  resultString;
        
    }
    @catch (NSException *exception) {
        return nil;
    }
    //    return self.postRequet.responseString;
}

-(NSString *)getRequestFromUrl:(NSString *)url  error:(ErrorModel *)error
{
   return [self requestFromUrl:url method:@"GET" Parmeter:nil error:error isUrlEncoding:YES];
}
-(NSString *)getRequestFromUrl:(NSString *)url  error:(ErrorModel *)error isUrlEncoding:(BOOL) isUrlEncoding
{
    return [self requestFromUrl:url method:@"GET" Parmeter:nil error:error isUrlEncoding:isUrlEncoding];
}

-(NSString *)postRequestFromUrl:(NSString *)url Parmeter:(NSMutableDictionary *)parm error:(ErrorModel *)error
{
    return [self requestFromUrl:url method:@"POST" Parmeter:parm error:error isUrlEncoding:YES];
}

-(void)requestFinished:(ASIHTTPRequest *)request
{
    _isFinished=YES;
    
}
-(void)requestFailed:(ASIHTTPRequest *)request
{
    @try {
        
     
    if(self.postRequet.error.code == 1)
    {
        
    }
    //self.status =self.postRequet.error.code;
    self.error=[[ErrorModel alloc] initWithHttpWithError:request.error];
    _isFinished=YES;
        
    }
    @catch (NSException *exception) {
        
        _isFinished=YES;
    }
}

-(NSString *)postRequestVoiceFromUrl:(NSString *)url fileName:(NSString *)fileName error:(ErrorModel *)error
{
    
    self.postRequet = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];;
    [self.postRequet setFile:fileName  forKey:@"caf"];
    [self.postRequet setDelegate:self];
    [self.postRequet buildRequestHeaders];
    //[self.postRequet setRequestMethod:@"POST"];
    [self.postRequet startSynchronous];
    [self.postRequet setValidatesSecureCertificate:NO];
    while (!_isFinished) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    
    return self.postRequet.responseString;

}


@end
