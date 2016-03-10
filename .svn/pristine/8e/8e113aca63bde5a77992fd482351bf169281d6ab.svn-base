//
//  ViewController.m
//  Test
//
//  Created by 邱健 on 14/11/5.
//  Copyright (c) 2014年 邱健. All rights reserved.
//

#import "OverviewController.h"
#import "CrmNetServiceUtil.h"
#import "ResponseModel.h"
#import "PopoverView.h"
#import "FollowUpController.h"
#import "OverviewDetailController.h"
#import "NSString+FontAwesome.h"
#import "FAImageView.h"

@interface OverviewController ()
{
    BOOL isLoadingNext;
    NSDictionary *dic;
    UIView *titleView;
    UIView *userView;
    UIView *ProjectView;
    UIView *showMessageView;
    UIButton *returnBtn;
}
@end

@implementation OverviewController
@synthesize dataList;
@synthesize secDateList;
@synthesize thirdDateList;
@synthesize projectDateList;
@synthesize myTableView;
@synthesize dataListHead;
@synthesize userList;
@synthesize selectProjectBtn;
@synthesize selectUserBtn;
@synthesize custTotalList;
@synthesize fistCustTotalList;
@synthesize secondCustTotalList;
@synthesize thirdCustTotalList;
//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        // Custom initialization
//    }
//    return self;
//}
- (void)viewDidLoad {
    [super viewDidLoad];
    titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 60)];
    [titleView setBackgroundColor:[UIColor colorWithRed:34/255.0 green:34/255.0 blue:34/255.0 alpha:0.83]];
//    titleView.layer.shadowColor = [UIColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:0.21].CGColor;//shadowColor阴影颜色
//    titleView.layer.shadowOffset = CGSizeMake(0,3);//shadowOffset阴影偏移,x向右偏移0，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
//    titleView.layer.shadowOpacity = 1;//阴影透明度，默认0
//    titleView.layer.shadowRadius = 3;//阴影半径，默认3
    //返回按钮 start
    returnBtn = [[UIButton alloc] initWithFrame:CGRectMake(0,22, 45, 30)];
    // 加入button单击事件
    [returnBtn addTarget:self action:@selector(backToRootViewController) forControlEvents:UIControlEventTouchUpInside];
    [returnBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];//title color
    [returnBtn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];//设置title的高亮颜色
//    [returnBtn setTitle:@"返回" forState:UIControlStateNormal];
//    [returnBtn setFont:[UIFont systemFontOfSize:15]];
    
    [returnBtn setFont:[UIFont fontWithName:kFontAwesomeFamilyName size:30]];
    [returnBtn setTitle:[NSString fontAwesomeIconStringForEnum:FAAngleLeft] forState:UIControlStateNormal];
//    [returnBtn.layer setMasksToBounds:YES];
//    [returnBtn.layer setCornerRadius:5]; //设置矩形四个圆角半径
//    [returnBtn.layer setBorderWidth:1.0]; //边框宽度
//    [returnBtn.layer setBorderColor:[UIColor colorWithRed:0.0/255 green:153.0/255 blue:204.0/255 alpha:1].CGColor];//边框颜色
    // [returnBtn.layer setBackgroundColor:[UIColor greenColor].CGColor];//背景颜色
//    UILabel *arrow = [[UILabel alloc] initWithFrame:CGRectMake(7, 8, 10, 13)];
//    arrow.font =[UIFont fontWithName:kFontAwesomeFamilyName size:20];
//    arrow.text = [NSString fontAwesomeIconStringForEnum:FAAngleLeft];
//    arrow.textColor = [UIColor whiteColor];
//    [returnBtn addSubview:arrow];
    [titleView addSubview:returnBtn];
    [self.view addSubview:titleView];
    // 初始化第一个section的数据
    dataList = [NSArray arrayWithObjects:@"Total Customers",@"No Follow-Up Yet",@"Followed Up", nil];//,@"已成交"
    // 初始化第二个section的数据
    secDateList = [NSArray arrayWithObjects:@"0 to 30 days",@"31 to 60 days",@"61 to 90 days",@"more than 91", nil];//,@"100天以上",@"120天以上",@"130天以上"
