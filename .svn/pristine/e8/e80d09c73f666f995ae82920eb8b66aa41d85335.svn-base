//
//  FollowUpDetailController.m
//  M_CRM
//
//  Created by 邱健 on 14/11/22.
//  Copyright (c) 2014年 邱健. All rights reserved.
//

#import "FollowUpDetailController.h"
#import "CBTextView.h"
#import "CustEntity.h"
#import "ResponseModel.h"
#import "CrmNetServiceUtil.h"
#import "JSON.h"
#import "EditCustomerController.h"
#import <MessageUI/MFMessageComposeViewController.h>
#import <CoreTelephony/CTCallCenter.h>
#import <CoreTelephony/CTCall.h>
#import "NSString+FontAwesome.h"
#import "FAImageView.h"


@interface FollowUpDetailController ()
{
    UIView *titleView;
    UIView *userView;
    UIView *serchView;
    double scrViewWidth;//屏幕宽度
    BOOL isLoadingNext;
    NSDictionary *dic;
    NSArray *pickerSourceID;
    NSString *sourceId;//沟通方式id
    NSString *followUpContent;//跟进详情内容
    NSDictionary *dicResultInfo;
    UIWebView *phoneCallWebView;//一键拨号view
    UIButton *selectBtn;
    
}
@end

