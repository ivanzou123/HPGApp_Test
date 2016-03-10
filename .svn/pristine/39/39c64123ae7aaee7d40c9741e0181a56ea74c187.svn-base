//
//  MenuButton.m
//  HPGApp
//
//  Created by hwpl on 15/11/25.
//  Copyright © 2015年 hwpl hwpl. All rights reserved.
//

#import "MenuButton.h"

@implementation MenuButton
@synthesize url;
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self= [super initWithFrame:frame]) {
        [self setBackgroundColor:kGetColor(245, 245, 245)];
        [self.layer setBorderWidth:1];
        [self setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [self.layer setBorderColor:kGetColor(220, 220, 220).CGColor];
        [self addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

-(void)buttonClick:(UIButton *)btn
{
    if (url) {
        if ([self.delegate respondsToSelector:@selector(meneButtonClicked:)]) {
            [self.delegate meneButtonClicked:url];
        }
    }
}
@end
