//
//  FollowUpController.m
//  Test
//
//  Created by 邱健 on 14/11/5.
//  Copyright (c) 2014年 邱健. All rights reserved.
//

#import "FollowUpController.h"
#import "FollowUpDetailController.h"
#import "CommInitViewUtil.h"
#import "CrmNetServiceUtil.h"
#import "ResponseModel.h"
#import "CustEntity.h"
#import "NSString+FontAwesome.h"
#import "FAImageView.h"
#import "AddCustomerController.h"
#import "AddCustPopoverView.h"

@interface FollowUpController ()
{
    UIView *titleView;
    UIView *searchView;
    UITextField *searchField;//查询条件输入框
    double scrViewWidth;//屏幕宽度
    BOOL isLoadingNext;
    NSDictionary *dic;
    UIView *showMessageView;
    UILabel *labelTitle;
    UIButton *AddCust;//新增客户按钮
    NSArray *AddCustTypeList;
}
@end

@implementation FollowUpController
@synthesize custTabView;
@synthesize custDataList;

//处理通告，重新刷新页面
-(void)receivedNotif:(NSNotification *)notification {
//    self.viewDidLoad;
//    [self showLoadingView];
    searchField.text = @"";
    searchField.placeholder=@"Search By Name, NO.,Tele";
    NSUserDefaults *Parmers = [NSUserDefaults standardUserDefaults];
    NSString *projectName = [Parmers objectForKey:@"CRM_PROJECTNAME"];
    [labelTitle  setText:[projectName stringByAppendingString:[NSString stringWithFormat:@"%@",@"-客户跟进"]]];
    [NSThread detachNewThreadSelector:@selector(startFollowUpListThread) toTarget:self withObject:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //注册通告,在需要接收通知的类中添加观察者,接收通告 start
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedNotif:) name:@"ReloadView" object:nil];
    //end
    // Do any additional setup after loading the view.
    scrViewWidth = self.view.frame.size.width;//屏幕宽度
    titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 60)];
    [titleView setBackgroundColor:[UIColor colorWithRed:34/255.0 green:34/255.0 blue:34/255.0 alpha:0.83]];
//    titleView.layer.shadowColor = [UIColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:0.21].CGColor;//shadowColor阴影颜色
//    titleView.layer.shadowOffset = CGSizeMake(0,3);//shadowOffset阴影偏移,x向右偏移0，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
//    titleView.layer.shadowOpacity = 1;//阴影透明度，默认0
//    titleView.layer.shadowRadius = 3;//阴影半径，默认3
    
    labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-75, 20, 150, 40)];
    //[labelTitle setBackgroundColor:[UIColor clearColor]];
    //labelTitle.textAlignment = NSTextAlignmentCenter;
    NSUserDefaults *Parmers = [NSUserDefaults standardUserDefaults];
    NSString *projectName = [Parmers objectForKey:@"CRM_PROJECTNAME"];
    
    [labelTitle  setText:[projectName stringByAppendingString:[NSString stringWithFormat:@"%@",@"-客户跟进"]]];
    //labelTitle.text = @"跟进";
    labelTitle.textColor =[UIColor whiteColor];
    //labelTitle.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];// [UIFont systemFontOfSize:20];
    [labelTitle setFont:[UIFont systemFontOfSize:15]];
    [titleView addSubview:labelTitle];
    //新增按钮 start
//    AddCust = [[UIButton alloc] initWithFrame:CGRectMake(scrViewWidth-50, 20, 50, 40)];
//    // 加入button单击事件
//    [AddCust addTarget:self action:@selector(AddCustBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//    [AddCust setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];//title color
//    [AddCust setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];//设置title的高亮颜色
//    AddCust.titleLabel.font = [UIFont fontWithName:kFontAwesomeFamilyName size:20];
//    [AddCust setTitle:[NSString fontAwesomeIconStringForEnum:FAPlusCircle] forState:UIControlStateNormal];
////    AddCust.contentHorizontalAlignment= UIControlContentHorizontalAlignmentRight;
//    [AddCust.layer setMasksToBounds:YES];
//    [AddCust.layer setCornerRadius:5]; //设置矩形四个圆角半径
//    [AddCust.layer setBorderWidth:1.0]; //边框宽度
//    [AddCust.layer setBorderColor:[UIColor colorWithRed:0.0/255 green:153.0/255 blue:204.0/255 alpha:1].CGColor];//边框颜色
////     [AddCust.layer setBackgroundColor:[UIColor greenColor].CGColor];//背景颜色
//    [titleView addSubview:AddCust];
    AddCustTypeList = [NSArray arrayWithObjects:@"扫描名片",@"扫描身份证",@"New Customers", nil];
    AddCust =[UIButton buttonWithType:UIButtonTypeCustom];
    [AddCust setFrame:CGRectMake(scrViewWidth-50, 20, 50, 40)];
