//
//  NewGroupAdUserViewController.m
//  HwpgMobile
//
//  Created by hwpl on 15/4/30.
//  Copyright (c) 2015年 hwpl hwpl. All rights reserved.
//

#import "NewGroupAdUserViewController.h"
#import "CommUtilHelper.h"
#import "MessageTableViewCell.h"
#import "eChatDAO.h"
#import "ResponseModel.h"
#import "ContactNetServiceUtil.h"
#import "UIWindow+YzdHUD.h"
@interface NewGroupAdUserViewController ()
{
    UITableView *aduserTableView;
     NSMutableArray *saveTempArr;
    UIBarButtonItem *savebutton;
    NSMutableArray *reTempArr;//返回上一页面
     BOOL isloading;
    UIActivityIndicatorView *pullLoadView;
    int min;
    int max;
    UIView *lview;
}
@end

@implementation NewGroupAdUserViewController
@synthesize dataArr;
@synthesize adUserBlock;
@synthesize groupId,searchText;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.navigationController.navigationBar.barTintColor= [CommUtilHelper getDefaultBackgroupColor];
    self.navigationController.navigationBar.translucent=YES;
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
    self.navigationItem.leftBarButtonItem=leftBarButton;

    savebutton = [[UIBarButtonItem alloc] initWithTitle:@"OK" style:UIBarButtonItemStyleDone target:self action:@selector(confirmAction)];
    [savebutton setEnabled:NO];
    self.navigationItem.rightBarButtonItem = savebutton;
    
    //INIT TABLEVIEW
    aduserTableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight) style:UITableViewStylePlain];
    aduserTableView.delegate=self;
    aduserTableView.dataSource=self;
    [self.view addSubview:aduserTableView];
    [[CommUtilHelper sharedInstance] setExtraCellLineHidden:aduserTableView type:nil];
    
    
    //dataArr =[NSMutableArray array];
    saveTempArr = [NSMutableArray array];
    reTempArr = [NSMutableArray array];
    isloading=NO;
    [self initLoadView];
    min=20;
    
    // Do any additional setup after loading the view.
}

