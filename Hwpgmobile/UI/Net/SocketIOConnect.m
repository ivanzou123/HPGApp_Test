//
//  SocketIOConnect.m
//  Chat
//
//  Created by hwpl hwpl on 14-10-31.
//  Copyright (c) 2014年 hwpl hwpl. All rights reserved.
//


#import "SocketIOConnect.h"

static SocketIOConnect *socketIOConnect =nil;



@implementation SocketIOConnect
@synthesize socketIOClient;

+ (SocketIOConnect*) sharedInstance  //第二步：实例构造检查静态实例是否为nil
{
    @synchronized (self)
    {
        if (socketIOConnect == nil)
        {
            socketIOConnect = [[self alloc] init];
            
        }
    }
    return socketIOConnect;
}

-(instancetype)init
{
    if ([super init]) {
        socketIOClient = [[SocketIO alloc] initWithDelegate:self];
    }
    return self;
}

+ (id) allocWithZone:(NSZone *)zone //第三步：重写allocWithZone方法
{
    @synchronized (self) {
        if (socketIOConnect == nil) {
            socketIOConnect = [super allocWithZone:zone];
            return socketIOConnect;
        }
    }
    return nil;
}

- (id) copyWithZone:(NSZone *)zone //第四步
{
    return self;
}

-(BOOL)doConnect
{
    if (socketIOClient.isConnected ==YES) {
        return true;
    }
    //pass cookies to handshake endpoint
    NSDictionary *properties = [NSDictionary dictionaryWithObjectsAndKeys:
                                socketIp,NSHTTPCookieDomain,
                                @"/",NSHTTPCookiePath,
                                @"auth",NSHTTPCookieName,
                                @"56cdea63acdf132",NSHTTPCookieValue,
                                nil];
    NSHTTPCookie *cookie = [NSHTTPCookie cookieWithProperties:properties];
    socketIOClient.cookies =[NSArray arrayWithObjects:cookie,nil];
    //connect to socket.io server
    //[socketIOClient connect]
    if ([@"https" isEqualToString: httpDelegate]) {
        socketIOClient.useSecure=YES;
    }
    
    [socketIOClient connectToHost:socketIp onPort:socketPort];
    //[socketIOClient connectToHost:host onPort:hostport];
    return true;
}





@end