//    AddCust.titleLabel.font = [UIFont fontWithName:kFontAwesomeFamilyName size:20];
//    [AddCust setTitle:[NSString fontAwesomeIconStringForEnum:FAPlusCircle] forState:UIControlStateNormal];
    [AddCust setTitle:@"+" forState:UIControlStateNormal];
//    AddCust.titleLabel.font = [UIFont systemFontOfSize:15];
    [AddCust setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //[AddCust setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [AddCust setFont:[UIFont fontWithName:@"Helvetica-Bold" size:28]];
    //[AddCust.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [AddCust addTarget:self action:@selector(AddCustBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:AddCust];
    
    [self.view addSubview:titleView];
    
    searchView = [[UIView alloc] initWithFrame:CGRectMake(0, 60, scrViewWidth, 50)];
//    [searchView setBackgroundColor:[UIColor colorWithRed:238.0/255 green:238.0/255 blue:238.0/255 alpha:1]];
    //圆角的textFieldView的宽度＝屏幕宽度－屏幕宽度1／10*2
    double textFieldViewWidth = scrViewWidth-(scrViewWidth/10) * 2;
    UIView *textFieldView = [[UIView alloc] initWithFrame:CGRectMake(20, 5, (scrViewWidth-20)-20, 40)];
    [textFieldView.layer setMasksToBounds:YES];
    [textFieldView.layer setCornerRadius:18]; //设置矩形四个圆角半径
    [textFieldView.layer setBorderWidth:1.0]; //边框宽度
    [textFieldView.layer setBorderColor:[UIColor whiteColor].CGColor];//边框颜色
    [textFieldView.layer setBackgroundColor:[UIColor whiteColor].CGColor];//背景颜色
    searchField = [[UITextField alloc] initWithFrame:CGRectMake(15, 0, (scrViewWidth-20)-20-55, 40)];
    searchField.font = [UIFont fontWithName:@"Helvetica-Bold" size:13];//[UIFont systemFontOfSize:13];
    searchField.keyboardType = UIKeyboardTypeEmailAddress;//设置键盘类型
    searchField.returnKeyType = UIReturnKeyDone;//设置回车键类型
    searchField.placeholder=@"Search By Name, NO.,Tele";
    searchField.clearButtonMode = UITextFieldViewModeAlways;//设置一次性删除按钮
    searchField.delegate = self;
    [searchField.layer setBorderColor:[UIColor whiteColor].CGColor];//边框颜色
    [searchField.layer setBackgroundColor:[UIColor whiteColor].CGColor];//背景颜色
    [textFieldView addSubview:searchField];
    UIButton *searchBtn = [[UIButton alloc] initWithFrame:CGRectMake((scrViewWidth-20)-20-50, 0, 50, 50)];
    UIImageView *searchimage = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 20, 20)];
    [searchimage setImage:[UIImage imageNamed:@"ico-search.png"]];
    [searchBtn addSubview:searchimage];

    
    //[searchBtn setBackgroundImage:[UIImage imageNamed:@"ico-search.png"] forState:UIControlStateNormal];
