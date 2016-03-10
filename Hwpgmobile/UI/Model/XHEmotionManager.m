//
//  MessageModel.m
//  Chat
//
//  Created by ivan on 14-10-30.
//  Copyright (c) 2014年 hwpl hwpl. All rights reserved.
//

#import "XHEmotionManager.h"

@implementation XHEmotionManager

- (void)dealloc {
    [self.emotions removeAllObjects];
    self.emotions = nil;
}

@end
