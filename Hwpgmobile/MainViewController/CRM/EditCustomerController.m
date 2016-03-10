//
//  AddCustomerController.m
//  Test
//
//  Created by 邱健 on 14/11/5.
//  Copyright (c) 2014年 邱健. All rights reserved.
//

#import "EditCustomerController.h"
#import "DVSwitch.h"
#import "SSCheckBoxView.h"
#import "UIHelpers.h"
#import "DropDownList.h"
#import "CBTextView.h"
#import "ResponseModel.h"
#import "CrmNetServiceUtil.h"
#import "JSON.h"
#import "CustEntity.h"
#import "NSString+FontAwesome.h"
#import "FAImageView.h"
@interface EditCustomerController ()
{
    BOOL isLoadingNext;
    NSDictionary *dicPrefer;
    NSMutableArray *PreferCheckList;
    NSDictionary *dicSelect;
    UIScrollView *vmain;
    UIScrollView *vother;
    NSString *Sex;
    UIButton *returnBtn;
}
@end

@implementation EditCustomerController
@synthesize TName;
@synthesize TTel;
@synthesize TPrefer;
@synthesize TRemark;
@synthesize checkboxes;
@synthesize TIC;
@synthesize myTableView;
@synthesize TFollowRemark;
@synthesize ddSource;
@synthesize ddType;
@synthesize ddLevel;
@synthesize ddCity;
@synthesize TFollowType;
@synthesize dataList;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIView *v1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 60)];
    [v1 setBackgroundColor:[UIColor colorWithRed:34/255.0 green:34/255.0 blue:34/255.0 alpha:0.83]];
    //设置uiview名称
    UILabel *l1 = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-75,20, 150, 40)];
    NSUserDefaults *Parmers = [NSUserDefaults standardUserDefaults];
    NSString *projectName = [Parmers objectForKey:@"CRM_PROJECTNAME"];
    
    [l1  setText:[projectName stringByAppendingString:[NSString stringWithFormat:@"%@",@"-客户编辑"]]];
    [l1  setTextColor:[UIColor whiteColor]];
    [l1 setFont:[UIFont systemFontOfSize:15]];
    [v1 addSubview: l1];
    
    //返回按钮 start
    returnBtn = [[UIButton alloc] initWithFrame:CGRectMake(0,22, 45, 30)];
    // 加入button单击事件
    [returnBtn addTarget:self action:@selector(returnBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [returnBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];//title color
    [returnBtn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];//设置title的高亮颜色
    [returnBtn setFont:[UIFont fontWithName:kFontAwesomeFamilyName size:30]];
    [returnBtn setTitle:[NSString fontAwesomeIconStringForEnum:FAAngleLeft] forState:UIControlStateNormal];
//    [returnBtn setTitle:@"返回" forState:UIControlStateNormal];
//    [returnBtn setFont:[UIFont systemFontOfSize:15]];
//    [returnBtn.layer setMasksToBounds:YES];
//    [returnBtn.layer setCornerRadius:5]; //设置矩形四个圆角半径
//    [returnBtn.layer setBorderWidth:1.0]; //边框宽度
//    [returnBtn.layer setBorderColor:[UIColor colorWithRed:0.0/255 green:153.0/255 blue:204.0/255 alpha:1].CGColor];//边框颜色
//           // [returnBtn.layer setBackgroundColor:[UIColor greenColor].CGColor];//背景颜色
//    UILabel *arrow = [[UILabel alloc] initWithFrame:CGRectMake(7, 14, 10, 13)];
//    arrow.font =[UIFont fontWithName:kFontAwesomeFamilyName size:20];
//    arrow.text = [NSString fontAwesomeIconStringForEnum:FAAngleLeft];
//    arrow.textColor = [UIColor whiteColor];
//    [returnBtn addSubview:arrow];
    [v1 addSubview: returnBtn];
    
    //设置save按钮
    UIButton *b1 = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width-60, 20, 60, 40)];
    //[b1 setBackgroundImage:[UIImage imageNamed:@"ico-save.png"] forState:UIControlStateNormal];
    [b1 addTarget:self action:@selector(SaveCustInfo:) forControlEvents:UIControlEventTouchUpInside];//添加点击事件
    [b1 setFont:[UIFont fontWithName:kFontAwesomeFamilyName size:20]];
    [b1 setTitle:[NSString fontAwesomeIconStringForEnum:FAFloppyO] forState:UIControlStateNormal];
