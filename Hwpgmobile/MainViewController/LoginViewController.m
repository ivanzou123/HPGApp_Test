
//
//  LoginViewController.m
//  Chart
//
//  Created by ivan on 14-10-28.
//  Copyright (c) 2014年 hwpl hwpl. All rights reserved.
//
#define newVersionTag 1000
#define retryTag 1005
#define TextWidth 280
#define TextHeight 40
#define gap 15
#import "LoginViewController.h"
#import "ChatViewController.h"

#import "ContactViewController.h"
#import "SettingViewController.h"
#import "BottomTableView.h"
#import "AppDelegate.h"
#import "CommUtilView.h"
#import "ResponseModel.h"
#import "ErrorModel.h"
#import "LoginNetServiceUtil.h"
#import "ApproveViewController.h"
#import "TestViewController.h"
#import "CharViewNetServiceUtil.h"
#import "eChatDAO.h"
#import "FormatTime.h"
#import "PushNotificationUtil.h"
#import "WorkViewController.h"
#import "CommUtilHelper.h"
#import "JSON.h"
#import "WorkWebViewController.h"
#import "SystemUpdateHelper.h"

@interface LoginViewController ()<UITextFieldDelegate>
{
    UITextField *userTextField;
    UITextField *passwordTextField;
    NSDictionary *userDic;
    UIImageView *disImageView;
    UIProgressView *proressView;
    UILabel *progressText;
    NSMutableDictionary *sysncArr;
    float currProgressValue;
    float totalProgressCounter;
    BOOL isFirstLogin;
    NSArray *methodArr;
    NSString *downloadUrl;
    UILabel *updateLable;
    
    }
@end

@implementation LoginViewController
@synthesize tabBarController;
@synthesize bottomBarView;
@synthesize isHasChangeAccount;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    updateLable = [[UILabel alloc] initWithFrame:CGRectMake(20, screenHeight/2-20, screenWidth-40, 60)];
    updateLable.text=@"Update in progress,please re-launch app after process completed";
    [updateLable setNumberOfLines:2];
    [updateLable setLineBreakMode:NSLineBreakByWordWrapping];
    [updateLable setFont:[UIFont boldSystemFontOfSize:13]];
    [updateLable setTextColor:[UIColor whiteColor]];
    updateLable.textAlignment=NSTextAlignmentCenter;
    
    disImageView = [[UIImageView alloc] init];
    [disImageView setFrame:self.view.bounds];
    disImageView.image = [UIImage imageNamed:@"loginView2.jpg"];
    [disImageView setUserInteractionEnabled:YES];
    [self.view addSubview:disImageView];
    self.view.userInteractionEnabled=YES;
    methodArr = [NSArray arrayWithObjects:@"sysChatSession",@"sysADUser",@"sysChatUser",@"sysChatGroup",@"sysChatPerson",nil];
    sysncArr = [[NSMutableDictionary alloc] init];
    
    //
    
    [self initView];
    
    //检查更新
    [self updateSoft];

}

-(void)updateSoft
{
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
       __block BOOL forceUpdate = NO;
        NSDictionary *checkDic  = [self getVersionNoFromServer];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (checkDic!=nil && [checkDic objectForKey:@"verCode"] !=nil) {
                if ([[CommUtilHelper sharedInstance] checkIsUpdate:[[checkDic objectForKey:@"verCode"] integerValue] ]) {
                    forceUpdate=YES;
                }
            }
            
            //
            if (!forceUpdate){
                //[self initView];
            }else
                
            {
                downloadUrl = [checkDic objectForKey:@"downloadUrl"];
                NSString *update =[checkDic objectForKey:@"forceUpdate"];
                if ([@"YES" isEqual:update]) {
                    [self.view addSubview:updateLable];
                    //            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Prompt" message:@"download new version?" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                    //            alertView.tag = newVersionTag;
                    //            alertView.delegate=self;
                    //            [alertView show];
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:downloadUrl]];
                }else
                {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Prompt" message:@"download new version?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
                    alertView.tag = newVersionTag+1;
                    alertView.delegate=self;
                    [alertView show];
                }
                
            }
        });
       
    });
        
    
    
}

