//
//  FSMessageViewController.h
//  HPGApp
//
//  Created by hwpl on 15/10/23.
//  Copyright © 2015年 hwpl hwpl. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "XHMessageTableViewController.h"
#import "SocketIO.h"
#import "SocketIOConnect.h"
#import "FacialView.h"
#import "FSWebServiceUtil.h"
#import "SubscribeLoadingView.h"
@interface FSMessageViewController : XHMessageTableViewController<SocketIODelegate,UIAlertViewDelegate>

+(FSMessageViewController *)shareInstance;

@property(nonatomic,retain) SocketIO *socketClient;

+(void) dealloc;
@property(nonatomic,retain)NSString *groupId;
@property(nonatomic,retain)NSString *nickName;
@property(nonatomic,retain)NSString *groupTitle;
@property(nonatomic,retain)NSString *source;
-(void)sendMsg:(NSDictionary *)dic Event:(NSString *)event;

@end
