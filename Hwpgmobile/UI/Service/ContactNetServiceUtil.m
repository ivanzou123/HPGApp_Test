//
//  ContactNetServiceUtil.m
//  HwpgMobile
//
//  Created by hwpl hwpl on 14-11-24.
//  Copyright (c) 2014年 hwpl hwpl. All rights reserved.
//

#import "ContactNetServiceUtil.h"
#import "HttpClient.h"
#import "ErrorModel.h"
#import "ResponseModel.h"
#import "JSON.h"
static ContactNetServiceUtil *instance;
@interface ContactNetServiceUtil()
@property(nonatomic,retain) HttpClient *listClient;

@end

@implementation ContactNetServiceUtil
@synthesize  listClient;

+(ContactNetServiceUtil *)sharedInstance
{
    @synchronized(self)
    {
    if(instance ==nil)
    {
        instance = [[ContactNetServiceUtil alloc] init];
    }
    }
    return instance;
}


-(id)getSearchContact:(NSString *)searchText Min:(int) min Max:(int) max From:(NSString *) from;
{
    @try {
        [ContactNetServiceUtil sharedInstance].listClient = [[HttpClient alloc] init];
        
        NSString *url =[NSString stringWithFormat:@"%@/setting/getWorldContact?min=%@&max=%@&val=%@&from=%@",charUrl,[NSString stringWithFormat:@"%i",(int)min],[NSString stringWithFormat:@"%i",(int)max],searchText,from];
        NSString *data =[[ContactNetServiceUtil sharedInstance].listClient getRequestFromUrl:url error:nil];
        id jsonData = [data JSONValue];
        ResponseModel *response = [[ResponseModel alloc] init];
        //response.status = [self sharedInstance].listClient.
        response.error = [ContactNetServiceUtil sharedInstance].listClient.error;
        response.resultInfo = jsonData;
        return response;
    }
    @catch (NSException *exception) {
        NSLog(@"getSearchContact error:%@",exception);
        return nil;
    }
    @finally {
    }
}


-(id)inviteUserFrom:(NSString *)fromUser ToUser:(NSString *)toUser
{
    @try {
        [ContactNetServiceUtil sharedInstance].listClient = [[HttpClient alloc] init];
        
        NSString *url =[NSString stringWithFormat:@"%@/setting/sendInvitationMail?from=%@&to=%@",charUrl,fromUser,toUser];
        NSString *data =[[ContactNetServiceUtil sharedInstance].listClient getRequestFromUrl:url error:nil];
        id jsonData = [data JSONValue];
        ResponseModel *response = [[ResponseModel alloc] init];
        //response.status = [self sharedInstance].listClient.
        response.error = [ContactNetServiceUtil sharedInstance].listClient.error;
        response.resultInfo = jsonData;
        return response;
    }
    @catch (NSException *exception) {
        NSLog(@"getSearchContact error:%@",exception);
        return nil;
    }
    @finally {
    }

}

-(id)getOtherUserContactDeatail:(NSString *) otherUser From:(NSString *) from;
{
    @try {
        [ContactNetServiceUtil sharedInstance].listClient = [[HttpClient alloc] init];
        
        NSString *url =[NSString stringWithFormat:@"%@/setting/?user=%@&otheruser=%@",charUrl,from,otherUser];
        NSString *data =[[ContactNetServiceUtil sharedInstance].listClient getRequestFromUrl:url error:nil];
        id jsonData = [data JSONValue];
        ResponseModel *response = [[ResponseModel alloc] init];
        //response.status = [self sharedInstance].listClient.
        response.error = [ContactNetServiceUtil sharedInstance].listClient.error;
        response.resultInfo = jsonData;
        return response;
    }
    @catch (NSException *exception) {
        NSLog(@"getOtherUserContactDeatail error:%@",exception);
        return nil;
    }
    @finally {
    }
}

-(id)addFrineds:(NSString *)otherUser From:(NSString *)from
{
    @try {
        [ContactNetServiceUtil sharedInstance].listClient = [[HttpClient alloc] init];
        
        NSString *url =[NSString stringWithFormat:@"%@/setting/addFriends?from=%@&users=%@",charUrl,from,otherUser];
        NSString *data =[[ContactNetServiceUtil sharedInstance].listClient getRequestFromUrl:url error:nil];
        id jsonData = [data JSONValue];
        ResponseModel *response = [[ResponseModel alloc] init];
        //response.status = [self sharedInstance].listClient.
        response.error = [ContactNetServiceUtil sharedInstance].listClient.error;
        response.resultInfo = jsonData;
        return response;
    }
    @catch (NSException *exception) {
        NSLog(@"addFrineds error:%@",exception);
        return nil;
    }
    @finally {
    }
}
-(id)deleteFrineds:(NSString *)otherUser From:(NSString *)from
{
    @try {
        [ContactNetServiceUtil sharedInstance].listClient = [[HttpClient alloc] init];
        NSString *url =[NSString stringWithFormat:@"%@/setting/deleteFriend?from=%@&user=%@",charUrl,from,otherUser];
        NSString *data =[[ContactNetServiceUtil sharedInstance].listClient getRequestFromUrl:url error:nil];
        id jsonData = nil;
        if (data) {
            jsonData  = [data JSONValue];
            if (!jsonData) {
                jsonData =data;
            }
        }
        ResponseModel *response = [[ResponseModel alloc] init];
        //response.status = [self sharedInstance].listClient.
        response.error = [ContactNetServiceUtil sharedInstance].listClient.error;
        response.resultInfo = jsonData;
        return response;
    }
    @catch (NSException *exception) {
        NSLog(@"deleteFrineds error:%@",exception);
        return nil;
    }
    @finally {
    }

}
-(id)deleteMember:(NSString *)otherUser From:(NSString *)from GroupId:(NSString *)groupId
{
    @try {
        [ContactNetServiceUtil sharedInstance].listClient = [[HttpClient alloc] init];
        NSString *url =[NSString stringWithFormat:@"%@/session_add/deletemember?from=%@&principalName=%@&groupid=%@",charUrl,from,otherUser,groupId];
        NSString *data =[[ContactNetServiceUtil sharedInstance].listClient getRequestFromUrl:url error:nil];
        id jsonData = nil;
        if (data) {
            jsonData  = [data JSONValue];
            if (!jsonData) {
                jsonData =data;
            }
        }
        ResponseModel *response = [[ResponseModel alloc] init];
        //response.status = [self sharedInstance].listClient.
        response.error = [ContactNetServiceUtil sharedInstance].listClient.error;
        response.resultInfo = jsonData;
        return response;
    }
    @catch (NSException *exception) {
        NSLog(@"deleteMember error:%@",exception);
        return nil;
    }
    @finally {
    }
}

