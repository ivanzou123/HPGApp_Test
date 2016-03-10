//
//  AppDelegate.h
//  Chart
//
//  Created by hwpl hwpl on 14-10-28.
//  Copyright (c) 2014年 hwpl hwpl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "BottomTableView.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property(nonatomic,retain)UITabBarController *tabBarController;
@property(nonatomic,retain)BottomTableView *bottomBarView;

@end