-(void)initView
{
   
    proressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
    [proressView setFrame:CGRectMake(screenWidth/2-TextWidth/2, screenHeight/2, TextWidth, 10)];
    progressText = [[UILabel alloc]initWithFrame:CGRectMake(proressView.frame.origin.x, proressView.frame.origin.y - 30, proressView.frame.size.width, 30)];
    progressText.textColor = [UIColor whiteColor];
    [self.view addSubview:proressView];
    [self.view addSubview:progressText];
    proressView.hidden = YES;
    progressText.hidden = YES;
    // Do any additional setup after loading the view.
    //[NSThread detachNewThreadSelector:@selector(checkNeedLgoin) toTarget:self withObject:nil];
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *user=[ud objectForKey:@"user"];
    //isFirstLogin = [self checkNeedLgoin];
    
    if(user == nil || [@"" isEqualToString:user] || isHasChangeAccount)
    //if(NO)
    {
        userTextField=[[UITextField alloc] initWithFrame:CGRectMake(screenWidth/2-TextWidth/2, screenHeight/2-gap*2+50, TextWidth, TextHeight)];
        
        [userTextField setReturnKeyType:UIReturnKeyDone];
        [userTextField setBorderStyle:UITextBorderStyleRoundedRect];
        [userTextField setClearButtonMode:UITextFieldViewModeWhileEditing];
        //[userTextField becomeFirstResponder];
        [userTextField setTextAlignment:NSTextAlignmentLeft];
        [userTextField setPlaceholder:@"Staff code/Email address"];
        userTextField.delegate=self;
        [disImageView addSubview:userTextField];
        //
        passwordTextField=[[UITextField alloc] initWithFrame:CGRectMake(screenWidth/2-TextWidth/2, screenHeight/2+gap+50, TextWidth, TextHeight)];
        [passwordTextField setSecureTextEntry:YES];
        [passwordTextField setReturnKeyType:UIReturnKeyDone];
        [passwordTextField setBorderStyle:UITextBorderStyleRoundedRect];
        [passwordTextField setClearButtonMode:UITextFieldViewModeWhileEditing];
        //[passwordTextField becomeFirstResponder];
        [passwordTextField setTextAlignment:NSTextAlignmentLeft];
        [passwordTextField setPlaceholder:@"Windows Password"];
        passwordTextField.delegate=self;
        [disImageView addSubview:passwordTextField];
        //
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        button.layer.cornerRadius=5;
        [button setTitle:@"Login" forState:UIControlStateNormal];
        [button setFrame:CGRectMake(screenWidth/2-TextWidth/2, screenHeight/2+gap*2+passwordTextField.frame.size.height+50, TextWidth, TextHeight)];
        button.backgroundColor=[UIColor colorWithRed:34/255.0 green:139/255.0 blue:34/255.0 alpha:0.9];
        button.titleLabel.font=[UIFont systemFontOfSize:18];
        [button addTarget:self action:@selector(doLogin) forControlEvents:UIControlEventTouchUpInside];
        [button setTintColor:[UIColor whiteColor]];
        [button setBackgroundColor:[UIColor clearColor]];
        [button.layer setBorderWidth:1];
        [button.layer setBorderColor:[[UIColor whiteColor] CGColor]];
        [disImageView addSubview:button];
        //注册键盘出现与隐藏时候的通知
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboadWillShow:)
                                                     name:UIKeyboardWillShowNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillHide:)
                                                     name:UIKeyboardWillHideNotification
                                                   object:nil];
    }else
    {
        //[self showLoadingView];
        proressView.hidden = NO;
        progressText.hidden = NO;
        totalProgressCounter = 2;
        currProgressValue = 0;
        progressText.text = @"Loading...";
        [proressView setProgress:0 animated:YES];
        [self initNav];
        [NSThread detachNewThreadSelector:@selector(startSyncData) toTarget:self withObject:nil];
    }
    
    //isFirstLogin = YES;
    
}
//
//更新app 链接
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag ==newVersionTag) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:downloadUrl]];
    }else if (alertView.tag ==newVersionTag+1)
    {
        if (buttonIndex == 1) {
            [self.view addSubview:updateLable];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:downloadUrl]];
        }else
        {
            [self initView] ;
        }
    }else if (alertView.tag == retryTag)//chongshi cao zuo 
    {
        proressView.hidden = NO;
        progressText.hidden = NO;
        totalProgressCounter = 2;
        currProgressValue = 0;
        progressText.text = @"Loading...";
        [proressView setProgress:0 animated:YES];
        [NSThread detachNewThreadSelector:@selector(startSyncData) toTarget:self withObject:nil];
        
        //[self startSyncData];
    }
}



