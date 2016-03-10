//
//  WorkViewController.m
//  HwpgMobile
//
//  Created by hwpl hwpl on 14-12-1.
//  Copyright (c) 2014年 hwpl hwpl. All rights reserved.
//

#import "WorkViewController.h"
#import "CommUtilHelper.h"
#import "CrmRootViewController.h"
#import "TestViewController.h"
#import "WorkWebViewController.h"
#import "CharViewNetServiceUtil.h"
#import "ResponseModel.h"
#import "WorkViewController.m"
#import "WorkWebViewController.h"
#import "FormatTime.h"
#import "ApproveServiceUtil.h"
#import "eChatDAO.h"
#import "NavWebViewController.h"
@implementation CustWorkViewCell
@synthesize custImageView;
@synthesize textLabel;

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self==[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        custImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 40, 40)];
        [self.contentView addSubview:custImageView];
        textLabel = [[UILabel alloc] initWithFrame:CGRectMake(58, 0, 250,60)];
        [textLabel setFont:[UIFont systemFontOfSize:14]];
        [textLabel setTextColor:kGetColorAl(0, 0, 0, 0.87)];
        [textLabel setTextAlignment:NSTextAlignmentLeft];
        [self.contentView addSubview:textLabel];
    }
    return self;
}

@end


@interface WorkViewController ()
{
    NSMutableArray *dataArr;
    UIView *bscrollView;
    UIView *scrollView;
    //UITableView *tableView;
    BOOL controlView;
    NSMutableArray *msipArr;
    int index;
    int totalCount;
    UIActivityIndicatorView *loadingView;
    BOOL isConinue;
    UILabel *lblMsipDate;
    UIButton *lblDetail;
    custLable *lblUnits;
    custLable *lblSalesValue;
    custLable *lblSoldValue;
    custLable *lblSoldUnits;
    custLable *lblChangeValue;
    custLable *lblChangeUnits;
    custLable *lblWithdrewValue;
    custLable *lblwithdrewUnits;
    NSDictionary *userDic;
    UIView *headView;
    //
    BOOL isOldMenu;
}
@end

@implementation custLable

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}
-(void) drawTextInRect:(CGRect)rect {
    return [super drawTextInRect:UIEdgeInsetsInsetRect(rect,UIEdgeInsetsMake(0, 5, 0, 5))];
}

@end

@implementation WorkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:kGetColor(245, 245, 245)];
    self.navigationItem.title = @"Work";
    //[self.navigationController.navigationBar setTintColor:[UIColor blueColor]];
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;
    self.navigationController.navigationBar.barTintColor=kGetColor(248, 248, 248);
    self.navigationController.navigationBar.tintColor = kGetColor(4, 118, 246);
    ///self.loadMoreRefreshed = NO;
   /// self.hasStatusLabelShowed = NO;
    NSMutableArray *userInfo =[[eChatDAO sharedChatDao] getUserInfo:[[CommUtilHelper sharedInstance] getUser]];
    if (userInfo && [userInfo count]>0) {
        userDic = [userInfo objectAtIndex:0];
    }
    headView  = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 125)];
    loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [loadingView setFrame:CGRectMake(screenWidth/2-10, screenWidth/2, 20, 20)];
    [self.view addSubview:loadingView];
    [self initUnApproveNum];
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"reload@3x.png"] style:UIBarButtonItemStyleDone target:self action:@selector(loadData)];
    self.navigationItem.rightBarButtonItem = rightButton;
}



-(instancetype)init
{
    if (self == [super init]) {
        self.imageCache = [[NSCache alloc] init];
        
        //self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0, screenWidth,screenHeight-self.tabBarController.tabBar.frame.size.height)];
        //[self.view addSubview:self.tableView];
        //self.tableView.delegate = self;
        //self.tableView.dataSource = self;
        [[CommUtilHelper sharedInstance] setExtraCellLineHidden:self.tableView type:@""];
        
        [self loadData];
    }
    return self;
}

