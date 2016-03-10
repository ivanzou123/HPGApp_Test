//
//  UtilDAO.m
//  MFS
//
//  Created by hwpl hwpl on 14-9-4.
//  Copyright (c) 2014年 hwpl hwpl. All rights reserved.
//
#import "HttpClient.h"
#import "CrmNetServiceUtil.h"
#import "ErrorModel.h"
#import "ResponseModel.h"
#import "JSON.h"
static CrmNetServiceUtil *instance=nil;
@interface CrmNetServiceUtil()
@property(nonatomic,retain) HttpClient *listClient;

@end
@implementation CrmNetServiceUtil
@synthesize  listClient;

+(CrmNetServiceUtil *)sharedInstance
{
    @synchronized(self)
    {
        if (!instance) {
            instance = [[CrmNetServiceUtil alloc] init];
        }
    }
    return instance;
}
+(id)startRecommandlistByPage:(int)pageIndex Message:(NSString *)parmer
{
    [self sharedInstance].listClient = [[HttpClient alloc] init];

    NSString *methodParmer = [@"http://210.3.22.118:8150/MCrmWebService.asmx/getFunctionInterface?" stringByAppendingString:[NSString stringWithFormat:parmer]];
    //NSLog(@"%@",methodParmer);
    NSString *data =[[self sharedInstance].listClient getRequestFromUrl:methodParmer error:nil];
    
    id jsonData = [data JSONValue];
//    NSLog(@"%@",data);
//    NSLog(@"%@",jsonData);
    ResponseModel *response = [[ResponseModel alloc] init];
//    NSLog(@"%@",response.error);
    //response.status = [self sharedInstance].listClient.
    response.error = [self sharedInstance].listClient.error;
    response.resultInfo = jsonData;
    return response;
}
+(id)startRecommandlistByPagePost:(int)pageIndex Message:(NSMutableDictionary *)parmer
{
    [self sharedInstance].listClient = [[HttpClient alloc] init];
    NSString *methodParmer = @"http://210.3.22.118:8150/MCrmWebService.asmx/getFunctionByPost";
    //NSLog(@"%@",methodParmer);
    NSString *data =[[self sharedInstance].listClient  postRequestFromUrl:methodParmer Parmeter:parmer error:nil];
    
    id jsonData = [data JSONValue];
//    NSLog(@"%@",data);
//    NSLog(@"%@",jsonData);
    ResponseModel *response = [[ResponseModel alloc] init];
    //response.status = [self sharedInstance].listClient.
    response.error = [self sharedInstance].listClient.error;
    response.resultInfo = jsonData;
//    NSLog(@"%@",response.error);
    return response;
}
@end
