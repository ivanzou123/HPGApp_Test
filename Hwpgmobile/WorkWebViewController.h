//
//  WorkWebViewController.h
//  HwpgMobile
//
//  Created by hwpl on 15/3/19.
//  Copyright (c) 2015年 hwpl hwpl. All rights reserved.
//



#import <UIKit/UIKit.h>
@interface WorkWebViewController : UIViewController<UIWebViewDelegate>
-(WorkWebViewController *)initWithUrl:(NSString *)url;
-(void)reloadHtml;
@end
