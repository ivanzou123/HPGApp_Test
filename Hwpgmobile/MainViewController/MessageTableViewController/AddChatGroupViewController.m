//
//  AddChatGroupViewController.m
//  HwpgMobile
//
//  Created by hwpl hwpl on 14-12-2.
//  Copyright (c) 2014年 hwpl hwpl. All rights reserved.
//

#import "AddChatGroupViewController.h"
#import "CommUtilHelper.h"
#import "eChatDAO.h"
#import "ResponseModel.h"
#import "ContactNetServiceUtil.h"
#import "CustomLoadingView.h"
#import "ChatMessageViewController.h"
#import "ChatViewController.h"
#import "SocketIO.h"
#import "SocketIOConnect.h"
#import "MessageTableViewCell.h"
#import "NewGroupAdUserViewController.h"
#import "UIWindow+YzdHUD.h"
@interface AddChatGroupViewController ()
{
    NSMutableArray *dataArr;
    NSMutableArray *dataTempArr;
    NSMutableArray *saveTempArr;
    NSString *myUser;
    UIBarButtonItem *savebutton;
    UIView *loadingView;
    NSString *groupName;
    NSString *groupId;
    UIView *headerView;
    UISearchBar *searchBar;
    BOOL isSeach;
    UIActivityIndicatorView *pullLoadView;
    BOOL isloading;
}
@end