-(void) keyboadWillShow:(NSNotification *)note{
    
    NSDictionary *info = [note userInfo];
    CGSize keyboardSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;//键盘的frame
    //CGFloat offY = (460-keyboardSize.height)-passwordTextField.frame.size.height;//屏幕总高度-键盘高度-UITextField高度
    [UIView beginAnimations:nil context:NULL];//此处添加动画，使之变化平滑一点
    [UIView setAnimationDuration:0.3];//设置动画时间 秒为单位
    self.view.frame = CGRectMake(0, 0-keyboardSize.height+120, screenWidth, screenHeight);//UITextField位置的y坐标移动到offY
    [UIView commitAnimations];//开始动画效果
    
}
//键盘消失时候调用的事件
-(void)keyboardWillHide:(NSNotification *)note{
    [UIView beginAnimations:nil context:NULL];//此处添加动画，使之变化平滑一点
    [UIView setAnimationDuration:0.3];
    self.view.frame = CGRectMake(0, 0,  screenWidth, screenHeight);//UITextField位置复原
    [UIView commitAnimations];
}
//
-(void)doLogin
{
    
    
    [userTextField resignFirstResponder];
    [passwordTextField resignFirstResponder];
    if (!userTextField.text) {
        [self showAlertView:@"please input your account"];
    }else if(!passwordTextField.text)
    {
        [self showAlertView:@"please input your password"];
    }
    //[self showLoadingView];
    totalProgressCounter = 4;
    currProgressValue = 0;
    progressText.text = @"Verify user...";
    proressView.hidden = NO;
    progressText.hidden = NO;
    [proressView setProgress:0 animated:YES];
    [sysncArr removeAllObjects];
    [NSThread detachNewThreadSelector:@selector(startRecommandGetUser) toTarget:self withObject:nil];
}
//获取用户信息
-(void)startRecommandGetUser
{
    NSString *userText = [userTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *password = [passwordTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    ResponseModel *response = [LoginNetServiceUtil LoginChat:userText Password:password];
    userDic = response.resultInfo;
    
    dispatch_async(dispatch_get_main_queue(), ^(void)
                   {
                       if (response.error !=nil) {
                           currProgressValue=0;
                           proressView.hidden = YES;
                           progressText.hidden = YES;
                           [self hideLoadingView];
                           [self showAlertView:response.error.errorMsg];
                           return;
                       }
                       if(!response.resultInfo)
                       {
                           currProgressValue=0;
                           proressView.hidden = YES;
                           progressText.hidden = YES;
                           [self hideLoadingView];
                           //[self showAlertView:@"login error!"];
                           return;
                       }
                       @try {
                           if ([[userDic objectForKey:@"RESULT"] isKindOfClass:[NSNull class]]){
                               progressText.text = nil;
                               [self showAlertView:[userDic objectForKey:@"ERROR"]];
                               return;
                           }
                      NSString *dicStr = [[userDic objectForKey:@"RESULT"] objectForKey:@"AppCommandResult"];
                       NSDictionary *dic = [dicStr JSONValue];
                       if ([dic count] >0) {
                           NSString *isPass = [dic objectForKey:@"RESULT"];
                           if ([@"1" isEqual:isPass]) {
                               NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
                               [ud setObject:[dic objectForKey:@"USER_PRINCIPAL_NAME"] forKey:@"user"];
                               [ud setObject:[dic objectForKey:@"SAM_ACCOUNT_NAME"] forKey:@"nickname"];
                               [ud setObject:[dic objectForKey:@"COMMON_NAME"] forKey:@"commonName"];
                               [ud setObject:password forKey:@"commPassword"];
                               [ud setObject:@"yes" forKey:@"firstLoginSystem"];
                               //
                               progressText.text = @"Register device...";
                               currProgressValue ++;
                               [proressView setProgress:currProgressValue/totalProgressCounter animated:YES];
                               //
                               [NSThread detachNewThreadSelector:@selector(startSyncData) toTarget:self withObject:nil];
                           }else
                           {
                               NSString *msgDetail = [dic objectForKey:@"MSG"];
                               [proressView setProgress:0 animated:YES];
                               [self showAlertView:msgDetail];
                           }
                       }
                       }
                       @catch (NSException *exception) {
                           [self showAlertView:[userDic objectForKey:@"RESULT"]];
                       }
                       @finally {
                           
                       }
    
                   });
}
//注册设备
-(void)startRegDevice
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *username = [ud objectForKey:@"user"];
    ResponseModel *response = [LoginNetServiceUtil regDevice:username];
    NSDictionary *resultDic = response.resultInfo;
    dispatch_async(dispatch_get_main_queue(), ^(void)
                   {
                       if (response.error !=nil) {
                           currProgressValue=0;
                           proressView.hidden = YES;
                           progressText.hidden = YES;
                           [ud setObject:nil forKey:@"user"];
                           [self hideLoadingView];
                           [self showAlertView:@"Register device failure."];
                           return;
                       }
                       if(resultDic ==nil)
                       {
                           currProgressValue=0;
                           proressView.hidden = YES;
                           progressText.hidden = YES;
                           [ud setObject:nil forKey:@"user"];
                           [self hideLoadingView];
                           [self showAlertView:@"Register device failure."];
                           return;
                       }
                       if ([resultDic count] >0) {
                           NSString *isPass = [resultDic objectForKey:@"ispass"];
                           if ([@"Y" isEqual:isPass]) {
                               progressText.text = @"Loading...";
                               currProgressValue ++;
                               [proressView setProgress:currProgressValue/totalProgressCounter animated:YES];
                               //
                               [NSThread detachNewThreadSelector:@selector(startSyncData) toTarget:self withObject:nil];
                           }else
                           {
                               currProgressValue=0;
                               proressView.hidden = YES;
                               progressText.hidden = YES;
                               [ud setObject:nil forKey:@"user"];
                               [proressView setProgress:0 animated:YES];
                               [self showAlertView:@"Register device failure"];
                           }
                       }
                   });
}
//
-(void)errorViewTapGesture:(UITapGestureRecognizer *)tapGesture
{
    [super errorViewTapGesture:tapGesture];
    [NSThread detachNewThreadSelector:@selector(startRecommandGetUser) toTarget:self withObject:nil];
}
-(void)showAlertView:(NSString *)message
{
    NSString *m = message;
    if (message == nil) {
        m=@"error";
    }
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Prompt" message:m delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
    [alertView show];
}

-(BOOL)checkNeedLgoin
{
    @try {
        
        
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        NSString *name = [ud objectForKey:@"user"];
        if (name == nil) {
            return false;
        }
        NSString *password = [ud objectForKey:@"commPassword"];
        if (password == nil) {
            return false;
        }
        
        BOOL  check = false;
        
        ResponseModel *response = [LoginNetServiceUtil LoginChat:name Password:@""];
        if (response.error !=nil) {
            [self showAlertView:[response.error.errorMsg stringByAppendingString:@"please check your network!"]];
            return false;
        }
        NSDictionary *_resultDic = response.resultInfo;
        
        
        
        if(response.resultInfo== nil )
        {
            return false;
            
        }
        if ([_resultDic count] >0) {
            NSDictionary *infoDic = [_resultDic objectForKey:@"RESULT"];
            if (infoDic == nil) {
                return false;
            }
            NSString *dicStr = [infoDic objectForKey:@"AppCommandResult"];
            NSDictionary *dic = [dicStr JSONValue];
            
            NSString *isPass = [dic objectForKey:@"RESULT"];
            if ([@"1" isEqual:isPass]) {
                check = true;
            }else
            {
                check = false;
            }
        }
        return check;
        
    }
    @catch (NSException *exception) {
        return false;
    }
    
    
    
    
    
}
//
-(void)initNav
{
     [[SystemUpdateHelper sharedInstance] clearAllMessageBage];
    //系统更新
    
    [[SystemUpdateHelper sharedInstance] clearAllMessageBage];
    
    //保存推送通知注册信息
    [NSThread detachNewThreadSelector:@selector(saveRegistrationInfo) toTarget:self withObject:nil];
    //
    [[ChatViewController sharedInstance] reloadData];
    
    //
    ChatViewController *chatVC = [ChatViewController sharedInstance];
    chatVC.tabBarItem.title=@"Message";
    [chatVC.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont  systemFontOfSize:11],NSFontAttributeName,[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.70],NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    [chatVC.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont  systemFontOfSize:11],NSFontAttributeName,[UIColor colorWithRed:4/255.0 green:118/255.0 blue:246/255.0 alpha:1],NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
    chatVC.tabBarItem.selectedImage=[[UIImage imageNamed:@"speech-bubble-blue@3x.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    chatVC.tabBarItem.image = [[UIImage imageNamed:@"speech-bubble@3x.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    chatVC.navigationController.navigationItem.title=@"Message";
    //chatVC.navigationController.navigationBar.tintColor = [CommUtilHelper getDefaultBackgroupColor];
    
    
    
    
    
    
//    EventViewController *eventView = [[EventViewController alloc] init];
//    eventView.tabBarItem.title=@"Event";
//    [eventView.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont  systemFontOfSize:11],NSFontAttributeName,[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.70],NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
//    [eventView.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont  systemFontOfSize:11],NSFontAttributeName,[UIColor colorWithRed:4/255.0 green:118/255.0 blue:246/255.0 alpha:1],NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
//    eventView.tabBarItem.selectedImage = [[UIImage imageNamed:@"contacts-blue@3x.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    eventView.tabBarItem.image = [[UIImage imageNamed:@"contacts@3x.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    
    
    
    
    
    
    
    
    ContactViewController *contactView = [[ContactViewController alloc] init];
    contactView.tabBarItem.title=@"Contacts";
    [contactView.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont  systemFontOfSize:11],NSFontAttributeName,[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.70],NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    [contactView.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont  systemFontOfSize:11],NSFontAttributeName,[UIColor colorWithRed:4/255.0 green:118/255.0 blue:246/255.0 alpha:1],NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
    contactView.tabBarItem.selectedImage = [[UIImage imageNamed:@"contacts-blue@3x.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    contactView.tabBarItem.image = [[UIImage imageNamed:@"contacts@3x.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //
    
    NSString *url = [NSString stringWithFormat:@"%@/work.html?userName=%@&deviceId=%@",charUrl, [[CommUtilHelper sharedInstance] getUser],[CommUtilHelper getDeviceId]];
     //NSString *url = [NSString stringWithFormat:@"%@/work.html?userName=%@&deviceId=%@",charUrl, @"bill.woo@hwpg.net",[CommUtilHelper getDeviceId]];
    //  NSString *url = [NSString stringWithFormat:@"%@/work.html?userName=%@&deviceId=%@",charUrl, @"quincy.zhang@sz.hwpg.net",@"6E41307D-CEB1-4B40-A7E9-E801312BBFEB"];
    //WorkWebViewController *conVC = [[WorkWebViewController alloc] initWithUrl:url];
    
    WorkViewController *conVC = [[WorkViewController alloc] init];
    conVC.tabBarItem.title=@"Work";
    [conVC.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont  systemFontOfSize:12],NSFontAttributeName,[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.70],NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    [conVC.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont  systemFontOfSize:12],NSFontAttributeName,[UIColor colorWithRed:4/255.0 green:118/255.0 blue:246/255.0 alpha:1],NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
    conVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"work-blue@3x.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    conVC.tabBarItem.image = [[UIImage imageNamed:@"work@3x.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    conVC.tabBarItem.tag =2;
    //
    SettingViewController *settingVC = [[SettingViewController alloc ] init];
   
    settingVC.tabBarItem.title=@"Me";
    [settingVC.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont  systemFontOfSize:11],NSFontAttributeName, [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.70],NSForegroundColorAttributeName,nil] forState:UIControlStateNormal];
    [settingVC.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont  systemFontOfSize:11],NSFontAttributeName, [UIColor colorWithRed:4/255.0 green:118/255.0 blue:246/255.0 alpha:1],NSForegroundColorAttributeName,nil] forState:UIControlStateSelected];
    settingVC.tabBarItem.selectedImage=[[UIImage imageNamed:@"me-blue@3x.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    settingVC.tabBarItem.image = [[UIImage imageNamed:@"me@3x.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //
    UINavigationController *chatNavController=[[UINavigationController alloc] initWithRootViewController:chatVC];
    //UINavigationController *eventNavController=[[UINavigationController alloc] initWithRootViewController:eventView];
    
    UINavigationController *contactNavController=[[UINavigationController alloc] initWithRootViewController:contactView];
    UINavigationController *workNavController=[[UINavigationController alloc] initWithRootViewController:conVC];
    UINavigationController *settingNavController=[[UINavigationController alloc] initWithRootViewController:settingVC];
    //
    tabBarController = [[CustTabbarController alloc] init];
    tabBarController.viewControllers = [NSArray arrayWithObjects:chatNavController,contactNavController,workNavController, settingNavController,nil];
    tabBarController.tabBar.backgroundColor=[UIColor clearColor];
    [tabBarController.tabBar setTranslucent:YES];
    [tabBarController.tabBar setBarTintColor:kGetColor(248, 248, 248)];
    [tabBarController.tabBar setTintColor:[UIColor blackColor]];
    
    NSLog(@"%@",[tabBarController.tabBar.delegate description]);
    AppDelegate * app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    [app.window setRootViewController:tabBarController];
    //如果用户是从通知点击进入App，则根据点击的通知自动显示相应页面
    [[CommUtilHelper sharedInstance] pushVeiwByRemoteNotic:chatNavController];
    
    
    
}

-(void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    NSLog(@"%@",@"123");
}

-(void)saveRegistrationInfo
{
    [PushNotificationUtil saveRegistrationInfo];
}
//
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

#pragma delegte method

//// 当输入框获得焦点时，执行该方法。
//- (void)textFieldDidBeginEditing:(UITextField *)textField{
//    if (textField == userTextField) {
//        [userTextField becomeFirstResponder];
//    }
//
//}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [userTextField resignFirstResponder];
    [passwordTextField resignFirstResponder];
    return YES;
}
//// 文本框失去first responder 时，执行
- (void)textFieldDidEndEditing:(UITextField *)textField{
    [textField resignFirstResponder];
    [passwordTextField resignFirstResponder];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [userTextField resignFirstResponder];
    [passwordTextField resignFirstResponder];
}
//sync data
-(void)startSyncData
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *user=[ud objectForKey:@"user"];
    //
    NSString *lastSyncTime = nil;
    if ([[CommUtilHelper sharedInstance] getLastSyncTime:@"CHAT_GROUP_SESSION"] !=nil) {
        lastSyncTime =[[CommUtilHelper sharedInstance] getLastSyncTime:@"CHAT_GROUP_SESSION"];
    }else if ([[CommUtilHelper sharedInstance] getLastSyncTime:@"CHAT_GROUP"] !=nil) {
        lastSyncTime =[[CommUtilHelper sharedInstance] getLastSyncTime:@"CHAT_GROUP"];
    }else if ([[CommUtilHelper sharedInstance] getLastSyncTime:@"CHAT_GROUP_PERSON"] !=nil) {
        lastSyncTime =[[CommUtilHelper sharedInstance] getLastSyncTime:@"CHAT_GROUP_PERSON"];
    }else if ([[CommUtilHelper sharedInstance] getLastSyncTime:@"CHAT_USERS"] !=nil) {
        lastSyncTime =[[CommUtilHelper sharedInstance] getLastSyncTime:@"CHAT_USERS"];
    }else if ([[CommUtilHelper sharedInstance] getLastSyncTime:@"CHAT_AD_USER"] !=nil) {
        lastSyncTime =[[CommUtilHelper sharedInstance] getLastSyncTime:@"CHAT_AD_USER"];
    }else
    {
     lastSyncTime = @"1900-1-1";
    }
        
    
    [self syncData:user syncTime:lastSyncTime method:@"syncData"];
}
//-(void) syncChatUser
//{
//    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
//    NSString *user=[ud objectForKey:@"user"];
//    [self syncData:user syncTime:[[CommUtilHelper sharedInstance] getLastSyncTime:@"CHAT_USERS"] method:@"sysChatUser"];
//}
//-(void) syncChatGroup
//{
//    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
//    NSString *user=[ud objectForKey:@"user"];
//    [self syncData:user syncTime:[[CommUtilHelper sharedInstance] getLastSyncTime:@"CHAT_GROUP"] method:@"sysChatGroup"];
//}
//-(void) syncChatPerson
//{
//    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
//    NSString *user=[ud objectForKey:@"user"];
//    [self syncData:user syncTime:[[CommUtilHelper sharedInstance] getLastSyncTime:@"CHAT_GROUP_PERSON"] method:@"sysChatPerson"];
//}
//-(void) syncChatSession
//{
//    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
//    NSString *user=[ud objectForKey:@"user"];
//    [self syncData:user syncTime:[[CommUtilHelper sharedInstance] getLastSyncTime:@"CHAT_GROUP_SESSION"] method:@"sysChatSession"];
//}
//按顺序开启新线程同步服务器数据，保存到本地
//在同步数据完毕后，才进入首页
-(BOOL)syncData:(NSString *)user syncTime:(NSString *)syncTime method:(NSString *)method
{
    proressView.hidden = NO;
    progressText.text = @"Connecting server...";
    [self setNextProgessValue];
    NSString *sendSyncTime=nil;
    if (!syncTime) {
        if([method isEqualToString:@"sysChatSession"]) {
            sendSyncTime=@"";
            //sendSyncTime=@"1900-01-01";
        }else
        {
            sendSyncTime=@"1900-01-01";
        }
    }else
    {
        sendSyncTime = syncTime;
    }
    ResponseModel *response = nil;
    NSMutableDictionary *mutableDic  = nil;
    response = [LoginNetServiceUtil GetSyncInfo:user SyncTime:sendSyncTime methodName:method];
    mutableDic=response.resultInfo;
    dispatch_async(dispatch_get_main_queue(), ^(void)
                   {
                       if (response.error !=nil) {
                           currProgressValue=0;
                           proressView.hidden = YES;
                           progressText.hidden = YES;
                           
//                           UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Prompt" message:response.error.errorMsg delegate:self cancelButtonTitle:@"retry" otherButtonTitles:nil, nil];
//                           alertView.tag = retryTag;
//                           alertView.delegate=self;
//                           [alertView show];
                           return;
                       }
                       [self setNextProgessValue];
                       //
                       if (mutableDic == nil) {
                           
                           return;
                       }
                       
                       NSMutableArray *adUsers = [mutableDic objectForKey:@"AD_USERS"];
                       NSMutableArray *chatUsers = [mutableDic objectForKey:@"CHAT_USERS"];
                       NSMutableArray *chatGroup = [mutableDic objectForKey:@"CHAT_GROUP"];
                       NSMutableArray *chatGroupPerson = [mutableDic objectForKey:@"CHAT_GROUP_PERSON"];
                       NSMutableArray *chatGroupSession = [mutableDic objectForKey:@"CHAT_GROUP_SESSION"];
                       if (![chatGroupSession isKindOfClass:[NSNull class]] && [chatGroupSession count]>0) {
                           [self addSyncDataMethod:@"sysChatSession" Data:chatGroupSession];
                       }
                       if (![adUsers isKindOfClass:[NSNull class]] && [adUsers count]>0) {
                         [self addSyncDataMethod:@"sysADUser" Data:adUsers];
                               
                        }
                       if (![chatUsers isKindOfClass:[NSNull class]] && [chatUsers count]>0) {
                           [self addSyncDataMethod:@"sysChatUser" Data:chatUsers];
                           
                       }
                       if (![chatGroup isKindOfClass:[NSNull class]] && [chatGroup count]>0) {
                           [self addSyncDataMethod:@"sysChatGroup" Data:chatGroup];
                           
                       }
                       if (![chatGroupPerson isKindOfClass:[NSNull class]] && [chatGroupPerson count]>0) {
                           [self addSyncDataMethod:@"sysChatPerson" Data:chatGroupPerson];
                           
                       }
                        progressText.text = @"Updating Data...";
                       [self excuteSaveData];
                       NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
                       NSString *firstLoginSystem =  [ud objectForKey:@"firstLoginSystem"];
                       if (firstLoginSystem !=nil ) {
                           [ud removeObjectForKey:@"firstLoginSystem"];
                            [self initNav];
                       }
                      
                    
                   });
    return true;
}

-(void)setNextProgessValue
{
    currProgressValue ++;
    [proressView setProgress:currProgressValue/totalProgressCounter animated:YES];
}

-(NSDictionary *)getVersionNoFromServer
{
    
    ResponseModel *rs = [LoginNetServiceUtil GetVersion];
    NSDictionary *resDic = rs.resultInfo;
    return resDic;
}
-(BOOL)excuteSaveData
{
    @try {
        BOOL isClearAllMsg = false;
        NSMutableArray *reArr = NULL;
        NSMutableArray *chatSession= NULL;
        NSString *clearStr = nil;
        for (int i=0; i<[methodArr count]; i++) {
            NSString *method =[methodArr objectAtIndex:i];
            NSMutableArray *chatArr = [sysncArr objectForKey:method];
            chatSession =[sysncArr objectForKey:@"sysChatSession"];
            if (chatArr !=nil) {
                if ([@"sysADUser" isEqualToString:method]) {
                    [[eChatDAO sharedChatDao] initADUser:chatArr];
                }else if([@"sysChatUser" isEqualToString:method])
                {
                    [[eChatDAO sharedChatDao] initChatUserList:chatArr];
                }
                else if([@"sysChatGroup" isEqualToString:method])
                {
                    [[eChatDAO sharedChatDao] initChatGroupList:chatArr];
                }
                else if([@"sysChatPerson" isEqualToString:method])
                {
                    [[eChatDAO sharedChatDao] initChatPersonList:chatArr];
                }else if([@"sysChatSession" isEqualToString:method])
                {
                    reArr= [[eChatDAO sharedChatDao] iniChatSessionList:chatArr];
                    for (int i=0; i<[reArr count]; i++) {
                        clearStr = [reArr objectAtIndex:i];
                        if (![@"" isEqualToString:clearStr]) {
                            
                            //[LoginNetServiceUtil clearMessage:[[CommUtilHelper sharedInstance] getUser] deviceId:deviceId successIds:[clearStr stringByAppendingString:@"]"] ];
                        ResponseModel *response =   [LoginNetServiceUtil clearMessage:[[CommUtilHelper sharedInstance] getUser] deviceId:[CommUtilHelper getDeviceId] successIds:clearStr];
                            NSString *result = [response.resultInfo objectForKey:@"RESPONSE"];
                            if ([@"1" isEqualToString:result]) {
                                isClearAllMsg = true;
                            }else
                            {
                             
                            }
                            
                        }
                    }
                }
            }
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setObject:@"YES" forKey:@"isFirstLoad"];
        }
         [self setNextProgessValue];
        if (chatSession == nil || ((clearStr!=nil || [@"" isEqualToString:clearStr]) && isClearAllMsg) || (clearStr ==nil ||[@"" isEqualToString:clearStr])) {
            //[self initNav];
        }
        
        return YES;
    } @catch (NSException *exception) {
        return NO;
    }
    
    
}
-(void)addSyncDataMethod:(NSString *)method Data:(NSMutableArray *)chatArr;
{
    [sysncArr setObject:chatArr forKey:method];
}

@end
