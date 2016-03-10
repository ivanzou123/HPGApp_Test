//
//  AddContactUserViewController.h
//  HwpgMobile
//
//  Created by hwpl hwpl on 14-11-27.
//  Copyright (c) 2014年 hwpl hwpl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SocketIO.h"
#import "ChatMessageViewController.h"
@interface AddContactUserViewController : UITableViewController<UISearchBarDelegate,UISearchControllerDelegate,SocketIODelegate>
@property(nonatomic,retain) NSString *groupId;
@end
