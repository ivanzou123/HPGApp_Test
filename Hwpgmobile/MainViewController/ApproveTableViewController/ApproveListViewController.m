//
//  ApproveListViewController.m
//  Chat
//
//  Created by hwpl hwpl on 14-11-6.
//  Copyright (c) 2014年 hwpl hwpl. All rights reserved.
//

#import "ApproveListViewController.h"
#import "ApproveFunctionViewController.h"
#import "ResponseModel.h"
#import "ApproveServiceUtil.h"
#import "JSON.h"
#import "CommUtilHelper.h"

@interface ApproveListViewController ()
{
    UILabel *noDataLable;
    NSMutableDictionary *resultDic;
    UISearchBar *searhBar;
    UISearchController *searchCon;
    NSString *aprTitle;
}

@end

@implementation ApproveListViewController
@synthesize tempArr;
@synthesize approveTableView;
@synthesize refreshAprId;
@synthesize sysCode;

//////////

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    //self.navigationItem.title = @"E-LEAVE";
    approveTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, navBarHeight+1, screenWidth, screenHeight)];
    approveTableView.delegate = self;
    approveTableView.dataSource = self;
    [approveTableView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:approveTableView];
    [self setExtraCellLineHidden:approveTableView];
    
    searhBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 50)];
    
    searhBar.showsCancelButton = NO;
    searchCon=[[UISearchController alloc] initWithSearchResultsController:self];
    approveTableView.tableHeaderView=searhBar;
    
    searhBar.delegate = self;
    
}
-(void)viewWillAppear:(BOOL)animated
{
    //审批或者拒绝后的回调显示
    if (refreshAprId) {
        for (int i=0; i<[tempArr  count]; i++) {
            NSIndexPath *p = [NSIndexPath indexPathForRow:i inSection:0];
           
            UITableViewCell *cell =[approveTableView  cellForRowAtIndexPath:p];
            if (cell.tag == [refreshAprId intValue]) {
                [tempArr removeObjectAtIndex:p.row];
                 NSArray *arr = [[NSArray alloc] initWithObjects:p, nil];
                [approveTableView deleteRowsAtIndexPaths:arr withRowAnimation:UITableViewRowAnimationAutomatic];
            }
        }
        
    }
    [self startGetApproveData:aprTitle];
    [self searchBarCancelButtonClicked:searhBar];
}

-(void)startGetApproveData:(NSString *)aprTtile
{
    [self showLoadingView];
    [NSThread detachNewThreadSelector:@selector(getApproveData:) toTarget:self withObject:aprTtile];
}

-(void)getApproveData:(NSString *)aprTtile
{
    @try {
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:[[CommUtilHelper sharedInstance] getUser],@"userName",@"L",@"listType",sysCode,@"SysCode",aprTtile,@"aprTitle" ,nil];
        ResponseModel *response = [ApproveServiceUtil getAppInfoMsg:@"getAppList" Data:dic];
        //isLoadingNext = NO;
        NSDictionary *resultArrDic = response.resultInfo;
        dispatch_async(dispatch_get_main_queue(), ^(void){
            if (response.error) {
                [self showErrorView];
                [self showAlertView:@"Can not connect Server"];
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
                if (dataList) {
                    tempArr = dataList;
                    
                }
                
            }else
            {
                tempArr=[NSMutableArray array];
                noDataLable = [[UILabel alloc] initWithFrame:CGRectMake(screenWidth/2-40, screenHeight/2-25, 80, 50)];
                [noDataLable setText:@"No Data"];
                [noDataLable setTextAlignment:NSTextAlignmentCenter];
                [self.view setBackgroundColor:[UIColor grayColor]];
                [noDataLable setFont:[UIFont systemFontOfSize:18]];
                [self .view addSubview:noDataLable];
            }
            [approveTableView reloadData];
        });
    }
    @catch (NSException *exception) {
        NSLog(@"getApproveData error:%@",exception);
    }
    @finally {
    }
}
-(void)showAlertView:(NSString *)msg
{
    UIAlertView *msgView = [[UIAlertView alloc] initWithTitle:msg message:msg delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [msgView show];
}

#pragma tapview delegate
-(void)errorViewTapGesture:(UITapGestureRecognizer *)tapGesture
{
    [super errorViewTapGesture:tapGesture];
    [NSThread detachNewThreadSelector:@selector(getApproveData:) toTarget:self withObject:nil];
}
#pragma tableview delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell =[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    NSDictionary *data = [tempArr objectAtIndex:indexPath.row];
    [cell.textLabel setFont:[UIFont systemFontOfSize:13]];
    NSString *title = [[data objectForKey:@"APR_TITLE"] stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@""] ;
    cell.textLabel.text = title;
    cell.detailTextLabel.text = [data objectForKey:@"APR_SUBMISSION_BY"];
    UILabel *accessView = [[UILabel alloc] initWithFrame:CGRectMake(cell.frame.size.width-80, -2,  80,25)];
    [accessView setText:[data objectForKey:@"APR_SUBMISSION_DATE"]];
    [accessView setFont:[UIFont systemFontOfSize:11]];
    cell.tag = [[data objectForKey:@"APRID"] intValue];
    [cell.contentView  addSubview: accessView];
    if ([title length]>0) {
        NSString *firstChar = [[title substringToIndex:1] lowercaseString];
        
        UIImage *img = [UIImage imageNamed:[[@"circular_" stringByAppendingString:firstChar] stringByAppendingString:@".png"]];
        if (img) {
            cell.imageView.image = img;
        }else
        {
         cell.imageView.image = [UIImage imageNamed:@"ico-a.png"];
        }
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
     UITableViewCell *cell = [tableView  cellForRowAtIndexPath:indexPath];
    
     ApproveFunctionViewController *v = [[ApproveFunctionViewController alloc] init];
     v.aprID = cell.tag;
     v.sysCode=sysCode;
     [self.navigationController pushViewController:v animated:YES];
     [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (void)setExtraCellLineHidden: (UITableView *)tableView{
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
    [tableView setTableHeaderView:view];
    
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
     [searhBar resignFirstResponder];
      NSString *searchText = searhBar.text;
     aprTitle = searchText;
     searhBar.showsCancelButton=NO;
     [self startGetApproveData:searchText];
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [searhBar resignFirstResponder];
    searhBar.showsCancelButton=NO;
}
-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
   searhBar.showsCancelButton=YES;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self searchBarCancelButtonClicked:searhBar];
    [searhBar resignFirstResponder];
    
     searhBar.showsCancelButton=NO;
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
 
    [searchBar resignFirstResponder];
    searchBar.showsCancelButton=NO;
}
-(void)dealloc
{
    [searhBar resignFirstResponder];
    searhBar = nil;
    
}
@end
