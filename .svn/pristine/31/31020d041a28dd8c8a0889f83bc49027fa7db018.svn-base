//
//  CustomLoadingView.m
//  HwpgMobile
//
//  Created by hwpl hwpl on 14-11-24.
//  Copyright (c) 2014年 hwpl hwpl. All rights reserved.
//

#import "CustomLoadingView.h"

@implementation CustomLoadingView
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
    custView = [[UIView alloc ] initWithFrame:frame];
    [custView setBackgroundColor:[UIColor clearColor]];
    disView = [[UIView alloc] initWithFrame:CGRectMake(frame.size.width/2-50, frame.size.height/2-40, 100, 80)];
    [disView.layer  setShadowOpacity:0.5 ];
    [disView.layer setCornerRadius:10];
    [disView.layer setBackgroundColor:[UIColor blackColor].CGColor];
    [disView.layer setBorderWidth:1];
    [disView setAlpha:0.5];
    
    lblName = [[UILabel alloc] initWithFrame:CGRectMake(5, 10, 95, 40)];
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
    
    //        lblSite = [[UILabel alloc] initWithFrame:CGRectMake(30, 50, 40, 40)];
    //        [lblSite setTextColor:[UIColor blueColor]];
    //        [lblSite setFont:[UIFont boldSystemFontOfSize:20]];
    //        [lblSite setBackgroundColor:[UIColor clearColor]];
    //        [lblSite setTextAlignment:NSTextAlignmentCenter];
    //        [lblSite setNumberOfLines:0];
    //        [lblSite setTag:802];
    //        [lblSite.layer setShadowOpacity:0.5];
    //        [lblSite.layer setShadowColor:[UIColor blackColor].CGColor];
    //        [lblSite.layer setShadowOffset:CGSizeMake(5, 3)];
    //        [self addSubview: lblSite];
    
    actView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [actView setTag:900];
    [actView setBackgroundColor:[UIColor clearColor]];
    //[actView setCenter:self.center];
    [actView setFrame:CGRectMake(lblName.frame.size.width/2-5, lblName.frame.origin.y+40, 10, 20)];
    //[actView setFrame:CGRectMake(140, 200, 20, 20)];
    [actView startAnimating];
    [disView addSubview:actView];
    [custView addSubview:disView];
    return custView;

}
@end
