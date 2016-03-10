//
//  ApproveFunctionViewController.m
//  Chat
//
//  Created by hwpl hwpl on 14-11-6.
//  Copyright (c) 2014年 hwpl hwpl. All rights reserved.
//

#import "EECSApproveFunctionViewController.h"
#import "JSON.h"
#import "ResponseModel.h"
#import "ApproveServiceUtil.h"
#import "EECSListViewController.h"
#import "CommUtilHelper.h"
@interface EECSApproveFunctionViewController ()
{
    UIWebView *htmlView;
    UILabel *noDataLable;
    NSMutableDictionary *resultDic;
    UILabel *date;
    UILabel *name;
    UILabel *numberBind;
    UILabel *titilLable;
    
    NSString *approveName;
    NSString *aprRefId;
    NSString *actionType;
    NSString *comment;
}
@end

@implementation EECSApproveFunctionViewController
@synthesize tempArr;
@synthesize aprID;
@synthesize sysCode;
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    int firstInfoHeight = 60;
    float lableWidth =screenWidth/3;
    int imageWidth = 15;
    int imageHeight = 13;
    int gap =15;
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    UIView *v1 = [[UIView alloc] initWithFrame:CGRectMake(0, navBarHeight, screenWidth, firstInfoHeight)];
    
    UIImageView *clockImageView =[[UIImageView alloc ] initWithImage: [UIImage imageNamed:@"ico-clock-16.png"]];
    //clock view
    [clockImageView setFrame:CGRectMake(gap, 23, imageWidth, imageHeight)];
    date = [[UILabel alloc] initWithFrame:CGRectMake(gap*2+5, 10, lableWidth-imageWidth-gap, 40)];
    [date setFont:[UIFont systemFontOfSize:12]];
    [date setTextColor:[UIColor colorWithRed:0/255.0 green:104/255.0 blue:183/255.0 alpha:0.9]];
    [v1 addSubview: date];
    [v1 addSubview:clockImageView];
    
    
    UIImageView *userImageView =[[UIImageView alloc ] initWithImage: [UIImage imageNamed:@"ico-user-16.png"]];
    [userImageView setFrame:CGRectMake(lableWidth+gap, 23, imageWidth, imageHeight)];
    name = [[UILabel alloc] initWithFrame:CGRectMake(lableWidth+gap*2+5, 10, lableWidth-imageWidth-gap, 40)];
    //[name setText:@"chen.kapong"];
    [name setFont:[UIFont systemFontOfSize:12]];
    [name setTextColor:[UIColor colorWithRed:0/255.0 green:104/255.0 blue:183/255.0 alpha:0.9]];
    [v1 addSubview: name];
     [v1 addSubview:userImageView];
    
    UIImageView *userImageView1 =[[UIImageView alloc ] initWithImage: [UIImage imageNamed:@"ico-address-book-16.png"]];
    [userImageView1 setFrame:CGRectMake(lableWidth*2, 23, imageWidth, imageHeight)];
    [v1 addSubview:userImageView1];
     numberBind = [[UILabel alloc] initWithFrame:CGRectMake(lableWidth*2+gap+5, 10, lableWidth-imageWidth, 40)];
    //[numberBind setText:@"203905"];
    [numberBind setFont:[UIFont systemFontOfSize:10]];
    [numberBind setTextColor:[UIColor colorWithRed:0/255.0 green:104/255.0 blue:183/255.0 alpha:0.9]];
    [v1 addSubview: numberBind];
    [self.view addSubview: v1];
    
    
    
    UIView *v2 =  [[UIView alloc] initWithFrame:CGRectMake(0, firstInfoHeight+navBarHeight, screenWidth, 80)];
    [v2 setBackgroundColor:[UIColor colorWithRed:222/255.0 green:222/255.0 blue:222/255.0 alpha:0.9]];
    titilLable =[[UILabel alloc] initWithFrame:CGRectMake(10, 10, 280, 60)];
    
    [titilLable setFont:[UIFont systemFontOfSize:23]];
    [v2 addSubview:titilLable];
    
    [self.view addSubview:v2];
    
    
    //webview 显示层
    htmlView =[[UIWebView alloc] initWithFrame:CGRectMake(0,205,screenWidth, screenHeight-205-60)];
    htmlView.scrollView.bounces=NO;
    [(UIScrollView *)[[htmlView subviews] objectAtIndex:0] setBounces:NO];
    [htmlView sizeToFit];
    [htmlView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:htmlView];
    
    
    
    UIButton *b1 = [[UIButton alloc] initWithFrame:CGRectMake(0, screenHeight-60, screenWidth/2, 60)];
    [b1 setTintColor:[UIColor greenColor]];
    [b1.layer setBorderWidth:1];
    [b1 setTitle:@"Approve" forState:UIControlStateNormal];
    [b1 setBackgroundColor:[UIColor colorWithRed:77/255.0 green:180/255.0 blue:207/255.0 alpha:0.9]];
    [b1.titleLabel setFont:[UIFont systemFontOfSize:17]];
    [b1 setShowsTouchWhenHighlighted:YES];
    [b1 addTarget:self action:@selector(ApproveAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:b1];
    
    
    UIButton *b2 = [[UIButton alloc] initWithFrame:CGRectMake(screenWidth/2, screenHeight-60, screenWidth/2, 60)];
    [b2 setTintColor:[UIColor greenColor]];
    [b2.layer setBorderWidth:1];
    [b2 setTitle:@"Reject" forState:UIControlStateNormal];
    [b2 setBackgroundColor:[UIColor colorWithRed:0/255.0 green:97/255.0 blue:145/255.0 alpha:0.9]];
    [b2.titleLabel setFont:[UIFont systemFontOfSize:17]];
    [b2 setShowsTouchWhenHighlighted:YES];
    [b2 addTarget:self action:@selector(RejectAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:b2];
    [self getApproveDataDetail];
    // Do any additional setup after loading the view.
}
//shenp操作

-(void)ApproveAction
{
    UIAlertView *appView = [[UIAlertView alloc] initWithTitle:@"Confirm Approval?" message:@"" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    appView.tag = 0;
    appView.alertViewStyle = UIAlertViewStyleDefault;
    [appView show];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 0) {
        //shenp
        if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"OK"]) {
        //
            [self approveOrRejectAction:alertView.tag Comment:@""];
        }
    }else if(alertView.tag == 1)
    {
        if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"OK"]) {
            UITextField *msgText = [alertView textFieldAtIndex:0];
            NSString *advice = msgText.text;
            [self approveOrRejectAction:alertView.tag Comment:advice];
        }
    }
}
-(void)RejectAction
{
    UIAlertView *appView = [[UIAlertView alloc] initWithTitle:@"Reject Advice" message:@"" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    appView.tag = 1;
    appView.alertViewStyle = UIAlertViewStylePlainTextInput;
    
    [appView show];
}
-(void)willPresentAlertView:(UIAlertView *)alertView
{
    if (alertView.tag == 1) {
    for (UIView *view in alertView.subviews) {
        if ([view isKindOfClass:[UILabel class]]) {
            UILabel *lable = (UILabel *)view;
            lable.font = [UIFont systemFontOfSize:15];
        }
     }
    }
}

-(void)approveOrRejectAction:(NSInteger)tag Comment:(NSString *)_comment
{
    if (!approveName) {
        [self showAlertView:@"无审批人异常"];
        return;
    }else if(!aprRefId)
    {
         [self showAlertView:@"aprRefId数据异常"];
        return;
    }else if(!aprID)
    {
         [self showAlertView:@"aprID数据异常"];
        return;
    }
    switch (tag) {
        case 0:
            actionType = @"A";
            comment=_comment;
           
            [NSThread detachNewThreadSelector:@selector(doApproveOrReject) toTarget:self withObject:nil];
            break;
        case 1:
            actionType=@"R";
            comment=_comment;
            [NSThread detachNewThreadSelector:@selector(doApproveOrReject) toTarget:self withObject:nil];
            break;
        default:
            break;
    }
}

//审批操作回调
-(void)doApproveOrReject
{
    @try {
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:approveName,@"userName",[NSString stringWithFormat:@"%i",(int)aprID],@"aprId",aprRefId,@"aprRefId",actionType,@"action",comment,@"comment", nil];
        ResponseModel *response = [ApproveServiceUtil approveOrRejectAction:dic];
        NSDictionary *resultArrDic = response.resultInfo;
        dispatch_async(dispatch_get_main_queue(), ^(void){
            if (response.error) {
                //[self showErrorView];
                [self showAlertView:@"操作数据失败"];
                return ;
            }
            NSString *result = [resultArrDic objectForKey:@"AppCommandResult"];
            NSDictionary *resultDic = [result JSONValue];
            NSString *resMsg = [resultDic objectForKey:@"Other"];
            if ([@"A" isEqualToString:resMsg]) {
                [self showAlertView:@"审批成功"];
                [EECSListViewController sharedInstance].refreshAprId = [NSString stringWithFormat:@"%i",(int)aprID];
                [self.navigationController popViewControllerAnimated:YES];
                
            }else if([@"R" isEqualToString:resMsg])
            {
                [self showAlertView:@"操作成功"];
                [EECSListViewController sharedInstance].refreshAprId = [NSString stringWithFormat:@"%i",(int)aprID];
                [self.navigationController popViewControllerAnimated:YES];
            }else
            {
                [self showAlertView:@"ohter exception"];
            }
        });
    }
    @catch (NSException *exception) {
        NSLog(@"doApproveOrReject error:%@",exception);
    }
    @finally {
    }
}

