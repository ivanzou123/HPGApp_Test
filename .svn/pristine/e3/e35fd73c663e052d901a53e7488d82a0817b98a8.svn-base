//
//  CrmRootViewController.m
//  HwpgMobile
//
//  Created by hwpl hwpl on 14-12-15.
//  Copyright (c) 2014年 hwpl hwpl. All rights reserved.
//
#define rootViewHeight 48
#import "CrmRootViewController.h"
#import "WorkViewController.h"
#import "TestViewController.h"
#import "SettingViewController.h"
#import "ChatViewController.h"
#import "ResponseModel.h"
#import "CrmNetServiceUtil.h"
#import "NSString+FontAwesome.h"
static CrmRootViewController *instance=nil;
@interface CrmRootViewController ()<UITextFieldDelegate>
{
    UIView *rootView;
    NSMutableDictionary *_controllersDict;
    UIView *mainView;
    
    BOOL isLoadingNext;
    NSDictionary *dic;
    UIButton *b1;
    UIButton *b2;
    UIButton *b3;
    UILabel *l1;
    UILabel *l2;
    UILabel *l3;
}

@end

@implementation CrmRootViewController
+(id)sharedInstance
{
   @synchronized(self)
    {
        if (instance == nil) {
            instance = [[CrmRootViewController alloc] init];
        }
    }
    return instance;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     [NSThread detachNewThreadSelector:@selector(startRecommandlistInThread) toTarget:self withObject:nil];
    
}
//v1.tabBarItem.image = [UIImage imageNamed:@"ico-portal.png"];
////                           v2.tabBarItem.image = [UIImage imageNamed:@"ico-contact-32.png"];
////                           v3.tabBarItem.image = [UIImage imageNamed:@"ico-list-32.png"];
//custView.tabBarItem.image = [UIImage imageNamed:@"ico-customers.png"];
//mine.tabBarItem.image = [UIImage imageNamed:@"ico-user.png"];
//myTeam.tabBarItem.image = [UIImage imageNamed:@"ico-team.png"];
-(void)showAlertView:(NSString *)message
{
    NSString *m = message;
    if (message == nil) {
        m=@"error";
    }
    if ([message isEqual:@"0"]) {
        m = @"账号或密码错误，请重新输入";
    }
    NSLog(@"%@",message);
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:m delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alertView show];
}
-(void)startRecommandlistInThread
{
    NSString *soapMessage=@"method=IsTrueUser&parameter=";
    //    soapMessage = [soapMessage stringByAppendingString:[NSString stringWithFormat:@"[%@,%@]",userName.text,password.text]];
    //    soapMessage = [soapMessage stringByAppendingString:[NSString stringWithFormat:@"[amy.yi,81564346]"]];
    soapMessage = [soapMessage stringByAppendingString:[NSString stringWithFormat:@"[Amy.Yi,1]"]];
    ResponseModel *response = [CrmNetServiceUtil startRecommandlistByPage:1 Message:soapMessage];
    isLoadingNext = NO;
    dic = response.resultInfo;
    dispatch_async(dispatch_get_main_queue(), ^(void)
                   {
                       if (response.error !=nil) {
                           //[self showErrorView];
                           [self showAlertView:@"请检查网络"];
                           return;
                       }
                       //[self hideLoadingView];
                       NSString *loginResult = [dic objectForKey:@"result"];
                       NSLog(@"loginResult------>%@",loginResult);
                       if ([loginResult isEqual:@"0"]) {
                           [self showAlertView:loginResult];
                       }else{
                           //                           [self showAlertView:@"登录成功"];
                           NSUserDefaults *userID = [NSUserDefaults standardUserDefaults];
                           [userID setObject:loginResult forKey:@"CRM_USERID"];
                           [userID setObject:loginResult forKey:@"CRM_SELECTUSERID"];//当前选中的用户id
                           //                           [userID setObject:loginResult forKey:@"MANAGERUSERID"];//权限用户id
                           [userID synchronize];
                           rootView=[[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-rootViewHeight, self.view.frame.size.width,rootViewHeight)];
                           // [rootView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.6]];
                           
                           [rootView setBackgroundColor:[UIColor colorWithRed:0.0/255 green:153.0/255 blue:204.0/255 alpha:1]];
                           [self.view setBackgroundColor:[UIColor whiteColor]];
                           _controllersDict = [NSMutableDictionary dictionary];
                           
                           int ButtonCount = 3;
                           float width = self.view.frame.size.width/ButtonCount;
                           //button 1
                           b1 = [[UIButton alloc] initWithFrame:CGRectMake(0, -6, width, rootViewHeight)];
                           b1.tag=1;
                           [b1 addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
                           [b1 setSelected:YES];
                           b1.showsTouchWhenHighlighted=YES;
                           
                           [b1 setFont:[UIFont fontWithName:kFontAwesomeFamilyName size:18]];
                           [b1 setTitle:[NSString fontAwesomeIconStringForEnum:FABarChartO] forState:UIControlStateNormal];
                           [b1 setTitleColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.53] forState:UIControlStateNormal];
                           //button 2
                           l1 = [[UILabel alloc] initWithFrame:CGRectMake(width/2-20,15, width, rootViewHeight)];
                           [l1  setText:@"Follow"];
                           
                           [l1  setTextColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.53]];
                           [l1 setFont:[UIFont systemFontOfSize:12]];
                           
                           [b1 addSubview:l1];
                           
                           
                           
                           b2 = [[UIButton alloc] initWithFrame:CGRectMake(width, -6, width, rootViewHeight)];
                           b2.tag=2;
                           [b2 addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
                           b2.showsTouchWhenHighlighted=YES;
                           [b2 setFont:[UIFont fontWithName:kFontAwesomeFamilyName size:18]];
                           [b2 setTitle:[NSString fontAwesomeIconStringForEnum:FAUsers] forState:UIControlStateNormal];
                           [b2 setTitleColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.53] forState:UIControlStateNormal];
                           l2 = [[UILabel alloc] initWithFrame:CGRectMake(width/2-30,15, width, rootViewHeight)];
                           [l2  setText:@"Customers"];
                           
                           [l2  setTextColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.53]];
                           [l2 setFont:[UIFont systemFontOfSize:12]];
                           
                           [b2 addSubview:l2];
                           
                           //button 3;
                           b3 = [[UIButton alloc] initWithFrame:CGRectMake(width*2, -6, width, rootViewHeight)];
                           b3.tag=3;
                           [b3 addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
                           b3.showsTouchWhenHighlighted=YES;
                           [b3 setFont:[UIFont fontWithName:kFontAwesomeFamilyName size:18]];
                           [b3 setTitleColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.53] forState:UIControlStateNormal];
                           [b3 setTitle:[NSString fontAwesomeIconStringForEnum:FAFlag] forState:UIControlStateNormal];
                           
                           l3 = [[UILabel alloc] initWithFrame:CGRectMake(width/2-15,15, width, rootViewHeight)];
                           [l3  setText:@"Team"];
                           
                           [l3  setTextColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.53]];
                           [l3 setFont:[UIFont systemFontOfSize:12]];
                           
                           [b3 addSubview:l3];
                           
                           
                           [rootView addSubview:b1];
                           [rootView addSubview:b2];
                           [rootView addSubview:b3];
                           mainView = [[UIView alloc] initWithFrame:self.view.bounds];
                           [self buttonClick:b1];
                           [self.view addSubview:mainView];
                           [self.view addSubview:rootView];
                       }
                       
                   }
                   );
    
}