@implementation FollowUpDetailController
@synthesize followUpDetailView;
@synthesize followUpDetailDataList;
@synthesize returnBtn;
@synthesize TFollowRemark;
@synthesize submitBtn;
@synthesize callCenter;
- (void)viewDidLoad {
    [super viewDidLoad];
    scrViewWidth = self.view.frame.size.width;//屏幕宽度
    titleView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, scrViewWidth, 60)];
    [titleView setBackgroundColor:[UIColor colorWithRed:34/255.0 green:34/255.0 blue:34/255.0 alpha:0.83]];
    UILabel *labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-75, 20, 150, 40)];
    //[labelTitle setBackgroundColor:[UIColor clearColor]];
    //labelTitle.textAlignment = NSTextAlignmentCenter;
    
    NSUserDefaults *Parmers = [NSUserDefaults standardUserDefaults];
    NSString *projectName = [Parmers objectForKey:@"CRM_PROJECTNAME"];
    [labelTitle  setText:[projectName stringByAppendingString:[NSString stringWithFormat:@"%@",@"-跟进记录"]]];
    //labelTitle.text = @"跟进详情";
    labelTitle.textColor =[UIColor whiteColor];
    [labelTitle setFont:[UIFont systemFontOfSize:15]];
    //labelTitle.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];// [UIFont systemFontOfSize:20];
    [titleView addSubview:labelTitle];
    //返回按钮 start
    returnBtn = [[UIButton alloc] initWithFrame:CGRectMake(0,22, 45, 30)];
    // 加入button单击事件
    [returnBtn addTarget:self action:@selector(returnBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [returnBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];//title color
    [returnBtn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];//设置title的高亮颜色
    [returnBtn setTitle:@"返回" forState:UIControlStateNormal];
   // [returnBtn setFont:[UIFont systemFontOfSize:15]];
    [returnBtn setFont:[UIFont fontWithName:kFontAwesomeFamilyName size:30]];
    [returnBtn setTitle:[NSString fontAwesomeIconStringForEnum:FAAngleLeft] forState:UIControlStateNormal];
//    [returnBtn.layer setMasksToBounds:YES];
//    [returnBtn.layer setCornerRadius:5]; //设置矩形四个圆角半径
//    [returnBtn.layer setBorderWidth:1.0]; //边框宽度
//    [returnBtn.layer setBorderColor:[UIColor colorWithRed:0.0/255 green:153.0/255 blue:204.0/255 alpha:1].CGColor];//边框颜色
//    // [returnBtn.layer setBackgroundColor:[UIColor greenColor].CGColor];//背景颜色
//    UILabel *arrow = [[UILabel alloc] initWithFrame:CGRectMake(7, 14, 10, 13)];
//    arrow.font =[UIFont fontWithName:kFontAwesomeFamilyName size:20];
//    arrow.text = [NSString fontAwesomeIconStringForEnum:FAAngleLeft];
//    arrow.textColor = [UIColor whiteColor];
//    [returnBtn addSubview:arrow];
    [titleView addSubview:returnBtn];
    [self.view addSubview:titleView];
    
    userView = [[UIView alloc] initWithFrame:CGRectMake(0,60,scrViewWidth,45)];
//    [userView setBackgroundColor:[UIColor redColor]];
//    UIImageView *bgImgView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 35, 35)];
//    if([self.custEntity.sex isEqual: @"0"])//0表示女性
//    {
//        [bgImgView setImage:[UIImage imageNamed:@"ico-female.png"]];
//    }
//    else{
//        [bgImgView setImage:[UIImage imageNamed:@"ico-male.png"]];
//    }
//    [bgImgView setImage:[UIImage imageNamed:@"ico-male.png"]];
//    [userView addSubview:bgImgView];
//    //客户名
//    UILabel *cellUserNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(75,5, 150, 30)];
//    cellUserNameLabel.text = self.custEntity.custName;
//    [cellUserNameLabel setFont:[UIFont systemFontOfSize:20]];
//    [userView addSubview: cellUserNameLabel];
//    //客户电话
//    UILabel *cellUserPhoneNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(75,30, 150, 20)];
//    cellUserPhoneNumLabel.text = self.custEntity.custPhone;
//    [cellUserPhoneNumLabel setFont:[UIFont systemFontOfSize:13]];
//    cellUserPhoneNumLabel.textColor = [UIColor grayColor];
//    [userView addSubview: cellUserPhoneNumLabel];
//    UIButton *EditBtn = [[UIButton alloc] initWithFrame:CGRectMake(scrViewWidth-55, 15, 28, 28)];
//    [EditBtn setBackgroundImage:[UIImage imageNamed:@"ico-edit.png"] forState:UIControlStateNormal];
//    [EditBtn addTarget:self action:@selector(editCustBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//    [userView addSubview: EditBtn];
    
    //客户名
    UILabel *cellUserNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(50,5, 130, 25)];
    cellUserNameLabel.text = self.custEntity.custName;
    [cellUserNameLabel setFont:[UIFont systemFontOfSize:15 ]];
    [userView addSubview: cellUserNameLabel];
    //客户电话
    UILabel *cellUserPhoneNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(50,22, 150, 20)];
    cellUserPhoneNumLabel.text = self.custEntity.custPhone;
    [cellUserPhoneNumLabel setFont:[UIFont systemFontOfSize:10]];
    cellUserPhoneNumLabel.textColor = [UIColor grayColor];
    [userView addSubview: cellUserPhoneNumLabel];
    UIButton *EditBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 0, 150, 45)];
    [EditBtn setFont:[UIFont fontWithName:kFontAwesomeFamilyName size:20]];
    [EditBtn setTitle:[NSString fontAwesomeIconStringForEnum:FAPencilSquareO] forState:UIControlStateNormal];
    [EditBtn setTitleColor:[UIColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:0.87] forState:UIControlStateNormal];
    [EditBtn setTitleEdgeInsets:UIEdgeInsetsMake(4, -125, 0, 0)];
    [EditBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];//设置title的高亮颜色
    [EditBtn addTarget:self action:@selector(editCustBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//    [EditBtn.layer setBackgroundColor:[UIColor blueColor].CGColor];//背景颜色

    [userView addSubview: EditBtn];

    //一键拨号
    UIButton *phoneBtn = [[UIButton alloc] initWithFrame:CGRectMake(scrViewWidth-110, 0, 48, 45)];
//    [phoneBtn setBackgroundImage:[UIImage imageNamed:@"ico-phone.png"] forState:UIControlStateNormal];
    [phoneBtn addTarget:self action:@selector(btnCall:) forControlEvents:UIControlEventTouchUpInside];
    [phoneBtn setFont:[UIFont fontWithName:kFontAwesomeFamilyName size:20]];
    [phoneBtn setTitle:[NSString fontAwesomeIconStringForEnum:FAPhone] forState:UIControlStateNormal];
    [phoneBtn setTitleColor:[UIColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:0.87] forState:UIControlStateNormal];
//    UIImageView *phoneBtnImg = [[UIImageView alloc] initWithFrame:CGRectMake(12, 18, 25, 25)];
//    [phoneBtnImg setImage:[UIImage imageNamed:@"ico-phone.png"]];
//    [phoneBtn addSubview: phoneBtnImg];
//     [phoneBtn.layer setBackgroundColor:[UIColor greenColor].CGColor];//背景颜色
    [phoneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];//设置title的高亮颜色
    [userView addSubview: phoneBtn];
    
    //一键发短信
    UIButton *sentMsgBtn = [[UIButton alloc] initWithFrame:CGRectMake(scrViewWidth-65, 0, 48, 45)];
    [sentMsgBtn setFont:[UIFont fontWithName:kFontAwesomeFamilyName size:20]];
    [sentMsgBtn setTitle:[NSString fontAwesomeIconStringForEnum:FAEnvelopeO] forState:UIControlStateNormal];
    [sentMsgBtn setTitleColor:[UIColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:0.87] forState:UIControlStateNormal];
    [sentMsgBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];//设置title的高亮颜色
//    UIImageView *MsgImg = [[UIImageView alloc] initWithFrame:CGRectMake(12, 18, 25, 25)];
//    [MsgImg setImage:[UIImage imageNamed:@"ico-message.png"]];
//    [sentMsgBtn addSubview: MsgImg];
//    [sentMsgBtn.layer setBackgroundColor:[UIColor blackColor].CGColor];//背景颜色
    [sentMsgBtn addTarget:self action:@selector(showSMSPicker:) forControlEvents:UIControlEventTouchUpInside];
    [userView addSubview: sentMsgBtn];
    
    
    [self.view addSubview:userView];
    
    [self showLoadingView];
    [NSThread detachNewThreadSelector:@selector(startFollowUpDetailThread) toTarget:self withObject:nil];

}
-(void)startFollowUpDetailThread
{
    NSUserDefaults *Parmers = [NSUserDefaults standardUserDefaults];
    //读取保存在NSUserDefaults的用户id
    NSString *UserID = [Parmers objectForKey:@"CRM_SELECTUSERID"];
    NSArray *userDetail = [UserID componentsSeparatedByString:@"_"];
    NSString *userId =[userDetail objectAtIndex:0];
    //读取保存在NSUserDefaults的ProjectID
    NSString *projectID = [Parmers objectForKey:@"CRM_PROJECTID"];
    NSString *custId = self.custEntity.custId;
    NSString *soapMessage=[@"method=getFollowUpDetailByCustID&parameter="stringByAppendingString:[NSString stringWithFormat: @"[%@,%@,%@]",userId,projectID,custId]];
    NSLog(@"soapMessage%@",soapMessage);
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
                       [self hideLoadingView];
                       NSArray *allList = [dic objectForKey:@"result"];
                       if ([allList count] == 0) {
                           [self showAlertView:@"跟进详情暂无相关数据"];
                           return;
                       }else{
                           //跟进详情 start
                           followUpDetailDataList = [allList objectAtIndex:0];//跟进详情
                           followUpDetailView = [[UITableView alloc] initWithFrame:CGRectMake(0, 105,scrViewWidth, self.view.frame.size.height-180)];
                           followUpDetailView.delegate = self;
                           followUpDetailView.dataSource = self;
                           followUpDetailView.separatorStyle = UITableViewCellSeparatorStyleNone;
                           [self.view addSubview:followUpDetailView];
                           //跟进详情 end
                           
                           UIView *importView = [[UIView alloc] initWithFrame:CGRectMake(5,self.view.frame.size.height-67, 85, 45)];
                           
                           //跟进内容输入框 start
                           TFollowRemark = [[CBTextView alloc] initWithFrame:CGRectMake(90,self.view.frame.size.height-62, self.view.frame.size.width-145, 45)];
                           TFollowRemark.placeHolder = @"请输入跟进内容";
                           //TFollowRemark.textView.delegate = self;
                           TFollowRemark.aDelegate=self;
                           TFollowRemark.textView.returnKeyType = UIReturnKeyDone;//设置回车键类型
                           [TFollowRemark.textView.layer setCornerRadius:5];
                           TFollowRemark.textView.font = [UIFont fontWithName:@"Arial" size:15];
//                           [importView addSubview:TFollowRemark];
                           [self.view addSubview:TFollowRemark];
                           //跟进内容输入框 end
                           
                           //提交按钮 start
                           submitBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width-50, self.view.frame.size.height-62, 45, 45)];
                           [submitBtn addTarget:self action:@selector(saveBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                           [submitBtn setBackgroundColor:[UIColor colorWithRed:0.0/255 green:153.0/255 blue:204.0/255 alpha:1]];//colorWithRed:0.0/255 green:153.0/255 blue:204.0/255 alpha:1
                           [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];//title color
                           [submitBtn setTitle:@"提交" forState:UIControlStateNormal];
                           [submitBtn setFont:[UIFont systemFontOfSize:15]];
                           [submitBtn.layer setMasksToBounds:YES];
                           [submitBtn.layer setCornerRadius:5]; //设置矩形四个圆角半径
                           [submitBtn.layer setBorderWidth:0]; //边框宽度
                           [submitBtn setShowsTouchWhenHighlighted:YES];
                           [self.view addSubview:submitBtn];
                           //提交按钮 end

                           //来源选择部分  start
                           UIView *dataSorceView = [[UIButton alloc] initWithFrame:CGRectMake(0, 5, 90, 45)];
                           //    [dataSorceView setBackgroundColor:[UIColor blackColor]];
                           selectBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 45)];
                           [selectBtn addTarget:self action:@selector(selectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                           [selectBtn setBackgroundColor:[UIColor whiteColor]];
                           [selectBtn.layer setMasksToBounds:YES];
                           [selectBtn.layer setCornerRadius:5]; //设置矩形四个圆角半径
                           [selectBtn.layer setBorderWidth:0]; //边框宽度
//                           [selectBtn setTitle:@"沟通方式" forState:UIControlStateNormal];
//                           [selectBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
                           [selectBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                           
                           [selectBtn setFont:[UIFont systemFontOfSize:15]];
//                           UIImageView *arrowView = [[UIImageView alloc] initWithFrame:CGRectMake(80, 18, 10, 10)];
//                           [arrowView setImage:[UIImage imageNamed:@"ico-arrow-dropdown.png"]];
                           //    [arrowView setBackgroundColor:[UIColor grayColor]];
//                           [dataSorceView addSubview:arrowView];
                           [dataSorceView addSubview:selectBtn];
                           ddlSorce = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, 85, 45)];
                           ddlSorce.text =@"沟通方式";
                           ddlSorce.font = [UIFont systemFontOfSize:15];
                           [ddlSorce setTextColor:[UIColor grayColor]];
                           [ddlSorce.layer setMasksToBounds:YES];
                           [ddlSorce.layer setCornerRadius:5]; //设置矩形四个圆角半径
                           [ddlSorce.layer setBorderWidth:0]; //边框宽度
                           [selectBtn addSubview:ddlSorce];
                           UILabel *arrow = [[UILabel alloc] initWithFrame:CGRectMake(67, 15, 10, 13)];
                           arrow.font =[UIFont fontWithName:kFontAwesomeFamilyName size:10];
                           arrow.text = [NSString fontAwesomeIconStringForEnum:FAChevronDown];
                           arrow.textColor = [UIColor grayColor];
                           [selectBtn addSubview:arrow];
                           [importView addSubview:dataSorceView];
                           [self.view addSubview:importView];
                           pickerSourceID=[allList objectAtIndex:1];//来源id
                           
                           pickerData = [allList objectAtIndex:2];//来源描述
                           CGRect frame = CGRectMake(0, self.view.frame.size.height-320, 320, 320);
                           pickerSheet = [[UIActionSheet alloc] initWithFrame:frame];
                           [pickerSheet setBackgroundColor:[UIColor colorWithRed:238.0/255 green:238.0/255 blue:238.0/255  alpha:1]];
                           CGRect btnFrame = CGRectMake(10, 5, 60, 30);
                           UIButton* cancelButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                           [cancelButton awakeFromNib];
                           [cancelButton addTarget:self action:@selector(pickerHideCancel) forControlEvents:UIControlEventTouchUpInside];
                           [cancelButton setFrame:btnFrame];
                           cancelButton.backgroundColor = [UIColor clearColor];
                           [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
                           [cancelButton setFont:[UIFont systemFontOfSize:15]];
                           [cancelButton.layer setMasksToBounds:YES];
                           [cancelButton.layer setCornerRadius:5]; //设置矩形四个圆角半径
                           [cancelButton.layer setBorderWidth:2]; //边框宽度
                           [cancelButton.layer setBorderColor:[UIColor whiteColor].CGColor];//边框颜色
                           [pickerSheet addSubview:cancelButton];
                           
                           CGRect btnOKFrame = CGRectMake(250, 5, 60, 30);
                           UIButton* okButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                           [okButton awakeFromNib];
                           [okButton addTarget:self action:@selector(pickerHideOK) forControlEvents:UIControlEventTouchUpInside];
                           [okButton setFrame:btnOKFrame];
                           okButton.backgroundColor = [UIColor clearColor];
                           [okButton setTitle:@"完成" forState:UIControlStateNormal];
                           [okButton setFont:[UIFont systemFontOfSize:15]];
                           [okButton.layer setMasksToBounds:YES];
                           [okButton.layer setCornerRadius:5]; //设置矩形四个圆角半径
                           [okButton.layer setBorderWidth:2]; //边框宽度
                           [okButton.layer setBorderColor:[UIColor whiteColor].CGColor];//边框颜色
                           [pickerSheet addSubview:okButton];
                           
                           
                           CGRect pickerFrame = CGRectMake(0, 40, 320, 200);
                           pickerView=[ [UIPickerView alloc] initWithFrame:pickerFrame];
                           pickerView.autoresizingMask=UIViewAutoresizingFlexibleWidth;
                           pickerView.showsSelectionIndicator = YES;//默认显示选择指示条
                           pickerView.delegate=self;
                           pickerView.dataSource=self;
                           pickerView.tag = 101;
                           pickerView.hidden = NO;
                           [pickerSheet addSubview:pickerView];
                           [self.view addSubview:pickerSheet];
                           pickerSheet.hidden = YES;
                           //来源选择部分  end

                       }
                   }
                   );
}

