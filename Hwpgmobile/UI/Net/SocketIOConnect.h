//
//  SocketIOConnect.h
//  Chat
//
//  Created by hwpl hwpl on 14-10-31.
//  Copyright (c) 2014年 hwpl hwpl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SocketIO.h"
@interface SocketIOConnect : NSObject<SocketIODelegate>
@property(nonatomic,retain) id<SocketIODelegate> socketIDDelegate;
@property(nonatomic,retain)SocketIO *socketIOClient;
+(SocketIOConnect *)sharedInstance;
-(BOOL)doConnect;
@end
