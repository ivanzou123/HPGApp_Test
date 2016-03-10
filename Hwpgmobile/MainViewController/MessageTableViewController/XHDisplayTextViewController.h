//
//  XHDisplayTextViewController.h
//  MessageDisplayExample
//
//  Created by hwpl hwpl on 14-12-2.
//  Copyright (c) 2014年 hwpl hwpl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XHBaseViewController.h"
#import "XHMessageModel.h"

@interface XHDisplayTextViewController : XHBaseViewController

@property (nonatomic, strong) id <XHMessageModel> message;

@end