//    UIButton *b1 = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width-60, 20, 60, 40)];
//    //[b1 setBackgroundImage:[UIImage imageNamed:@"ico-save.png"] forState:UIControlStateNormal];
//    [b1 addTarget:self action:@selector(SaveCustInfo:) forControlEvents:UIControlEventTouchUpInside];//添加点击事件
//    //[b1.layer setBackgroundColor:[UIColor greenColor].CGColor];//背景颜色
//    
//    UIImageView *saveimage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, 32, 32)];
//    [saveimage setImage:[UIImage imageNamed:@"ico-save.png"]];
//    [b1 addSubview:saveimage];
    [v1 addSubview: b1];

    
    //myTableView.tableHeaderView =v1;
    [self.view addSubview:v1];
    
    
    
    DVSwitch *switcherView = [[DVSwitch alloc] initWithStringsArray:@[@"Important",@"Intent", @"Other"]];
    switcherView.frame = CGRectMake(0, 60, self.view.frame.size.width, 30);
    switcherView.backgroundColor = [UIColor colorWithRed:34/255.0 green:34/255.0 blue:34/255.0 alpha:0.83];
    switcherView.labelTextColorInsideSlider = [UIColor whiteColor];
  
    switcherView.labelTextColorOutsideSlider = [UIColor colorWithRed:255.0/255 green:255.0/255 blue:255.0/255 alpha:0.87];
    switcherView.font = [UIFont systemFontOfSize:12];
    switcherView.sliderColor = [UIColor colorWithRed:54.0/255 green:175.0/255 blue:215.0/255 alpha:1];
    [self.view addSubview:switcherView];
    
//    UIView *v4 = [[UIView alloc] initWithFrame:CGRectMake(0, 89, self.view.frame.size.width, 3)];
//   [v4 setBackgroundColor:[UIColor colorWithRed:51.0/255 green:204.0/255 blue:102.0/255 alpha:1]];
//   [self.view addSubview:v4];
    
    //获取下拉菜单信息
    [NSThread detachNewThreadSelector:@selector(startgetSelectThread) toTarget:self withObject:nil];
    
    //主要信息
    vmain = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 92, self.view.frame.size.width, self.view.frame.size.height-90)];
    [vmain setBackgroundColor:[UIColor colorWithRed:238.0/255 green:238.0/255 blue:238.0/255 alpha:1]];
   
    vmain.directionalLockEnabled = YES; //只能一个方向滑动
    vmain.pagingEnabled = NO; //是否翻页
  
    vmain.showsVerticalScrollIndicator =YES; //垂直方向的滚动指示
    vmain.indicatorStyle = UIScrollViewIndicatorStyleWhite;//滚动指示的风格
    vmain.showsHorizontalScrollIndicator = NO;//水平方向的滚动指示
    vmain.delegate = self;
    CGSize newSize = CGSizeMake(self.view.frame.size.width, 568-90);
    [vmain setContentSize:newSize];
    
    
   
    
     //客户意向
    UIView *vprefer = [[UIView alloc] initWithFrame:CGRectMake(0, 92, self.view.frame.size.width, self.view.frame.size.height)];
    [vprefer setBackgroundColor:[UIColor colorWithRed:238.0/255 green:238.0/255 blue:238.0/255 alpha:1]];
 
   
    
    
    myTableView  = [[UITableView alloc] initWithFrame:CGRectMake(10, 8, self.view.frame.size.width-20, self.view.frame.size.height-120) style:UITableViewStyleGrouped];//
    PreferCheckList = [[NSMutableArray alloc] init];
    
    // 设置tableView的数据源
    myTableView.dataSource = self;
    // 设置tableView的委托
    myTableView.delegate = self;
     myTableView.separatorColor = [UIColor lightGrayColor];
   
    // 设置tableView的背景图
    //myTableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"01.png"]];
    [vprefer addSubview:myTableView];
    
    

    //其他信息
    vother = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 92, self.view.frame.size.width, self.view.frame.size.height-90)];
    [vother setBackgroundColor:[UIColor colorWithRed:238.0/255 green:238.0/255 blue:238.0/255 alpha:1]];
    
    
    vother.directionalLockEnabled = YES; //只能一个方向滑动
    vother.pagingEnabled = NO; //是否翻页
    
    vother.showsVerticalScrollIndicator =YES; //垂直方向的滚动指示
    vother.indicatorStyle = UIScrollViewIndicatorStyleWhite;//滚动指示的风格
    vother.showsHorizontalScrollIndicator = NO;//水平方向的滚动指示
    vother.delegate = self;
   
    [vother setContentSize:newSize];
    
    
    
    
    TFollowRemark = [[CBTextView alloc] initWithFrame:CGRectMake(10,65, self.view.frame.size.width-20, 110)];
    TFollowRemark.placeHolder = @"输入跟进内容";
    //TFollowRemark.textView.delegate = self;
    TFollowRemark.aDelegate= self;
    TFollowRemark.textView.returnKeyType = UIReturnKeyDone;//设置回车键类型
    [TFollowRemark.textView.layer setCornerRadius:10];
    TFollowRemark.textView.font = [UIFont fontWithName:@"Arial" size:15];
    [vother addSubview: TFollowRemark];

    
    
    
    
    
   
    
    [self.view addSubview:vmain];
    [switcherView setPressedHandler:^(NSUInteger index) {
       // NSLog(@"Did press position on first switch at index: %lu", (unsigned long)index);
        if(index==0)
        {
            [vother removeFromSuperview];
            [vprefer removeFromSuperview];
            [self.view addSubview:vmain];
        }
        else if(index==1)
        {
            [vmain removeFromSuperview];
            [vother removeFromSuperview];
      
            [self.view addSubview:vprefer];
        }
        else
        {
          
            [vmain removeFromSuperview];
            [vprefer removeFromSuperview];
            [self.view addSubview:vother];
        }
        
    }];
   
}

