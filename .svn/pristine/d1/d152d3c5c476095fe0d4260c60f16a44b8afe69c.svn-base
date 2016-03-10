//
//  ManageNetServiceUitl.m
//  HwpgMobile
//
//  Created by hwpl hwpl on 14-12-3.
//  Copyright (c) 2014年 hwpl hwpl. All rights reserved.
//

#import "ManageNetServiceUitl.h"
#import "HttpClient.h"
#import "ErrorModel.h"
#import "ResponseModel.h"
#import "JSON.h"

static ManageNetServiceUitl *instance;


@interface ManageNetServiceUitl ()
@property(nonatomic,retain) HttpClient *listClient;
@end

@implementation ManageNetServiceUitl
@synthesize  listClient;

+(ManageNetServiceUitl *)sharedInstance
{
    @synchronized(self)
    {
        if(instance ==nil)
        {
            instance = [[ManageNetServiceUitl alloc] init];
        }
    }
    return instance;
}
-(id)dropGroupFrunFrom:(NSString *)from GroupId:(NSString *)groupId;
{
    @try {
        [ManageNetServiceUitl sharedInstance].listClient = [[HttpClient alloc] init];
        NSString *url =[NSString stringWithFormat:@"%@/setting/dropGroupFun?from=%@&groupid=%@",charUrl,from,groupId];
        NSString *data =[[ManageNetServiceUitl sharedInstance].listClient getRequestFromUrl:url error:nil];
        id jsonData = [data JSONValue];
        ResponseModel *response = [[ResponseModel alloc] init];
        //response.status = [self sharedInstance].listClient.
        response.error = [ManageNetServiceUitl sharedInstance].listClient.error;
        response.resultInfo = jsonData;
        return response;
    }
    @catch (NSException *exception) {
        NSLog(@"dropGroupFrunFrom error:%@",exception);
        return nil;
    }
    @finally {
    }
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
