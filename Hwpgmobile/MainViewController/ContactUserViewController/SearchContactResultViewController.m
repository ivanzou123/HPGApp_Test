//
//  SearchContactResultViewController.m
//  HwpgMobile
//
//  Created by hwpl hwpl on 14-11-25.
//  Copyright (c) 2014年 hwpl hwpl. All rights reserved.
//

#import "SearchContactResultViewController.h"
#import "CommUtilHelper.h"
#import "UserContactInfoViewController.h"
#import "ResponseModel.h"
#import "ContactNetServiceUtil.h"
#import "CustomLoadingView.h"
#import "MessageTableViewCell.h"
@implementation SearchContactResultViewController
@synthesize resultArr;
@synthesize loadingView;
@synthesize searchText;
@synthesize pageIndex;
-(void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, navBarHeight+5, screenWidth, screenHeight-navBarHeight) style:UITableViewStylePlain];
       self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    self.tableView.delegate=self;
    self.tableView.dataSource =self;
    [self.view setBackgroundColor:[UIColor blackColor]];
    [self.tableView setBackgroundColor:[UIColor whiteColor]];
    [[CommUtilHelper sharedInstance] setExtraCellLineHidden:self.tableView type:@""];
    self.navigationItem.title=@"Search Result";
    self.pullDownRefreshed=YES;
    self.loadMoreRefreshed=YES;
    self.hasStatusLabelShowed=NO;
    [self beginPullDownRefreshing];
    pageIndex=1;
   
}
-(void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [resultArr count];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    MessageTableViewCell *cell=(MessageTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    NSMutableDictionary *userDic = [resultArr objectAtIndex:indexPath.row];
    [userDic setObject:cell.custImageView.image forKey:@"headImage"];
    loadingView = [[[CustomLoadingView alloc] init] getLoaidngViewByText:@"Loading..." Frame:self.view.frame];
    [self.view addSubview:loadingView];
    [NSThread detachNewThreadSelector:@selector(getContactUserDetailInfo:) toTarget:self withObject:userDic];
    
    
}
-(void)beginPullDownRefreshing
{
    [self endPullDownRefreshing];
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self startPullDownRefreshing];
    
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
[self endPullDownRefreshing];
}
-(void)getContactUserDetailInfo:(NSMutableDictionary *)dic
{
   
    NSString *contactUser = [dic objectForKey:@"USER_PRINCIPAL_NAME"];
    NSDictionary *myUserDic = [[CommUtilHelper sharedInstance] GetNativeUserInfo];
    NSString *myUser = [myUserDic objectForKey:@"user"];
    ResponseModel *rs = [[ContactNetServiceUtil sharedInstance] getOtherUserContactDeatail:contactUser From:myUser] ;
    
    dispatch_async(dispatch_get_main_queue(), ^(void){
        [loadingView removeFromSuperview];
        NSDictionary *rsArr = rs.resultInfo;

        if (rs.error !=nil) {
           
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"prompt" message:@"Network Error" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alertView show];
            return;
        }
        if (rsArr) {
            XHContact *contact = [[XHContact alloc] init];
            contact.headImage =[dic objectForKey:@"headImage"];
            contact.contactUser = [dic objectForKey:@"USER_PRINCIPAL_NAME"];
            contact.contactName = [dic objectForKey:@"SAM_ACCOUNT_NAME"];
            contact.ContactTitile = [rsArr objectForKey:@"usertitle"];
            contact.contactRegion = [rsArr objectForKey:@"city"];
            contact.contactEmail = [rsArr objectForKey:@"email"];
            contact.contactPhone =[rsArr objectForKey:@"phone"];
            contact.contactLoginStatus =[dic objectForKey:@"LOGIN_STATUS"];
            [dic setObject:[rsArr objectForKey:@"friend"] forKey:@"friend"];
            UserContactInfoViewController *infoCon = [[UserContactInfoViewController alloc] initWithContact:contact UserDic:dic isNatvie:NO];
            
            [self.navigationController pushViewController:infoCon animated:YES];
           
        }

    });
    
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[MessageTableViewCell alloc] initWithReuserIdentifier:@"cell" TableViewStyle:UITableViewCellStyleSubtitle];
    }
    tableView.separatorInset=UIEdgeInsetsZero;
    NSInteger row = indexPath.row;
    if (row <[resultArr count]) {
        NSDictionary *result = [resultArr objectAtIndex:row];
        [cell setBackgroundColor:[UIColor whiteColor]];
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        NSString *loginStatus = [result objectForKey:@"LOGIN_STATUS"];
        cell.custTextLable.text = [result objectForKey:@"COMMON_NAME"];
        cell.custDetailTextLable.text = [result objectForKey:@"TITLE"];
        [cell.custDetailTextLable setFont:[UIFont systemFontOfSize:12]];
        NSString *image =  [[CommUtilHelper sharedInstance] changeNullToStr: [result objectForKey:@"HEAD_PHOTO"]];
        NSString *image2 =  [[CommUtilHelper sharedInstance] changeNullToStr:[result objectForKey:@"HEAD_PHOTO2"]];
        NSString *image3 =  [[CommUtilHelper sharedInstance] changeNullToStr:[result objectForKey:@"HEAD_PHOTO3"]];
        NSString *image4 = [[CommUtilHelper sharedInstance] changeNullToStr: [result objectForKey:@"HEAD_PHOTO4"]];
        NSString *image5 =  [[CommUtilHelper sharedInstance] changeNullToStr:[result objectForKey:@"HEAD_PHOTO5"]];
        NSString *commbineImage = [NSString stringWithFormat:@"%@%@%@%@%@",image,image2,image3,image4,image5];
        if (commbineImage && ![commbineImage isEqualToString:@""]) {
            NSString *base64ImageStr = [commbineImage stringByReplacingOccurrencesOfString:@"data:image/jpeg;base64," withString:@"" ];
            NSData *imageData = [[NSData alloc] initWithBase64EncodedString:base64ImageStr options:0];
            if (imageData) {
                cell.custImageView.image = [UIImage imageWithData:imageData];
            }else
            {
                cell.custImageView.image=[UIImage imageNamed:@"default2x@2x.png"];
            }
        }else
        {
            cell.custImageView.image=[UIImage imageNamed:@"default2x@2x.png"];
        }
        if ([@"Y" isEqualToString:loginStatus]) {
            
            [cell.custDetailTextLable setTextColor:[UIColor blackColor]];
            [cell.custTextLable setTextColor:[UIColor blackColor]];
            cell.tip.text =@"Hi! I'm using HPG Mobile";
            [cell.tip setFont:[UIFont systemFontOfSize:10]];
            [cell.tip setTextColor:[UIColor redColor]];
        }else
        {
            [cell.tip setHighlighted:NO];
            [cell.custDetailTextLable setTextColor:[UIColor lightGrayColor]];
            [cell.custTextLable setTextColor:[UIColor lightGrayColor]];
        }
    }
    return  cell;
}



-(void)beginLoadMoreRefreshing
{
    
    [NSThread detachNewThreadSelector:@selector(searchNetContactAction:) toTarget:self withObject:searchText];
}

-(void)searchNetContactAction:(NSString *)text
{
    NSDictionary *user = [[CommUtilHelper alloc] GetNativeUserInfo];
    NSInteger startCount = pageIndex*20+1;
    NSInteger endCount = startCount+20-1;
    ResponseModel *rs = [[ContactNetServiceUtil sharedInstance] getSearchContact:text Min:(int)startCount Max:(int)endCount From:[user objectForKey:@"user"]];
    NSMutableArray  *result = rs.resultInfo;
    dispatch_async(dispatch_get_main_queue(), ^(void){
        [self endLoadMoreRefreshing];
        if (rs.error !=nil) {
           
            return;
        }
        if (resultArr && [resultArr count] == 0) {
            return;
        }
        pageIndex++;
        [resultArr addObjectsFromArray:result];
        [self.tableView reloadData];
        
    });
}
-(void)viewWillAppear:(BOOL)animated
{
[self endLoadMoreRefreshing];
    
}
//- (NSString *)displayAutoLoadMoreRefreshedMessage {
//    return @"Click show more 20";
//}
@end