-(void)buttonClick:(UIButton *)button
{
    switch (button.tag) {
        case 1:
        {
         [l1  setTextColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:1]];
         [l2  setTextColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.53]];
         [l3  setTextColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.53]];
         [b1 setTitleColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:1] forState:UIControlStateNormal];
         [b2 setTitleColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.53] forState:UIControlStateNormal];
         [b3 setTitleColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.53] forState:UIControlStateNormal];
         [self showContentControllerWithModel:@"OverviewController"];
            break;
        }
        case 2:
        {
            [l1  setTextColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.53]];
            [l2  setTextColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:1]];
            [l3  setTextColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.53]];
            [b1 setTitleColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.53] forState:UIControlStateNormal];
            [b2 setTitleColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:1] forState:UIControlStateNormal];
            [b3 setTitleColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.53] forState:UIControlStateNormal];
            [self showContentControllerWithModel:@"FollowUpController"];
            break;
            
        }
        case 3:
        {
            [l1  setTextColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.53]];
            [l2  setTextColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.53]];
            [l3  setTextColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:1]];
            [b1 setTitleColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.53] forState:UIControlStateNormal];
            [b2 setTitleColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.53] forState:UIControlStateNormal];
            [b3 setTitleColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:1] forState:UIControlStateNormal];
            [self showContentControllerWithModel:@"MyTeamViewController"];
             
            break;
            
        }
        default:
        {
        
        }
        break;
    }
    
}

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

- (void)showContentControllerWithModel:(NSString *)className
{
   
    
    UIViewController *controller = _controllersDict[className];
    if (!controller)
    {
        Class c = NSClassFromString(className);
        
#if __has_feature(objc_arc)
        controller = [[c alloc] init];
#else
        controller = [[[c alloc] init] autorelease];
#endif
        [_controllersDict setObject:controller forKey:className];
    }
    
    if (mainView.subviews.count > 0)
    {
        UIView *view = [mainView.subviews firstObject];
        [view removeFromSuperview];
    }
    controller.view.frame = mainView.frame;
    [mainView addSubview:controller.view];
    
    //self.MainVC=controller;
}




@end