-(void)errorViewTapGesture:(UITapGestureRecognizer *)tapGesture
{
    [super errorViewTapGesture:tapGesture];
    [NSThread detachNewThreadSelector:@selector(startFollowUpDetailThread) toTarget:self withObject:nil];
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
//    NSLog(@"%@",message);
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:m delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alertView show];
}

#pragma mark UITabelViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [followUpDetailDataList count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellWithIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellWithIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellWithIdentifier];
    }
    else
    {
        while ([cell.contentView.subviews lastObject] != nil) {
            [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        }
    }
    NSUInteger row = [indexPath row];
    NSDictionary *followUpDetail = [followUpDetailDataList objectAtIndex:row];
    NSString *followUpDate = [followUpDetail objectForKey:@"followUpDate"];
    NSString *labelStr = [followUpDetail objectForKey:@"followUpDetail"];
    UILabel *cellLabelTitle = [[UILabel alloc] initWithFrame:CGRectMake(25,5,scrViewWidth-30, 20)];
    [cellLabelTitle setFont:[UIFont systemFontOfSize:13]];
    followUpDate=[@"●  "stringByAppendingString:[NSString stringWithFormat: @"%@",followUpDate]];
    [cellLabelTitle setText:followUpDate];
    [cellLabelTitle setTextColor:[UIColor colorWithRed:0.0/255 green:153.0/255 blue:204.0/255 alpha:1]];
    [cell.contentView addSubview: cellLabelTitle];

    UILabel *cellLabel = [[UILabel alloc] initWithFrame:CGRectMake(40,25,scrViewWidth-50, 80)];
    [cellLabel setFont:[UIFont systemFontOfSize:11]];
    // 计算长文本高度 start
    CGSize labelSize = {0, 0};
    labelSize = [labelStr sizeWithFont:[UIFont systemFontOfSize:12]
                     constrainedToSize:CGSizeMake(scrViewWidth-50, 9999)
                         lineBreakMode:UILineBreakModeWordWrap];
    //14 为UILabel的字体大小
    //scrViewWidth-30为UILabel的宽度，9999是预设的一个高度，表示在这个范围内
    cellLabel.numberOfLines = 0;//表示label可以多行显示
    cellLabel.lineBreakMode = UILineBreakModeCharacterWrap;//换行模式，与上面的计算保持一致。
    cellLabel.frame = CGRectMake(cellLabel.frame.origin.x, cellLabel.frame.origin.y, cellLabel.frame.size.width, labelSize.height);//保持原来Label的位置和宽度，只是改变高度。
    // 计算长文本高度 end
    [cellLabel setText:labelStr];
    [cell.contentView addSubview: cellLabel];
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;//隐藏选中效果
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = [indexPath row];
    NSDictionary *followUpDetail = [followUpDetailDataList objectAtIndex:row];
    NSString *followUpDate = [followUpDetail objectForKey:@"followUpDate"];
    NSString *labelStr = [followUpDetail objectForKey:@"followUpDetail"];
    CGSize labelSize = {0, 0};
    double delta = 35;//delta 是Cell除了自适应控件UILabel外的其它控件所占的高度。
    labelSize = [labelStr sizeWithFont:[UIFont systemFontOfSize:12]
                     constrainedToSize:CGSizeMake(scrViewWidth-50, 9999)
                         lineBreakMode:UILineBreakModeWordWrap];
    return labelSize.height + delta;
}
//设置内容缩进
- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 1;
}
-(void)returnBtnClick:(UIButton *)sender
{

    [self dismissModalViewControllerAnimated:YES];//presentModalViewController:svc animated:YES

}
-(void)selectBtnClick:(UIButton *)sender
{
    pickerSheet.hidden = NO;
//    [pickerSheet resignFirstResponder];
    // 如果是在键盘升起后选择来源，则隐藏键盘并将整个页面下移
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    CGRect rect = CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height);
    self.view.frame = rect;
    [UIView commitAnimations];
    [TFollowRemark resignFirstResponder];
}

