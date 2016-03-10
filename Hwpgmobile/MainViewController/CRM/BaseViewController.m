//
//  BaseViewController.m
//  MFS
//
//  Created by hwpl hwpl on 14-8-20.
//  Copyright (c) 2014年 hwpl hwpl. All rights reserved.
//
#define ImageViewWidth  100
#define ImageViewHeight 120

#define marginTop 100

#define kButtonNetSttingTag 501 //网络设置
#import "BaseViewController.h"

@interface BaseViewController ()

@property(nonatomic,retain)WaitView *loadingView;
@property (nonatomic,retain)UIImageView *bgImageView;
@property(nonatomic,retain)UIView *errorView;

@end

@implementation BaseViewController
@synthesize  loadingView;
@synthesize  errorView;
@synthesize bgImageView=_bgImageView;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)loadView
{
    [super loadView];
   
    
    //    UIImageView *errorImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"NoNetWork.png"]];
    //    [errorImgView setFrame:CGRectMake((screenWidth-ImageViewWidth)/2, marginTop, ImageViewWidth, ImageViewHeight)];
    //    [errorView addSubview:errorImgView];
    //
    //    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    //    [btn setTag:kButtonNetSttingTag];
    //    [btn setFrame:CGRectMake((screenWidth-ImageViewWidth)/2, marginTop+ImageViewHeight+20, ImageViewWidth, ImageViewHeight)];
    //    [btn setTitle:@"点击加载视图" forState:UIControlStateNormal];
    //    [btn addTarget:self action:@selector(baseButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    //    [errorView addSubview:btn];
    
}
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isKindOfClass:[UIButton class] ]) {
        return NO;
    }
    return YES;
}
#pragma mark-private method
-(void)waitViewTap:(NSString *)url
{
    [self errorViewTapGesture:nil];
}
-(void)hideLoadingView
{
    [loadingView setDisplayText:@"" url:nil];
    [loadingView setHidden:YES];
    
    [self.view sendSubviewToBack:loadingView];
}
-(void)showLoadingView
{
    [self.view bringSubviewToFront:loadingView];
   
    [loadingView.reloadButton setHidden:YES];
    [loadingView setHidden:NO];
}
-(void)errorViewTapGesture:(UITapGestureRecognizer *)tapGesture
{
    [errorView setHidden:YES];
    [self showLoadingView];
}
-(void)showErrorView
{
    //[loadingView setDisplayText:nil];
    [loadingView setErrorView];
}
-(void)baseButtonClick:(UIButton *)button
{
    switch (button.tag) {
        case kButtonNetSttingTag:
            
            break;
            
        default:
            break;
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithRed:242/255.0f green:242/255.0f blue:246/255.0f alpha:1.0f]];
    
    self.loadingView=[[WaitView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.width, self.view.frame.size.width, self.view.frame.size.height)];
    [self.loadingView setDelegate:self];
    [self.view addSubview:self.loadingView];
    self.loadingView.hidden=YES;
    
//    errorView = [[UIView alloc] initWithFrame:CGRectMake(0, navBarHeight, screenWidth, screenHeight)];
//    [errorView setBackgroundColor:[UIColor colorWithCGColor:[UIColor blueColor].CGColor]];
//    [errorView setHidden:YES];
//    [self.view addSubview:errorView];
//    
//    UITapGestureRecognizer *errorTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(errorViewTapGesture:)];
//    [errorTap setDelegate:self];
//    [errorView addGestureRecognizer:errorTap];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