-(void)SaveCustInfo:(UIButton *)btn{
    if ([TName.text isEqual:@""])
    {
        NSString *cellcontent = @"请输入客户姓名";
        UIAlertView *messageAlert = [[UIAlertView alloc]
        initWithTitle:@"提示" message:cellcontent delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [messageAlert show];
        return;
    }
    if ([TTel.text isEqual:@""])
    {
        NSString *cellcontent = @"请输入客户电话";
        UIAlertView *messageAlert = [[UIAlertView alloc]
                                     initWithTitle:@"提示" message:cellcontent delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [messageAlert show];
        return;
    }
    if ([ddSource.tField.text isEqual:@""])
    {
        NSString *cellcontent = @"请选择客户首次来源";
        UIAlertView *messageAlert = [[UIAlertView alloc]
                                     initWithTitle:@"提示" message:cellcontent delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [messageAlert show];
        return;
    }
    if ([ddType.tField.text isEqual:@""])
    {
        NSString *cellcontent = @"请选择客户类型";
        UIAlertView *messageAlert = [[UIAlertView alloc]
                                     initWithTitle:@"提示" message:cellcontent delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [messageAlert show];
        return;
    }
    if ([ddLevel.tField.text isEqual:@""])
    {
        NSString *cellcontent = @"请选择客户等级";
        UIAlertView *messageAlert = [[UIAlertView alloc]
                                     initWithTitle:@"提示" message:cellcontent delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [messageAlert show];
        return;
    }
    if ([ddCity.tField.text isEqual:@""])
    {
        NSString *cellcontent = @"请选择客户居住地";
        UIAlertView *messageAlert = [[UIAlertView alloc]
                                     initWithTitle:@"提示" message:cellcontent delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [messageAlert show];
        return;
    }
    if (![TFollowRemark.textView.text isEqual:@""] && ![TFollowRemark.textView.text isEqual:@"输入跟进内容"])
    {
        if ([TFollowType.tField.text isEqual:@""])
        {
            NSString *cellcontent = @"请选择跟进方式";
            UIAlertView *messageAlert = [[UIAlertView alloc]
                                         initWithTitle:@"提示" message:cellcontent delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [messageAlert show];
            return;
        }
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
    [NSThread detachNewThreadSelector:@selector(SaveCustInfoThread) toTarget:self withObject:nil];
    
        
}
-(void)SaveCustInfoThread
{
    
    NSUserDefaults *Parmers = [NSUserDefaults standardUserDefaults];
    NSString *projectID = [Parmers objectForKey:@"CRM_PROJECTID"];
    NSString *UserID = [Parmers objectForKey:@"CRM_USERID"];
    NSMutableDictionary *parmer = [NSMutableDictionary dictionaryWithCapacity:2];
    NSMutableDictionary *CustParmers = [NSMutableDictionary dictionaryWithCapacity:15];
     [CustParmers setObject:projectID  forKey:@"ProjectID"];
     [CustParmers setObject:TName.text forKey:@"Name"];
     [CustParmers setObject:TTel.text forKey:@"Tel"];
     [CustParmers setObject:TPrefer.text forKey:@"Prefer"];
     [CustParmers setObject:TIC.text forKey:@"IC"];
     [CustParmers setObject:Sex forKey:@"Sex"];
     [CustParmers setObject:TRemark.text forKey:@"Remark"];
     [CustParmers setObject:TFollowRemark.textView.text forKey:@"FollowRemark"];
   
     [CustParmers setObject:[NSString stringWithFormat:@"%d",ddSource.tField.tag] forKey:@"Source"];
     [CustParmers setObject:[NSString stringWithFormat:@"%d",ddType.tField.tag] forKey:@"Type"];
     [CustParmers setObject:[NSString stringWithFormat:@"%d",ddLevel.tField.tag] forKey:@"Level"];
     [CustParmers setObject:[NSString stringWithFormat:@"%d",ddCity.tField.tag] forKey:@"City"];
     [CustParmers setObject:[NSString stringWithFormat:@"%d",TFollowType.tField.tag] forKey:@"FollowType"];

     [CustParmers setObject:UserID forKey:@"UserID"];
     NSString *custID=self.custEntity.custId;
     [CustParmers setObject:custID forKey:@"CustID"];
     NSString *PCheckList = @"-1";
     for(NSString *Checkstring in PreferCheckList)
     {
        //NSLog(@"string:%@",string);
         PCheckList=[PCheckList stringByAppendingString:[NSString stringWithFormat:@"%@%@",@",",Checkstring]];
     }
    
     [CustParmers setObject:PCheckList forKey:@"PreferCheckList"];
     [parmer setObject:@"updateCustInfo" forKey:@"method"];
     [parmer setObject:[CustParmers JSONRepresentation] forKey:@"parameter"];
    
     //ResponseModel *response = [CrmNetServiceUtil startRecommandlistByPagePost:<#(int)#> :(NSString *)];
    ResponseModel *response = [CrmNetServiceUtil startRecommandlistByPagePost:1 Message:parmer];
     isLoadingNext = NO;
      NSDictionary *dicResultInfo = response.resultInfo;
     dispatch_async
    (
      dispatch_get_main_queue(), ^(void)
      {
         if (response.error !=nil)
         {
             [self showErrorView];
             [self showAlertView:@"请检查网络"];
             return;
         }
         [self hideLoadingView];
         
         NSString *result = [dicResultInfo objectForKey:@"result"];
           if ([result isEqual:@"1"])
          {
             NSString *cellcontent = @"客户信息保存成功！";
             UIAlertView *messageAlert = [[UIAlertView alloc]
                                       initWithTitle:@"提示" message:cellcontent delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
             [messageAlert show];
              
          }
          else
          {
              NSString *cellcontent = @"客户信息保存失败！";
              UIAlertView *messageAlert = [[UIAlertView alloc]
                                           initWithTitle:@"提示" message:cellcontent delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
              [messageAlert show];
          }
      }
     );
}
-(void)startgetSelectThread
{
    NSUserDefaults *Parmers = [NSUserDefaults standardUserDefaults];
    NSString *projectID = [Parmers objectForKey:@"CRM_PROJECTID"];
    NSString *custID=self.custEntity.custId;
    
    NSString *soapMessage=@"method=getSelectListEdit&parameter=";
    soapMessage = [soapMessage stringByAppendingString:[NSString stringWithFormat:@"[%@,%@]",custID,projectID]];
    ResponseModel *response = [CrmNetServiceUtil startRecommandlistByPage:1 Message:soapMessage];
    isLoadingNext = NO;
    NSDictionary *dicSelectListInfo = response.resultInfo;
    dispatch_async
    (
     dispatch_get_main_queue(), ^(void)
     {
         if (response.error !=nil)
         {
             [self showErrorView];
             [self showAlertView:@"请检查网络"];
             return;
         }
         [self hideLoadingView];
         
         dicSelect = [dicSelectListInfo objectForKey:@"result"];
         
         
         
         TName= [[UITextField alloc] initWithFrame:CGRectMake(10,10, self.view.frame.size.width-20, 45)];
         
         TName.borderStyle=UITextBorderStyleRoundedRect;//设置文本框的边框样式
         TName.keyboardType = UIKeyboardTypeEmailAddress;//设置键盘类型
         TName.returnKeyType = UIReturnKeyDone;//设置回车键类型
         TName.placeholder=@"输入姓名(必填)";
         TName.font = [UIFont systemFontOfSize:15];
         
         TName.clearButtonMode = UITextFieldViewModeAlways;//设置一次性删除按钮
         //[TName becomeFirstResponder];//设置成为页面默认焦点
         TName.delegate = self;
         TName.text=[dicSelect objectForKey:@"Name"];
         [vmain addSubview: TName];
         
         
         TTel= [[UITextField alloc] initWithFrame:CGRectMake(10,65, self.view.frame.size.width-20, 45)];
         
         TTel.borderStyle=UITextBorderStyleRoundedRect;//设置文本框的边框样式
         TTel.keyboardType = UIKeyboardTypeEmailAddress;//设置键盘类型
         TTel.returnKeyType = UIReturnKeyDone;//设置回车键类型
         TTel.placeholder=@"输入电话(必填)";
         TTel.font = [UIFont systemFontOfSize:15];
         TTel.clearButtonMode = UITextFieldViewModeAlways;//设置一次性删除按钮
         TTel.delegate = self;
         TTel.text=[dicSelect objectForKey:@"Tel"];
         [vmain addSubview: TTel];
         
         
         DVSwitch *switcher = [[DVSwitch alloc] initWithStringsArray:@[@"男", @"女"]];
         switcher.frame = CGRectMake(self.view.frame.size.width/2, 348, self.view.frame.size.width/2-10 , 30);
         switcher.backgroundColor = [UIColor colorWithRed:221.0/255.0 green:221.0/255.0 blue:221.0/255.0 alpha:1.0];
         switcher.labelTextColorInsideSlider = [UIColor whiteColor];
         switcher.labelTextColorOutsideSlider = [UIColor blackColor];
         switcher.cornerRadius=10;
         switcher.sliderColor = [UIColor colorWithRed:0.0/255.0 green:153.0/255.0 blue:204.0/255.0 alpha:1.0];
          Sex=@"0";
         [switcher setPressedHandler:^(NSUInteger index) {
             Sex=[NSString stringWithFormat:@"%d",index];
         }];
         NSString *SexValue =[dicSelect objectForKey:@"Sex"];
         if([SexValue isEqual:@"0"])
             [switcher forceSelectedIndex:1 animated: true];
         else
             [switcher forceSelectedIndex:0 animated: true];
         
         [vmain addSubview: switcher];
         
         
         
         
         ddSource = [[DropDownList alloc] initWithFrame:CGRectMake(10, 121, self.view.frame.size.width - 20, 100)];
         
         ddSource.tField.placeholder = @"选择首次来源(必填)";
         ddSource.tField.font = [UIFont systemFontOfSize:15];
         [ddSource.tField resignFirstResponder];
         ddSource.tField.keyboardType = UIKeyboardTypeEmailAddress;//设置键盘类型
//         [TName becomeFirstResponder];//设置成为页面默认焦点
         NSArray* arrSource=[dicSelect objectForKey:@"ListSource"];
         ddSource.tableArray = arrSource;
         for(int i=0;i<[arrSource count];i++)
         {
             NSString *ValueAndID = [arrSource objectAtIndex:i];
             NSArray *ValueAndIDArray = [ValueAndID componentsSeparatedByString:@"_"];
             NSString *ID =[ValueAndIDArray objectAtIndex:0];
             NSString *Value =[ValueAndIDArray objectAtIndex:1];
             
             if([ValueAndIDArray count]>2)
             {
                 NSString *Checked=[ValueAndIDArray objectAtIndex:2];
                 if([Checked isEqual:@"1"])
                 {
                     ddSource.tField.text = Value;
                     ddSource.tField.tag = [ID integerValue];
                 }
             }
         }

         
         [vmain addSubview: ddSource];
         
         ddType = [[DropDownList alloc] initWithFrame:CGRectMake(10, 178, self.view.frame.size.width - 20, 100)];
         [ddType.tField resignFirstResponder];
         ddType.tField.placeholder = @"选择类型(必填)";
         ddType.tField.font = [UIFont systemFontOfSize:15];
         NSArray* arrdType=[dicSelect objectForKey:@"ListType"];
         ddType.tableArray = arrdType;
         ddType.tField.keyboardType = UIKeyboardTypeEmailAddress;//设置键盘类型
         for(int i=0;i<[arrdType count];i++)
         {
             NSString *ValueAndID = [arrdType objectAtIndex:i];
             NSArray *ValueAndIDArray = [ValueAndID componentsSeparatedByString:@"_"];
             NSString *ID =[ValueAndIDArray objectAtIndex:0];
             NSString *Value =[ValueAndIDArray objectAtIndex:1];
             
             if([ValueAndIDArray count]>2)
             {
                 NSString *Checked=[ValueAndIDArray objectAtIndex:2];
                 if([Checked isEqual:@"1"])
                 {
                     ddType.tField.text = Value;
                     ddType.tField.tag = [ID integerValue];
                 }
             }
         }

         [vmain addSubview: ddType];
         
         
         ddLevel = [[DropDownList alloc] initWithFrame:CGRectMake(10, 235, self.view.frame.size.width - 20, 100)];
         [ddLevel.tField resignFirstResponder];
         ddLevel.tField.placeholder = @"选择等级(必填)";
         ddLevel.tField.font = [UIFont systemFontOfSize:15];
         NSArray* arrLevel=[dicSelect objectForKey:@"ListLevel"];
         for(int i=0;i<[arrLevel count];i++)
         {
             NSString *ValueAndID = [arrLevel objectAtIndex:i];
             NSArray *ValueAndIDArray = [ValueAndID componentsSeparatedByString:@"_"];
             NSString *ID =[ValueAndIDArray objectAtIndex:0];
             NSString *Value =[ValueAndIDArray objectAtIndex:1];
             
             if([ValueAndIDArray count]>2)
             {
                 NSString *Checked=[ValueAndIDArray objectAtIndex:2];
                 if([Checked isEqual:@"1"])
                 {
                     ddLevel.tField.text = Value;
                     ddLevel.tField.tag = [ID integerValue];
                 }
             }
         }

         ddLevel.tableArray = arrLevel;

         ddLevel.tField.keyboardType = UIKeyboardTypeEmailAddress;//设置键盘类型
         [vmain addSubview: ddLevel];
         
         ddCity = [[DropDownList alloc] initWithFrame:CGRectMake(10, 292, self.view.frame.size.width - 20, 100)];
         [ddCity.tField resignFirstResponder];
         ddCity.tField.placeholder = @"选择居住地(必填)";
         ddCity.tField.font = [UIFont systemFontOfSize:15];
         NSArray* arrCity=[dicSelect objectForKey:@"ListCity"];
         ddCity.tableArray = arrCity;

         ddCity.tField.keyboardType = UIKeyboardTypeEmailAddress;//设置键盘类型
         for(int i=0;i<[arrCity count];i++)
         {
             NSString *ValueAndID = [arrCity objectAtIndex:i];
             NSArray *ValueAndIDArray = [ValueAndID componentsSeparatedByString:@"_"];
             NSString *ID =[ValueAndIDArray objectAtIndex:0];
             NSString *Value =[ValueAndIDArray objectAtIndex:1];
             
             if([ValueAndIDArray count]>2)
             {
                 NSString *Checked=[ValueAndIDArray objectAtIndex:2];
                 if([Checked isEqual:@"1"])
                 {
                     ddCity.tField.text = Value;
                     ddCity.tField.tag = [ID integerValue];
                 }
             }
         }

         [vmain addSubview: ddCity];
         
         
         TFollowType = [[DropDownList alloc] initWithFrame:CGRectMake(10, 10, self.view.frame.size.width - 20, 45)];
         
         TFollowType.tField.placeholder = @"选择跟进方式";
         [TFollowType.tField resignFirstResponder];
          NSArray* arrFollowType=[dicSelect objectForKey:@"ListFollowType"];
         TFollowType.tableArray = arrFollowType;
         TFollowType.tField.keyboardType = UIKeyboardTypeEmailAddress;//设置键盘类型
         TFollowType.tField.font = [UIFont systemFontOfSize:15];
         [vother addSubview: TFollowType];
         
         
         
         
         TRemark = [[UITextView alloc] initWithFrame:CGRectMake(10,185, self.view.frame.size.width-20, 110)];
         
         
         [TRemark.layer setCornerRadius:10];
         // TRemark.textView.delegate = self;
         TRemark.delegate= self;
         TRemark.returnKeyType = UIReturnKeyDone;//设置回车键类型
         TRemark.font = [UIFont fontWithName:@"Arial" size:15];
         TRemark.text=[dicSelect objectForKey:@"Remark"];
        
         [vother addSubview: TRemark];
         
         
         TPrefer= [[UITextField alloc] initWithFrame:CGRectMake(10,305, self.view.frame.size.width-20, 45)];
         TPrefer.borderStyle=UITextBorderStyleRoundedRect;//设置文本框的边框样式
         TPrefer.keyboardType = UIKeyboardTypeEmailAddress;//设置键盘类型
         TPrefer.returnKeyType = UIReturnKeyDone;//设置回车键类型
         TPrefer.placeholder=@"输入意向单位";
         TPrefer.clearButtonMode = UITextFieldViewModeAlways;//设置一次性删除按钮
         TPrefer.text=[dicSelect objectForKey:@"Prefer"];
         TPrefer.font = [UIFont systemFontOfSize:15];
         TPrefer.delegate = self;
         [vother addSubview: TPrefer];
         
         TIC= [[UITextField alloc] initWithFrame:CGRectMake(10,360, self.view.frame.size.width-20, 45)];
         TIC.borderStyle=UITextBorderStyleRoundedRect;//设置文本框的边框样式
         TIC.keyboardType = UIKeyboardTypeEmailAddress;//设置键盘类型
         TIC.returnKeyType = UIReturnKeyDone;//设置回车键类型
         TIC.placeholder=@"输入证件号码";
         TIC.clearButtonMode = UITextFieldViewModeAlways;//设置一次性删除按钮
         TIC.text=[dicSelect objectForKey:@"IC"];
         TIC.font = [UIFont systemFontOfSize:15];
         TIC.delegate = self;
         [vother addSubview: TIC];

     }
     );
     [NSThread detachNewThreadSelector:@selector(startgetPreferInThread) toTarget:self withObject:nil];
}


-(void)startgetPreferInThread
{
    NSUserDefaults *Parmers = [NSUserDefaults standardUserDefaults];
    NSString *projectID = [Parmers objectForKey:@"CRM_PROJECTID"];
    NSString *custID=self.custEntity.custId;
    NSString *soapMessage=@"method=getPreferListEdit&parameter=";
    soapMessage = [soapMessage stringByAppendingString:[NSString stringWithFormat:@"[%@,%@]",custID,projectID]];
    NSLog(@"%@",soapMessage);
    ResponseModel *response = [CrmNetServiceUtil startRecommandlistByPage:1 Message:soapMessage];
    isLoadingNext = NO;
    dicPrefer = response.resultInfo;
    
    dispatch_async
    (
     dispatch_get_main_queue(), ^(void)
                   {
                       if (response.error !=nil)
                       {
                           [self showErrorView];
                           [self showAlertView:@"请检查网络"];
                           return;
                       }
                       [self hideLoadingView];
                      
                    dataList = [dicPrefer objectForKey:@"result"];
                    for(int j=0;j<[dataList count];j++)
                    {
                       NSDictionary *dic= [dataList objectAtIndex:j];
                       NSString *title = [dic objectForKey:@"title"];
                       NSArray *titleArray = [title componentsSeparatedByString:@"_"];
                       NSString *titleId =[titleArray objectAtIndex:0];
                       NSArray *answers = [dic objectForKey:@"answers"];
                       for(int i=0;i<[answers count];i++)
                       {
                           NSString *answer= [answers objectAtIndex:i];
                           NSArray *answerArray = [answer componentsSeparatedByString:@"_"];
                           NSString *answerId =[answerArray objectAtIndex:0];
                          
                            if([answerArray count]>2)
                           {
                               NSString *answerCheck =[answerArray objectAtIndex:2];
                               if([answerCheck isEqual:@"1"])
                               {
                                   if(![PreferCheckList containsObject: [answerId stringByAppendingString:[NSString stringWithFormat:@"%@%@",@"_",titleId]]])
                                   {
                                       [PreferCheckList addObject: [answerId stringByAppendingString:[NSString stringWithFormat:@"%@%@",@"_",titleId]]];
                                   }
                                   
                               }
                               
                           }
                       }
                    }
                }
    );
    
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
//标签数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

// 设置section的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
   
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  
        return [dataList count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = indexPath.row;
    NSDictionary *dic= [dataList objectAtIndex:row];
    NSArray *answers = [dic objectForKey:@"answers"];
    
    return [answers count]*42+45;//设置每个cell高度
}
//创建并设置每行显示的内容
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
    NSDictionary *dic= [dataList objectAtIndex:row];
    NSString *title = [dic objectForKey:@"title"];
    NSArray *titleArray = [title componentsSeparatedByString:@"_"];
    NSString *titleId =[titleArray objectAtIndex:0];
    NSString *titleName =[titleArray objectAtIndex:1];
    UILabel *cellTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(5,5, self.view.frame.size.width-10, 30)];
    cellTitleLabel.text=titleName;
    cellTitleLabel.font = [UIFont systemFontOfSize:15];
    [cell.contentView addSubview: cellTitleLabel];
    NSArray *answers = [dic objectForKey:@"answers"];
    for(int i=0;i<[answers count];i++)
    {
        NSString *answer= [answers objectAtIndex:i];
        NSArray *answerArray = [answer componentsSeparatedByString:@"_"];
        NSString *answerId =[answerArray objectAtIndex:0];
        NSString *answerName =[answerArray objectAtIndex:1];
        SSCheckBoxView *cbanswer = [[SSCheckBoxView alloc] initWithFrame:CGRectMake(10, 40+(40*i), self.view.frame.size.width-10, 30) style:3 checked:NO];
        
   
        [cbanswer setText:answerName];
        cbanswer.textLabel.font = [UIFont systemFontOfSize:15];
         if([PreferCheckList containsObject: [answerId stringByAppendingString:[NSString stringWithFormat:@"%@%@",@"_",titleId]]])
             cbanswer.checked=YES;
        [cbanswer setStateChangedBlock:^(SSCheckBoxView *cbv) {
            NSLog(@"复选框状态: %@",cbv.checked ? @"选中" : @"没选中");
            if(cbv.checked)
            {
                
                if(![PreferCheckList containsObject: [answerId stringByAppendingString:[NSString stringWithFormat:@"%@%@",@"_",titleId]]])
                {
                    [PreferCheckList addObject: [answerId stringByAppendingString:[NSString stringWithFormat:@"%@%@",@"_",titleId]]];
                }
            }
            else
            {
                if([PreferCheckList containsObject: [answerId stringByAppendingString:[NSString stringWithFormat:@"%@%@",@"_",titleId]]])
                {
                    [PreferCheckList removeObject: [answerId stringByAppendingString:[NSString stringWithFormat:@"%@%@",@"_",titleId]]];
                }
            }
            
        }];
                [cell.contentView addSubview: cbanswer];
    }
    
    cell.accessoryType = UITableViewCellAccessoryNone;
   
    cell.selectionStyle = UITableViewCellSelectionStyleNone;//隐藏选中效果
  

    return cell;
}
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
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    // When the user presses return, take focus away from the text field so that the keyboard is dismissed.
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    CGRect rect = CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height);
    self.view.frame = rect;
    [UIView commitAnimations];
    [textField resignFirstResponder];
    return YES; 
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
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
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGRect frame = textField.frame;
    int offset = frame.origin.y +112+92 - (self.view.frame.size.height - 216.0);//键盘高度216
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
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    
    
    CGRect frame = textView.superview.frame;
    
    int offset = frame.origin.y +112+ 92 - (self.view.frame.size.height - 216.0);//键盘高度216
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
    //textView.text=@"";
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
    
    [TRemark resignFirstResponder];
    [TName resignFirstResponder];
    [TTel resignFirstResponder];
    [TPrefer resignFirstResponder];
    [ddSource.tField resignFirstResponder];
    [ddLevel.tField resignFirstResponder];
    [ddCity.tField resignFirstResponder];
    [TFollowType.tField resignFirstResponder];
    [TFollowRemark resignFirstResponder];
    [TIC resignFirstResponder];
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
    [self.TRemark resignFirstResponder];
    [TName resignFirstResponder];
    [TTel resignFirstResponder];
    [TPrefer resignFirstResponder];
    [ddSource.tField resignFirstResponder];
    [ddLevel.tField resignFirstResponder];
    [ddCity.tField resignFirstResponder];
    [TFollowType.tField resignFirstResponder];
    [TIC resignFirstResponder];
    [self.TFollowRemark resignFirstResponder];
    
    
}


-(void)checkBoxViewChangedState:(SSCheckBoxView*)cbv
{
    NSLog(@"复选框状态: %@",cbv.checked ? @"选中" : @"没选中");
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)returnBtnClick:(UIButton *)sender
{
    
    [self dismissModalViewControllerAnimated:YES];//presentModalViewController:svc animated:YES
    
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
