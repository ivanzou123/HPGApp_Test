//
//  ViewController.m
//  Test
//
//  Created by 邱健 on 14/11/5.
//  Copyright (c) 2014年 邱健. All rights reserved.
//

#import "UserCenterController.h"
#import "CrmNetServiceUtil.h"
#import "ResponseModel.h"
#import "PopoverView.h"
#import "FollowUpController.h"
#import "OverviewDetailController.h"
#import "NSString+FontAwesome.h"
#import "FAImageView.h"
#import "MyTeamViewController.h"

@interface UserCenterController ()
{
    BOOL isLoadingNext;
    NSDictionary *dic;
    UIView *pageTitleView;
    UIView *userDetailView;
    UIView *showMessageView;
    
}
@end
@implementation UserCenterController
@synthesize sectionList;
@synthesize firstDataList;
@synthesize secDateList;
@synthesize myTableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    pageTitleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 60)];
    [pageTitleView setBackgroundColor:[UIColor colorWithRed:0.0/255 green:153.0/255 blue:204.0/255 alpha:1]];
    pageTitleView.layer.shadowColor = [UIColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:0.21].CGColor;//shadowColor阴影颜色
    pageTitleView.layer.shadowOffset = CGSizeMake(0,3);//shadowOffset阴影偏移,x向右偏移0，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
    pageTitleView.layer.shadowOpacity = 1;//阴影透明度，默认0
    pageTitleView.layer.shadowRadius = 3;//阴影半径，默认3
    UILabel *title =[[UILabel alloc] init];
    [title setFrame:CGRectMake(self.view.frame.size.width/2-55,20, 110, 37)];
    title.text = @"我";
    title.textAlignment= NSTextAlignmentCenter;
    title.textColor =[UIColor whiteColor];
    title.font = [UIFont systemFontOfSize:17];
    [pageTitleView addSubview:title];
    
    //myTableView.tableHeaderView =v1;
    [self.view addSubview:pageTitleView];
    // 初始化第一个section中的数据
    firstDataList = [NSArray arrayWithObjects:@"通知提醒",@"生日提醒",@"设置计划",@"微信二维码", nil];//,@"已成交"
    // 初始化第二个section中的数据
    secDateList = [NSArray arrayWithObjects:@"修改密码",@"退出登录", nil];//,@"100天以上",@"120天以上",@"130天以上"
    userDetailView = [[UIView alloc] initWithFrame:CGRectMake(0, 70, self.view.frame.size.width, 60)];
    [userDetailView setBackgroundColor:[UIColor whiteColor]];
    
    UIImageView *userImgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 35, 35)];
    [userImgView setImage:[UIImage imageNamed:@"ico-male.png"]];
    [userDetailView addSubview:userImgView];
    
    NSUserDefaults *userID = [NSUserDefaults standardUserDefaults];
    //读取保存在NSUserDefaults的用户id
    NSString *UserID = [userID objectForKey:@"CRM_USERID"];
    NSArray *userDetail = [UserID componentsSeparatedByString:@"_"];
    NSString *userId =[userDetail objectAtIndex:0];
    NSString *userName =[userDetail objectAtIndex:1];
    NSString *userCompany =[userDetail objectAtIndex:2];
    //用户名
    UILabel *userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(65,5, 150, 30)];
    userNameLabel.text = userName;
    [userNameLabel setFont:[UIFont systemFontOfSize:15]];
    [userDetailView addSubview: userNameLabel];
    //用户公司
    UILabel *UserPhoneNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(65,30, 300, 20)];
    UserPhoneNumLabel.text = userCompany;
    [UserPhoneNumLabel setFont:[UIFont systemFontOfSize:13]];
    UserPhoneNumLabel.textColor = [UIColor grayColor];
    [userDetailView addSubview: UserPhoneNumLabel];
    
    UILabel *arrow = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width-20, 20, 20, 20)];
    arrow.font =[UIFont fontWithName:kFontAwesomeFamilyName size:15];
    arrow.text = [NSString fontAwesomeIconStringForEnum:FAAngleRight];
    [userDetailView addSubview: arrow];
    [self.view addSubview:userDetailView];
    
    myTableView  = [[UITableView alloc] initWithFrame:CGRectMake(0, 130, self.view.frame.size.width, self.view.frame.size.height-64) style:UITableViewStyleGrouped];//
    // 设置tableView的数据源
    myTableView.dataSource = self;
    // 设置tableView的委托
    myTableView.delegate = self;
    // 设置tableView的背景图
    //myTableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"01.png"]];
    [self.view addSubview:myTableView];