-(void)viewDidDisappear:(BOOL)animated
{
    [self initUnApproveNum];
}
//-(void)beginPullDownRefreshing
//{
//    [self loadData];
//}
-(void)loadMsipData
{
    
}
-(void)addLoadingView
{
    [loadingView startAnimating];
    [loadingView bringSubviewToFront:self.view];
}
-(void)loadData
{
    @try {
        [NSThread detachNewThreadSelector:@selector(addLoadingView) toTarget:self withObject:nil];
        NSUserDefaults *workDefault = [NSUserDefaults standardUserDefaults];
        self.tableView.tableHeaderView=nil;
        //先显示旧菜单数据
        NSMutableArray *menuList =(NSMutableArray *)[workDefault objectForKey:@"workMainPageInfo"];
        dataArr = menuList;
        BOOL isExistMsip=false;
        if(menuList!=nil){
            isOldMenu = true;
            for (int i=0; i<[menuList count]; i++) {
                if ([@"MSIP" isEqualToString: [[menuList objectAtIndex:i] objectForKey:@"SYS_NAME"]]) {
                    isExistMsip = true;
                }
            }
            if (isExistMsip) {
                self.tableView.tableHeaderView=headView;
            }
            [loadingView stopAnimating];
        }
        if(isExistMsip){
            NSMutableArray *msipdefaultData = [workDefault objectForKey:@"tempMsipDataArr"];
            [self setMsipValue:msipdefaultData];
        }
        [self.tableView reloadData];
        //取最新菜单数据
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
            
            ResponseModel *rs=  [CharViewNetServiceUtil getMenu:[[CommUtilHelper sharedInstance] getUser] deviceId:[CommUtilHelper getDeviceId]];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [loadingView stopAnimating];
                //[self endPullDownRefreshing];
                NSDictionary *dic = rs.resultInfo;
                NSDictionary *headInfo = [dic objectForKey:@"HeadInfo"];
                NSString *result = [headInfo objectForKey:@"RESULT"];
                BOOL isExistMsip = false;
                if ([@"1" isEqualToString:result]) {
                    isOldMenu = false;
                    NSMutableArray *dataList = [dic objectForKey:@"DataList"];
                    NSMutableArray *tempDataList = [[NSMutableArray alloc] init];
                    for (int i=0; i<[dataList count]; i++) {
                        if ([@"MSIP" isEqualToString: [[dataList objectAtIndex:i] objectForKey:@"SYS_NAME"]]) {
                            isExistMsip=true;
                            [workDefault setObject:[[dataList objectAtIndex:i] objectForKey:@"SYS_MENUURL"] forKey:@"sysMsipDetailUrl"];
                            [tempDataList addObject:[dataList objectAtIndex:i]];
                        }else if([@"EHR" isEqualToString:[[dataList objectAtIndex:i] objectForKey:@"SYS_CODE"]] )
                        {
                            //[NSThread detachNewThreadSelector:@selector(getEHRNum) toTarget:self withObject:nil];
                            //[tempDataList addObject:[dataList objectAtIndex:i]];
                        }
                        else
                        {
                            [tempDataList addObject:[dataList objectAtIndex:i]];
                        }
                    }
                    if (isExistMsip) {
                        self.tableView.tableHeaderView = headView;
                    }
                    [workDefault setObject:tempDataList forKey:@"workMainPageInfo"];
                    dataArr = tempDataList;
                    [self.tableView reloadData];
                }
            });
        });
        //取MSIP数据
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
            [loadingView startAnimating];
            ResponseModel *rs=  [CharViewNetServiceUtil getMsipData:[[CommUtilHelper sharedInstance] getUser] deviceId:[CommUtilHelper getDeviceId]];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [loadingView stopAnimating];
               // [self endPullDownRefreshing];
                NSDictionary *dic = rs.resultInfo;
                NSMutableArray *inf = [dic objectForKey:@"inf"];
                NSMutableArray *tempArr = [NSMutableArray array];
                BOOL infIsNuLL = [inf isKindOfClass:[NSNull class]];
                if (!infIsNuLL && [inf count] >0) {
                    for (int j=0; j<[inf count]; j++) {
                        NSDictionary *msipDic = [inf objectAtIndex:j];
                        
                        [tempArr addObject:[NSDictionary dictionaryWithObjectsAndKeys:[msipDic objectForKey:@"transaction_date"],@"transaction_date",[msipDic objectForKey:@"sales_amount"],@"sales_amount",[msipDic objectForKey:@"sales_count"], @"sales_count",[msipDic objectForKey:@"change_amount"],@"change_amount",[msipDic objectForKey:@"withdraw_amount"],@"withdraw_amount",[msipDic objectForKey:@"change_count"],@"change_count",[msipDic objectForKey:@"withdraw_count"],@"withdraw_count",nil]];
                    }
                    [workDefault setObject:tempArr forKey:@"tempMsipDataArr"];
                    
                }
                [self setMsipValue:tempArr];
            });
        });
    }
    @catch (NSException *exception) {
        NSLog(@"WorkViewController loadData error:%@",exception);
    }
    @finally {
    }
}
//
-(void)getEHRNum
{
   ResponseModel *rs=  [CharViewNetServiceUtil getEhrNum:[[CommUtilHelper sharedInstance] getUser]];
    dispatch_async(dispatch_get_main_queue(), ^(void){
       NSDictionary *dic = rs.resultInfo;
        if (dic) {
            NSDictionary *rsDic = [dic objectForKey:@"RESULT"];
            if (rsDic && [rsDic isKindOfClass:[NSDictionary class]]) {
                NSString *number = [rsDic objectForKey:@"pendingNum"];
                for (int i=0; i<[dataArr count]; i++) {
                    NSDictionary *dataDic = [dataArr objectAtIndex:i];
                    NSString *code = [dataDic objectForKey:@"SYS_CODE"];
                    if ([@"EHR" isEqualToString:code] || [@"PRC_EHR" isEqualToString:code]) {
                        NSMutableDictionary  *muDic = [NSMutableDictionary dictionaryWithDictionary:dataDic];
                        [muDic  setValue:number forKey:@"Other"];
                        [dataArr removeObjectAtIndex:i];
                        [dataArr insertObject:muDic atIndex:i];
                    }
                }
            }
        }
        [self.tableView reloadData];
    });
    
}



