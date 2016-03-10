//
//  FSWebServiceUtil.m
//  HPGApp
//
//  Created by hwpl on 15/10/26.
//  Copyright © 2015年 hwpl hwpl. All rights reserved.
//

#import "FSWebServiceUtil.h"
#import "HttpClient.h"
#import "ErrorModel.h"
#import "ResponseModel.h"
#import "JSON.h"
#import "CommUtilHelper.h"
static FSWebServiceUtil *instance;

@interface FSWebServiceUtil ()
@property(nonatomic,retain) HttpClient *listClient;
@end

@implementation FSWebServiceUtil
@synthesize  listClient;
+(FSWebServiceUtil *)sharedInstance
{
    @synchronized(self)
    {
        if(instance ==nil)
        {
            instance = [[FSWebServiceUtil alloc] init];
        }
    }
    return instance;
}

-(id)getSearchMessageByParam:(NSString *)txtConnmods user:(NSString *)user
{
    @try {
        [FSWebServiceUtil sharedInstance].listClient = [[HttpClient alloc] init];
        NSString *url =[NSString stringWithFormat:@"%@/work/getSaleInfoData?txtCommonds=%@&user_principal_name=%@",charUrl,txtConnmods,user];
        NSString *data =[[FSWebServiceUtil sharedInstance].listClient getRequestFromUrl:url error:nil];
        id jsonData = [data JSONValue];
        ResponseModel *response = [[ResponseModel alloc] init];
        //response.status = [self sharedInstance].listClient.
        response.error = [FSWebServiceUtil sharedInstance].listClient.error;
        response.resultInfo = jsonData;
        return response;
    }
    @catch (NSException *exception) {
        //NSLog(@"dropGroupFrunFrom error:%@",exception);
        return nil;
    }
    @finally {
        
    }
}

-(id)getMsgCatalogList:(NSString *) user withSource:(NSString *)source
{
    @try {
        [FSWebServiceUtil sharedInstance].listClient = [[HttpClient alloc] init];
        NSString *url =[NSString stringWithFormat:@"%@/publicGroup/getPublicGroupSetting?userName=%@&source=%@",charUrl,user,source];
        NSString *data =[[FSWebServiceUtil sharedInstance].listClient getRequestFromUrl:url error:nil];
        id jsonData = [data JSONValue];
        ResponseModel *response = [[ResponseModel alloc] init];
        //response.status = [self sharedInstance].listClient.
        response.error = [FSWebServiceUtil sharedInstance].listClient.error;
        response.resultInfo = jsonData;
        return response;
    }
    @catch (NSException *exception) {
        //NSLog(@"dropGroupFrunFrom error:%@",exception);
        return nil;
    }
    @finally {
        
    }

}

-(id)updateSendType:(NSString *)dataInfo withSource:(NSString *)source
{
    @try {
        [FSWebServiceUtil sharedInstance].listClient = [[HttpClient alloc] init];
        NSString *url =[NSString stringWithFormat:@"%@/publicGroup/updatePublicGroupSetting?settings=%@&source=%@&userName=%@",charUrl,dataInfo,source,[[CommUtilHelper sharedInstance] getUser]];
        NSString *data =[[FSWebServiceUtil sharedInstance].listClient getRequestFromUrl:url error:nil];
        id jsonData = [data JSONValue];
        ResponseModel *response = [[ResponseModel alloc] init];
        //response.status = [self sharedInstance].listClient.
        response.error = [FSWebServiceUtil sharedInstance].listClient.error;
        response.resultInfo = jsonData;
        return response;
    }
    @catch (NSException *exception){
        //NSLog(@"dropGroupFrunFrom error:%@",exception);
        return nil;
    }
    @finally {
        
    }

}
@end