-(void)initLoadView
{
    
    lview = [[UIView alloc] initWithFrame:CGRectMake(0, aduserTableView.tableFooterView.frame.origin.y+60, aduserTableView.tableFooterView.frame.size.width, 60)];
    [lview setBackgroundColor:[UIColor whiteColor]];
    pullLoadView = [[UIActivityIndicatorView alloc] init];
    [pullLoadView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    [pullLoadView setFrame:CGRectMake(screenWidth/2-15, 20, 30, 20)];
    // pullLoadView.center = lview.center;
    [pullLoadView stopAnimating];
    [lview addSubview:pullLoadView];
    [aduserTableView addSubview:lview];
    
}
-(void)confirmAction
{
    if ([saveTempArr count]>0) {
        [self addContactUser];
    }
}
-(void)cancel
{
    
    
    [self dismissViewControllerAnimated:YES completion:^(void){}];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark TABLEVIEW DELEGATE
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dataArr count];
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
    if (row <[dataArr count]) {
        NSDictionary *result = [dataArr objectAtIndex:row];
        [cell setBackgroundColor:[UIColor whiteColor]];
        
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        [saveTempArr removeObject:[dataArr objectAtIndex:indexPath.row]];
    }else
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        [saveTempArr addObject:[dataArr objectAtIndex:indexPath.row]];
        
    }
    if ([saveTempArr count] >0) {
        [savebutton setEnabled:YES];
    }else
    {
        [savebutton setEnabled:NO];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

-(void)addContactUser
{
    NSString *contactUser =nil;
    for (int j=0; j<[saveTempArr count]; j++) {
        NSDictionary *tempDic = [saveTempArr objectAtIndex:j];
        if (tempDic !=nil) {
            if (j==0) {
                contactUser =  [NSString stringWithFormat:@"'%@'",[tempDic objectForKey:@"USER_PRINCIPAL_NAME"]];
            }else{
                contactUser = [contactUser stringByAppendingString:[NSString stringWithFormat:@",'%@'",[tempDic objectForKey:@"USER_PRINCIPAL_NAME"]]];
            }
        }
        
    }
    
    NSString *myUser = [[CommUtilHelper sharedInstance] getUser];
    ResponseModel *rs = [[ContactNetServiceUtil sharedInstance] addFrineds:contactUser From:myUser];
    NSMutableArray *arr = rs.resultInfo;
    dispatch_async(dispatch_get_main_queue(), ^(void){
       
        if (rs.error !=nil) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Prompt" message:@"Network Error" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alertView show];
            return ;
        }
        if (arr  && [arr count] >0) {
            
            
            NSMutableArray *chatUserArr = [NSMutableArray array];
            NSMutableArray *chatAdUserArr = [NSMutableArray array];
            
                for (int i=0; i<[arr count]; i++) {
                    NSDictionary *dic = [arr objectAtIndex:i];
                    //NSString *sysDttm = [dic objectForKey:@"SYSDTTM"];
                    NSMutableDictionary *chatUsersaveDic = [NSMutableDictionary dictionary ];
                    NSMutableDictionary *chatAdSaveDic = [NSMutableDictionary dictionary ];
                    [chatAdSaveDic setObject:[dic objectForKey:@"USER_PRINCIPAL_NAME"]  forKey:@"USER_PRINCIPAL_NAME"];
                    [chatAdSaveDic setObject:[dic objectForKey:@"USER_PRINCIPAL_NAME"]  forKey:@"FREQUENT_CONTACT_USER"];
                    [chatAdSaveDic setObject:[dic objectForKey:@"SAM_ACCOUNT_NAME"] forKey:@"USER_NICK_NAME"];
                    [chatAdSaveDic setObject:[dic objectForKey:@"DISPLAY_NAME"] forKey:@"USER_DISPLAY_NAME"];
                    [chatAdSaveDic setObject:[dic objectForKey:@"SYSDTTM"] forKey:@"LAST_SYNC_TIME"];
                    [chatAdSaveDic setObject:[dic objectForKey:@"LOCATION"] forKey:@"LOCATION"];
                    [chatAdSaveDic setObject:[dic objectForKey:@"TITLE"] forKey:@"TITLE"];
                    [chatAdSaveDic setObject:[dic objectForKey:@"PHONE_NUMBER"] forKey:@"PHONE_NUMBER"];
                    [chatAdSaveDic setObject:[dic objectForKey:@"EMPLOYEE_NUMBER"] forKey:@"EMPLOYEE_NUMBER"];
                    [chatAdSaveDic setObject:[dic objectForKey:@"EMAIL"] forKey:@"EMAIL"];
                    [chatAdSaveDic setObject:[dic objectForKey:@"HEAD_BIG_PHOTO"] forKey:@"HEAD_BIG_PHOTO"];
                    [chatAdSaveDic setObject:[dic objectForKey:@"COMMON_NAME"] forKey:@"COMMON_NAME"];
                    [chatAdSaveDic setObject:[dic objectForKey:@"LOGIN_STATUS"] forKey:@"LOGIN_STATUS"];
                    
                    NSString *image =  [[CommUtilHelper sharedInstance] changeNullToStr: [dic objectForKey:@"HEAD_PHOTO"]];
                    NSString *image2 =  [[CommUtilHelper sharedInstance] changeNullToStr:[dic objectForKey:@"HEAD_PHOTO2"]];
                    NSString *image3 =  [[CommUtilHelper sharedInstance] changeNullToStr:[dic objectForKey:@"HEAD_PHOTO3"]];
                    NSString *image4 =  [[CommUtilHelper sharedInstance] changeNullToStr:[dic objectForKey:@"HEAD_PHOTO4"]];
                    NSString *image5 =  [[CommUtilHelper sharedInstance] changeNullToStr:[dic objectForKey:@"HEAD_PHOTO5"]];
                    NSString *commbineImage = [NSString stringWithFormat:@"%@%@%@%@%@",image,image2,image3,image4,image5];
                    NSString *HEAD_PHOTO = [[CommUtilHelper sharedInstance] saveImageToPath:commbineImage];
                    [chatAdSaveDic setObject:HEAD_PHOTO forKey:@"HEAD_PHOTO"];
                    
                    [chatAdSaveDic setObject:@"N" forKey:@"DISABLED"];
                    
                    
                    [chatUsersaveDic setObject:[dic objectForKey:@"USER_PRINCIPAL_NAME" ] forKey:@"FREQUENT_CONTACT_USER"];
                    [chatUsersaveDic setObject:[dic objectForKey:@"SAM_ACCOUNT_NAME"] forKey:@"USER_NICK_NAME"];
                    [chatUsersaveDic setObject:[dic objectForKey:@"DISPLAY_NAME"] forKey:@"USER_DISPLAY_NAME"];
                    [chatUsersaveDic setObject:[dic objectForKey:@"SYSDTTM"] forKey:@"LAST_SYNC_TIME"];
                    [chatUsersaveDic setObject:@"N" forKey:@"DISABLED"];
                    [chatUsersaveDic setObject:[dic objectForKey:@"USER_PRINCIPAL_NAME" ]  forKey:@"USER_PRINCIPAL_NAME"];
                    [chatUsersaveDic setObject:myUser  forKey:@"USER_PRINCIPAL_NAME"];
                    [chatUserArr addObject:chatUsersaveDic];
                    [chatAdUserArr addObject:chatAdSaveDic];
                    
                    
                    [reTempArr addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"-1",@"TYPE",[dic objectForKey:@"USER_PRINCIPAL_NAME"],@"USER", nil]];
                }
                [[eChatDAO sharedChatDao] insertChatUser:chatUserArr];
                [[eChatDAO sharedChatDao] insertChatAdUser:chatAdUserArr];
                self.adUserBlock(reTempArr);
                [self dismissViewControllerAnimated:YES completion:nil];
                
            }else
            {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Prompt" message:@"Add Falied" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [alertView show];
                
            }
        
    });
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([dataArr count]>=20) {
        if (!isloading) {
            float contentsetY= scrollView.contentOffset.y;
            float contentsizeY = scrollView.contentSize.height;
            //float bottom = scrollView.contentInset.bottom;
            if (contentsetY+screenHeight-64+30>contentsizeY && !isloading) {
                isloading = YES;
                //dataArr = [[NSMutableArray alloc] initWithArray:dataTempArr];
               
                //[aduserTableView reloadData];
                [self refreshData];
                
                
                
            }
            
        }
    }

}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if ([dataArr count]>=20) {
        if (!isloading) {
            float contentsetY= scrollView.contentOffset.y;
            float contentsizeY = scrollView.contentSize.height;
            //float bottom = scrollView.contentInset.bottom;
            if (contentsetY+screenHeight-64+30>contentsizeY && !isloading) {
                isloading = YES;
                //dataArr = [[NSMutableArray alloc] initWithArray:dataTempArr];
                
                //[aduserTableView reloadData];
                [self refreshData];
                
                
                
            }
            
        }
    }

}
-(void)refreshData
{
    [pullLoadView startAnimating];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        ContactNetServiceUtil *serviceUtil= [[ContactNetServiceUtil alloc] init];
        ResponseModel *rs=  [serviceUtil getWCForGroupByGroupId:groupId From:[[CommUtilHelper sharedInstance] getUser] Val:searchText min:min max:min+20];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            isloading = NO;
            [pullLoadView stopAnimating];
            NSMutableArray *resultArr = rs.resultInfo;
            
            if (rs.error !=nil){
                [self.view.window showHUDWithText:@"Network is not good!" Type:ShowPhotoNo Enabled:YES];
                return ;
            }
            if ([resultArr count] == 0) {
                
                return ;
            }
            [dataArr addObjectsFromArray:resultArr];
             min=min+(int)[resultArr count];
             [aduserTableView reloadData];
            [lview removeFromSuperview];
             lview = [[UIView alloc] initWithFrame:CGRectMake(0, aduserTableView.tableFooterView. frame.origin.y-60, aduserTableView.frame.size.width, 60)];
            [aduserTableView addSubview:lview];
        });
    });
    

}
@end