//    thirdDateList = [NSArray arrayWithObjects:@"A-明确表示开盘时会购买",@"B-需考虑户型、面积、价格",@"C-意向一般，仍可跟进",@"D-明确表示暂不考虑购买",@"E-联系不上", nil];
    [self showLoadingView];
    [NSThread detachNewThreadSelector:@selector(startDetailThread) toTarget:self withObject:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//取项目列表
-(void)startDetailThread
{
    [selectProjectBtn removeFromSuperview];
    [selectUserBtn removeFromSuperview];
    NSUserDefaults *userID = [NSUserDefaults standardUserDefaults];
    //读取保存在NSUserDefaults的用户id
//    NSString *UserID = [userID objectForKey:@"SELECTUSERID"];
    NSString *UserID = [userID objectForKey:@"CRM_USERID"];
    //rload时重新赋值
    [userID setObject:UserID forKey:@"CRM_SELECTUSERID"];

//    NSString *UserIDStr  = [NSString stringWithFormat:@"[%ld]",(long)UserID];
    NSArray *userDetail = [UserID componentsSeparatedByString:@"_"];
    NSString *userId =[userDetail objectAtIndex:0];
    NSString *userName =[userDetail objectAtIndex:1];
    NSString *soapMessage=[@"method=getProjectPerms&parameter="stringByAppendingString:[NSString stringWithFormat: @"[%@]",userId]];
    NSLog(@"soapMessage%@",soapMessage);
    ResponseModel *response = [CrmNetServiceUtil startRecommandlistByPage:1 Message:soapMessage];
    isLoadingNext = NO;
    dic = response.resultInfo;
    dispatch_async(dispatch_get_main_queue(), ^(void)
                   {
                       if (response.error !=nil) {
                           [self showErrorView];
                           [self showAlertView:@"请检查网络"];
                           return;
                       }
                       projectDateList = [dic objectForKey:@"result"];
                       if ([projectDateList count] == 0) {
                           [self showAlertView:@"项目列表暂无相关数据"];
                           return;
                       }else{
                           //设置项目
                          // NSString *projectId =  [userID objectForKey:@"CRM_PROJECTID"];
                           
                           NSString *dataStr = [projectDateList objectAtIndex:0];
                           NSArray *projectDetail = [dataStr componentsSeparatedByString:@"_"];
                           NSString *projectId =[projectDetail objectAtIndex:0];
                           //保存ProjectID在NSUserDefaults
                           NSUserDefaults *PorjectID = [NSUserDefaults standardUserDefaults];
                            NSString *projectName =[projectDetail objectAtIndex:1];
                           [PorjectID setObject:projectId forKey:@"CRM_PROJECTID"];
                           [PorjectID setObject:projectName forKey:@"CRM_PROJECTNAME"];
                           [PorjectID synchronize];
                           
                           UIButton *qrCodeBtn = [[UIButton alloc] initWithFrame:CGRectMake(86,24, 30, 30)];
                           [qrCodeBtn setFont:[UIFont fontWithName:kFontAwesomeFamilyName size:15]];
                           [qrCodeBtn setTitle:[NSString fontAwesomeIconStringForEnum:FAQrcode] forState:UIControlStateNormal];
                           [titleView addSubview:qrCodeBtn];
                           
                           selectProjectBtn =[UIButton buttonWithType:UIButtonTypeCustom];
                           [selectProjectBtn setFrame:CGRectMake(115,23, 110, 30)];
                           [selectProjectBtn setTitle:projectName forState:UIControlStateNormal];
                           [selectProjectBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
//                           [selectProjectBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -25, 0, 0)];
                           [selectProjectBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                           [selectProjectBtn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
                           //[selectProjectBtn.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:15]];
                          [selectProjectBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
                           
                           //[UIFont systemFontOfSize:15];
                           //项目数量大于1才绑定下拉事件
                           if ([projectDateList count] > 1) {
                               [selectProjectBtn addTarget:self action:@selector(projectBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
                           }
//                           [selectProjectBtn.layer setMasksToBounds:YES];
//                           [selectProjectBtn.layer setCornerRadius:5]; //设置矩形四个圆角半径
//                           [selectProjectBtn.layer setBorderWidth:2.0]; //边框宽度
//                           [selectProjectBtn.layer setBorderColor:[UIColor whiteColor].CGColor];//边框颜色
//                           [selectProjectBtn setBackgroundColor:[UIColor greenColor].CGColor];//背景颜色
                           [titleView addSubview:selectProjectBtn];
                           
                           //[NSThread detachNewThreadSelector:@selector(startUserListThread) toTarget:self withObject:nil];
                           [NSThread detachNewThreadSelector:@selector(startCustDataThread) toTarget:self withObject:nil];
                       }
                       
                   }
                   );
}
//取用户列表
-(void)startUserListThread
{
    NSUserDefaults *userID = [NSUserDefaults standardUserDefaults];
    //读取保存在NSUserDefaults的用户id
    NSString *UserID = [userID objectForKey:@"CRM_USERID"];
    NSArray *userDetail = [UserID componentsSeparatedByString:@"_"];
    NSString *userId =[userDetail objectAtIndex:0];
    NSString *userName =[userDetail objectAtIndex:1];
    NSString *soapMessage=[@"method=getUserPerms&parameter="stringByAppendingString:[NSString stringWithFormat: @"[%@]",userId]];
    ResponseModel *responseUser = [CrmNetServiceUtil startRecommandlistByPage:1 Message:soapMessage];
    isLoadingNext = NO;
    dic = responseUser.resultInfo;
    dispatch_async(dispatch_get_main_queue(), ^(void)
                   {
                       if (responseUser.error !=nil) {
                           [self showErrorView];
                           [self showAlertView:@"请检查网络"];
                           return;
                       }
                       userList = [dic objectForKey:@"result"];
                       if ([userList count] == 0) {
                           [self showAlertView:@"用户列表暂无相关数据"];
                           return;
                       }else{
                           //设置用户
                           selectUserBtn =[UIButton buttonWithType:UIButtonTypeCustom];		
                           [selectUserBtn setFrame:CGRectMake(self.view.frame.size.width-80,21, 70, 37)];
//                           [selectUserBtn setBackgroundColor:[UIColor colorWithRed:0.0/255 green:153.0/255 blue:204.0/255 alpha:1]];
                           [selectUserBtn setTitle:userName forState:UIControlStateNormal];
                           [selectUserBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
                           [selectUserBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                           [selectUserBtn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];//设置title的高亮颜色
                           [selectUserBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
//                           [selectUserBtn.layer setMasksToBounds:YES];
//                           [selectUserBtn.layer setCornerRadius:5]; //设置矩形四个圆角半径
//                           [selectUserBtn.layer setBorderWidth:2.0]; //边框宽度
//                           [selectUserBtn.layer setBorderColor:[UIColor whiteColor].CGColor];//边框颜色
//                           UIImageView *arrow = [[UIImageView alloc] initWithFrame:CGRectMake(70, 12, 8, 8)];//添加下拉箭头图片
//                           [arrow setImage:[UIImage imageNamed:@"ico-arrow-dropdown-white.png"]];
//                           [selectUserBtn addSubview:arrow];
                           
                           //项目数量大于1才绑定下拉事件
                           if ([userList count] > 1) {
                               [selectUserBtn addTarget:self action:@selector(userBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
                           }
                           [titleView addSubview:selectUserBtn];
                           
                       }
                   }
                   );
//    FollowUpController *DetailView=[[FollowUpController alloc] init];
//    DetailView.viewDidLoad;

}
//取统计列表
-(void)startCustDataThread
{
    [myTableView removeFromSuperview];//先移除myTableView，防止切换用户时多个myTableView重叠
    NSUserDefaults *Parmers = [NSUserDefaults standardUserDefaults];
    //读取保存在NSUserDefaults的用户id
    NSString *UserID = [Parmers objectForKey:@"CRM_SELECTUSERID"];
    NSArray *userDetail = [UserID componentsSeparatedByString:@"_"];
    NSString *userId =[userDetail objectAtIndex:0];
    //读取保存在NSUserDefaults的ProjectID
    NSString *projectID = [Parmers objectForKey:@"CRM_PROJECTID"];
    NSString *soapMessage=[@"method=getCustDetailTotal&parameter="stringByAppendingString:[NSString stringWithFormat: @"[%@,%@]",userId,projectID]];
    NSLog(@"soapMessage%@",soapMessage);
    ResponseModel *responseUser = [CrmNetServiceUtil startRecommandlistByPage:1 Message:soapMessage];
    isLoadingNext = NO;
    dic = responseUser.resultInfo;
    dispatch_async(dispatch_get_main_queue(), ^(void)
                   {
                       if (responseUser.error !=nil) {
                           [self showErrorView];
//                           [self showAlertView:@"请检查网络"];
                           return;
                       }
                       [self hideLoadingView];
                       custTotalList = [dic objectForKey:@"result"];
//                       NSLog(@"custTotalList--->%lu",(unsigned long)[custTotalList count]);
                       if ([custTotalList count] == 0) {
//                           [self showAlertView:@"该用户暂无客户数据"];
                           return;
                       }else{
                           for (int i = 0; i <= custTotalList.count; i++) {
                               if (i == 0) {
                                   //第一个section中的数据
                                   fistCustTotalList = [custTotalList objectAtIndex:i];
                               }
                               if (i == 1) {
                                   //第二个section中的数据
                                   secondCustTotalList = [custTotalList objectAtIndex:i];
                               }
                               if(i==2){
                                    thirdCustTotalList = [custTotalList objectAtIndex:i];
                               }
                           }
                           myTableView  = [[UITableView alloc] initWithFrame:CGRectMake(0, 65, self.view.frame.size.width, self.view.frame.size.height-60-57) style:UITableViewStyleGrouped];//
                           // 设置tableView的数据源
                           myTableView.dataSource = self;
                           // 设置tableView的委托
                           myTableView.delegate = self;
                           // 设置tableView的背景图
                           //myTableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"01.png"]];
                           [self.view addSubview:myTableView];
                       }
                   }
                   );
    //动作发生的时候发送通知给所有的监听者,执行相关操作
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ReloadView" object:nil];
}

-(void)errorViewTapGesture:(UITapGestureRecognizer *)tapGesture
{
    [super errorViewTapGesture:tapGesture];
    [NSThread detachNewThreadSelector:@selector(startDetailThread) toTarget:self withObject:nil];
}
-(void)showAlertView:(NSString *)message
{
    NSString *m = message;
    if (message == nil) {
        m=@"error";
    }
    if ([message isEqual:@"0"]) {
        m = @"暂无相关数据";
    }
    NSLog(@"%@",message);
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:m delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alertView show];
}
-(void)showMessageView:(NSString *)message
{
    [myTableView removeFromSuperview];//先移除myTableView
    [showMessageView removeFromSuperview];
    NSString *msg = message;
    if (message == nil) {
        msg=@"error";
    }
    if ([message isEqual:@"0"]) {
        msg = @"暂无相关数据";
    }
    showMessageView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height/2-25, self.view.frame.size.width, 50)];
    UILabel *msgLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,10, self.view.frame.size.width, 40)];
    msgLabel.text =msg;
    msgLabel.textAlignment = NSTextAlignmentCenter;
    msgLabel.textColor =[UIColor blackColor];
    msgLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
    [showMessageView addSubview:msgLabel];
    [self.view addSubview:showMessageView];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return [dataList count];
    }
    else if(section == 1){
        return [secDateList count];
    }
    else{
//        return [thirdDateList count];
        return [thirdCustTotalList count];
    }
}

//heightForRowAtIndexPath表示cell高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;//设置每个cell高度
}
//创建并设置每行显示的内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellWithIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellWithIdentifier];
//    UIButton * alreadyFollowUpButton;
//    UIButton * notFollowUpButton;
//    cell = nil;//对取出的重用的cell做重新赋值，不要遗留老数据,否则易出现数据错乱或者数据重复
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellWithIdentifier];
        //[cell setBackgroundColor:[UIColor clearColor]];
    }
    else
    {
        while ([cell.contentView.subviews lastObject] != nil) {
            [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        }
        
        //alreadyFollowUpButton = (UIButton *)[cell viewWithTag:indexPath.row+100];
    }
    NSUInteger row = indexPath.row;
    if(indexPath.section == 0){
        [dataList objectAtIndex:row];
        cell.textLabel.text = [dataList objectAtIndex:row];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        UILabel *cellLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width-65,8, 40, 30)];
        cellLabel.textAlignment = UITextAlignmentCenter;
        [cellLabel setFont:[UIFont systemFontOfSize:17]];
        //设置uilabel边框圆角,边框粗细，边框颜色，layer背景颜色等样式,适用的是layer下面的各种属性
        cellLabel.layer.cornerRadius = 5;
        cellLabel.layer.borderWidth = 1;
        NSString  *total ;
        switch (indexPath.row)
        {
            case 0://客户总数
                total = [fistCustTotalList objectAtIndex:0];
                [cellLabel  setText:total];
                cellLabel.layer.borderColor = [UIColor clearColor].CGColor;
//                cellLabel.layer.borderColor = [UIColor greenColor].CGColor;
//                cellLabel.layer.backgroundColor = [UIColor greenColor].CGColor;
                break;
            case 1://新分配/未跟进人数
                total = [fistCustTotalList objectAtIndex:1];
                [cellLabel  setText:total];
                [cellLabel setTextColor:[UIColor whiteColor]];
                cellLabel.layer.borderColor = [UIColor clearColor].CGColor;
                cellLabel.layer.borderColor = [UIColor colorWithRed:0.0/255 green:153.0/255 blue:204.0/255 alpha:1].CGColor;
                cellLabel.layer.backgroundColor = [UIColor colorWithRed:0.0/255 green:153.0/255 blue:204.0/255 alpha:1].CGColor;

                break;
            case 2://已跟进人数
                total = [fistCustTotalList objectAtIndex:2];
                [cellLabel  setText:total];
                cellLabel.layer.borderColor = [UIColor clearColor].CGColor;
            //  cellLabel.layer.borderColor = [UIColor redColor].CGColor;
            //  cellLabel.layer.backgroundColor = [UIColor redColor].CGColor;
                break;
            default:
                [cellLabel  setText:@"0"];
                cellLabel.layer.borderColor = [UIColor clearColor].CGColor;
//                cellLabel.layer.borderColor = [UIColor grayColor].CGColor;
//                cellLabel.layer.backgroundColor = [UIColor grayColor].CGColor;
                break;
        }
        cellLabel.font = [UIFont systemFontOfSize:15];
        [cell.contentView addSubview: cellLabel];
    }
    else if(indexPath.section == 1){
//        NSInteger count =secondCustTotalList.count/2;
        //已跟进按钮 start
//        alreadyFollowUpButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width-132, 5, 50, 45)];
//        alreadyFollowUpButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width-85,12, 60, 30)];
//            // 加入button单击事件
//        [alreadyFollowUpButton addTarget:self action:@selector(accessoryDetailDisclosureButtonPress: event:) forControlEvents:UIControlEventTouchUpInside];
//        alreadyFollowUpButton.tag = indexPath.row+100;
////        [alreadyFollowUpButton setTitle:@"25" forState:UIControlStateNormal];//button title
//        [alreadyFollowUpButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];//title color
//        [alreadyFollowUpButton.layer setMasksToBounds:YES];
//        [alreadyFollowUpButton.layer setCornerRadius:5]; //设置矩形四个圆角半径
//        [alreadyFollowUpButton.layer setBorderWidth:1.0]; //边框宽度
//        [alreadyFollowUpButton.layer setBorderColor:[UIColor greenColor].CGColor];//边框颜色
//        [alreadyFollowUpButton.layer setBackgroundColor:[UIColor greenColor].CGColor];//背景颜色
        //已跟进按钮 end
            
//        //未跟进按钮 start
//        notFollowUpButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width-62, 5, 50, 45)];
//        [notFollowUpButton addTarget:self action:@selector(notFollowUpButtonButtonPress: event:) forControlEvents:UIControlEventTouchUpInside];
//        notFollowUpButton.tag = indexPath.row+200;
////        [notFollowUpButton setTitle:@"15" forState:UIControlStateNormal];//button title
//        [notFollowUpButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];//title color
//        [notFollowUpButton.layer setMasksToBounds:YES];
//        [notFollowUpButton.layer setCornerRadius:5]; //设置矩形四个圆角半径
//        [notFollowUpButton.layer setBorderWidth:1.0]; //边框宽度
//        [notFollowUpButton.layer setBorderColor:[UIColor grayColor].CGColor];//边框颜色
//        [notFollowUpButton.layer setBackgroundColor:[UIColor grayColor].CGColor];//背景颜色
//        //未跟进按钮 end
        [secDateList objectAtIndex:row];
        cell.textLabel.text = [secDateList objectAtIndex:row];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;//隐藏选中效果
        UILabel *cellLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width-65,8, 40, 30)];
        cellLabel.textAlignment = UITextAlignmentCenter;
        [cellLabel setFont:[UIFont systemFontOfSize:17]];
        //设置uilabel边框圆角,边框粗细，边框颜色，layer背景颜色等样式,适用的是layer下面的各种属性
        cellLabel.layer.cornerRadius = 5;
        cellLabel.layer.borderWidth = 1;

        switch (indexPath.row)
        {
            case 0://0-30天
//                [alreadyFollowUpButton setTitle:[secondCustTotalList objectAtIndex:0] forState:UIControlStateNormal];//button title
//                [notFollowUpButton setTitle:[secondCustTotalList objectAtIndex:1] forState:UIControlStateNormal];//button title
                [cellLabel  setText:[secondCustTotalList objectAtIndex:0]];
//                cellLabel.layer.borderColor = [UIColor greenColor].CGColor;
//                cellLabel.layer.backgroundColor = [UIColor greenColor].CGColor;
                break;
            case 1://31-60天
//                [alreadyFollowUpButton setTitle:[secondCustTotalList objectAtIndex:2] forState:UIControlStateNormal];//button title
//                [notFollowUpButton setTitle:[secondCustTotalList objectAtIndex:3] forState:UIControlStateNormal];//button title
                [cellLabel  setText:[secondCustTotalList objectAtIndex:1]];
//                cellLabel.layer.borderColor = [UIColor greenColor].CGColor;
//                cellLabel.layer.backgroundColor = [UIColor greenColor].CGColor;
                break;
            case 2://61天－90天
//                [alreadyFollowUpButton setTitle:[secondCustTotalList objectAtIndex:4] forState:UIControlStateNormal];//button title
//                [notFollowUpButton setTitle:[secondCustTotalList objectAtIndex:5] forState:UIControlStateNormal];//button title
                [cellLabel  setText:[secondCustTotalList objectAtIndex:2]];
//                cellLabel.layer.borderColor = [UIColor greenColor].CGColor;
//                cellLabel.layer.backgroundColor = [UIColor greenColor].CGColor;
                break;
            case 3://91天以上
//                [alreadyFollowUpButton setTitle:[secondCustTotalList objectAtIndex:4] forState:UIControlStateNormal];//button title
//                [notFollowUpButton setTitle:[secondCustTotalList objectAtIndex:5] forState:UIControlStateNormal];//button title
                [cellLabel  setText:[secondCustTotalList objectAtIndex:3]];
//                cellLabel.layer.borderColor = [UIColor greenColor].CGColor;
//                cellLabel.layer.backgroundColor = [UIColor greenColor].CGColor;
                
                break;
            default:

                break;
        }
        
        cellLabel.layer.borderColor = [UIColor clearColor].CGColor;
        cellLabel.font = [UIFont systemFontOfSize:15];
        [cell.contentView addSubview: cellLabel];
//        [cell.contentView addSubview: alreadyFollowUpButton];
//        [cell.contentView addSubview: notFollowUpButton];
    }
    else{
//        [thirdDateList objectAtIndex:row];
        NSDictionary *custLevelDetail = [thirdCustTotalList objectAtIndex:row];
        cell.tag = [[custLevelDetail objectForKey:@"sysParaId"] integerValue];
        cell.textLabel.text = [custLevelDetail objectForKey:@"title"];
        UILabel *cellLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width-65,8, 40, 30)];
        cellLabel.textAlignment = UITextAlignmentCenter;
        [cellLabel setFont:[UIFont systemFontOfSize:17]];
        //设置uilabel边框圆角,边框粗细，边框颜色，layer背景颜色等样式,适用的是layer下面的各种属性
        cellLabel.layer.cornerRadius = 5;
        cellLabel.layer.borderWidth = 1;
        [cellLabel  setText:[custLevelDetail objectForKey:@"value"]];
        cellLabel.layer.borderColor = [UIColor clearColor].CGColor;
        cellLabel.font = [UIFont systemFontOfSize:15];
        [cell.contentView addSubview: cellLabel];
    }
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.textColor = [UIColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:0.87];
    cell.accessoryType = UITableViewCellAccessoryNone;//UITableViewCellSelectionStyleGray
    return cell;
}

