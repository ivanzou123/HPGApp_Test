//
//  PushNotificationUtil.m
//  HwpgMobile
//
//  Created by test on 11/17/14.
//  Copyright (c) 2014 hwpl hwpl. All rights reserved.
//

#import "HttpClient.h"
#import "ErrorModel.h"
#import "ResponseModel.h"
#import "JSON.h"
#import "PushNotificationUtil.h"
#import "APService.h"
#import "CommUtilHelper.h"

@implementation PushNotificationUtil
//jpush,register
+ (void)pushNotificationSetup:(NSDictionary *) launchOptions
{
    // Required
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [APService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                       UIUserNotificationTypeSound |
                                                       UIUserNotificationTypeAlert)
                                           categories:nil];
    } else {
        //categories 必须为nil
        [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                       UIRemoteNotificationTypeSound |
                                                       UIRemoteNotificationTypeAlert)
                                           categories:nil];
    }
#else
    //categories 必须为nil
    [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                   UIRemoteNotificationTypeSound |
                                                   UIRemoteNotificationTypeAlert)
                                       categories:nil];
#endif
    // Required
    [APService setupWithOption:launchOptions];
}
//将通知注册信息保存到服务器
+ (BOOL)saveRegistrationInfo
{
    NSUserDefaults *userInfo = [NSUserDefaults standardUserDefaults];
    NSString *userPrincipalName = (NSString *)[userInfo objectForKey:@"user"];
    NSData *deviceToken = (NSData *)[userInfo objectForKey:@"deviceToken"];
    if (deviceToken == nil) {
        
    }
    NSString *registrationId = [APService registrationID];
    NSString *deviceId = [CommUtilHelper getDeviceId];
    NSString *deviceType = @"IOS";
    NSString *tag = userPrincipalName;
    NSString *alias = userPrincipalName;
    NSMutableString *regStatus = [[NSMutableString alloc] initWithString:@""];
    NSUserDefaults *pushDefault = [NSUserDefaults standardUserDefaults];
    if(nil == deviceToken){
        [regStatus appendString:@"DEVICE_TOKEN_FAILURE"];
        //[pushDefault setObject:@"NO" forKey:@"pushNotification"];
    }else{
        [regStatus appendString:@"DEVICE_TOKEN_SUCCESS"];
        //[pushDefault setObject:@"YES" forKey:@"pushNotification"];
    }
    if(nil == registrationId){
        [regStatus appendString:@",REG_JPUSH_FAILURE"];
        //[pushDefault setObject:@"NO" forKey:@"pushNotification"];
    }else{
        [regStatus appendString:@",REG_JPUSH_SUCCESS"];
       // [pushDefault setObject:@"YES" forKey:@"pushNotification"];
    }
    HttpClient *client = [[HttpClient alloc] init];
    NSString *url =[NSString stringWithFormat:@"%@/pushNotification/reg?userPrincipalName=%@&deviceId=%@&deviceType=%@&regId=%@&tag=%@&alias=%@&deviceToken=%@&regStatus=%@",charUrl,userPrincipalName,deviceId,deviceType,registrationId,tag,alias,deviceToken,regStatus];
    NSLog(@"saveRegistrationInfo");
    NSString *result = [client getRequestFromUrl:url error:nil];
    if([@"1" isEqualToString:result]){
        NSLog(@"推送通知注册信息保存成功.");
        [pushDefault setObject:@"YES" forKey:@"pushNotification"];
        return YES;
    }else{
        NSLog(@"推送通知注册信息保存失败.");
        [pushDefault setObject:@"NO" forKey:@"pushNotification"];
        return NO;
    }
}
//清除推送通知记数标识
+ (void)clearBadge:(NSInteger)count;
{
    [APService setBadge:count];
    //[[UIApplication sharedApplication] setApplicationIconBadgeNumber:1];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:count];
}
@end
