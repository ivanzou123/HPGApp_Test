//
//  XHBaseViewController.h
//  MessageDisplayExample
//
//  Created by hwpl hwpl on 14-12-2.
//  Copyright (c) 2014年 hwpl hwpl. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^XHBarButtonItemActionBlock)(void);

typedef NS_ENUM(NSInteger, XHBarbuttonItemStyle) {
    XHBarbuttonItemStyleSetting = 0,
    XHBarbuttonItemStyleMore,
    XHBarbuttonItemStyleCamera,
};

@interface XHBaseViewController : UIViewController

/**
 *  统一设置背景图片
 *
 *  @param backgroundImage 目标背景图片
 */
- (void)setupBackgroundImage:(UIImage *)backgroundImage;

/**
 *  push新的控制器到导航控制器
 *
 *  @param newViewController 目标新的控制器对象
 */
- (void)pushNewViewController:(UIViewController *)newViewController;

/**
 *  显示加载的loading，没有文字的
 */
- (void)showLoading;
/**
 *  显示带有某个文本加载的loading
 *
 *  @param text 目标文本
 */
- (void)showLoadingWithText:(NSString *)text;

- (void)showLoadingWithText:(NSString *)text onView:(UIView *)view;

/**
 *  显示成功的HUD
 */
- (void)showSuccess;
/**
 *  显示错误的HUD
 */
- (void)showError;

/**
 *  隐藏在该View上的所有HUD，不管有哪些，都会全部被隐藏
 */
- (void)hideLoading;

- (void)configureBarbuttonItemStyle:(XHBarbuttonItemStyle)style action:(XHBarButtonItemActionBlock)action;

@end