//// 检查用户点击已跟进按钮时的位置，并转发事件到对应的accessory tapped事件
//-(void)accessoryDetailDisclosureButtonPress:(id)sender event:(id)event
//{
//    NSSet *touches = [event allTouches];
//    UITouch *touch = [touches anyObject];
//    CGPoint currentTouchPosition = [touch locationInView:myTableView];
//    NSIndexPath *indexPath = [myTableView indexPathForRowAtPoint:currentTouchPosition];
//    NSString *cellcontent = nil;
//    if(indexPath != nil)
//    {
//        [self tableView:myTableView didSelectRowAtIndexPath:indexPath];
//        cellcontent = @"已跟进--";
//        UITableViewCell  *cell = [self.myTableView cellForRowAtIndexPath:indexPath];
//        cellcontent = [cellcontent stringByAppendingString:[NSString stringWithFormat:@"%@",cell.textLabel.text]];
//
//    }
//    UIAlertView *messageAlert = [[UIAlertView alloc]
//                                 initWithTitle:@"section2选中的菜单" message:cellcontent delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//    [messageAlert show];
//}
//// 检查用户点击未跟进按钮时的位置，并转发事件到对应的accessory tapped事件
//-(void)notFollowUpButtonButtonPress:(id)sender event:(id)event
//{
//    NSSet *touches = [event allTouches];
//    UITouch *touch = [touches anyObject];
//    CGPoint currentTouchPosition = [touch locationInView:myTableView];
//    NSIndexPath *indexPath = [myTableView indexPathForRowAtPoint:currentTouchPosition];
//    NSString *cellcontent = nil;
//    if(indexPath != nil)
//    {
//        [self tableView:myTableView didSelectRowAtIndexPath:indexPath];
//        UITableViewCell  *cell = [self.myTableView cellForRowAtIndexPath:indexPath];
//        cellcontent = @"未跟进——";
//        NSString *cellDetailLabel = cell.textLabel.text;
//        //[cellcontent stringByAppendingString:cellDetailLabel];
//        cellcontent = [cellcontent stringByAppendingString:[NSString stringWithFormat:@"%@",cellDetailLabel
//                                                          ]];
//    }
//    UIAlertView *messageAlert = [[UIAlertView alloc]
//                                 initWithTitle:@"section2选中的菜单" message:cellcontent delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//    [messageAlert show];
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if(indexPath.section == 0)
//    {
        UITableViewCell  *cell = [self.myTableView cellForRowAtIndexPath:indexPath];
        //获取cell内容
        NSString *cellcontent =cell.textLabel.text;