-(id)addMember:(NSString *) contactUser From:(NSString *) from GroupId:(NSString *)groupId NickUser:(NSString *)nickUser
{
    @try {
        [ContactNetServiceUtil sharedInstance].listClient = [[HttpClient alloc] init];
        NSString *url =[NSString stringWithFormat:@"%@/session_add/adduser?from=%@&adduser=%@&groupid=%@&nickuser=%@",charUrl,from,contactUser,groupId,nickUser];
        NSString *data =[[ContactNetServiceUtil sharedInstance].listClient getRequestFromUrl:url error:nil];
        id jsonData = nil;
        if (data) {
            jsonData  = [data JSONValue];
            if (!jsonData) {
                jsonData =data;
            }
        }
        ResponseModel *response = [[ResponseModel alloc] init];
        //response.status = [self sharedInstance].listClient.
        response.error = [ContactNetServiceUtil sharedInstance].listClient.error;
        response.resultInfo = jsonData;
        return response;
    }
    @catch (NSException *exception) {
        NSLog(@"addMember error:%@",exception);
        return nil;
    }
    @finally {
    }
}
//
-(id)saveGroupTitleFun:(NSString *)groupId Name:(NSString *)groupName User:(NSString *)user
{
    @try {
        [ContactNetServiceUtil sharedInstance].listClient = [[HttpClient alloc] init];
        NSString *url =[NSString stringWithFormat:@"%@/setting/saveGroupTitleFun?groupid=%@&msg=%@&from=%@",charUrl,groupId,groupName,user];
        NSString *data =[[ContactNetServiceUtil sharedInstance].listClient getRequestFromUrl:url error:nil];
        id jsonData = nil;
        if (data) {
            jsonData  = [data JSONValue];
            if (!jsonData) {
                jsonData =data;
            }
        }
        ResponseModel *response = [[ResponseModel alloc] init];
        //response.status = [self sharedInstance].listClient.
        response.error = [ContactNetServiceUtil sharedInstance].listClient.error;
        response.resultInfo = jsonData;
        return response;
    }
    @catch (NSException *exception) {
        NSLog(@"saveGroupTitleFun error:%@",exception);
        return nil;
    }
    @finally {
    }
}
-(id)checkIsSingleChat:(NSString *)groupId
{
    @try {
        [ContactNetServiceUtil sharedInstance].listClient = [[HttpClient alloc] init];
        NSString *url =[NSString stringWithFormat:@"%@/setting/setgroup?groupid=%@",charUrl,groupId];
        NSString *data =[[ContactNetServiceUtil sharedInstance].listClient getRequestFromUrl:url error:nil];
        id jsonData = nil;
        if (data) {
            jsonData  = [data JSONValue];
            if (!jsonData) {
                jsonData =data;
            }
        }
        ResponseModel *response = [[ResponseModel alloc] init];
        //response.status = [self sharedInstance].listClient.
        response.error = [ContactNetServiceUtil sharedInstance].listClient.error;
        response.resultInfo = jsonData;
        return response;
    }
    @catch (NSException *exception) {
        NSLog(@"saveGroupTitleFun error:%@",exception);
        return nil;
    }
    @finally {
    }

}
-(id)getWCForGroupByGroupId:(NSString *)groupId From:(NSString *)from Val:(NSString *)val min:(NSInteger)min max:(NSInteger)max
{
    @try {
        [ContactNetServiceUtil sharedInstance].listClient = [[HttpClient alloc] init];
        NSString *url =[NSString stringWithFormat:@"%@/setting/getWCForGroupByGroupId?groupid=%@&from=%@&val=%@&min=%li&max=%li",charUrl,groupId,from,val,(long)min,(long)max];
        NSString *data =[[ContactNetServiceUtil sharedInstance].listClient getRequestFromUrl:url error:nil];
        id jsonData = nil;
        if (data) {
            jsonData  = [data JSONValue];
//            if (!jsonData) {
//                jsonData =data;
//            }
        }
        ResponseModel *response = [[ResponseModel alloc] init];
        //response.status = [self sharedInstance].listClient.
        response.error = [ContactNetServiceUtil sharedInstance].listClient.error;
        response.resultInfo = jsonData;
        return response;
    }
    @catch (NSException *exception) {
        NSLog(@"saveGroupTitleFun error:%@",exception);
        return nil;
    }
    @finally {
    }

}
@end
