//
//  SystemUpdateHelper.m
//  HPGApp
//
//  Created by hwpl on 15/10/20.
//  Copyright © 2015年 hwpl hwpl. All rights reserved.
//

#import "SystemUpdateHelper.h"
#import "PushNotificationUtil.h"
static SystemUpdateHelper *instance = nil;

@implementation SystemUpdateHelper

+(SystemUpdateHelper *)sharedInstance
{
    if (instance) {
        return instance;
    }else
    {
        instance = [[SystemUpdateHelper alloc] init];
        return instance;
    }
}

///清除所有消息bage
-(void)clearAllMessageBage
{
    NSUserDefaults *messageDefault = [NSUserDefaults standardUserDefaults];
    NSString *nssClearStatus = [messageDefault objectForKey:@"clearAllMessageStatus"];
    if (nssClearStatus == nil) {
        [messageDefault removeObjectForKey:@"messageCountArr"];
        [PushNotificationUtil clearBadge:0];
        [messageDefault setObject:@"OK" forKey:@"clearAllMessageStatus"];
    }
    
}

@end