//        UIAlertView *messageAlert = [[UIAlertView alloc]
//                                     initWithTitle:@"选中的菜单" message:cellcontent delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        [messageAlert show];
//    }
    CustEntity *custEntity = [[CustEntity alloc] init];
    OverviewDetailController* DetailView=[[OverviewDetailController alloc] init];
    //设置OverviewDetailController中需要传递的值
    if(indexPath.section == 2)//表示是客户等级，直接传等级id
    {
        custEntity.OverViewType = [NSString stringWithFormat: @"levelId_%d",cell.tag];
        NSLog(@"OverViewType------>%@",custEntity.OverViewType);
        DetailView.custEntity = custEntity;
        
    }else{
        custEntity.OverViewType = cellcontent;
        DetailView.custEntity = custEntity;
    }
    custEntity.OverViewText = cellcontent;
    //跳转界面
    [self presentModalViewController:DetailView animated:YES];
    //交互完成之后移除高亮显示,通知表格取消单元格选中状态
    [self performSelector:@selector(delectCellByOverview:) withObject:nil afterDelay:1];
}
-(void)delectCellByOverview:(id)sender{
    [self.myTableView deselectRowAtIndexPath:[self.myTableView indexPathForSelectedRow] animated:YES];
}

//section （标签）标题显示
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//    if(section == 0)
//    {
//        return @"总览";
//    }
//    else
//    {
//        return [dataListHead objectAtIndex:section];
//    }
    return nil;
    
}

