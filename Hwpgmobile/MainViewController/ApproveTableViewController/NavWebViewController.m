//
//  NavWebViewController.m
//  HPGApp
//
//  Created by hwpl on 15/11/23.
//  Copyright © 2015年 hwpl hwpl. All rights reserved.
//

#import "NavWebViewController.h"
#import "ApproveServiceUtil.h"
#import "JSON.h"
#import "AppDelegate.h"
#import "NSURLRequest+ForSSL.h"
@interface NavWebViewController ()
{
    UIWebView *htmlView;
    
    UIActivityIndicatorView *activityIndicatorView;
    UIView *view;
    UIButton *erroRButton;
    NSString *reurl;
    BOOL Numcontrol;
    UIBarButtonItem *leftBackBtn;
    UIBarButtonItem *leftCloseBtn;
}
@end

@implementation NavWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title =nil;
    self.title=@"";
    //self.navigationController.navigationBar.hidden=YES;
    [self.view setBackgroundColor:[UIColor whiteColor]];
       Numcontrol = YES;
    leftBackBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back@3x.png"] style:UIBarButtonItemStyleDone target:self action:@selector(goToBack:)];
    //leftBackBtn =[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleDone target:self action:@selector(goToBack:)];
    leftCloseBtn =[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon-close@3x.png"] style:UIBarButtonItemStyleDone target:self action:@selector(closeCon:)];
    self.navigationItem.leftBarButtonItem=leftBackBtn;
    
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"reload@3x.png"] style:UIBarButtonItemStyleDone target:self action:@selector(refreshWebView:)];
    self.navigationItem.rightBarButtonItem = rightButton;

}

-(void)refreshWebView:(UIBarButtonItem *)item
{
    NSString  *currentURL = htmlView.request.URL.absoluteString;
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:currentURL]];
    [NSURLRequest setAllowsAnyHTTPSCertificate:YES forHost:[[NSURL URLWithString:currentURL] host]];
    [htmlView loadRequest:request];
}

-(void)closeCon:(UIBarButtonItem *)item
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)goToBack:(UIBarButtonItem *)item
{
    if ([htmlView canGoBack]){
        self.navigationItem.leftBarButtonItems =[NSArray arrayWithObjects:leftBackBtn,leftCloseBtn, nil];
        [htmlView goBack];
    }else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
-(void)viewWillDisappear:(BOOL)animated
{
    [htmlView removeFromSuperview];
    htmlView = nil;
    //[self.navigationController popViewControllerAnimated:YES];
}

-(NavWebViewController *)initWithUrl:(NSString *)url
{
    if ([super init]) {
        //[self initUnApproveNum];
        reurl = url;
        
        view = [[UIView alloc] initWithFrame:CGRectMake(0,navBarHeight,screenWidth, screenHeight-navBarHeight)];
        [view setBackgroundColor:[UIColor grayColor]];
        htmlView =[[UIWebView alloc] initWithFrame:CGRectMake(0,navBarHeight,screenWidth, screenHeight-navBarHeight)];
        
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
    
    // [UIApplicationsharedApplication].networkActivityIndicatorVisible =NO;
    self.title =  [htmlView stringByEvaluatingJavaScriptFromString:@"document.title"];//获取
    
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