//    [serchBtn setHighlighted:YES];//默认高亮
    [searchBtn addTarget:self action:@selector(searchBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    //[searchBtn.layer setBackgroundColor:[UIColor greenColor].CGColor];//背景颜色
    [searchBtn setShowsTouchWhenHighlighted:YES];
    [textFieldView addSubview: searchBtn];
    [searchView addSubview:textFieldView];
    [self.view addSubview:searchView];
    
    [self showLoadingView];
    [NSThread detachNewThreadSelector:@selector(startFollowUpListThread) toTarget:self withObject:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [searchField resignFirstResponder];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [searchField resignFirstResponder];
    [self showLoadingView];
    [NSThread detachNewThreadSelector:@selector(SearchFollowUpListThread) toTarget:self withObject:nil];
    return YES;
}
-(void)AddCustBtnClicked:(UIButton *)sender
{
    CGPoint addCustPoint = CGPointMake(sender.frame.origin.x + sender.frame.size.width/2, sender.frame.origin.y + sender.frame.size.height);
    AddCustPopoverView *addPop = [[AddCustPopoverView alloc] initWithPoint:addCustPoint titles:AddCustTypeList images:nil FrameHeight:self.view.frame.size.width];
    addPop.selectRowAtIndex = ^(NSInteger *index){
//        NSLog(@"addDetail index:%@", index);
        if (index == 2) {
            AddCustomerController *AddCustView=[[AddCustomerController alloc] init];
            //跳转界面
            [self presentModalViewController:AddCustView animated:YES];
        }
    };
    [addPop show];
}

-(void)startFollowUpListThread
{
    [custTabView removeFromSuperview];//先移除myTableView
    NSUserDefaults *Parmers = [NSUserDefaults standardUserDefaults];
    //读取保存在NSUserDefaults的用户id
    NSString *UserID = [Parmers objectForKey:@"CRM_SELECTUSERID"];
    NSArray *userDetail = [UserID componentsSeparatedByString:@"_"];
    NSString *userId =[userDetail objectAtIndex:0];
    //读取保存在NSUserDefaults的ProjectID
    NSString *projectID = [Parmers objectForKey:@"CRM_PROJECTID"];
    NSString *soapMessage=[@"method=getFollowUpList&parameter="stringByAppendingString:[NSString stringWithFormat: @"[%@,%@]",userId,projectID]];
    NSLog(@"soapMessage%@",soapMessage);
    //                             CrmNetServiceUtil startRecommandlistByPage:1:soapMessage
    ResponseModel *responseUser = [CrmNetServiceUtil startRecommandlistByPage:1 Message:soapMessage ];
    isLoadingNext = NO;
    dic = responseUser.resultInfo;
    dispatch_async(dispatch_get_main_queue(), ^(void)
                   {
                       if (responseUser.error !=nil) {
                           [self showErrorView];
//                           [self showAlertView:@"请检查网络"];
                           [self showMessageView:@"请检查网络"];
                           return;
                       }
                       [self hideLoadingView];
                       custDataList = [dic objectForKey:@"result"];
                       if ([custDataList count] == 0) {
//                           [self showAlertView:@"跟进纪录列表暂无相关数据"];
                           [self showMessageView:@"跟进纪录列表暂无数据"];
                           return;
                       }else{
                           custTabView  = [[UITableView alloc] initWithFrame:CGRectMake(0, 110, self.view.frame.size.width, self.view.frame.size.height-50-60) style:UITableViewStyleGrouped];//
                           // 设置tableView的数据源
                           custTabView.dataSource = self;
                           // 设置tableView的委托
                           custTabView.delegate = self;
                           // 设置tableView的背景图
                           //custTabView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"01.png"]];
                           [self.view addSubview:custTabView];
                       }
                   }
                   );
    
}

-(void)errorViewTapGesture:(UITapGestureRecognizer *)tapGesture
{
    [super errorViewTapGesture:tapGesture];
    [NSThread detachNewThreadSelector:@selector(startFollowUpListThread) toTarget:self withObject:nil];
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
    [custTabView removeFromSuperview];//先移除custTabView
    [showMessageView removeFromSuperview];
    NSString *msg = message;
    if (message == nil) {
        msg=@"error";
    }
    if ([message isEqual:@"0"]) {
        msg = @"暂无相关数据";
    }
    showMessageView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height/2-25, scrViewWidth, 50)];
    UILabel *msgLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,10, scrViewWidth, 40)];
    msgLabel.text =msg;
    msgLabel.textAlignment = NSTextAlignmentCenter;
    msgLabel.textColor =[UIColor blackColor];
    msgLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
    [showMessageView addSubview:msgLabel];
    [self.view addSubview:showMessageView];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [custDataList count];
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
    //    cell = nil;//对取出的重用的cell做重新赋值，不要遗留老数据,否则易出现数据错乱或者数据重复
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellWithIdentifier];
    }
    else
    {
        while ([cell.contentView.subviews lastObject] != nil) {
            [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        }
        
    }
    NSUInteger row = indexPath.row;
    NSDictionary *custDetail = [custDataList objectAtIndex:row];
    NSString *sex = [custDetail objectForKey:@"custSex"];
    //客户性别图片
    UIImageView *bgImgView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 7, 30, 30)];
    if([sex isEqual: @"0"])//0表示女性
    {
        [bgImgView setImage:[UIImage imageNamed:@"ico-female.png"]];
    }
    else{
        [bgImgView setImage:[UIImage imageNamed:@"ico-male.png"]];
    }
    [cell.contentView addSubview: bgImgView];
    NSString *name = [custDetail objectForKey:@"custName"];
    NSString *phone = [custDetail objectForKey:@"custPhone"];
    NSString *userID = [custDetail objectForKey:@"custId"];
    //客户名
    UILabel *cellUserNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(70,2, 150, 30)];
    cellUserNameLabel.text = name;
    [cellUserNameLabel setFont:[UIFont systemFontOfSize:15]];
    [cell.contentView addSubview: cellUserNameLabel];
    //客户电话
    UILabel *cellUserPhoneNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(70,22, 150, 20)];
    cellUserPhoneNumLabel.text = phone;
    [cellUserPhoneNumLabel setFont:[UIFont systemFontOfSize:10]];
    cellUserPhoneNumLabel.textColor = [UIColor grayColor];
    [cell.contentView addSubview: cellUserPhoneNumLabel];
    cell.tag = [userID integerValue];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.accessoryType = UITableViewCellAccessoryNone;//UITableViewCellSelectionStyleGray