//标签数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

// 设置section Header的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30.0f;
}
// 设置section Footer的高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *v = nil;
    if (section == 1) {
        v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)];
//        [v setBackgroundColor:[UIColor colorWithRed:238.0/255 green:238.0/255 blue:238.0/255  alpha:1]];
        UILabel *labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(15, 8, 120, 15)];
        labelTitle.textAlignment = NSTextAlignmentLeft;
        labelTitle.text = @"Recent Follow-Up";
        labelTitle.textColor =[UIColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:0.53];
        labelTitle.font = [UIFont fontWithName:@"Helvetica" size:13];
        [v addSubview:labelTitle];
        
        UILabel *labelTitle1 = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width-95,8, 80, 15)];
        labelTitle1.textAlignment = NSTextAlignmentCenter;
        labelTitle1.text = @"Followe Up";
        labelTitle1.textColor =[UIColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:0.53];
        labelTitle1.font = [UIFont fontWithName:@"Helvetica" size:13];
        [v addSubview:labelTitle1];
    }
    else if(section == 0)
    {
        v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)];
        UILabel *labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(15, 11, 80, 10)];
        labelTitle.textAlignment = NSTextAlignmentLeft;
        labelTitle.text = @"Customer";
        labelTitle.textColor =[UIColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:0.53];
         labelTitle.font = [UIFont fontWithName:@"Helvetica" size:13];
        [v addSubview:labelTitle];
    }
    else{
        v = [[UIView alloc] initWithFrame:CGRectMake(5, 0, self.view.frame.size.width, 20)];
        UILabel *labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(15, 8, 100, 15	)];
        labelTitle.textAlignment = NSTextAlignmentLeft;
        labelTitle.text = @"Level Of Intent";
        labelTitle.textColor =[UIColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:0.53];
        labelTitle.font = [UIFont fontWithName:@"Helvetica" size:13];
        [v addSubview:labelTitle];
    }
    return v;
}