#pragma mark Picker Date Source Methods

-(void)pickerHideOK
{
    pickerSheet.hidden = YES;
    NSInteger row = [pickerView selectedRowInComponent:0];//得到选中的行数
    NSString * mys = [pickerData objectAtIndex:row];
    ddlSorce.text = mys;
//    [selectBtn setTitle:mys forState:UIControlStateNormal];

    //接下来根据选中的行数去nsarry对应的行数里面寻找该来源的id
    sourceId = [pickerSourceID objectAtIndex:row];
//    NSLog(@"sourceId------->%@",sourceId);
}
-(void)pickerHideCancel
{
   
    pickerSheet.hidden = YES;
}
//返回当前行的内容,此处是将数组中数值添加到滚动的那个显示栏上
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row
            forComponent:(NSInteger)component
{
    return [pickerData objectAtIndex:row];
}


// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [pickerData count];
}
//添加subView可以设置每一项显示的文本，并且设置字体大小
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row
          forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel * myView = view ? (UILabel *) view : [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 150.0f, 30.0f)];
    myView.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    myView.tag = 1;
    myView.textAlignment = NSTextAlignmentCenter;
    [myView setFont:[UIFont systemFontOfSize:20 ]];
    myView.backgroundColor = [UIColor clearColor];
    return myView;
}
#pragma mark 编辑客户详情
-(void)editCustBtnClick:(UIButton *)sender
{
    CustEntity *custEntity = [[CustEntity alloc] init];
    custEntity.custId = self.custEntity.custId;
    EditCustomerController *DetailView=[[EditCustomerController alloc] init];
    //设置EditCustomerController中需要传递的值
    DetailView.custEntity = custEntity;
    //跳转界面
    [self presentModalViewController:DetailView animated:YES];
}

