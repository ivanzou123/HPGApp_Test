//
//  ChartViewController.h
//  Chart
//
//  Created by hwpl hwpl on 14-10-28.
//  Copyright (c) 2014年 hwpl hwpl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "SocketIO.h"
#import "SocketIOConnect.h"
#import "LoginViewController.h"
@interface ChatViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,SocketIODelegate>


+(ChatViewController *)sharedInstance;
+(void) dealloc;
-(void)reloadData;
@property(nonatomic,retain) SocketIO *socketClient;
@property(nonatomic,retain) UIImagePickerController *imagePicker;
@property(nonatomic,retain) UITableView *chartListView;
@property(nonatomic,retain) NSString *temMsg;

-(void)pushNextMessageViewController:(UIViewController *)controller;
-(void)sendMsg:(NSDictionary *)dic Event:(NSString *)event;
-(void)setBadageValue;
@end
