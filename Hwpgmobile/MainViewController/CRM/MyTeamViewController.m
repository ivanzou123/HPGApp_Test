//
//  ReportViewController.m
//  M_CRM
//
//  Created by 邱健 on 14/11/29.
//  Copyright (c) 2014年 邱健. All rights reserved.
//

#import "MyTeamViewController.h"
#import "NSString+FontAwesome.h"
#import "FAImageView.h"
#import "UserCenterController.h"
#import "ResponseModel.h"
#import "CrmNetServiceUtil.h"

@interface MyTeamViewController ()
{
    UIView *titleView;
    double scrViewWidth;//屏幕宽度
    UIButton *returnBtn;
    NSDictionary *dic;
    BOOL isLoadingNext;
    UIView *showMessageView;
    NSString *maxCustTotal;//当前团队中的最大数量
}
@end

@implementation MyTeamViewController
@synthesize myTeamTabView;
@synthesize allList;
@synthesize myTeamList;
- (void)viewDidLoad {
    [super viewDidLoad];
    scrViewWidth = self.view.frame.size.width;//屏幕宽度
    titleView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, scrViewWidth, 60)];
    [titleView setBackgroundColor:[UIColor colorWithRed:34/255.0 green:34/255.0 blue:34/255.0 alpha:0.83]];
//    titleView.layer.shadowColor = [UIColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1].CGColor;//shadowColor阴影颜色
//    titleView.layer.shadowOffset = CGSizeMake(0,3);//shadowOffset阴影偏移,x向右偏移0，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
//    titleView.layer.shadowOpacity = 1;//阴影透明度，默认0
//    titleView.layer.shadowRadius = 3;//阴影半径，默认3
    UILabel *labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-30, 20, 60, 40)];
    [labelTitle  setText:@"我的团队"];
    labelTitle.textColor =[UIColor whiteColor];
    [labelTitle setFont:[UIFont systemFontOfSize:15]];
    [titleView addSubview:labelTitle];
    [self.view addSubview:titleView];
    
    [NSThread detachNewThreadSelector:@selector(startMyTeamListThread) toTarget:self withObject:nil];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)returnBtnClick:(UIButton *)sender
{
    
    UserCenterController *mine = [[UserCenterController alloc] init];
    [mine viewDidLoad];
    [self dismissModalViewControllerAnimated:YES];//presentModalViewController:svc animated:YES
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    return 11;
    return myTeamList.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;//设置每个cell高度
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellWithIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellWithIdentifier];
    
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
//    [myTeamList objectAtIndex:row];
    
//    cell.textLabel.text = [myTeamDetail objectForKey:@"name"];
    NSDictionary *myTeamDetail = [myTeamList objectAtIndex:row];
    
    //图表部分最大宽度,减去起始位置100和120的详情描述位置
    double maxChartLength = scrViewWidth-100-120;
    
    //本月新增人数
//    double addCustMonthTotal = 10;
    NSString *addCustMonthTotal = [myTeamDetail objectForKey:@"addCustMonth"];
    //今日新增人数
//    double addCustTodayTotal = 5;
    NSString *addCustTodayTotal = [myTeamDetail objectForKey:@"addCustToday"];;
    //本月跟进人数
//    double followUpCustMonthTotal = 120;
    NSString *followUpCustMonthTotal = [myTeamDetail objectForKey:@"followUpCustMonth"];;
    //今日跟进人数
//    double followUpCustTodayTotal = 13;
    NSString *followUpCustTodayTotal = [myTeamDetail objectForKey:@"followUpCustToday"];;
    
    //图片
    UILabel *icon = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, 50, 20)];
    UIImageView *ImgView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 0, 20, 20)];
    if ([[myTeamDetail objectForKey:@"salerSex"] isEqual: @"0"]) {
        [ImgView setImage:[UIImage imageNamed:@"user_female4-20.png"]];
    }else{
        [ImgView setImage:[UIImage imageNamed:@"user_male4-20.png"]];
    }
    
    [icon addSubview:ImgView];
    //名字
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 28, 50, 20)];
    nameLabel.font =[UIFont systemFontOfSize:12];
    nameLabel.text = [myTeamDetail objectForKey:@"salerName"];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    
    //新增
    UILabel *newCust = [[UILabel alloc] initWithFrame:CGRectMake(70, 6, 40, 20)];
    newCust.font =[UIFont systemFontOfSize:12];
    newCust.text = @"新增";
    
    //新增图表
    //本月新增图表长度＝本月新增人数*(图表部分最大宽度/当前团队中客户的最大数量)
    if (![addCustMonthTotal isEqual:@"0"]) {
        double addMonthLength = [addCustMonthTotal doubleValue]*(maxChartLength/[maxCustTotal doubleValue]);
        UILabel *newCustChartMonth = [[UILabel alloc] initWithFrame:CGRectMake(100, 10, addMonthLength, 12)];//本月
        newCustChartMonth.backgroundColor = [UIColor colorWithRed:205.0/255 green:228.0/255 blue:228.0/255 alpha:1];
        //今日新增图表长度＝本月新增图表长度*(本日新增人数/本月新增人数)
        UILabel *newCustChartToday = [[UILabel alloc] initWithFrame:CGRectMake(100, 10, addMonthLength*([addCustTodayTotal doubleValue]/[addCustMonthTotal doubleValue]), 12)];//今日
        //    UILabel *newCustChartToday = [[UILabel alloc] initWithFrame:CGRectMake(100, 10, addMonthLength*(0/0), 12)];//今日
        newCustChartToday.backgroundColor = [UIColor colorWithRed:162.0/255 green:198.0/255 blue:6.0/255 alpha:1];
        [cell.contentView addSubview:newCustChartMonth];
        [cell.contentView addSubview:newCustChartToday];
    }
    
    //新增详情描述
    UILabel *newCustDes =[[UILabel alloc] initWithFrame:CGRectMake(scrViewWidth -115, 6, 100, 20)];
    newCustDes.font =[UIFont systemFontOfSize:12];
    NSString *newCustDesText=[@"本月"stringByAppendingString:[NSString stringWithFormat: @"%@,今日%@",addCustMonthTotal,addCustTodayTotal]];
