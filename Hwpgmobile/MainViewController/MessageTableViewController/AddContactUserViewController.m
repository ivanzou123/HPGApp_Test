//
//  AddContactUserViewController.m
//  HwpgMobile
//
//  Created by hwpl hwpl on 14-11-27.
//  Copyright (c) 2014年 hwpl hwpl. All rights reserved.
//

#import "AddContactUserViewController.h"
#import "eChatDAO.h"
#import "CommUtilHelper.h"
#import "ResponseModel.h"
#import "ContactNetServiceUtil.h"
#import "CustomLoadingView.h"
#import "JSON.h"
#import "SocketIOConnect.h"
#import "SocketIO.h"
#import "MessageTableViewCell.h"
#import "NewGroupAdUserViewController.h"
#import "UIWindow+YzdHUD.h"
@interface AddContactUserViewController ()
{
    NSMutableArray *nativeArr;
    NSMutableArray  *dataArr;
    NSMutableArray *saveTempArr;
    NSString *myUser;
    UIView *loadingView;
    UIBarButtonItem *savebutton;
    UISearchBar *searchBar;
}
/**
 *  搜索框
 */
@property (nonatomic, strong) UISearchBar *aSearchBar;

/**
 *  搜索框绑定的控制器
 */
@property (nonatomic) UISearchController *searchController;
@end

@implementation AddContactUserViewController
@synthesize groupId;