//

-(void)getApproveDataDetail
{
    [self showLoadingView];
    [NSThread detachNewThreadSelector:@selector(getApproveDataDetailList) toTarget:self withObject:nil];
    
}

-(void)getApproveDataDetailList
{
    @try {
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:[[CommUtilHelper sharedInstance] getUser],@"userName",@"D",@"listType",[NSString stringWithFormat:@"%i",(int)aprID],@"aprId",sysCode,@"SysCode",nil];
        ResponseModel *response = [ApproveServiceUtil getAppDetailsInfoMsg:@"getAppList" Data:dic];
        //isLoadingNext = NO;
        NSDictionary *resultArrDic = response.resultInfo;
        dispatch_async(dispatch_get_main_queue(), ^(void){
            if (response.error) {
                [self showErrorView];
                [self showAlertView:@"无法连接服务器"];
                return ;
            }
            NSString *result1 =[resultArrDic objectForKey:@"AppCommandResult"];
            resultDic =[result1 JSONValue];
            NSDictionary *headInfo = [resultDic objectForKey:@"HeadInfo"];
            NSString *count = [headInfo objectForKey:@"COUNCT"];
            [self hideLoadingView];
            if ([count intValue] >0) {
                if (noDataLable) {
                    [noDataLable removeFromSuperview];
                }
                NSMutableArray *dataList = [resultDic objectForKey:@"DataList"];
                for (int i=0; i<[dataList count]; i++) {
                    
                    tempArr = dataList;
                    NSDictionary *d = [tempArr objectAtIndex:i];
                    NSArray *subHtmlData = [d objectForKey:@"SubDataList"];
                    //title
                    [date setText:[d objectForKey:@"APR_SUBMISSION_DATE"]];
                    [numberBind setText:[d objectForKey:@"APR_REFID"]];
                    [name setText:[d objectForKey:@"APR_SUBMISSION_BY"]];
                    [titilLable setText:[[d objectForKey:@"APR_TITLE"] stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@""]] ;
                    approveName = [d objectForKey:@"APR_SUBMISSION_TO"];
                    aprRefId =[d objectForKey:@"APR_REFID"];
                    //
                    for (int j=0; j< [d count]; j++) {
                        NSDictionary *detailData = [subHtmlData objectAtIndex:i];
                        
                        [htmlView loadHTMLString:[detailData objectForKey:@"COL_DESCRIPTION"] baseURL:nil];
                    }
                }
            }else
            {
                noDataLable = [[UILabel alloc] initWithFrame:CGRectMake(screenWidth/2-40, screenHeight/2-25, 80, 50)];
                [noDataLable setText:@"暂无数据"];
                [noDataLable setTextAlignment:NSTextAlignmentCenter];
                [noDataLable setFont:[UIFont systemFontOfSize:18]];
                [self.view setBackgroundColor:[UIColor grayColor]];
                [self .view addSubview:noDataLable];
            }
        });
    }
    @catch (NSException *exception) {
        NSLog(@"getApproveDataDetailList error:%@",exception);
    }
    @finally {
    }

}
-(void)showAlertView:(NSString *)msg
{
    UIAlertView *msgView = [[UIAlertView alloc] initWithTitle:msg message:@"" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    msgView.tag=3;
    [msgView show];
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

@end
