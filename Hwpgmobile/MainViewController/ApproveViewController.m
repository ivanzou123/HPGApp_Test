//
//  ApproveViewController.m
//  Chat
//
//  Created by hwpl hwpl on 14-11-6.
//  Copyright (c) 2014年 hwpl hwpl. All rights reserved.
//
#define PI 3.14159265358979323846
#import "ApproveViewController.h"
#import "ApproveListViewController.h"
#import "ApproveServiceUtil.h"
#import "ResponseModel.h"
#import "EECSListViewController.h"
#import "JSON.h"
#import "CommUtilHelper.h"
#import "WorkWebViewController.h"
@interface ApproveViewController()
{
    UILabel *noDataLable;
    NSMutableDictionary *resultDic;
    bool isViewDidLoad;
}
@end

@implementation ApproveViewController

@synthesize tempArr;
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)viewDidLoad
{
    [super viewDidLoad];
    
    //self.navigationController.navigationBar.translucent=YES;
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationItem.title = @"Approval";
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [self setExtraCellLineHidden:self.tableView];
    [self startGetApproveData];
    self.hasStatusLabelShowed=YES;
    isViewDidLoad=true;
    self.dataSource = [NSMutableArray array];
    self.navigationController.navigationBar.barTintColor=[CommUtilHelper getDefaultBackgroupColor];    
}

-(void)startGetApproveData
{
    //[self showLoadingView];
    
    [NSThread detachNewThreadSelector:@selector(getApproveData) toTarget:self withObject:nil];
}

-(void)getApproveData
{
    @try {
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:[[CommUtilHelper sharedInstance] getUser],@"userName",@"S",@"listType",@"",@"sysCode", nil];
        ResponseModel *response = [ApproveServiceUtil getAppInfoMsg:@"getAppList" Data:dic];
        //isLoadingNext = NO;
        NSDictionary *resultArrDic = response.resultInfo;
        dispatch_async(dispatch_get_main_queue(), ^(void){
            
            if (response.error) {
                //[self showErrorView];
                [self endPullDownRefreshing];
                [self showAlertView:@"Can not Connnect Server"];
                return ;
            }
            NSString *result1 =[resultArrDic objectForKey:@"AppCommandResult"];
            resultDic =[result1 JSONValue];
            NSDictionary *headInfo = [resultDic objectForKey:@"HeadInfo"];
            NSString *count = [headInfo objectForKey:@"COUNCT"];
            //[self hideLoadingView];
            if ([count intValue] >0) {
                if (noDataLable) {
                    [noDataLable removeFromSuperview];
                }
                NSMutableArray *dataList = [resultDic objectForKey:@"DataList"];
                if (dataList) {
                    
                    tempArr = dataList;
                    //[self.dataSource addObjectsFromArray:tempArr];
                    //[self.dataSource addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"FlatSale", @"SYS_CODE", nil]];
                    [self.tableView reloadData];
                    
                }
                
            }else
            {
                noDataLable = [[UILabel alloc] initWithFrame:CGRectMake(screenWidth/2-40, screenHeight/2-25, 80, 50)];
                [noDataLable setText:@"No Data"];
                [noDataLable setTextAlignment:NSTextAlignmentCenter];
                [noDataLable setFont:[UIFont systemFontOfSize:16]];
                [self .view addSubview:noDataLable];
            }
            
            [self endPullDownRefreshing];
        });
    }
    @catch (NSException *exception) {
        NSLog(@"getApproveData error:%@",exception);
    }
    @finally {
    }

}

#pragma tapview delegate
-(void)errorViewTapGesture:(UITapGestureRecognizer *)tapGesture
{
    //[super errorViewTapGesture:tapGesture];
    [NSThread detachNewThreadSelector:@selector(getApproveData) toTarget:self withObject:nil];
}

-(void)showAlertView:(NSString *)msg
{
   //UIAlertView *alertView= [[UIAlertView alloc] initWithTitle:@"Prompt" message:msg delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    //[alertView show];
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell =[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    
    NSDictionary *data = [tempArr objectAtIndex:indexPath.row];
    NSString *sysCode = [data objectForKey:@"SYS_CODE"];
    cell.textLabel.text = [data objectForKey:@"APR_DESCRIPTION"];
    if ([sysCode isEqualToString:@"ELEAVE"]) {
        cell.imageView.image = [UIImage imageNamed:@"eleave_1.png"];
    }else if ([sysCode isEqualToString:@"EECS"])
    {
    cell.imageView.image = [UIImage imageNamed:@"eecs_1.png"];
    }else
    {
        
      cell.textLabel.text=@"FlatSale";
      cell.imageView.image = [UIImage imageNamed:@"flatsale@2x.png"];
    }
    
    return  cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [tempArr count];
}
-(void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

     NSDictionary *data = [tempArr objectAtIndex:indexPath.row];
     NSString *sysCode = [data objectForKey:@"SYS_CODE"];
    if ([sysCode isEqualToString:@"ELEAVE"]){
//        ApproveListViewController *v = [[ApproveListViewController alloc] init];
//         v.navigationItem.title = sysCode;
//         v.sysCode = sysCode;
        // EleaveViewController *v=[[EleaveViewController alloc] init];
        //[self.navigationController pushViewController:v animated:YES];
        
    }else if([sysCode isEqualToString:@"EECS"])
    {
        EECSListViewController *eeclListController = [[EECSListViewController alloc] init];
        eeclListController._sysCode=sysCode;
        eeclListController.navigationItem.title = sysCode;
        
        [self.navigationController pushViewController:eeclListController animated:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}
- (void)setExtraCellLineHidden: (UITableView *)tableView{
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
    [tableView setTableHeaderView:view];
    
}

-(void)viewWillAppear:(BOOL)animated
{
       [super viewWillAppear:animated];

}

#pragma  delegate refreshMehtod
-(void)beginPullDownRefreshing
{
    
    self.hasStatusLabelShowed=YES;
    [self startGetApproveData];
}

-(XHPullDownRefreshViewType)pullDownRefreshViewType
{
    return XHPullDownRefreshViewTypeActivityIndicator;
}

-(void)viewDidAppear:(BOOL)animated
{
    
    if (isViewDidLoad) {
        
        [super viewDidAppear:animated];
        self.hasStatusLabelShowed=YES;
        self.loadMoreRefreshed=NO;
        [self startPullDownRefreshing];
        isViewDidLoad=false;
    }
    
}

@end
