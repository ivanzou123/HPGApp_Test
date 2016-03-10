//
//  AppDelegate.m
//  Chart
//
//  Created by hwpl hwpl on 14-10-28.
//  Copyright (c) 2014年 hwpl hwpl. All rights reserved.
//

#import "AppDelegate.h"
#import "APService.h"
#import "PushNotificationUtil.h"
#import "BottomTableView.h"

#import "ChatViewController.h"
#import "ChatMessageViewController.h"
#import "ContactViewController.h"
#import "SettingViewController.h"
#import "LoginViewController.h"

#import "eChatDAO.h"
#import "CommUtilHelper.h"


@interface AppDelegate ()
{
    BOOL fromBackgroud;
}
@end

@implementation AppDelegate
@synthesize tabBarController;
@synthesize bottomBarView;

-(void)initDataBase
{
    BOOL isCrete =  [[eChatDAO sharedChatDao] creteTable];
    if (!isCrete) {
        NSLog(@"-----初始化数据库失败----");
    }
    
    assert(isCrete);
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
   
    fromBackgroud = NO;
    [self initDataBase];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    self.window=[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds ] ];
    self.window.backgroundColor = [CommUtilHelper getDefaultBackgroupColor];
    LoginViewController *loginVC = [[LoginViewController alloc] init];
    self.window.rootViewController = loginVC;
    [self.window makeKeyAndVisible];
    //设置推送
    [NSThread detachNewThreadSelector:@selector(pushNotificationSetup:) toTarget:self withObject:launchOptions];
    //如果此建值不为空，表示是由点击远程通知启动;否则此键值为空
    NSDictionary *remoteNotifiction = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    [[CommUtilHelper sharedInstance] clearRemoteNotic];
    [[CommUtilHelper sharedInstance] setRemoteNotic:remoteNotifiction];
    //
    return YES;
}
-(void)pushNotificationSetup:(NSDictionary *)launchOptions
{
    [PushNotificationUtil pushNotificationSetup:launchOptions];
    //清除推送通知记数标识
    //[PushNotificationUtil clearBadge];
}
//jpush,get deviceToken from APN,then upload to jpush server
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSLog(@"deviceToken:%@",deviceToken);
    // Required
    //保存deviceToken
    [APService registerDeviceToken:deviceToken];
    NSUserDefaults *userInfo = [NSUserDefaults standardUserDefaults];
    [userInfo setObject:deviceToken forKey:@"deviceToken"];
}
//
-(void)registerToken:(NSData *)deviceToken
{
    //保存deviceToken
    NSUserDefaults *userInfo = [NSUserDefaults standardUserDefaults];
    [userInfo setObject:deviceToken forKey:@"deviceToken"];
    
}
//jpush,get notification
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    // Required
    [APService handleRemoteNotification:userInfo];
    //
    [[CommUtilHelper sharedInstance] setRemoteNotic:userInfo];
}
//jpush,get notification
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    // IOS 7 Support Required
    [APService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
    //
    [[CommUtilHelper sharedInstance] setRemoteNotic:userInfo];
}
//

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    fromBackgroud=YES;
    [[CommUtilHelper sharedInstance] clearRemoteNotic];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return (toInterfaceOrientation == UIInterfaceOrientationMaskPortrait|| toInterfaceOrientation==UIInterfaceOrientationMaskPortraitUpsideDown);
}

-(NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    return UIInterfaceOrientationMaskPortrait;
    
}
//
- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}
//
- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    //清除推送通知记数标识
    //[PushNotificationUtil clearBadge];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    ChatViewController *cVC=[ChatViewController sharedInstance];
    if(fromBackgroud && cVC){
        [[CommUtilHelper sharedInstance] pushVeiwByRemoteNotic:cVC.navigationController];
    }
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
