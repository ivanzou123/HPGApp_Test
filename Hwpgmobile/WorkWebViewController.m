//
//  WorkWebViewController.m
//  HwpgMobile
//
//  Created by hwpl on 15/3/19.
//  Copyright (c) 2015年 hwpl hwpl. All rights reserved.
//

#import "WorkWebViewController.h"
#import "ApproveServiceUtil.h"
#import "JSON.h"
#import "AppDelegate.h"
#import "NSURLRequest+ForSSL.h"
#import "NSString+FontAwesome.h"

@interface WorkWebViewController ()<UITabBarControllerDelegate>
{
    UIWebView *htmlView;
    
    UIActivityIndicatorView *activityIndicatorView;
    UIView *view;
    UIButton *erroRButton;
    NSString *reurl;
    BOOL Numcontrol;
}
@end

@implementation WorkWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     //self.navigationController.navigationBar.hidden=YES;
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.tabBarController.delegate = self;
    Numcontrol = YES;
    self.navigationController.navigationBar.hidden=YES;
   //    activityIndicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
//    [activityIndicatorView setCenter:self.view.center];
//    [activityIndicatorView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
//    [self.view addSubview:activityIndicatorView];
//     [self.view setBackgroundColor:[UIColor grayColor]];
    //webview 显示层
    //设置left button
//    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [backBtn setFrame:CGRectMake(-5, 0, 25, 25)];
//    [backBtn setTitle:@"" forState:UIControlStateNormal];
//    [backBtn setImage:[UIImage imageNamed:@"back@2x.png"] forState:UIControlStateNormal];
//    [backBtn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
//    backBtn.backgroundColor = [UIColor clearColor];
    
//    UILabel *backLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, backBtn.frame.size.width, backBtn.frame.size.height)];
//    backLabel.text = @"";
//    backLabel.textAlignment = NSTextAlignmentLeft;
//    backLabel.textColor = [UIColor whiteColor];
//    backLabel.backgroundColor = [UIColor clearColor];
//    backLabel.font = [UIFont fontWithName:kFontAwesomeFamilyName size:36];
//    backLabel.text = [NSString fontAwesomeIconStringForEnum:FAAngleLeft];
//    [backBtn addSubview:backLabel];
    
//    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
//    self.navigationItem.leftBarButtonItem = backItem;
}
-(void)viewWillDisappear:(BOOL)animated
{
    [htmlView removeFromSuperview];
    htmlView = nil;
    [self.navigationController popToRootViewControllerAnimated:YES];
}
//
-(void)goBack
{
    if(htmlView.canGoBack) {
        [htmlView goBack];
    }else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}


-(WorkWebViewController *)initWithUrl:(NSString *)url
{
    if ([super init]) {
        reurl = url;
        view = [[UIView alloc] initWithFrame:CGRectMake(0,0,screenWidth, screenHeight)];
        [view setBackgroundColor:[UIColor grayColor]];
        htmlView =[[UIWebView alloc] initWithFrame:CGRectMake(0,0,screenWidth, screenHeight)];
        
        [htmlView setBackgroundColor:[UIColor grayColor]];
        htmlView.scrollView.bounces=YES;
        
        [(UIScrollView *)[[htmlView subviews] objectAtIndex:0] setBounces:YES];
        [htmlView sizeToFit];
        [htmlView setBackgroundColor:[UIColor whiteColor]];
        [htmlView setScalesPageToFit:YES];
        htmlView.allowsInlineMediaPlayback=NO;
        htmlView.delegate=self;
        [self.view addSubview:htmlView];
        
        activityIndicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        [activityIndicatorView setCenter:view.center];
        [activityIndicatorView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
        [view addSubview:activityIndicatorView];
        [self.view addSubview:view];
    }
    return  self;
}


-(id)jsonToDic:(NSString *)str
{
    
    NSData* data2 = [str dataUsingEncoding:NSASCIIStringEncoding];
    __autoreleasing NSError* error1 = nil;
    id result1 = [NSJSONSerialization JSONObjectWithData:data2 options:NSJSONReadingAllowFragments error:&error1];
    return result1;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)webViewDidStartLoad:(UIWebView *)webView
{
    view.hidden=NO;
    [activityIndicatorView startAnimating];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    view.hidden=YES;
    NSLog(@"%d" ,webView.canGoBack);
    [activityIndicatorView stopAnimating];
   
}
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    
    view.hidden=YES;
    [activityIndicatorView stopAnimating];
    
//    erroRButton = [[UIButton alloc]  initWithFrame:CGRectMake(htmlView.frame.size.width/2-100, htmlView.frame.size.height/2-30, 200, 60)];
//    
//    [erroRButton addTarget:self action:@selector(loadError) forControlEvents:UIControlEventTouchUpInside];
//    [erroRButton.layer setBorderWidth:1];
//    [erroRButton setBackgroundColor:[UIColor orangeColor]];
//    [erroRButton.layer setBorderColor:[UIColor greenColor].CGColor];
//    [erroRButton.layer setCornerRadius:3];
//    [erroRButton.titleLabel setFont:[UIFont systemFontOfSize:13]];
//    [erroRButton setTitle:@"NetWork error click Reload" forState:UIControlStateNormal];
//    [erroRButton.titleLabel setTextAlignment:NSTextAlignmentJustified];
//    [erroRButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
//    [self.view addSubview:erroRButton];
//    [self.view bringSubviewToFront:erroRButton];
}

-(void)loadError
{
    
    [erroRButton removeFromSuperview];
    erroRButton = nil;
    view.hidden=NO;
    [activityIndicatorView startAnimating];
    
     [htmlView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:reurl]]];
}
-(void)viewDidDisappear:(BOOL)animated
{
    //[self initUnApproveNum];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)reloadHtml
{
     NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:reurl]];
    [NSURLRequest setAllowsAnyHTTPSCertificate:YES forHost:[[NSURL URLWithString:reurl] host]];
    [htmlView loadRequest:request];
}

@end