//    [self showLoadingView];
//    [NSThread detachNewThreadSelector:@selector(startDetailThread) toTarget:self withObject:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        return [firstDataList count];
    }
    else{
        return [secDateList count];
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
    UILabel *icon = [[UILabel alloc] initWithFrame:CGRectMake(15, 12, 20, 20)];
    UILabel *arrow = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width-20, 12, 20, 20)];
    arrow.font =[UIFont fontWithName:kFontAwesomeFamilyName size:15];
    arrow.text = [NSString fontAwesomeIconStringForEnum:FAAngleRight];
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
    if(indexPath.section == 0){
        [firstDataList objectAtIndex:row];
        cell.textLabel.text = [firstDataList objectAtIndex:row];
        switch (row) {
            case 0://通知提醒
                icon.font =[UIFont fontWithName:kFontAwesomeFamilyName size:15];
                icon.text = [NSString fontAwesomeIconStringForEnum:FABell];
                break;
            case 1://生日提醒
                icon.font =[UIFont fontWithName:kFontAwesomeFamilyName size:15];
                icon.text = [NSString fontAwesomeIconStringForEnum:FAbirthdayCake];
                break;
            case 2://设置计划
                icon.font =[UIFont fontWithName:kFontAwesomeFamilyName size:15];
                icon.text = [NSString fontAwesomeIconStringForEnum:FACalendar];
                break;
            case 3://微信二维码
                icon.font =[UIFont fontWithName:kFontAwesomeFamilyName size:15];
                icon.text = [NSString fontAwesomeIconStringForEnum:FAQrcode];
                break;
            default:
                
                break;
        }

    }
    else{
        [secDateList objectAtIndex:row];
        cell.textLabel.text = [secDateList objectAtIndex:row];
        switch (row) {
            case 0://修改密码
                icon.font =[UIFont fontWithName:kFontAwesomeFamilyName size:15];
                icon.text = [NSString fontAwesomeIconStringForEnum:FAKey];
                break;
            case 1://退出登录
                icon.font =[UIFont fontWithName:kFontAwesomeFamilyName size:15];
                icon.text = [NSString fontAwesomeIconStringForEnum:FASignOut];
                break;
            default:
                break;
        }

    }
    [cell.contentView addSubview:icon];
    [cell.contentView addSubview:arrow];
    cell.indentationLevel = 2; //缩进层级
    cell.indentationWidth = 15.0f; //每次缩进寛
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;//隐藏选中效果
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.accessoryType = UITableViewCellAccessoryNone;//UITableViewCellSelectionStyleGray
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = indexPath.row;
    if(indexPath.section == 0)
    {
//        UITableViewCell  *cell = [self.myTableView cellForRowAtIndexPath:indexPath];
//        //获取cell内容
//        NSString *cellcontent =cell.textLabel.text;
//        UIAlertView *messageAlert = [[UIAlertView alloc]
//                                     initWithTitle:@"选中的菜单" message:cellcontent delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        [messageAlert show];
//        ReportViewController *reportView=[[ReportViewController alloc] init];
//        switch (row) {
//            case 0://报表
//                [self presentModalViewController:reportView animated:YES];
//                break;
//            case 1://通知提醒
//                icon.font =[UIFont fontWithName:kFontAwesomeFamilyName size:15];
//                icon.text = [NSString fontAwesomeIconStringForEnum:FABell];
//                break;
//            case 2://生日提醒
//                icon.font =[UIFont fontWithName:kFontAwesomeFamilyName size:15];
//                icon.text = [NSString fontAwesomeIconStringForEnum:FAbirthdayCake];
//                break;
//            case 3://设置计划
//                icon.font =[UIFont fontWithName:kFontAwesomeFamilyName size:15];
//                icon.text = [NSString fontAwesomeIconStringForEnum:FACalendar];
//                break;
//            case 4://微信二维码
//                icon.font =[UIFont fontWithName:kFontAwesomeFamilyName size:15];
//                icon.text = [NSString fontAwesomeIconStringForEnum:FAQrcode];
//                break;
//            default:
//                
//                break;
//        }
//        if (row==0) {
//            ReportViewController *reportView=[[ReportViewController alloc] init];
//            [self presentModalViewController:reportView animated:YES];
//        }
    }
    else
    {
        
    }
    //交互完成之后移除高亮显示,通知表格取消单元格选中状态
    [self performSelector:@selector(delectCell:) withObject:nil afterDelay:1];
}

-(void)delectCell:(id)sender{
    [self.myTableView deselectRowAtIndexPath:[self.myTableView indexPathForSelectedRow] animated:YES];
}
//section （标签）标题显示
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return nil;
}

//标签数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

// 设置section Header的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 15.0f;
}
// 设置section Footer的高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}

@end