-(void)setMsipValue:(NSMutableArray *)varr
{
    
    //msipArr = inf;
    //[self.tableView.tableHeaderView reloadInputViews];
    NSArray *headViewArr = [self.tableView.tableHeaderView subviews];
    for (int i=0; i<[headViewArr count]; i++) {
        UIView *view = [headViewArr objectAtIndex:i];
        [view removeFromSuperview];
    }
    double salesAmount = 0 ;
    int salesUnits = 0;
    double changeAmount = 0;
    double withdrawAmount = 0;
    int unitsChange=0;
    int unitsWithDraw = 0;
    NSString *transacationDate;
    for (int j=0; j<[varr count]; j++) {
        NSDictionary *msipDic = [varr objectAtIndex:j];
        transacationDate = [msipDic objectForKey:@"transaction_date"];
        double saleAmount = [[msipDic objectForKey:@"sales_amount"] doubleValue];
        int saleUnit = [[msipDic objectForKey:@"sales_count"] intValue];
        changeAmount += [[msipDic objectForKey:@"change_amount"] doubleValue];
        withdrawAmount += [[msipDic objectForKey:@"withdraw_amount"] doubleValue];
        unitsChange += [[msipDic objectForKey:@"change_count"] intValue];
        unitsWithDraw += [[msipDic objectForKey:@"withdraw_count"] intValue];
        salesAmount +=saleAmount;
        salesUnits +=saleUnit;
    }
    
    
    UILabel *prcLable = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 100, 25)];
    [prcLable setFont:[UIFont systemFontOfSize:13]];
    [prcLable setText:@"PRC Sales on"];
    [headView addSubview:prcLable];
    
    lblMsipDate = [[UILabel alloc] initWithFrame:CGRectMake(110, 5, 120, 25)];
    
    [lblMsipDate setFont:[UIFont systemFontOfSize:14]];
    [headView addSubview:lblMsipDate];
    
    if (!transacationDate) {
        [lblMsipDate setText:[FormatTime dateToStr:[NSDate date] Format:@"yyyy-MM-dd"]];
    }else
    {
        lblMsipDate.text = transacationDate;
    }
    
    UIColor *gridColor = kGetColor(221, 221, 221);
    CGFloat gridHeight = 100;
    
    lblDetail = [[UIButton alloc] initWithFrame:CGRectMake(screenWidth-100, 5, 100, 20)];
    [lblDetail setTitle:@"Detail" forState:UIControlStateNormal];
    [lblDetail setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [lblDetail addTarget:self action:@selector(gotoMsipDetail) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *lineviewtop =[[UIView alloc] initWithFrame:CGRectMake(10, 30, screenWidth-20, 1)];
    [lineviewtop setBackgroundColor:gridColor];
    
    [headView addSubview:lineviewtop];
    
    [headView addSubview:lblDetail];
    
    
   
    
    UIView *gridView = [[UIView alloc] initWithFrame:CGRectMake(10, 35, screenWidth-20, gridHeight)];
    gridView.layer.borderWidth=1;
    [gridView.layer setCornerRadius:3];
    gridView.layer.borderColor=gridColor.CGColor;
    
    UIView *lineview1 =[[UIView alloc] initWithFrame:CGRectMake(0, 30, screenWidth-20, 1)];
    [lineview1 setBackgroundColor:gridColor];
    
    
    UIView *lineview2 =[[UIView alloc] initWithFrame:CGRectMake(0, 65, screenWidth-20, 1)];
    [lineview2 setBackgroundColor:gridColor];
    
    CGFloat width = ((screenWidth-20)-80)/4;
    
    UIView *tlineview1 =[[UIView alloc] initWithFrame:CGRectMake(80, 0, 1, gridHeight)];
    [tlineview1 setBackgroundColor:gridColor];
    
    UIView *tlineview2 =[[UIView alloc] initWithFrame:CGRectMake(80+width, 0, 1, gridHeight)];
    [tlineview2 setBackgroundColor:gridColor];
    
    UIView *tlineview3 =[[UIView alloc] initWithFrame:CGRectMake(80+width*2, 0, 1, gridHeight)];
    [tlineview3 setBackgroundColor:gridColor];
    
    UIView *tlineview4 =[[UIView alloc] initWithFrame:CGRectMake(80+width*3, 0, 1.5, gridHeight)];
    [tlineview4 setBackgroundColor:kGetColor(146, 123, 123)];
    
    
    
    
    
    UILabel *soldLable = [[UILabel alloc] initWithFrame:CGRectMake(80, 0,width, 30)];
    [soldLable setText:@"Sold"];
    [soldLable setTextAlignment:NSTextAlignmentCenter];
    [soldLable setFont:[UIFont systemFontOfSize:11]];
    
    
    UILabel *changeLable = [[UILabel alloc] initWithFrame:CGRectMake(80+width, 0,width, 30)];
    [changeLable setText:@"Change"];
    [changeLable setFont:[UIFont systemFontOfSize:11]];
    [changeLable setTextAlignment:NSTextAlignmentCenter];
    
    UILabel *withdrewLable = [[UILabel alloc] initWithFrame:CGRectMake(80+width*2, 0,width, 30)];
    [withdrewLable setText:@"Withdrew"];
    [withdrewLable setFont:[UIFont systemFontOfSize:11]];
    [withdrewLable setTextAlignment:NSTextAlignmentCenter];
    
    UILabel *totalLable = [[UILabel alloc] initWithFrame:CGRectMake(80+width*3, 0,width, 30)];
    [totalLable setText:@"Total"];
    [totalLable setFont:[UIFont systemFontOfSize:11]];
    [totalLable setTextAlignment:NSTextAlignmentCenter];
    
    [totalLable setBackgroundColor:kGetColor(255, 244, 238)];
    
    [gridView addSubview:soldLable];
    [gridView addSubview:changeLable];
    [gridView addSubview:withdrewLable];
    [gridView addSubview:totalLable];
    
    
    UILabel *unitsLable = [[custLable alloc] initWithFrame:CGRectMake(0,30,80,35)];
    [unitsLable setText:@"Units"];
    [unitsLable setTextAlignment:NSTextAlignmentRight];
    [unitsLable setBackgroundColor:[UIColor whiteColor]];
    [unitsLable setFont:[UIFont systemFontOfSize:10]];
    [gridView addSubview:unitsLable];
    
    UILabel *salesLable = [[custLable alloc] initWithFrame:CGRectMake(0, 65,80,35)];
    [salesLable setText:@"Sales Value(¥)"];
    [salesLable setTextAlignment:NSTextAlignmentRight];
    [salesLable setFont:[UIFont systemFontOfSize:10]];
    [salesLable setBackgroundColor:[UIColor whiteColor]];
    [gridView addSubview:salesLable];
    
    
    
    lblSoldUnits = [[custLable alloc] initWithFrame:CGRectMake(80, 30, width, 35)];
    [lblSoldUnits setFont:[UIFont systemFontOfSize:10]];
    [lblSoldUnits setTextAlignment:NSTextAlignmentRight];
    [lblSoldUnits setBackgroundColor:[UIColor whiteColor]];
    [gridView addSubview:lblSoldUnits];
    //
    lblSoldValue = [[custLable alloc] initWithFrame:CGRectMake(80, 65, width, 35)];
    [lblSoldValue setFont:[UIFont systemFontOfSize:10]];
    [lblSoldValue setTextAlignment:NSTextAlignmentRight];
    [lblSoldValue setBackgroundColor:[UIColor whiteColor]];
    [gridView addSubview:lblSoldValue];
    //
    lblSoldUnits.text =[NSString stringWithFormat:@"%i ",salesUnits];
    lblSoldValue.text =[NSString stringWithFormat:@"%.2fM ",salesAmount];
    
    


    lblChangeUnits = [[custLable alloc] initWithFrame:CGRectMake(80+width, 30, width, 35)];
    [lblChangeUnits setFont:[UIFont systemFontOfSize:10]];
    [lblChangeUnits setText:@"0 "];
    [lblChangeUnits setBackgroundColor:[UIColor whiteColor]];
    [lblChangeUnits setTextAlignment:NSTextAlignmentRight];
    [gridView addSubview:lblChangeUnits];
    
    lblChangeValue = [[custLable alloc] initWithFrame:CGRectMake(80+width, 65, width, 35)];
    [lblChangeValue setFont:[UIFont systemFontOfSize:10]];
    [lblChangeValue setText:@"0M "];
    [lblChangeValue setTextAlignment:NSTextAlignmentRight];
    [gridView addSubview:lblChangeValue];
    [lblChangeValue setBackgroundColor:[UIColor whiteColor]];
    lblChangeUnits.text =[NSString stringWithFormat:@"%i ",unitsChange];
    lblChangeValue.text =[NSString stringWithFormat:@"%.2fM ",changeAmount];
    
    
    lblwithdrewUnits = [[custLable alloc] initWithFrame:CGRectMake(80+width*2, 30, width, 35)];
    [lblwithdrewUnits setFont:[UIFont systemFontOfSize:10]];
    [lblwithdrewUnits setText:@"0 "];
    [lblwithdrewUnits setTextAlignment:NSTextAlignmentRight];
    [lblwithdrewUnits setBackgroundColor:[UIColor whiteColor]];
    [gridView addSubview:lblwithdrewUnits];
    //
    lblWithdrewValue = [[custLable alloc] initWithFrame:CGRectMake(80+width*2, 65, width, 35)];
    [lblWithdrewValue setFont:[UIFont systemFontOfSize:10]];
    [lblWithdrewValue setText:@"0M "];
     [lblWithdrewValue setTextAlignment:NSTextAlignmentRight];
    [lblWithdrewValue setBackgroundColor:[UIColor whiteColor]];
    [gridView addSubview:lblWithdrewValue];
    //
    lblwithdrewUnits.text =[NSString stringWithFormat:@"%i",unitsWithDraw];
    lblWithdrewValue.text =[NSString stringWithFormat:@"%.2fM ",withdrawAmount];
    
    
    
    lblUnits = [[custLable alloc] initWithFrame:CGRectMake(80+width*3, 30, width, 35)];
    [lblUnits setFont:[UIFont systemFontOfSize:11]];
    [lblUnits setBackgroundColor:kGetColor(255, 244, 238)];
    [lblUnits setTextColor:kGetColor(146, 123, 123)];
    [lblUnits setTextAlignment:NSTextAlignmentRight];
    [lblUnits setText:@"0"];
    
    [gridView addSubview:lblUnits];
        lblSalesValue = [[custLable alloc] initWithFrame:CGRectMake(80+width*3, 65, width, 35)];
        [lblSalesValue setFont:[UIFont systemFontOfSize:11]];
        [lblSalesValue setText:@"0M"];
        [lblSalesValue setTextColor:kGetColor(146, 123, 123)];
        [lblSalesValue setTextAlignment:NSTextAlignmentRight];
        [lblSalesValue setBackgroundColor:kGetColor(255, 244, 238)];
        lblUnits.text = [NSString stringWithFormat:@"%i",(salesUnits-unitsWithDraw)];
        lblSalesValue.text = [NSString stringWithFormat:@"%.2fM",(salesAmount+changeAmount-withdrawAmount)];
[gridView addSubview:lblSalesValue];

    
    [gridView addSubview:lineview1];
    [gridView addSubview:lineview2];
    
    [gridView addSubview:tlineview1];
    [gridView addSubview:tlineview2];
    [gridView addSubview:tlineview3];
    [gridView addSubview:tlineview4];
    
//    //
//    UILabel *prcLable = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 100, 25)];
//    [prcLable setFont:[UIFont systemFontOfSize:14]];
//    [prcLable setText:@"PRC Sales on"];
//    [headView addSubview:prcLable];
//    float totalHeight = 0;
//    lblMsipDate = [[UILabel alloc] initWithFrame:CGRectMake(110, 5, 120, 25)];
//    
//    [lblMsipDate setFont:[UIFont systemFontOfSize:14]];
//    [headView addSubview:lblMsipDate];
//    
//    if (!transacationDate) {
//        [lblMsipDate setText:[FormatTime dateToStr:[NSDate date] Format:@"yyyy-MM-dd"]];
//    }else
//    {
//        lblMsipDate.text = transacationDate;
//    }
//    totalHeight +=25;
//    
//    lblDetail = [[UIButton alloc] initWithFrame:CGRectMake(screenWidth-100, 5, 100, 25)];
//    [lblDetail setTitle:@"Detail" forState:UIControlStateNormal];
//    [lblDetail setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
//    [lblDetail addTarget:self action:@selector(gotoMsipDetail) forControlEvents:UIControlEventTouchUpInside];
//    [headView addSubview:lblDetail];
//    
//    
//    UILabel *unitsLable = [[UILabel alloc] initWithFrame:CGRectMake(100, 30, 60, 20)];
//    [unitsLable setText:@"Units"];
//    [unitsLable setFont:[UIFont systemFontOfSize:12]];
//    [headView addSubview:unitsLable];
//    
//    UILabel *salesLable = [[UILabel alloc] initWithFrame:CGRectMake(screenWidth/2+40, 30,100, 20)];
//    [salesLable setText:@"Sales Value(¥)"];
//    [salesLable setFont:[UIFont systemFontOfSize:12]];
//    [headView addSubview:salesLable];
//    totalHeight+=25;
//    
//    
//    UILabel *totalLable = [[UILabel alloc] initWithFrame:CGRectMake(5, 55,60, 20)];
//    [totalLable setText:@"Total"];
//    [totalLable setFont:[UIFont boldSystemFontOfSize:14]];
//    
//    [headView addSubview:totalLable];
//    
//    
//    lblUnits = [[UILabel alloc] initWithFrame:CGRectMake(100, 55, 80, 20)];
//    [lblUnits setFont:[UIFont systemFontOfSize:14]];
//    
//    
//    [lblUnits setText:@"0"];
//    
//    [headView addSubview:lblUnits];
//    
//    lblSalesValue = [[UILabel alloc] initWithFrame:CGRectMake(screenWidth/2+40, 55, 100, 20)];
//    [lblSalesValue setFont:[UIFont systemFontOfSize:14]];
//    [lblSalesValue setText:@"0 M"];
//    [lblSalesValue setTextAlignment:NSTextAlignmentCenter];
//    [headView addSubview:lblSalesValue];
//    totalHeight +=25;
//    
//    if (salesAmount !=0 || salesUnits !=0) {
//        lblUnits.text = [NSString stringWithFormat:@"%i",(salesUnits-unitsWithDraw)];
//        lblSalesValue.text = [NSString stringWithFormat:@"%.2f M",(salesAmount+changeAmount-withdrawAmount)];
//    }
//    //sold
//    if (salesAmount !=0 || salesUnits !=0) {
//        UILabel *soldLable = [[UILabel alloc] initWithFrame:CGRectMake(5, 80,60, 20)];
//        [soldLable setText:@"Sold"];
//        [soldLable setFont:[UIFont systemFontOfSize:14]];
//        [headView addSubview:soldLable];
//        //
//        lblSoldUnits = [[UILabel alloc] initWithFrame:CGRectMake(100, 80, 80, 20)];
//        [lblSoldUnits setFont:[UIFont systemFontOfSize:14]];
//        [headView addSubview:lblSoldUnits];
//        //
//        lblSoldValue = [[UILabel alloc] initWithFrame:CGRectMake(screenWidth/2+40, 80, 100, 20)];
//        [lblSoldValue setFont:[UIFont systemFontOfSize:14]];
//        [lblSoldValue setTextAlignment:NSTextAlignmentCenter];
//        [headView addSubview:lblSoldValue];
//        //
//        lblSoldUnits.text =[NSString stringWithFormat:@"%i",salesUnits];
//        lblSoldValue.text =[NSString stringWithFormat:@"%.2f M",salesAmount];
//        //
//        totalHeight+=25;
//    }
//    //change
//    if (changeAmount !=0 || unitsChange !=0) {
//        UILabel *changeLable = [[UILabel alloc] initWithFrame:CGRectMake(5, 105,80, 20)];
//        [changeLable setText:@"Changed"];
//        [changeLable setFont:[UIFont systemFontOfSize:14]];
//        [headView addSubview:changeLable];
//        //
//        lblChangeUnits = [[UILabel alloc] initWithFrame:CGRectMake(100, 105, 80, 20)];
//        [lblChangeUnits setFont:[UIFont systemFontOfSize:14]];
//        [lblChangeUnits setText:@"0"];
//        [headView addSubview:lblChangeUnits];
//        //
//        lblChangeValue = [[UILabel alloc] initWithFrame:CGRectMake(screenWidth/2+40, 105, 100, 20)];
//        [lblChangeValue setFont:[UIFont systemFontOfSize:14]];
//        [lblChangeValue setText:@"0 M"];
//        [lblChangeValue setTextAlignment:NSTextAlignmentCenter];
//        [headView addSubview:lblChangeValue];
//        //
//        lblChangeUnits.text =[NSString stringWithFormat:@"%i",unitsChange];
//        lblChangeValue.text =[NSString stringWithFormat:@"%.2f M",changeAmount];
//        //
//        totalHeight+=25;
//    }
//    //withdraw
//    if (withdrawAmount !=0 || unitsWithDraw !=0) {
//        UILabel *withdrewLable = [[UILabel alloc] initWithFrame:CGRectMake(5, 125,80, 20)];
//        [withdrewLable setText:@"Withdrew"];
//        [withdrewLable setFont:[UIFont systemFontOfSize:14]];
//        [headView addSubview:withdrewLable];
//        //
//        lblwithdrewUnits = [[UILabel alloc] initWithFrame:CGRectMake(100, 125, 80, 20)];
//        [lblwithdrewUnits setFont:[UIFont systemFontOfSize:14]];
//        [lblwithdrewUnits setText:@"0"];
//        [headView addSubview:lblwithdrewUnits];
//        //
//        lblWithdrewValue = [[UILabel alloc] initWithFrame:CGRectMake(screenWidth/2+40, 125, 100, 20)];
//        [lblWithdrewValue setFont:[UIFont systemFontOfSize:14]];
//        [lblWithdrewValue setText:@"0 M"];
//        [lblWithdrewValue setTextAlignment:NSTextAlignmentCenter];
//        [headView addSubview:lblWithdrewValue];
//        //
//        lblwithdrewUnits.text =[NSString stringWithFormat:@"%i",unitsWithDraw];
//        lblWithdrewValue.text =[NSString stringWithFormat:@"%.2f M",withdrawAmount];
//        //
//        totalHeight+=25;
//    }
    [headView addSubview:gridView];
    [headView setFrame:CGRectMake(0, 0, screenWidth, 140)];
    //self.tableView.tableHeaderView=headView;
    //self.tableView.tableHeaderView = headView;
    
}

-(void)gotoMsipDetail
{
    NSUserDefaults *workDefault = [NSUserDefaults standardUserDefaults];
    NSString *sysName = @"MSIP";
    NSString *url=[workDefault objectForKey:@"sysMsipDetailUrl"];
    NSString *email = nil;
    NSString *staffCode = nil;
    if (userDic) {
        email = [userDic objectForKey:@"EMAIL"];
        staffCode = [userDic objectForKey:@"EMPLOYEE_NUMBER"];
    }
    if (url) {
        url= [NSString stringWithFormat:@"%@?userName=%@&deviceId=%@&email=%@&staffCode=%@",url, [[CommUtilHelper sharedInstance] getUser],[CommUtilHelper getDeviceId],email,staffCode];
         url= [url stringByReplacingOccurrencesOfString:@"<NULL>" withString:@""];
        WorkWebViewController *wwController = [[WorkWebViewController alloc] initWithUrl:url];
        [wwController reloadHtml];
        //
        wwController.title = sysName;
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:wwController animated:YES];
        self.hidesBottomBarWhenPushed = NO;
    }
    
}