//    cell.textLabel.font =[UIFont systemFontOfSize:15];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
        UITableViewCell  *cell = [self.custTabView cellForRowAtIndexPath:indexPath];
//        //获取cell内容
//        NSInteger cellTag =cell.tag;
//        NSString *cellcontent;
    //构建UserEntity对象
    CustEntity *custEntity = [[CustEntity alloc] init];
    NSUInteger row = indexPath.row;
    //根据选中的行数去custDataList匹配对应行数的客户
    NSDictionary *custDetail = [custDataList objectAtIndex:row];
    NSString *sex = [custDetail objectForKey:@"custSex"];
    NSString *name = [custDetail objectForKey:@"custName"];
    NSString *phone = [custDetail objectForKey:@"custPhone"];
    NSString *userID = [custDetail objectForKey:@"custId"];
    custEntity.custId = userID;
    custEntity.custName = name;
    custEntity.sex = sex;
    custEntity.custPhone = phone;
    FollowUpDetailController* DetailView=[[FollowUpDetailController alloc] init];
    //设置FollowUpDetailController中需要传递的值
    DetailView.custEntity = custEntity;
    //交互完成之后移除高亮显示,通知表格取消单元格选中状态
    [self performSelector:@selector(delectCellByFollowUp:) withObject:nil afterDelay:1];
    //跳转界面
    [self presentModalViewController:DetailView animated:YES];
}
-(void)delectCellByFollowUp:(id)sender{
    [self.custTabView deselectRowAtIndexPath:[self.custTabView indexPathForSelectedRow] animated:YES];
}

//section （标签）标题显示
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {

    return nil;
    
}

//标签数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

// 设置section的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 1;
}
-(void)searchBtnClick:(UIButton *)sender
{
//    NSString *searchContent = searchField.text;
//    if (searchContent == [NSNull null] || 0 == searchContent.length) {
////        [self showAlertView:@"请输入查询条件"];
//        [self showMessageView:@"请输入查询条件"];
//        return;
//    }
    [self showLoadingView];
    [NSThread detachNewThreadSelector:@selector(SearchFollowUpListThread) toTarget:self withObject:nil];
}
-(void)SearchFollowUpListThread
{
    [custTabView removeFromSuperview];//先移除custTabView,防止与初始化时加载的custTabView重叠
    NSUserDefaults *Parmers = [NSUserDefaults standardUserDefaults];
    //读取保存在NSUserDefaults的用户id
    NSString *UserID = [Parmers objectForKey:@"CRM_USERID"];
    NSArray *userDetail = [UserID componentsSeparatedByString:@"_"];
    NSString *userId =[userDetail objectAtIndex:0];
    //读取保存在NSUserDefaults的ProjectID
    NSString *projectID = [Parmers objectForKey:@"CRM_PROJECTID"];
    NSString *searchContent = searchField.text;
    NSString *soapMessage=[@"method=getFollowUpListBySearchContent&parameter="stringByAppendingString:[NSString stringWithFormat: @"[%@,%@,%@]",userId,projectID,searchContent]];
    NSLog(@"soapMessage%@",soapMessage);
    ResponseModel *responseUser = [CrmNetServiceUtil startRecommandlistByPage:1 Message:soapMessage];
    isLoadingNext = NO;
    dic = responseUser.resultInfo;
    dispatch_async(dispatch_get_main_queue(), ^(void)
                   {
                       if (responseUser.error !=nil) {
                           [self showErrorView];
//                           [self showAlertView:@"请检查网络"];
                           [self showMessageView:@"请检查网络"];
                           return;
                       }
                       [self hideLoadingView];
                       custDataList = [dic objectForKey:@"result"];
                       if ([custDataList count] == 0) {
//                           [self showAlertView:@"跟进纪录纪录暂无相关数据"];
                           [self showMessageView:@"跟进纪录列表暂无数据"];
                           return;
                       }else{
                           custTabView  = [[UITableView alloc] initWithFrame:CGRectMake(0, 110, self.view.frame.size.width, self.view.frame.size.height-50-60) style:UITableViewStyleGrouped];//
                           // 设置tableView的数据源
                           custTabView.dataSource = self;
                           // 设置tableView的委托
                           custTabView.delegate = self;
                           // 设置tableView的背景图
                           //custTabView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"01.png"]];
                           [self.view addSubview:custTabView];
                       }
                   }
                   );
    
}

-(void)AddCustBtnClick:(UIButton *)sender
{
    AddCustomerController *AddCustView=[[AddCustomerController alloc] init];
    //跳转界面
    [self presentModalViewController:AddCustView animated:YES];

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
