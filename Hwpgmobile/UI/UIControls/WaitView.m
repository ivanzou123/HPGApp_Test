//
//  WaitView.m
//  FS
//
//  Created by hwpl hwpl on 14-10-20.
//  Copyright (c) 2014年 hwpl hwpl. All rights reserved.
//

#import "WaitView.h"

@implementation WaitView
@synthesize delegate;
@synthesize url;
@synthesize disView;
@synthesize reloadButton;
-(id)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:CGRectMake(0, navBarHeight, frame.size.width, frame.size.height)];
    if (self) {
        reloadButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [reloadButton setFrame:CGRectMake(self.frame.size.width/2-60, self.frame.size.height/2-20, 120, 40)];
        [reloadButton setTitle:@"点击重新加载" forState:UIControlStateNormal];
        reloadButton.titleLabel.font=[UIFont systemFontOfSize:16];
        [reloadButton.layer setBorderWidth:1];
        [reloadButton.layer setCornerRadius:8];
        [reloadButton setBackgroundColor:[UIColor colorWithRed:250/255.0 green:218/255.0 blue:185/255.0 alpha:0.8]];
        //[reloadButton.layer setBackgroundColor:[UIColor whiteColor].CGColor];
        reloadButton.hidden=YES;
        [reloadButton addTarget:self action:@selector(reloadView) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:reloadButton];
        
        //[self setBackgroundColor:[UIColor colorWithRed:225/255.0 green:225/255.0 blue:225/255.0 alpha:1.0f]];
        disView = [[UIView alloc] initWithFrame:CGRectMake(frame.size.width/2-50, self.frame.size.height/2-40, 100, 80)];
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
        [lblName setText:@"加载中...."];
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
        [self addSubview:disView];
        
        
    }
    return self;
}
//-(void)setFrame:(CGRect)frame
//{
//    [super setFrame:frame];
//    [lblName setFrame:CGRectMake(0, self.frame.size.height/2-80, frame.size.width, lblName.frame.size.height)];
//    [lblSite setFrame:CGRectMake(0, self.frame.size.height/2-30, frame.size.width, lblSite.frame.size.height)];
//    //[actView setCenter:self.center];
//    [actView setFrame:CGRectMake(140, 300, 20, 20)];
//}
-(void)showTouchView
{
    [disView setHidden:YES];
    [reloadButton setHidden:NO];
    //[self setBackgroundColor:[UIColor colorWithRed:225/255.0 green:225/255.0 blue:225/255.0 alpha:1.0f]];
}
-(void)setDisplayText:(NSString *)text
{
    [self showTouchView];
    [actView stopAnimating];
    isDownLoadFailed=YES;
}
-(void)setLoadingViewStart
{
    [actView startAnimating];
}
-(void)setLoadingViewEnd
{
    [actView startAnimating];
}
-(void)setErrorView
{
    [self showTouchView];
    //NSLog(@"errorview:%@",reloadButton.hidden?@"1":@"2");
    isDownLoadFailed=YES;
}
-(void)setDisplayText:(NSString *)text url:(NSString *)_url
{
    [self setDisplayText:text];
    self.url=_url;
}
-(void)reloadView
{
    [self setBackgroundColor:[UIColor clearColor]];
    [reloadButton setHidden:YES];
    [disView setHidden:NO];
    [actView startAnimating];
    if(isDownLoadFailed)
    {
        isDownLoadFailed =NO;
        [self restart];
        if([delegate respondsToSelector:@selector(waitViewTap:)])
        {
            [delegate waitViewTap:url];
        }
    }
}
//-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
//  if(isDownLoadFailed)
//  {
//      isDownLoadFailed =NO;
//      [self restart];
//      if([delegate respondsToSelector:@selector(waitViewTap:)])
//      {
//          [delegate waitViewTap:url];
//      }
//  }
//}
-(void)restart
{
    [lblName setText:@"加载中..."];
    [actView startAnimating];
}
@end