//-(void)animationView
//{
//    if (isConinue) {
//        isConinue=NO;
//        scrollView.frame = CGRectMake(scrollView.frame.origin.x-20, scrollView.frame.origin.y, scrollView.frame.size.width, scrollView.frame.size.height);
//    }
//    float delay = 0.003;
//
//    if (controlView){
//        if (totalCount ==0) {
//            return;
//        }
//        CGRect frame = scrollView.frame;
//        if (frame.origin.x == 0) {
//            delay=3;
//            isConinue = YES;
//
//        }
//
//        frame.origin.x = frame.origin.x-20;
//        if (index ==0 ) {
//            [self changeMsipData];
//            index++;
//        }
//        if (frame.origin.x<-frame.size.width) {
//            frame.origin.x=screenWidth;
//
//            if (index == totalCount) {
//                index =0;
//            }
//            [self changeMsipData];
//            index++;
//
//        }
//        if (!isConinue) {
//             scrollView.frame = frame;
//        }
//
//        [self performSelector:@selector(animationView) withObject:nil afterDelay:delay];
//    }
//
//}





-(void)initUnApproveNum
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *data1 = [ApproveServiceUtil getUnApproveNum];
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!data1 || [@"" isEqualToString:data1]) {
                return ;
            }
            NSString *result = [self jsonToDic:data1];
            id result1 = [self jsonToDic:result];
            
            NSArray *obj =  [result1 objectForKey:@"inf"];
            if ([obj isKindOfClass:[NSNull class]]) {
                return;
            }
            if ([obj count ] >0) {
                NSDictionary *dic = [obj objectAtIndex:0];
                NSString *count = [dic objectForKey:@"num"];
                if ([@"0" isEqualToString:count] ||  [@"" isEqualToString:count]) {
                    self.tabBarItem.badgeValue= nil;
                }else
                {
                    self.tabBarItem.badgeValue = count;
                    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
                    [userDefault setObject:count forKey:@"workBageValue"];
                }
                
            }
        });
    });
    
    
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
-(void)viewWillAppear:(BOOL)animated
{
    controlView = YES;
    [super viewWillAppear:animated];
    [self.tabBarController.tabBar setHidden:NO];
    [self.navigationController setNavigationBarHidden:NO];
    
    self.navigationController.navigationBar.barTintColor=kGetColor(248, 248, 248);
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:@"0" forKey:@"workBageValue"];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    controlView=NO;
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dataArr count];
}
//
- (UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *MyIdentifier = @"customIdentifier";
    CustWorkViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil) {
        cell = [[CustWorkViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:MyIdentifier];
    }
    NSDictionary *result = [dataArr objectAtIndex:indexPath.row];
    NSString *name = [result objectForKey:@"SYS_NAME"];
    NSString *sysImageUrl = [result objectForKey:@"SYS_IMAGE"];
    NSString *newMessageCounter = [result objectForKey:@"Other"];
    cell.textLabel.text = name;
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSData *imageData = [userDefault objectForKey:[NSString stringWithFormat:@"workMenu%@", name]];
    if(imageData != nil){
        cell.custImageView.image = [UIImage imageWithData:imageData];
    }
    else{
        cell.custImageView.image = [UIImage imageNamed:@"test1"];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, (unsigned long) NULL), ^(void){
            UIImage *image = [self getPictureFromServer:sysImageUrl];
            if (image != nil){
                NSData *tmpImageData = UIImagePNGRepresentation(image);
                [userDefault setObject:tmpImageData forKey:[NSString stringWithFormat:@"workMenu%@", name]];
                 NSInteger a= indexPath.row;
                [self performSelectorOnMainThread:@selector(reloadTableViewDataAtIndexPath:) withObject:indexPath waitUntilDone:NO];
            }
            else{
                // do nothing ..
            }
        });
    }
    NSArray *lblArr = cell.textLabel.subviews;
    
    for (int i=0;i<[lblArr count] ; i++) {
        if ([[lblArr objectAtIndex:i] isKindOfClass:[UIImageView class]]) {
            UIImageView *imview = [lblArr objectAtIndex:i];
            [imview removeFromSuperview];
        }
    }
    //badge仅显示最新数据
    if(!isOldMenu && newMessageCounter &&  ![@"" isEqualToString: newMessageCounter] && ![@"0" isEqualToString:newMessageCounter]){
       // NSDictionary *attribute = @{NSFontAttributeName: cell.textLabel.font};
//        CGSize retSize = [cell.textLabel.text boundingRectWithSize:CGSizeMake(250, MAXFLOAT)
//                                                           options:\
//                          NSStringDrawingTruncatesLastVisibleLine |
//                          NSStringDrawingUsesLineFragmentOrigin |
//                          NSStringDrawingUsesFontLeading
//                                                        attributes:attribute
//                                                           context:nil].size;
        UIImageView *badge = nil;
        badge = [[UIImageView alloc] initWithFrame:CGRectMake(cell.custImageView.frame.size.width-4, -8, 15, 15)];
        [badge setAlpha:0.9];
        int reCounter = [newMessageCounter intValue];
        UILabel *numbLable = [[UILabel alloc] initWithFrame:CGRectMake(1, 1, 12, 12)];
        [numbLable setText:[NSString stringWithFormat:@"%@",@"1"]];
        [numbLable setTextAlignment:NSTextAlignmentCenter];
        [numbLable setTextColor:[UIColor  whiteColor]];
        if (reCounter<10) {
            [numbLable setFont:[UIFont systemFontOfSize:11]];
        }else if(reCounter >=10 && reCounter<=99)
        {
            [numbLable setFont:[UIFont systemFontOfSize:10]];
        }else
        {
            [numbLable setFont:[UIFont systemFontOfSize:9]];
        }
        
        [badge addSubview:numbLable];
        [badge.layer setCornerRadius:CGRectGetHeight([badge bounds])/2];
        badge.backgroundColor = [UIColor redColor];
        [cell.custImageView addSubview:badge];
    }
    return cell;
}