@implementation AddChatGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.barTintColor=kGetColor(248, 248, 248);
    self.navigationController.navigationBar.tintColor = kGetColor(4, 118, 246);

    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
    self.navigationItem.leftBarButtonItem=leftBarButton;
    //
    dataArr =[NSMutableArray array];
    saveTempArr = [NSMutableArray array];
    NSDictionary *myDic = [[CommUtilHelper sharedInstance] GetNativeUserInfo];
    myUser = [myDic objectForKey:@"user"];
    dataArr = [[eChatDAO sharedChatDao] getAddChatGroupMember:myUser];
    dataTempArr = [dataArr copy];
    // Do any additional setup after loading the view.
    savebutton = [[UIBarButtonItem alloc] initWithTitle:@"OK" style:UIBarButtonItemStyleDone target:self action:@selector(addContactUser)];
    [savebutton setEnabled:NO];
    self.navigationItem.rightBarButtonItem = savebutton;
    isSeach = NO;
    
    
    searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 44)];
    searchBar.delegate=self;
    self.tableView.tableHeaderView = searchBar;
    isloading = NO;
    //[self initLoadView];
   
}
-(void)initLoadView
{
    
    UIView *lview = [[UIView alloc] initWithFrame:CGRectMake(0, self.tableView.tableHeaderView.frame.origin.y-60, self.tableView.frame.size.width, 60)];
    [lview setBackgroundColor:[UIColor whiteColor]];
    pullLoadView = [[UIActivityIndicatorView alloc] init];
    [pullLoadView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    [pullLoadView setFrame:CGRectMake(screenWidth/2-15, 20, 30, 20)];
   // pullLoadView.center = lview.center;
    [pullLoadView startAnimating];
    [lview addSubview:pullLoadView];
    [self.tableView addSubview:lview];
    
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [searchBar resignFirstResponder];
    
}



//-(void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    
//    if (!isloading) {
//        if (scrollView.contentOffset.y < (-64-50)) {
//            isloading = YES;
//            dataArr = [[NSMutableArray alloc] initWithArray:dataTempArr];
//            [pullLoadView startAnimating];
//            [UIView animateWithDuration:1.5 animations:^{
//                [self.tableView setContentInset:UIEdgeInsetsMake(104, 0, 0, 0)];
//            } completion:^(BOOL check){
//                [self.tableView setContentInset:UIEdgeInsetsMake(64, 0, 0, 0)];
//                [pullLoadView stopAnimating];
//                [self.tableView reloadData];
//                isloading = NO;
//            }];
//            
//        }
//
//    }
//    
//}



-(void)cancel
{
    [self dismissViewControllerAnimated:YES completion:^(void){}];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: [NSString stringWithFormat:@"cell_%i",(int)indexPath.row]];
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
                if ([reuser isEqualToString:[dic objectForKey:@"USER"]]) {
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
    cell.tip.text =@"Hi! I'm using HPG Mobile";
    [cell.tip setFont:[UIFont systemFontOfSize:10]];
    [cell.tip setTextColor:[UIColor redColor]];
    NSString *imageName = [dic objectForKey:@"HeadPhoto"];
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

///

-(void)addContactUser
{
    NSString *contactUser = @"";
    NSString *tempUser = @"";
        for (int i=0; i<[saveTempArr count]; i++) {
        NSDictionary *dic = [saveTempArr objectAtIndex:i];
        NSString *user = [dic objectForKey:@"USER"];
        NSString *nickName = [dic objectForKey:@"COMMON_NAME"];
        if (i<=3) {
            if (i ==0 && [saveTempArr count] ==1) {
                groupName = nickName;
            }else if(i==0)
            {
                 groupName = [[[CommUtilHelper sharedInstance] getCommonName] stringByAppendingString:nickName];
            }
            else
            {
                groupName =[groupName stringByAppendingString:[NSString stringWithFormat:@"%@",nickName]];
            }
        }
        if ([saveTempArr count] ==1) {
            contactUser = [NSString stringWithFormat:@"'%@'",user];
            tempUser = nickName;
        }else
        {
           
            if (i==[saveTempArr count]-1) {
                contactUser = [contactUser stringByAppendingString:[NSString stringWithFormat:@"'%@'",user]];
            }else
            {
             contactUser = [contactUser stringByAppendingString:[NSString stringWithFormat:@"'%@',",user]];
            }
        }
    }
    loadingView = [[CustomLoadingView alloc] getLoaidngViewByText:@"Waiting.." Frame:self.view.frame];
    
    if (contactUser) {
        //添加群组按钮一律按照群聊处理
        [self.view addSubview:loadingView];
        [NSThread detachNewThreadSelector:@selector(saveThreadCallBack:) toTarget:self withObject:contactUser];
        /*
        if ([saveTempArr count] >1) {
            //群聊
        }else
        {
            //检查本地是否存在 单聊
            NSString *chatGroupId = [[eChatDAO sharedChatDao] isExistOneByOneChatByUser:contactUser];
            if (![chatGroupId isEqualToString:@"-1"]) {
                [self cancel];
                ChatMessageViewController *cv = [ChatMessageViewController shareInstance] ;
                cv.groupId = chatGroupId;
                cv.nickName = [[CommUtilHelper sharedInstance] getNickName];
                cv.groupTitle = tempUser;
                cv.navigationItem.title = tempUser;
                [[ChatViewController sharedInstance]pushNextMessageViewController:cv];
            }else
            {
                [self.view addSubview:loadingView];
                [NSThread detachNewThreadSelector:@selector(saveThreadCallBack:) toTarget:self withObject:contactUser];
            }
        }
        */
    }
    
}
//已存在组  只需插入person和aduser
-(void)saveThreadCallBack:(NSString *)contactUser
{
 
    ResponseModel *rs = [[ContactNetServiceUtil sharedInstance] addMember:contactUser From:myUser GroupId:@"0" NickUser:groupName];
    dispatch_async(dispatch_get_main_queue(), ^(void){
        [loadingView removeFromSuperview];
        if (rs.error !=nil) {
            [[CommUtilHelper sharedInstance] showAlertView:@"Prompt" Message:@"Request Failed" delegate:self];
            return ;
        }
        NSMutableDictionary *dic = rs.resultInfo;
        NSString *userjSON = [dic objectForKey:@"users"];
        NSMutableArray *arrs = [NSMutableArray arrayWithObjects:userjSON, nil];
        NSMutableArray *tempArr = [NSMutableArray array];
        NSString *inviteUser = [[[CommUtilHelper sharedInstance] getNickName] stringByAppendingString:@" invited "];
        NSString *tempChatGroupName=@"";
        for (int i=0; i<[arrs  count]; i++) {
            NSArray *userArr = [arrs objectAtIndex:i];
            if ([userArr count] == 0) {
                [[CommUtilHelper sharedInstance] showAlertView:@"Prompt" Message:@"Request Failed" delegate:self];
                return;
            }
            for (int j=0; j<[userArr count]; j++) {
                NSDictionary *user = [userArr objectAtIndex:j] ;
                NSMutableDictionary  *saveDic = [NSMutableDictionary dictionary];
                NSString *sysDttm = [user objectForKey:@"SYSDTTM"];
                NSString *userPrincipalName = [user objectForKey:@"USER_PRINCIPAL_NAME"];
                NSString *barCode =  [user objectForKey:@"CHAT_GROUP_BARCODE"];
                //NSString *lastSessionNick = [user objectForKey:@"LAST_SESSION_NICK	"];
                
                NSString *nickName = [user objectForKey:@"USER_NICK_NAME"];
                if (![userPrincipalName isEqualToString:myUser]) {
                    inviteUser=[[inviteUser stringByAppendingString:nickName] stringByAppendingString:@" "] ;
                }
                NSString *lastUpdPerson =[user objectForKey:@"LASTUPD_PERSON"];
                NSString *createPerson =[user objectForKey:@"CREATE_PERSON"];
                //NSString *chatGroupImage = [user objectForKey:@"CHAT_GROUP_IMAGE"];
                NSString *empNumber = [user objectForKey:@"EMPLOYEE_NUMBER"];
                NSString *phoneNumer=[user objectForKey:@"PHONE_NUMBER"];
                NSString *title =[user objectForKey:@"TITLE"];
                NSString *email = [user objectForKey:@"EMAIL"];
                NSString *headPhoto =[user objectForKey:@"HEAD_PHOTO"];
                NSString *chatGroupName = [user objectForKey:@"CHAT_GROUP_NAME"];
                tempChatGroupName=chatGroupName;
                NSString *lastUpdDate =[user objectForKey:@"LASTUPD_DATE"];
                // NSString *createDate = [user objectForKey:@"CHAT_GROUP_ID"];[user objectForKey:@"CREATE_DATE"];
                NSString *lastSessionPerson =[user objectForKey:@"LAST_SESSION_PERSON"];
                NSString *groupPersonId =[user objectForKey:@"GROUP_PERSON_ID"];
                NSString *lastSessionDate =[user objectForKey:@"LAST_SESSION_DATE"];
                NSString *chatGroupInfo =[user objectForKey:@"LAST_SESSION_DATE"];
                // NSString *loginStatus = [user objectForKey:@"LOGIN_STATUS"];
                // NSString *chatGroupLimit = [user objectForKey:@"CHAT_GROUP_LIMIT"];
                NSString *location =[user objectForKey:@"LOCATION"];
                NSString *disabled =@"N";
                NSString *isGroup=[user objectForKey:@"IS_GROUP"];
                NSString *filePath = [user objectForKey:@"FILE_PATH"];
                //NSString  *personCreateDate = [user objectForKey:@"PERSON_CREATE_DATE"];
                NSString  *chatGroupId = [[user objectForKey:@"CHAT_GROUP_ID"] stringValue];
                NSString *lastUpdSession = [user objectForKey:@"LAST_UPDATE_SESSION"];
                NSString *commName = [user objectForKey:@"COMMON_NAME"];
                NSString *loginStatus = [user objectForKey:@"LOGIN_STATUS"];
                
                [saveDic  setObject:sysDttm forKey:@"LAST_SYNC_TIME"];
                [saveDic setObject:nickName forKey:@"USER_NICK_NAME"];
                [saveDic setObject:empNumber forKey:@"EMPLOYEE_NUMBER"];
                [saveDic setObject:title forKey:@"TITLE"];
                [saveDic setObject:location forKey:@"LOCATION"];
                [saveDic setObject:email forKey:@"EMAIL"];
                [saveDic setObject:phoneNumer forKey:@"PHONE_NUMBER"];
                
               
            
                NSString *image = [user objectForKey:@"HEAD_PHOTO"];
                NSString *image2 = [user objectForKey:@"HEAD_PHOTO"];
                NSString *image3 = [user objectForKey:@"HEAD_PHOTO"];
                NSString *image4 = [user objectForKey:@"HEAD_PHOTO"];
                NSString *image5 = [user objectForKey:@"HEAD_PHOTO"];
                NSString *commbineImage = [NSString stringWithFormat:@"%@%@%@%@%@",image,image2,image3,image4,image5];
                NSString *HEAD_PHOTO = [[CommUtilHelper sharedInstance] saveImageToPath:commbineImage];
                [saveDic setObject:HEAD_PHOTO forKey:@"HEAD_PHOTO"];
                
                [saveDic setObject:headPhoto forKey:@"HEAD_BIG_PHOTO"];
                [saveDic setObject:userPrincipalName forKey:@"USER_PRINCIPAL_NAME"];
                [saveDic setObject:chatGroupId forKey:@"CHAT_GROUP_ID"];
                [saveDic setObject:lastUpdPerson forKey:@"LAST_UPDATEBY"];
                [saveDic setObject:lastUpdDate forKey:@"LAST_UPDATEDTTM"];
                [saveDic setObject:disabled forKey:@"DISABLED"];
                
                //group info
                [saveDic setObject:groupPersonId forKey:@"GROUP_PERSON_ID"];
                [saveDic setObject:chatGroupName forKey:@"CHAT_GROUP_NAME"];
                [saveDic setObject:barCode forKey:@"CHAT_GROUP_BARCODE"];
                [saveDic setObject:createPerson forKey:@"CREATE_PERSON"];
                [saveDic setObject:loginStatus forKey:@"LOGIN_STATUS"];
                
                [saveDic setObject:lastSessionPerson forKey:@"LAST_SESSION_PERSON"];
                [saveDic setObject:isGroup forKey:@"IS_GROUP"];
                [saveDic setObject:isGroup forKey:@"IS_GROUP"];
   
                
                NSString *cimage = [user objectForKey:@"CHAT_GROUP_IMAGE"];
                NSString *cimage2 = [user objectForKey:@"CHAT_GROUP_IMAGE2"];
                NSString *cimage3 = [user objectForKey:@"CHAT_GROUP_IMAGE3"];
                NSString *cimage4 = [user objectForKey:@"CHAT_GROUP_IMAGE4"];
                NSString *cimage5 = [user objectForKey:@"CHAT_GROUP_IMAGE5"];
                NSString *commbineImage1 = [NSString stringWithFormat:@"%@%@%@%@%@",cimage,cimage2,cimage3,cimage4,cimage5];
                NSString *CHAT_GROUPIMAGE = [[CommUtilHelper sharedInstance] saveImageToPath:commbineImage1];
                
                [saveDic setObject:CHAT_GROUPIMAGE forKey:@"CHAT_GROUP_IMAGE"];
                
                [saveDic setObject:barCode forKey:@"LASTUPD_DATE"];
                [saveDic setObject:filePath forKey:@"FILE_PATH"];
                [saveDic setObject:lastUpdPerson forKey:@"LASTUPD_PERSON"];
                [saveDic setObject:lastSessionDate forKey:@"LAST_SESSION_DATE"];
                [saveDic setObject:lastUpdSession forKey:@"LAST_UPDATE_SESSION"];
                [saveDic setObject:chatGroupInfo forKey:@"CHAT_GROUP_INFO"];
                [saveDic setObject:commName forKey:@"COMMON_NAME"];
                [tempArr addObject:saveDic];
                groupId = chatGroupId;
            }
        }
        inviteUser=[inviteUser stringByAppendingString:@" to join the chat"];
        [[eChatDAO sharedChatDao] insertChatAdUser:tempArr];
        [[eChatDAO sharedChatDao] insertGroupPerson:tempArr];
        [[eChatDAO sharedChatDao] insertChatGroup:tempArr];
        [self cancel];
        ChatMessageViewController *cv = [ChatMessageViewController shareInstance] ;
        cv.groupTitle = tempChatGroupName;
        cv.groupId = groupId;
        cv.nickName = [[CommUtilHelper sharedInstance] getNickName];
        cv.navigationItem.title=tempChatGroupName;
        self.tabBarController.tabBar.hidden=YES;
        
        NSString *deviceId = [CommUtilHelper getDeviceId];
        NSString *sID = [[CommUtilHelper sharedInstance] createDiffUUID];
        [[ChatViewController sharedInstance] sendMsg:[NSDictionary dictionaryWithObjectsAndKeys:groupId,@"groupid",[[CommUtilHelper sharedInstance] getUser],@"from",deviceId,@"deviceId",myUser,@"from",inviteUser,@"msg",@"A",@"msgType",@"100",@"sessionId",contactUser,@"adduser",sID,@"sId", nil] Event:@"newMember"];
        
        //[[ChatViewController sharedInstance] sendMsg:[NSDictionary dictionaryWithObjectsAndKeys:groupId,@"groupid",myUser,@"from",inviteUser,@"msg",@"A",@"msgType",@"100",@"sessionId",deviceId,@"deviceId", nil] Event:@"sendSysMsg"];
        
        [[ChatViewController sharedInstance].tabBarController.tabBar setHidden:YES];
        [[ChatViewController sharedInstance].navigationController pushViewController:cv animated:YES];
    });
  }



#pragma mark - UITableView Delegate

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    if ([self enableForSearchTableView:tableView]) {
//        [self pushNewViewController:[[XHContactDetailTableViewController alloc] initWithContact:self.filteredDataSource[indexPath.row]]];
//    } else {
//        [self pushNewViewController:[[XHContactDetailTableViewController alloc] initWithContact:self.dataSource[indexPath.section][indexPath.row]]];
//    }
//}

#pragma mark searchBar delegate

//-(void)searchBarSearchButtonClicked:(UISearchBar *) _searchBar
//{
//    [_searchBar resignFirstResponder];
//    NSString *searchText = [_searchBar.text lowercaseString];
//    if ([@"" isEqualToString:[searchText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]]){
//        [dataArr removeAllObjects];
//         dataArr =[NSMutableArray arrayWithArray:dataTempArr];
//        [self.tableView reloadData];
//        
//    }else
//    {
//        [dataArr removeAllObjects];
//        for (int i=0; i<[dataTempArr count]; i++) {
//            NSDictionary *dic = [dataTempArr objectAtIndex:i];
//            NSString *nickName = [[dic objectForKey:@"COMMON_NAME"] lowercaseString];
//            if ([nickName  containsString:searchText]) {
//                [dataArr addObject:dic];
//            }
//        }
//        [self.tableView reloadData];
//    }
//  
//}
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
                
                if (rs.resultInfo ==nil) {
                   
                        return ;
                    
                }
                NSMutableArray *resultArr = rs.resultInfo;
                if (rs.error !=nil){
                     [self.view.window showHUDWithText:@"Network is not good!" Type:ShowPhotoNo Enabled:YES];
                    return ;
                }
                if ([resultArr count] == 0) {
                     [self.view.window showHUDWithText:@"No relative data!" Type:ShowPhotoNo Enabled:YES];
                    return ;
                }
                NewGroupAdUserViewController *newGroupAdUser =[[NewGroupAdUserViewController alloc] init];
                newGroupAdUser.dataArr = resultArr;
                newGroupAdUser.groupId=@"-1";
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
-(void)reloadAddData:(NSMutableArray *)reArr
{
    dataArr = [[eChatDAO sharedChatDao] getAddChatGroupMember:myUser];
    [saveTempArr addObjectsFromArray:reArr];
    [self.tableView reloadData];
    [savebutton setEnabled:YES];
}
-(void)dealloc
{
    [searchBar resignFirstResponder];
}

@end

