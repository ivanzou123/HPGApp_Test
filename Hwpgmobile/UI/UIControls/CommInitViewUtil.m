//
//  CommInitViewUtil.m
//  MFS
//
//  Created by hwpl hwpl on 14-8-19.
//  Copyright (c) 2014年 hwpl hwpl. All rights reserved.
//

#import "CommInitViewUtil.h"
//#import "LeftRigthSliderController.h"
@implementation CommInitViewUtil

+(UIImageView *)initUIImageView:(NSString *)imageName Rect:(CGRect)rect
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:rect];
    [imageView setImage:[UIImage imageNamed:imageName]];
    return imageView;
}
+(UIButton *)initUIButtonView:(NSString *)title Rect:(CGRect)rect
{
    UIButton *button =[UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:rect];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    return button;
}
+(UIButton *)initUIButtonViewByImage:(NSString *)title Image:(NSString *)imageName Rect:(CGRect)rect
{
    return [UIButton buttonWithType:UIButtonTypeCustom];
}

+(UIView *)initNavBarView:(NSString *)textLable  Rect:(CGRect)rect BarWith:(float)BarWidth BarHeight:(float)BarHeight

{
    
    UIView  *navBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, BarWidth, BarHeight)];
    navBar.backgroundColor = [UIColor clearColor];
    navBar.alpha=0.8;
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0, [UIApplication sharedApplication].statusBarFrame.size.height, 44, 44);
    [leftButton setTitle:@"左" forState:UIControlStateNormal];
    [leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(leftBarClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(BarWidth-44, [UIApplication sharedApplication].statusBarFrame.size.height, 44, 44);
    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(rightBarClick) forControlEvents:UIControlEventTouchUpInside];
    [rightButton setTitle:@"右" forState:UIControlStateNormal];
    [navBar addSubview: leftButton];
    [navBar addSubview: rightButton];
    
    UILabel *titleLable = [[UILabel alloc] initWithFrame:CGRectMake(rect.size.width/2-40, [UIApplication sharedApplication].statusBarFrame.size.height, 80, 40)];
    [titleLable setTextAlignment:NSTextAlignmentCenter];
    [titleLable setTextColor:[UIColor whiteColor]];
    [titleLable setText:textLable];
    [navBar addSubview:titleLable];
    [navBar setBackgroundColor:[UIColor blackColor]];
    return navBar;
    
}
//+(void) leftBarClick
//{
//    [[LeftRigthSliderController sharedSliderController] leftBarClick];
//}
//+(void)rightBarClick
//{
//    [[LeftRigthSliderController sharedSliderController] rightBarClick];
//}
//动画构造
+(void)pushAnimationWithType:(NSString *) transType ViewController:(UIViewController *) Controller
{
    CATransition *animation = [CATransition animation];
    [animation setDuration:0.6];
    [animation setType: transType];
    [animation setSubtype: kCATransitionFromTop];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
    //return  animation;
    
    
    //CATransition *animation = [CommInitViewUtil animationWithType:kCATransitionFromRight];
//    
//    [LeftRigthSliderController sharedSliderController].navigationController.navigationBarHidden=NO;
//    [[LeftRigthSliderController sharedSliderController].navigationController pushViewController:Controller animated:NO];
//    
//    
//    [[LeftRigthSliderController sharedSliderController].navigationController.view.layer addAnimation:animation forKey:nil];
}
@end