-(void)tableView:(UITableView *)_tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *infoDic = [dataArr objectAtIndex:indexPath.row];
    NSString *sysName = [infoDic objectForKey:@"SYS_NAME"];
    NSString *url = [infoDic objectForKey:@"SYS_MENUURL"];
    NSString *email = nil;
    NSString *staffCode = nil;
    if (userDic) {
        email = [userDic objectForKey:@"EMAIL"];
        
        staffCode = [userDic objectForKey:@"EMPLOYEE_NUMBER"];
    }
    url= [NSString stringWithFormat:@"%@?userName=%@&deviceId=%@&email=%@&staffCode=%@",url, [[CommUtilHelper sharedInstance] getUser],[CommUtilHelper getDeviceId],email,staffCode];
    url= [url stringByReplacingOccurrencesOfString:@"<NULL>" withString:@""];
    //
    
    if ([@"eCustomer" isEqualToString:sysName]){
        NavWebViewController *wwController = [[NavWebViewController alloc] initWithUrl:url];
        [wwController reloadHtml];
        //wwController.title = sysName;
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:wwController animated:YES];
        self.hidesBottomBarWhenPushed = NO;
    }else
    {
    WorkWebViewController *wwController = [[WorkWebViewController alloc] initWithUrl:url];
    [wwController reloadHtml];
    wwController.title = sysName;
       [self.navigationController setNavigationBarHidden:YES];
    //self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:wwController animated:YES];
    //self.hidesBottomBarWhenPushed = NO;
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
    //UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    //return cell.frame.size.height;
}
//
- (void) reloadTableViewDataAtIndexPath: (NSIndexPath *)indexPath{
    NSArray* indexArray = [NSArray arrayWithObjects:indexPath, nil];
    [self.tableView reloadRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationFade];
    
}
- (UIImage *) getPictureFromServer:(NSString *)URL{
    UIImage *image = nil;
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:URL]];
    [request setHTTPMethod:@"GET"];
    
    NSURLResponse *response;
    NSError *connectionError;
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&connectionError];
    
    if (connectionError == NULL) {
        NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
        NSLog(@"getPictureFromServer - Response Status code: %ld", (long)statusCode);
        
        if (statusCode == 200) {
            image = [UIImage imageWithData:returnData];
        }
        else{
            // do nothing..
        }
    }
    else{
        // do nothing..
    }
    
    return image;
}

@end
