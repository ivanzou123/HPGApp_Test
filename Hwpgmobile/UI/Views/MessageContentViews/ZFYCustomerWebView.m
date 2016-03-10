//
//  ZFYCustomerWebView.m
//  HPGApp
//
//  Created by hwpl on 15/11/10.
//  Copyright © 2015年 hwpl hwpl. All rights reserved.
//

#import "ZFYCustomerWebView.h"

@implementation ZFYCustomerWebView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.userInteractionEnabled=NO;
        
    }
    return self;
}




@end