#pragma mark 提交
-(void)saveBtnClick:(UIButton *)sender
{
    followUpContent = TFollowRemark.textView.text;
    if (followUpContent == [NSNull null] || 0 == followUpContent.length || [followUpContent isEqualToString: @"请输入跟进内容"]) {
        [self showAlertView:@"请输入跟进内容"];
        return;
    }
    if (sourceId == [NSNull null] || 0 == sourceId.length ) {
        [self showAlertView:@"请选择沟通方式"];
        return;

    }
    NSUserDefaults *Parmers = [NSUserDefaults standardUserDefaults];
    NSString *SelectUserID = [Parmers objectForKey:@"CRM_SELECTUSERID"];
    NSArray *SelectUserDetail = [SelectUserID componentsSeparatedByString:@"_"];
    NSString *selectUserId =[SelectUserDetail objectAtIndex:0];
    
    NSString *UserID = [Parmers objectForKey:@"CRM_USERID"];
    NSArray *userDetail = [UserID componentsSeparatedByString:@"_"];
    NSString *userId =[userDetail objectAtIndex:0];
    if (![userId isEqual:selectUserId])//选中的用户为本人才可保存
    {
        NSString *cellcontent = @"该客户的跟进纪录只有跟进该客户的销售员方可提交";
        UIAlertView *messageAlert = [[UIAlertView alloc]
                                     initWithTitle:@"提示" message:cellcontent delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [messageAlert show];
        return;
    }
    [self showLoadingView];
    [NSThread detachNewThreadSelector:@selector(saveFollowUpDetailThread) toTarget:self withObject:nil];
}
-(void)saveFollowUpDetailThread
{
    NSMutableDictionary *parmer = [NSMutableDictionary dictionaryWithCapacity:2];
    NSMutableDictionary *CustParmers = [NSMutableDictionary dictionaryWithCapacity:4];
    NSUserDefaults *Parmers = [NSUserDefaults standardUserDefaults];
    //读取保存在NSUserDefaults的用户id
    NSString *SelectUserID = [Parmers objectForKey:@"CRM_SELECTUSERID"];
    NSString *UserID = [Parmers objectForKey:@"CRM_USERID"];
    NSArray *userDetail = [UserID componentsSeparatedByString:@"_"];
    NSString *userId =[userDetail objectAtIndex:0];
    //读取保存在NSUserDefaults的ProjectID
    NSString *projectID = [Parmers objectForKey:@"CRM_PROJECTID"];
//    NSString *followUpContent = TFollowRemark.textView.text;
    [CustParmers setObject:userId forKey:@"UserID"];
    [CustParmers setObject:projectID  forKey:@"ProjectID"];
    [CustParmers setObject:self.custEntity.custId forKey:@"CustID"];
    [CustParmers setObject:followUpContent forKey:@"FollowRemark"];
    [CustParmers setObject:sourceId forKey:@"FollowType"];
    [parmer setObject:@"saveFollowUpDetail" forKey:@"method"];
    [parmer setObject:[CustParmers JSONRepresentation] forKey:@"parameter"];
    ResponseModel *response = [CrmNetServiceUtil startRecommandlistByPagePost:1 Message:parmer];
    isLoadingNext = NO;
    dicResultInfo = response.resultInfo;
    dispatch_async(dispatch_get_main_queue(), ^(void)
                   {
                       NSString *result = [dicResultInfo objectForKey:@"result"];
                       if ([result isEqual:@"1"])
                       {
                           NSString *cellcontent = @"跟进纪录保存成功！";
                           UIAlertView *messageAlert = [[UIAlertView alloc]
                                                        initWithTitle:@"提示" message:cellcontent delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                           [messageAlert show];
                           [self viewDidLoad];
                       }
                       else
                       {
                           NSString *cellcontent = @"网络异常，跟进纪录保存失败！";
                           UIAlertView *messageAlert = [[UIAlertView alloc]
                                                        initWithTitle:@"提示" message:cellcontent delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                           [messageAlert show];
                       }
                   }
                   );
    sourceId=@"";
    followUpContent=@"";

}
#pragma mark 一键拨号
-(void)btnCall:(id)sender
{
    NSUserDefaults *Parmers = [NSUserDefaults standardUserDefaults];
    NSString *SelectUserID = [Parmers objectForKey:@"CRM_SELECTUSERID"];
    NSArray *SelectUserDetail = [SelectUserID componentsSeparatedByString:@"_"];
    NSString *selectUserId =[SelectUserDetail objectAtIndex:0];
    
    NSString *UserID = [Parmers objectForKey:@"CRM_USERID"];
    NSArray *userDetail = [UserID componentsSeparatedByString:@"_"];
    NSString *userId =[userDetail objectAtIndex:0];
    if (![userId isEqual:selectUserId])//选中的用户为本人才可打电话
    {
        NSString *cellcontent = @"只有跟进该客户的销售员方可给该客户拨打电话";
        UIAlertView *messageAlert = [[UIAlertView alloc]
                                     initWithTitle:@"提示" message:cellcontent delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [messageAlert show];
        return;
    }
    NSString *phoneNum = self.custEntity.custPhone;// 电话号码
    
    NSURL *phoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",phoneNum]];
    
    if ( !phoneCallWebView ) {
        
        phoneCallWebView = [[UIWebView alloc] initWithFrame:CGRectZero];//
        
    }
    //用loadRequest可以使得用户结束通话后自动返回到应用
    [phoneCallWebView loadRequest:[NSURLRequest requestWithURL:phoneURL]];
    followUpContent=@"使用APP一键拨号功能拨打了客户电话";
    sourceId = @"1";
//    //监听拨号状态
//    callCenter = [[CTCallCenter alloc] init];
//    callCenter.callEventHandler=^(CTCall* call)
//    {
//        if (call.callState == CTCallStateDisconnected)
//        {
//            NSLog(@"Call has been disconnected");//电话已经断开连接
//            [self showAlertView:@"电话已经断开连接"];
//        }
//        else if (call.callState == CTCallStateConnected)
//        {
//            NSLog(@"Call has just been connected");//刚刚打电话联系
//            [self showAlertView:@"刚刚打电话联系"];
//        }
//        
//        else if(call.callState == CTCallStateIncoming)
//        {
//            NSLog(@"Call is incoming");//调用传入
//            [self showAlertView:@"调用传入"];
//        }
//        
//        else if (call.callState ==CTCallStateDialing)
//        {
//            NSLog(@"call is dialing");//电话拨号
//            [self showAlertView:@"电话拨号"];
//            
//        }
//        else
//        {
//            NSLog(@"Nothing is done");//什么都不做
//            [self showAlertView:@"什么都不做"];
//        }
//    };
    [self showLoadingView];
    [NSThread detachNewThreadSelector:@selector(saveFollowUpDetailBySMSPhone) toTarget:self withObject:nil];
    
}

#pragma mark 一键发短信
-(IBAction)showSMSPicker:(id)sender {
    NSUserDefaults *Parmers = [NSUserDefaults standardUserDefaults];
    NSString *SelectUserID = [Parmers objectForKey:@"CRM_SELECTUSERID"];
    NSArray *SelectUserDetail = [SelectUserID componentsSeparatedByString:@"_"];
    NSString *selectUserId =[SelectUserDetail objectAtIndex:0];
    
    NSString *UserID = [Parmers objectForKey:@"CRM_USERID"];
    NSArray *userDetail = [UserID componentsSeparatedByString:@"_"];
    NSString *userId =[userDetail objectAtIndex:0];
    if (![userId isEqual:selectUserId])//选中的用户为本人才可发短信
    {
        NSString *cellcontent = @"只有跟进该客户的销售员方可给该客户发送短信";
        UIAlertView *messageAlert = [[UIAlertView alloc]
                                     initWithTitle:@"提示" message:cellcontent delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [messageAlert show];
        return;
    }
    //  The MFMessageComposeViewController class is only available in iPhone OS 4.0 or later.
    //  So, we must verify the existence of the above class and log an error message for devices
    //      running earlier versions of the iPhone OS. Set feedbackMsg if device doesn't support
    //      MFMessageComposeViewController API.
    Class messageClass = (NSClassFromString(@"MFMessageComposeViewController"));
    if (messageClass != nil) {
        // Check whether the current device is configured for sending SMS messages
        if ([messageClass canSendText]) {
            [self sendSMS];
        }
        else {
            [self showAlertView:@"设备没有短信功能"];
        }
    }
    else {
        [self showAlertView:@"iOS版本过低,iOS4.0以上才支持程序内发送短信"];
    }
}
- (void)sendSMS
{
    MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
    if([MFMessageComposeViewController canSendText])
        
    {
        controller.body = @"";
        // 默认收件人为当前客户(可多个)
        controller.recipients = [NSArray arrayWithObject:self.custEntity.custPhone];
        controller.navigationBar.tintColor = [UIColor blackColor];
        controller.messageComposeDelegate = self;
        [self presentModalViewController:controller animated:YES];
    }
}
// 处理发送完的响应结果
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [self dismissModalViewControllerAnimated:YES];
    switch (result) {
        case MessageComposeResultCancelled:
           // if (DEBUG) NSLog(@"Result: canceled");
//            [self showAlertView:@"取消发送"];
            break;
        case MessageComposeResultSent:
            //if (DEBUG) NSLog(@"Result: Sent");
//            [self showAlertView:@"短信发送成功"];
            followUpContent=@"使用APP一键发信息功能向客户发送短信";
            sourceId = @"2";
            [self showLoadingView];
            [NSThread detachNewThreadSelector:@selector(saveFollowUpDetailBySMSPhone) toTarget:self withObject:nil];
            break;
        case MessageComposeResultFailed:
            //if (DEBUG) NSLog(@"Result: Failed");
//            [self showAlertView:@"短信发送失败"];
            break;
        default:
            break;
    }
}
-(void)saveFollowUpDetailBySMSPhone
{
    NSMutableDictionary *parmer = [NSMutableDictionary dictionaryWithCapacity:2];
    NSMutableDictionary *CustParmers = [NSMutableDictionary dictionaryWithCapacity:4];
    NSUserDefaults *Parmers = [NSUserDefaults standardUserDefaults];
    //读取保存在NSUserDefaults的用户id
    NSString *SelectUserID = [Parmers objectForKey:@"CRM_SELECTUSERID"];
    NSString *UserID = [Parmers objectForKey:@"CRM_USERID"];
    NSArray *userDetail = [UserID componentsSeparatedByString:@"_"];
    NSString *userId =[userDetail objectAtIndex:0];
    //读取保存在NSUserDefaults的ProjectID
    NSString *projectID = [Parmers objectForKey:@"CRM_PROJECTID"];
    //    NSString *followUpContent = TFollowRemark.textView.text;
    [CustParmers setObject:userId forKey:@"UserID"];
    [CustParmers setObject:projectID  forKey:@"ProjectID"];
    [CustParmers setObject:self.custEntity.custId forKey:@"CustID"];
    [CustParmers setObject:followUpContent forKey:@"FollowRemark"];
    [CustParmers setObject:sourceId forKey:@"FollowType"];
    [parmer setObject:@"saveFollowUpDetail" forKey:@"method"];
    [parmer setObject:[CustParmers JSONRepresentation] forKey:@"parameter"];
    ResponseModel *response = [CrmNetServiceUtil startRecommandlistByPagePost:1 Message:parmer];
    isLoadingNext = NO;
    dicResultInfo = response.resultInfo;
    dispatch_async(dispatch_get_main_queue(), ^(void)
                   {
                       NSString *result = [dicResultInfo objectForKey:@"result"];
                       if ([result isEqual:@"1"])
                       {
//                           NSString *cellcontent = @"跟进纪录保存成功！";
//                           UIAlertView *messageAlert = [[UIAlertView alloc]
//                                                        initWithTitle:@"提示" message:cellcontent delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
//                           [messageAlert show];
                           [self viewDidLoad];
                       }
                       else
                       {
                           NSString *cellcontent = @"网络异常，跟进纪录保存失败！";
                           UIAlertView *messageAlert = [[UIAlertView alloc]
                                                        initWithTitle:@"提示" message:cellcontent delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                           [messageAlert show];
                       }
                   }
                   );
    sourceId=@"";
    followUpContent=@"";
    
}
#pragma mark 弹出键盘后自动提高textview高度方法
- (void)keyboardWillShow:(NSNotification *)noti
{
    //键盘输入的界面调整
    //键盘的高度
    float height = 216.0;
    CGRect frame = self.view.frame;
    frame.size = CGSizeMake(frame.size.width, frame.size.height - height);
    [UIView beginAnimations:@"Curl"context:nil];//动画开始
    [UIView setAnimationDuration:0.30];
    [UIView setAnimationDelegate:self];
    [self.view setFrame:frame];
    [UIView commitAnimations];
}

- (BOOL)textView:(UIView *)textView shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        
        NSTimeInterval animationDuration = 0.30f;
        [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
        [UIView setAnimationDuration:animationDuration];
        CGRect rect = CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height);
        self.view.frame = rect;
        [UIView commitAnimations];
        
        
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void)textViewDidBeginEditing:(UIView *)textView
{
    
    
    CGRect frame = textView.superview.frame;
    
    int offset = frame.origin.y +112+ 50 - (self.view.frame.size.height - 216.0);//键盘高度216
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyBoard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    float width = self.view.frame.size.width;
    float height = self.view.frame.size.height;
    if(offset > 0)
    {
        CGRect rect = CGRectMake(0.0f, -offset,width,height);
        self.view.frame = rect;
    }
    [UIView commitAnimations];
}

-(IBAction)backgroundTap:(id)sender
{
    // When the user presses return, take focus away from the text field so that the keyboard is dismissed.
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    CGRect rect = CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height);
    self.view.frame = rect;
    [UIView commitAnimations];
    [TFollowRemark resignFirstResponder];

}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    CGRect rect = CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height);
    self.view.frame = rect;
    [UIView commitAnimations];
    //隐藏键盘
    [self.TFollowRemark resignFirstResponder];
}
@end