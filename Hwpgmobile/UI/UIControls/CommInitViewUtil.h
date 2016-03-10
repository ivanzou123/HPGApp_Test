//
//  CommInitViewUtil.h
//  MFS
//
//  Created by hwpl hwpl on 14-8-19.
//  Copyright (c) 2014年 hwpl hwpl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommInitViewUtil : UIView
+(UIImageView *)initUIImageView:(NSString *)imageName Rect:(CGRect) rect;
+(UIButton *) initUIButtonView:(NSString *) title Rect:(CGRect) rect;
+(UIButton *) initUIButtonViewByImage:(NSString *)title Image:(NSString *)imageName Rect:(CGRect) rect;
+(UIView *)initNavBarView:(NSString *)textLable  Rect:(CGRect)rect BarWith:(float)BarWidth BarHeight:(float)BarHeight;
+(void)pushAnimationWithType:(NSString *) transType ViewController:(UIViewController *) Controller;
@end
