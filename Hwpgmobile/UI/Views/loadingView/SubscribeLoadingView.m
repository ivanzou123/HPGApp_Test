//
//  SubscribeLoadingView.m
//  HPGApp
//
//  Created by hwpl on 15/11/13.
//  Copyright © 2015年 hwpl hwpl. All rights reserved.
//

#import "SubscribeLoadingView.h"

@implementation SubscribeLoadingView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@synthesize disView;
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */
-(UIView *)getLoaidngViewByText:(NSString *)text Frame:(CGRect)frame
{

    
    disView = [[UIView alloc] initWithFrame:frame];
    //[disView.layer  setShadowOpacity:0.5 ];
    //[disView.layer setCornerRadius:10];
    [disView.layer setBackgroundColor:[UIColor colorWithRed:255/255.0 green:140/255.0 blue:0/255.0 alpha:0.8].CGColor];
    //[disView.layer setBorderWidth:1];
    //[disView setAlpha:0.5];
    
    lblName = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width/2-40, 3, 80, 25)];
    [lblName setTextColor:[UIColor grayColor]];
    [lblName setFont:[UIFont boldSystemFontOfSize:16]];
    [lblName setBackgroundColor:[UIColor clearColor]];
    [lblName setTextAlignment:NSTextAlignmentCenter];
    if (text) {
        [lblName setText:text];
    }else
    {
        [lblName setText:@"加载中...."];
    }
    
    [lblName setTextColor:[UIColor whiteColor]];
    [lblName setNumberOfLines:0];
    [lblName setTag:801];
    
    [disView addSubview: lblName];
    
    actView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [actView setTag:900];
    [actView setBackgroundColor:[UIColor clearColor]];
    
    [actView setFrame:CGRectMake(lblName.frame.origin.x+lblName.frame.size.width+12, 6, 10, 20)];

    [actView startAnimating];
    [disView addSubview:actView];
    
   
    
    return disView;
}

@end
