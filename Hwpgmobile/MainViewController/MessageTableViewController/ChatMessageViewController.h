//
//  ChatMessageViewController.h
//  Chat
//
//  Created by hwpl hwpl on 14-10-30.
//  Copyright (c) 2014年 hwpl hwpl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XHMessageTableViewController.h"
#import "SocketIO.h"
#import "SocketIOConnect.h"
#import "FacialView.h"
@interface ChatMessageViewController : XHMessageTableViewController<SocketIODelegate,UIAlertViewDelegate>
+(ChatMessageViewController *)shareInstance;
+(void) dealloc;
@property(nonatomic,retain)NSString *groupId;
@property(nonatomic,retain)NSString *nickName;
@property(nonatomic,retain)NSString *groupTitle;
-(void)sendMsg:(NSDictionary *)dic Event:(NSString *)event;
@end