- (void)viewDidLoad {
    [super viewDidLoad];
    dataArr =[NSMutableArray array];
    saveTempArr = [NSMutableArray array];
    NSDictionary *myDic = [[CommUtilHelper sharedInstance] GetNativeUserInfo];
    myUser = [myDic objectForKey:@"user"];
    dataArr = [self getWillAddContactUser:groupId User:myUser];
    nativeArr = dataArr;
    // Do any additional setup after loading the view.
    savebutton = [[UIBarButtonItem alloc] initWithTitle:@"OK" style:UIBarButtonItemStyleDone target:self action:@selector(addContactUser)];
    self.navigationItem.rightBarButtonItem = savebutton;
    self.navigationItem.title=@"Add Member";
    
    searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 44)];
    searchBar.delegate=self;
    self.tableView.tableHeaderView = searchBar;
    [savebutton setEnabled:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [searchBar resignFirstResponder];
    
}
//- (UISearchBar *)aSearchBar {
//    if (!_aSearchBar) {
//        _aSearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 44)];
//        _aSearchBar.delegate = self;
//        _aSearchBar.placeholder=@"搜索";
//        _searchController = [[UISearchController alloc] initWithSearchResultsController:self];
//        _searchController.delegate=self;
//        [_searchController searchBar];
//    }
//    return _aSearchBar;
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)searchBarSearchButtonClicked:(UISearchBar *) _searchBar
{
    [_searchBar resignFirstResponder];
    NSString *searchText = [_searchBar.text lowercaseString];
    if ([@"" isEqualToString:[searchText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]]){
        
    }else
    {
        [self.view.window showHUDWithText:@"Searching..." Type:ShowLoading Enabled:YES];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            ContactNetServiceUtil *serviceUtil= [[ContactNetServiceUtil alloc] init];
            ResponseModel *rs=  [serviceUtil getWCForGroupByGroupId:@"-1" From:[[CommUtilHelper sharedInstance] getUser] Val:searchText min:0 max:20];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.view.window showHUDWithText:@"" Type:ShowDismiss Enabled:YES];
                NSMutableArray *resultArr = rs.resultInfo;
                if (rs.error !=nil){
                    [self.view.window showHUDWithText:@"Network is not good" Type:ShowPhotoNo Enabled:YES];
                    return ;
                }
                if ([resultArr count] == 0) {
                    [self.view.window showHUDWithText:@"No data" Type:ShowPhotoNo Enabled:YES];
                    return ;
                }
                NewGroupAdUserViewController *newGroupAdUser =[[NewGroupAdUserViewController alloc] init];
                newGroupAdUser.dataArr = resultArr;
                newGroupAdUser.groupId=groupId;
                newGroupAdUser.searchText=searchText;

                newGroupAdUser.navigationItem.title=@"Search result";
                UINavigationController *av = [[UINavigationController alloc] initWithRootViewController:newGroupAdUser];
                newGroupAdUser.adUserBlock=^(NSMutableArray *reArr)
                {
                    if (reArr == nil) {
                        return ;
                    }else if([reArr count]>0)
                    {
                        [self reloadAddData:reArr];
                        return;
                    }
                    
                };
                [self presentViewController:av animated:YES completion:nil];
            });
        });
        
        
    }
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: [NSString stringWithFormat:@"cell_%i",(int)indexPath.row]];
//    if (!cell) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
//        [cell.imageView setFrame:CGRectMake(0, 0, 40, 40)];
//        cell.imageView.layer.masksToBounds=YES;
//        [cell.imageView.layer setCornerRadius:CGRectGetHeight([cell.imageView bounds])/2];
//        cell.imageView.layer.borderWidth=1;
//        cell.imageView.layer.borderColor=[[UIColor lightGrayColor] CGColor];
//    }
//    if ([saveTempArr count] >0) {
//        if ( [saveTempArr  indexOfObject:[dataArr objectAtIndex:indexPath.row]] !=NSNotFound) {
//            cell.accessoryType = UITableViewCellAccessoryCheckmark;
//        }
//    }
//
//    NSDictionary *dic = [dataArr objectAtIndex:indexPath.row];
//    cell.textLabel.text = [dic objectForKey:@"SAM_ACCOUNT_NAME"];
//   
//    NSString *Base64headImage = [dic objectForKey:@"HEAD_PHOTO"] ;
//    [cell.imageView setFrame:CGRectMake(0, 0, 35, 35)];
//    tableView.separatorInset =UIEdgeInsetsZero;
//    UIImage *image= [[CommUtilHelper sharedInstance] getImageByImageName:Base64headImage Size:CGSizeMake(40, 40)];
//    if (image) {
//        cell.imageView.image = image;
//    }else
//    {
//        cell.imageView.image = [UIImage imageNamed: @"default.jpg"];
//    }
    
    NSString *cellIden = [NSString stringWithFormat:@"cell_%li",indexPath.row];
    MessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIden];
    if (!cell) {
        cell = [[MessageTableViewCell alloc] initWithReuserIdentifier:cellIden TableViewStyle:UITableViewCellStyleSubtitle];
    }
    if (!cell) {
        //cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        
        [cell.custImageView setFrame:CGRectMake(0, 0, 40, 40)];
        [cell.custImageView.layer setCornerRadius:CGRectGetHeight([cell.imageView bounds]) / 2];
        cell.custImageView.layer.masksToBounds = YES;
        cell.custImageView.layer.borderWidth = 1;
        
        cell.custImageView.layer.borderColor = [[UIColor grayColor] CGColor] ;
    }
    NSDictionary *dic = [dataArr objectAtIndex:indexPath.row];
    //是否已选择
    if ([saveTempArr count] >0) {
        if ( [saveTempArr  indexOfObject:[dataArr objectAtIndex:indexPath.row]] !=NSNotFound) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            
        }
        for (int i=0; i<[saveTempArr count]; i++) {
            NSDictionary *redic = [saveTempArr objectAtIndex:i];
            NSString *type=[redic objectForKey:@"TYPE"];//是否为添加好友而来
            NSString *reuser = [redic objectForKey:@"USER"];
            if ([@"-1" isEqualToString:type]){//表示从搜索ad user返回的用户
                if ([reuser isEqualToString:[dic objectForKey:@"USER_PRINCIPAL_NAME"]]) {
                    [saveTempArr removeObjectAtIndex:i];
                    [saveTempArr addObject:dic];
                    cell.accessoryType = UITableViewCellAccessoryCheckmark;
                }
            }
        }
    }
    
    
    cell.separatorInset = UIEdgeInsetsZero;
    cell.custTextLable.text = [dic objectForKey:@"COMMON_NAME"];
    cell.custDetailTextLable.text = [dic objectForKey:@"TITLE"];
    [cell.custDetailTextLable setFont:[UIFont systemFontOfSize:12]];
    cell.tip.text =@"Hi! I'm using HWG Mobile";
    [cell.tip setFont:[UIFont systemFontOfSize:10]];
    [cell.tip setTextColor:[UIColor redColor]];
    NSString *imageName = [dic objectForKey:@"HEAD_PHOTO"];
    if (imageName && ![@"" isEqualToString:imageName]) {
        if([[CommUtilHelper sharedInstance] getImageByImageName:imageName Size:CGSizeMake(40, 40)])
        {
            cell.custImageView.image=[[CommUtilHelper sharedInstance] getImageByImageName:imageName Size:CGSizeMake(40, 40)];
        }else
        {
            cell.custImageView.image=[UIImage imageNamed:@"default2x@2x.png"];
        }
    }else
    {
        cell.custImageView.image=[UIImage imageNamed:@"default2x@2x.png"];
    }
    return cell;

    
   
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dataArr count];
}
-(NSMutableArray *)getWillAddContactUser:(NSString *)_groupId User:(NSString *)user
{
   NSMutableArray *arr =  [[eChatDAO sharedChatDao] getNotInGroupUserByGroupId:_groupId User:user];
    NSMutableArray *tempArr = [[NSMutableArray alloc] init];
    NSString *tempUser= @"";
    for (int i=0; i<[arr count]; i++) {
        NSDictionary *dic = [arr objectAtIndex:i];
        NSString *user = [dic objectForKey:@"USER_PRINCIPAL_NAME"];
        if (![user isEqualToString:tempUser]) {
            [tempArr addObject:arr[i]];
        }
        tempUser = user;
    }
    return tempArr;
   
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
-(void)searchNetContactAction:(UISearchBar *)_searchBar
{
    NSDictionary *user = [[CommUtilHelper alloc] GetNativeUserInfo];
    NSString *text = _searchBar.text;
    ResponseModel *rs = [[ContactNetServiceUtil sharedInstance] getSearchContact:text Min:1 Max:20 From:[user objectForKey:@"user"]];
    NSMutableArray *resultArr = rs.resultInfo;
    dispatch_async(dispatch_get_main_queue(), ^(void){
        [loadingView removeFromSuperview];
        if (rs.error !=nil) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Prompt" message:@"NetWork Error" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alertView show];
            return;
        }
        if (resultArr && [resultArr count] == 0) {
            [loadingView removeFromSuperview];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Prompt" message:@"Account is not Exist" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alertView show];
            return;
        }
        [dataArr removeAllObjects];
        [dataArr addObjectsFromArray:nativeArr];
        [dataArr addObjectsFromArray:resultArr];
        [self.tableView reloadData];
        
    });
}
//
-(void)addContactUser
{
    NSString *contactUser = @"";
    for (int i=0; i<[saveTempArr count]; i++) {
        NSDictionary *dic = [saveTempArr objectAtIndex:i];
        NSString *user = [dic objectForKey:@"USER_PRINCIPAL_NAME"];
        if ([saveTempArr count] ==1) {
            contactUser = [NSString stringWithFormat:@"'%@'",user];
        }else
        {
            contactUser = [contactUser stringByAppendingString:[NSString stringWithFormat:@"'%@',",user]];
            if (i==[saveTempArr count]-1) {
                  contactUser = [contactUser stringByAppendingString:[NSString stringWithFormat:@"'%@'",user]];
            }
        }
    }
    loadingView = [[[CustomLoadingView alloc] init] getLoaidngViewByText:@"Waiting.." Frame:self.view.frame];
    [self.view addSubview:loadingView];
    [NSThread detachNewThreadSelector:@selector(saveThreadCallBack:) toTarget:self withObject:contactUser];
}
//已存在组  只需插入person和aduser
-(void)saveThreadCallBack:(NSString *)contactUser
{
    ResponseModel *rs = [[ContactNetServiceUtil sharedInstance] addMember:contactUser From:myUser GroupId:groupId NickUser:@""];
    dispatch_async(dispatch_get_main_queue(), ^(void){
        [loadingView removeFromSuperview];
        if (rs.error !=nil) {
            [[CommUtilHelper sharedInstance] showAlertView:@"Prompt" Message:@"Request Failed" delegate:self];
            return ;
        }
        NSString *inviteUser = [[[CommUtilHelper sharedInstance] getNickName] stringByAppendingString:@" invited "];
        NSMutableDictionary *dic = rs.resultInfo;
        NSString *userjSON = [dic objectForKey:@"users"];
        NSMutableArray *arrs = [NSMutableArray arrayWithObjects:userjSON, nil];
        NSMutableArray *tempArr = [NSMutableArray array];
        for (int i=0; i<[arrs  count]; i++) {
            NSArray *userArr = [arrs objectAtIndex:i];
            for (int j=0; j<[userArr count]; j++) {
                NSDictionary *user = [userArr objectAtIndex:j] ;
                NSMutableDictionary  *saveDic = [NSMutableDictionary dictionary];
                NSString *sysDttm = [user objectForKey:@"SYSDTTM"];
                NSString *userPrincipalName = [user objectForKey:@"USER_PRINCIPAL_NAME"];
                NSString *nickName = [user objectForKey:@"USER_NICK_NAME"];
                if (![userPrincipalName isEqualToString:myUser]) {
                    inviteUser=[inviteUser stringByAppendingString:nickName];
                    if(j<([userArr count]-1)){
                        inviteUser = [inviteUser stringByAppendingString:@";"];
                    }
                }
                NSString *lastUpdPerson =[user objectForKey:@"LASTUPD_PERSON"];
                NSString *empNumber = [user objectForKey:@"EMPLOYEE_NUMBER"];
                NSString *phoneNumer=[user objectForKey:@"PHONE_NUMBER"];
                NSString *title =[user objectForKey:@"TITLE"];
                NSString *email = [user objectForKey:@"EMAIL"];
                NSString *headPhoto =[user objectForKey:@"HEAD_PHOTO"];
                NSString *lastUpdDate =[user objectForKey:@"LASTUPD_DATE"];
                NSString *groupPersonId =[user objectForKey:@"GROUP_PERSON_ID"];
                NSString *location =[user objectForKey:@"LOCATION"];
                NSString *disabled =@"N";
                NSString  *chatGroupId = [user objectForKey:@"CHAT_GROUP_ID"];
                [saveDic  setObject:sysDttm forKey:@"LAST_SYNC_TIME"];
                [saveDic setObject:nickName forKey:@"USER_NICK_NAME"];
                [saveDic setObject:empNumber forKey:@"EMPLOYEE_NUMBER"];
                [saveDic setObject:title forKey:@"TITLE"];
                [saveDic setObject:location forKey:@"LOCATION"];
                [saveDic setObject:email forKey:@"EMAIL"];
                [saveDic setObject:phoneNumer forKey:@"PHONE_NUMBER"];
                //
                NSString *image =  [[CommUtilHelper sharedInstance] changeNullToStr:[user objectForKey:@"HEAD_PHOTO"]];
                NSString *image2 =  [[CommUtilHelper sharedInstance] changeNullToStr:[user objectForKey:@"HEAD_PHOTO2"]];
                NSString *image3 =  [[CommUtilHelper sharedInstance] changeNullToStr:[user objectForKey:@"HEAD_PHOTO3"]];
                NSString *image4 =  [[CommUtilHelper sharedInstance] changeNullToStr:[user objectForKey:@"HEAD_PHOTO4"]];
                NSString *image5 =  [[CommUtilHelper sharedInstance] changeNullToStr:[user objectForKey:@"HEAD_PHOTO5"]];
                NSString *commbineImage = [NSString stringWithFormat:@"%@%@%@%@%@",image,image2,image3,image4,image5];
                NSString *HEAD_PHOTO = [[CommUtilHelper sharedInstance] saveImageToPath:commbineImage];
                NSString *loginStatus =[user objectForKey:@"LOGIN_STATUS"];
                [saveDic setObject:loginStatus forKey:@"LOGIN_STATUS"];
                [saveDic setObject:HEAD_PHOTO forKey:@"HEAD_PHOTO"];
                [saveDic setObject:[user objectForKey:@"COMMON_NAME"] forKey:@"COMMON_NAME"];
                [saveDic setObject:headPhoto forKey:@"HEAD_BIG_PHOTO"];
                [saveDic setObject:userPrincipalName forKey:@"USER_PRINCIPAL_NAME"];
                [saveDic setObject:chatGroupId forKey:@"CHAT_GROUP_ID"];
                [saveDic setObject:lastUpdPerson forKey:@"LAST_UPDATEBY"];
                [saveDic setObject:lastUpdDate forKey:@"LAST_UPDATEDTTM"];
                [saveDic setObject:disabled forKey:@"DISABLED"];
                [saveDic setObject:groupPersonId forKey:@"GROUP_PERSON_ID"];
                
                
                [tempArr addObject:saveDic];
            }
        }
        
        if ([tempArr count] == 0){
            return;
        }
        
        inviteUser=[inviteUser stringByAppendingString:@" to join the chat"] ;
        [[eChatDAO sharedChatDao] insertChatAdUser:tempArr];
        if([[eChatDAO sharedChatDao] insertGroupPerson:tempArr])
        {
             NSString *deviceId = [CommUtilHelper getDeviceId];
             NSString *sID = [[CommUtilHelper sharedInstance] createDiffUUID];
             [[ChatMessageViewController shareInstance] sendMsg:[NSDictionary dictionaryWithObjectsAndKeys:groupId,@"groupid",deviceId,@"deviceId",myUser,@"from",inviteUser,@"msg",@"A",@"msgType",@"100",@"sessionId", sID,@"sId", nil] Event:@"newMember"];
             //[[ChatMessageViewController shareInstance] sendMsg:[NSDictionary dictionaryWithObjectsAndKeys:groupId,@"groupid",myUser,@"from",inviteUser,@"msg",@"A",@"msgType",@"100",@"sessionId",deviceId,@"deviceId",  nil] Event:@"sendSysMsg"];
        }
        [self.navigationController popViewControllerAnimated:YES];
    });
}

-(void)reloadAddData:(NSMutableArray *)reArr
{
    dataArr = [self getWillAddContactUser:groupId User:myUser];
    [saveTempArr addObjectsFromArray:reArr];
    [self.tableView reloadData];
    [savebutton setEnabled:YES];
}
@end
