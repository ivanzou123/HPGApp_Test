//
//  ApproveServiceUtil.m
//  Chat
//
//  Created by hwpl hwpl on 14-11-9.
//  Copyright (c) 2014年 hwpl hwpl. All rights reserved.
//



#define approveUrl @"http://172.21.5.136:8000"
#import "HttpClient.h"
#import "ErrorModel.h"
#import "ResponseModel.h"
#import "ApproveServiceUtil.h"
#import "JSON.h"
#import "CommUtilHelper.h"
static ApproveServiceUtil *instance;
@interface ApproveServiceUtil ()
@property(nonatomic,retain) HttpClient *listClient;
@end

@implementation ApproveServiceUtil
@synthesize  listClient;

+(ApproveServiceUtil *)sharedInstance
{
    if(instance ==nil)
    {
        instance = [[ApproveServiceUtil alloc] init];
    }
    return instance;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
+(id)getAppInfoMsg:(NSString *)method Data:(NSMutableDictionary *)dic
{
    @try {
        [self sharedInstance].listClient = [[HttpClient alloc] init];
        NSString *userName = [dic objectForKey:@"userName"];
        NSString *type = [dic objectForKey:@"listType"];
        NSString *sysCode = [dic objectForKey:@"SysCode"];
        NSString *aprTtile = [dic objectForKey:@"aprTitle"];
        if (!sysCode){
            sysCode=@"";
        }
        if (!aprTtile){
            aprTtile=@"";
        }
        
        NSString *url =[NSString stringWithFormat:@"%@/appMobilePlatform/%@?userName=%@&listType=%@&sysCode=%@&aprTitle=%@",charUrl,method,userName,type,sysCode,aprTtile];
        NSString *data =[[self sharedInstance].listClient getRequestFromUrl:url error:nil];
        id jsonData = [data JSONValue];
        ResponseModel *response = [[ResponseModel alloc] init];
        //response.status = [self sharedInstance].listClient.
        response.error = [self sharedInstance].listClient.error;
        response.resultInfo = jsonData;
        return response;
    }
    @catch (NSException *exception) {
        NSLog(@"getAppInfoMsg error:%@",exception);
        return nil;
    }
    @finally {
    }
}
+(id)getAppDetailsInfoMsg:(NSString *)method Data:(NSMutableDictionary *)dic
{
    @try {
        [self sharedInstance].listClient = [[HttpClient alloc] init];
        
        NSString *userName = [dic objectForKey:@"userName"];
        NSString *type = [dic objectForKey:@"listType"];
        NSString *aprId = [dic objectForKey:@"aprId"];
        NSString *sysCode = [dic objectForKey:@"SysCode"];
        NSString *url =[NSString stringWithFormat:@"%@/appMobilePlatform/%@?userName=%@&listType=%@&aprId=%@&sysCode=%@",charUrl,method,userName,type,aprId,sysCode];
        NSString *data =[[self sharedInstance].listClient getRequestFromUrl:url error:nil];
        id jsonData = [data JSONValue];
        ResponseModel *response = [[ResponseModel alloc] init];
        //response.status = [self sharedInstance].listClient.
        response.error = [self sharedInstance].listClient.error;
        response.resultInfo = jsonData;
        return response;
    }
    @catch (NSException *exception) {
        NSLog(@"getAppDetailsInfoMsg error:%@",exception);
        return nil;
    }
    @finally {
    }
}
+(id)approveOrRejectAction:(NSMutableDictionary *)dic
{
    @try {
        [self sharedInstance].listClient = [[HttpClient alloc] init];
        NSString *userName = [dic objectForKey:@"userName"];
        NSString *aprRefId = [dic objectForKey:@"aprRefId"];
        NSString *aprId = [dic objectForKey:@"aprId"];
        NSString *action = [dic objectForKey:@"action"];
        NSString *comment = [dic objectForKey:@"comment"];
        NSString *url =[NSString stringWithFormat:@"%@/appMobilePlatform/approveOrReject?userName=%@&aprId=%@&aprRefId=%@&action=%@&comment=%@",charUrl,userName,aprId,aprRefId,action,comment];
        NSString *data =[[self sharedInstance].listClient getRequestFromUrl:url error:nil];
        id jsonData = [data JSONValue];
        ResponseModel *response = [[ResponseModel alloc] init];
        //response.status = [self sharedInstance].listClient.
        response.error = [self sharedInstance].listClient.error;
        response.resultInfo = jsonData;
        return response;
    }
    @catch (NSException *exception) {
        NSLog(@"approveOrRejectAction error:%@",exception);
        return nil;
    }
    @finally {
    }
}
+(id)getUnApproveNum
{
    @try {
        [self sharedInstance].listClient = [[HttpClient alloc] init];
       
        NSString *url =[NSString stringWithFormat:@"%@/otherWebService/getUnapproveNum?userName=%@&deviceId=%@",charUrl,[[NSUserDefaults standardUserDefaults] objectForKey:@"user"],[CommUtilHelper getDeviceId]];
        NSString *data =[[self sharedInstance].listClient getRequestFromUrl:url error:nil];
        
        return data;
    }
    @catch (NSException *exception) {
        NSLog(@"approveOrRejectAction error:%@",exception);
        return nil;
    }
    @finally {
    }

}
@end
