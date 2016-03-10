//
//  CommUtilView.m
//  Chart
//
//  Created by IVAN on 14-10-29.
//  Copyright (c) 2014年 hwpl hwpl. All rights reserved.
//

#import "CommUtilView.h"

@implementation CommUtilView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
+(UIButton *)initUIButton:(NSString *)title withFontSize:(NSInteger) fontSize Frame:(CGRect)frame Image:(NSString *)imageName
{
    UIButton *button =[UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame=frame;
    
    if (imageName) {
        [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    }
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    button.titleLabel.font=[UIFont systemFontOfSize:fontSize];
    
    return button;
}
+(UILabel *)initUIlable:(NSString *)title withFontSize:(NSInteger)fontSize withFrame:(CGRect)frame
{
    UILabel *lable = [[UILabel alloc] init];
    lable.frame=frame;
    lable.font=[UIFont systemFontOfSize:fontSize];
    lable.text=title;
    lable.textAlignment=NSTextAlignmentCenter;
    return lable;
}
+(UIView *)initUIView:(CGRect)frame
{
    UIView *view = [[UIView alloc] init];
    return view;
}
@end