//    newCustDes.text = @"本月10，今日5";
    newCustDes.text = newCustDesText;
    
    //跟进
    UILabel *followUpCust = [[UILabel alloc] initWithFrame:CGRectMake(70, 28, 40, 20)];
    followUpCust.text = @"跟进";
    followUpCust.font =[UIFont systemFontOfSize:12];
    //跟进图表
    //本月跟进图表长度＝本月跟进人数*(图表部分最大宽度/当前团队中客户的最大数量)
    if (![followUpCustMonthTotal isEqual:@"0"]) {
        double followUpMonthLength = [followUpCustMonthTotal doubleValue]*(maxChartLength/[maxCustTotal doubleValue]);
        UILabel *followUpChartMonth = [[UILabel alloc] initWithFrame:CGRectMake(100, 33, followUpMonthLength, 12)];
        followUpChartMonth.backgroundColor = [UIColor colorWithRed:179.0/255 green:224.0/255 blue:239.0/255 alpha:1];
        
        //今日跟进图表长度＝本月跟进图表长度*(本日跟进人数/本月跟进人数)
        UILabel *followUpChartToday = [[UILabel alloc] initWithFrame:CGRectMake(100, 33, followUpMonthLength*([followUpCustTodayTotal doubleValue]/[followUpCustMonthTotal doubleValue]), 12)];
        followUpChartToday.backgroundColor = [UIColor colorWithRed:0/255 green:153.0/255 blue:204.0/255 alpha:1];
        [cell.contentView addSubview:followUpChartMonth];
        [cell.contentView addSubview:followUpChartToday];
    }
    
    //跟进详情描述
    UILabel *followUpCustDes =[[UILabel alloc] initWithFrame:CGRectMake(scrViewWidth -115, 28, 100, 20)];
    followUpCustDes.font =[UIFont systemFontOfSize:12];
//    followUpCustDes.text = @"跟进120，今日13";
    NSString *followUpCustDesText=[@"本月"stringByAppendingString:[NSString stringWithFormat: @"%@,今日%@",followUpCustMonthTotal,followUpCustTodayTotal]];
    followUpCustDes.text = followUpCustDesText;
    
    [cell.contentView addSubview:icon];
    [cell.contentView addSubview:nameLabel];
    
    [cell.contentView addSubview:newCust];

    [cell.contentView addSubview:newCustDes];
    
    [cell.contentView addSubview:followUpCust];
    
    [cell.contentView addSubview:followUpCustDes];
    
//    [cell.contentView addSubview:allChart];
    cell.indentationLevel = 2; //缩进层级
    cell.indentationWidth = 15.0f; //每次缩进寛
    cell.selectionStyle = UITableViewCellSelectionStyleNone;//隐藏选中效果
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.accessoryType = UITableViewCellAccessoryNone;//UITableViewCellSelectionStyleGray
    return cell;
}
-(void)startMyTeamListThread
{
    [myTeamTabView removeFromSuperview];//先移除myTableView
    NSUserDefaults *Parmers = [NSUserDefaults standardUserDefaults];
    //读取保存在NSUserDefaults的用户id
    NSString *UserID = [Parmers objectForKey:@"CRM_SELECTUSERID"];
    NSArray *userDetail = [UserID componentsSeparatedByString:@"_"];
    NSString *userId =[userDetail objectAtIndex:0];
    //读取保存在NSUserDefaults的ProjectID
    NSString *projectID = [Parmers objectForKey:@"CRM_PROJECTID"];
    NSString *soapMessage=[@"method=getMyTeamList&parameter="stringByAppendingString:[NSString stringWithFormat: @"[%@,%@]",userId,projectID]];
    ResponseModel *responseUser = [CrmNetServiceUtil startRecommandlistByPage:1 Message:soapMessage ];
    isLoadingNext = NO;
    dic = responseUser.resultInfo;
    dispatch_async(dispatch_get_main_queue(), ^(void)
                   {
                       if (responseUser.error !=nil) {
                           [self showErrorView];
                           [self showMessageView:@"请检查网络"];
                           return;
                       }
                       [self hideLoadingView];
                       allList = [dic objectForKey:@"result"];
                       if ([allList count] == 0) {
                           [self showMessageView:@"我的团队列表暂无数据"];
                           return;
                       }else{
                           maxCustTotal=[allList objectAtIndex:0];
                           NSLog(@"maxCustTotal------->%d",maxCustTotal);
                           myTeamList = [allList objectAtIndex:1];
                           myTeamTabView = [[UITableView alloc] initWithFrame:CGRectMake(0, 63,self.view.frame.size.width, self.view.frame.size.height-63-50)];
                           // 设置tableView的数据源
                           myTeamTabView.dataSource = self;
                           // 设置tableView的委托
                           myTeamTabView.delegate = self;
                           [self.view addSubview:myTeamTabView];
                       }
                   }
                   );
    
}
-(void)showMessageView:(NSString *)message
{
    [myTeamTabView removeFromSuperview];//先移除myTeamTabView
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