-(void)projectBtnClicked:(UIButton *)sender
{
    CGPoint point = CGPointMake(sender.frame.origin.x + sender.frame.size.width/2, sender.frame.origin.y + sender.frame.size.height);
    PopoverView *pop = [[PopoverView alloc] initWithPoint:point titles:projectDateList images:nil FrameHeight:self.view.frame.size.width];
    pop.selectRowAtIndex = ^(NSString *index){
        NSLog(@"select index:%@", index);
        NSArray *projectDetail = [index componentsSeparatedByString:@"_"];
        NSString *projectId =[projectDetail objectAtIndex:0];
        NSString *projectName =[projectDetail objectAtIndex:1];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"CRM_PROJECTID"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"CRM_PROJECTNAME"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        NSUserDefaults *Parmers = [NSUserDefaults standardUserDefaults];
        [Parmers setObject:projectId forKey:@"CRM_PROJECTID"];
        [Parmers setObject:projectName forKey:@"CRM_PROJECTNAME"];
        [Parmers synchronize];
        [selectProjectBtn setTitle:projectName forState:UIControlStateNormal];
        [self showLoadingView];
        
        [NSThread detachNewThreadSelector:@selector(startCustDataThread) toTarget:self withObject:nil];
    };
    [pop show];
}
-(void)userBtnClicked:(UIButton *)sender
{
    CGPoint userPoint = CGPointMake(sender.frame.origin.x + sender.frame.size.width/2, sender.frame.origin.y + sender.frame.size.height);
    PopoverView *userPop = [[PopoverView alloc] initWithPoint:userPoint titles:userList images:nil FrameHeight:self.view.frame.size.width];
    userPop.selectRowAtIndex = ^(NSString *index){
        NSArray *userDetail = [index componentsSeparatedByString:@"_"];
        NSString *userId =[userDetail objectAtIndex:0];
        NSString *userName =[userDetail objectAtIndex:1];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"CRM_SELECTUSERID"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        NSUserDefaults *Parmers = [NSUserDefaults standardUserDefaults];
        [Parmers setObject:index forKey:@"CRM_SELECTUSERID"];
        [Parmers synchronize];
        NSLog(@"userDetail index:%@", index);
        [selectUserBtn setTitle:userName forState:UIControlStateNormal];
        [self showLoadingView];
        [NSThread detachNewThreadSelector:@selector(startCustDataThread) toTarget:self withObject:nil];
        
        
    };
    [userPop show];
}
-(void)backToRootViewController
{
    [[[CrmRootViewController sharedInstance] navigationController] popToRootViewControllerAnimated:YES];
}
@end
