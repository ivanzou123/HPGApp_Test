//
//  EventViewController.h
//  HPGApp
//
//  Created by hwpl on 16/1/19.
//  Copyright © 2016年 hwpl hwpl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "SocketIO.h"
#import "SocketIOConnect.h"
#import "LoginViewController.h"
@interface EventViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,SocketIODelegate>

+(EventViewController *)sharedInstance;
+(void) dealloc;
-(void)reloadData;
@property(nonatomic,retain) SocketIO *socketClient;
@property(nonatomic,retain) UIImagePickerController *imagePicker;
@property(nonatomic,retain) UITableView *eventListView;
@property(nonatomic,retain) NSString *temMsg;

-(void)pushNextMessageViewController:(UIViewController *)controller;
-(void)sendMsg:(NSDictionary *)dic Event:(NSString *)event;
-(void)setBadageValue;
@end
