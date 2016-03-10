//
//  UserContactInfoViewController.m
//  HwpgMobile
//
//  Created by hwpl hwpl on 14-11-25.
//  Copyright (c) 2014年 hwpl hwpl. All rights reserved.
//
#define isAddContactUserTag 0
#define isSendButtonTag 1
#import "UserContactInfoViewController.h"

#import "XHContactView.h"
#import "XHContactPhotosTableViewCell.h"
#import "XHContactCommunicationView.h"
#import "CustomLoadingView.h"
#import "ContactNetServiceUtil.h"
#import "ResponseModel.h"
#import "CommUtilHelper.h"
#import "eChatDAO.h"
#import "ChatViewController.h"
#import "ChatMessageViewController.h"
#import "SocketIOConnect.h"
#import "XHLoadMoreView.h"
@interface UserContactInfoViewController ()
{
    NSString *groupId;
    BOOL isNative;
}

@property (nonatomic, strong) XHContact *contact;



@property (nonatomic, strong) NSDictionary *contactUserDic;

@property (nonatomic, strong) XHContactView *contactUserInfoView;

@property (nonatomic, strong) XHContactCommunicationView *contactCommunicationView;

@property (nonatomic, retain) UIView *loadingView;
@end


@implementation UserContactInfoViewController
@synthesize contactUserDic;
@synthesize loadingView;
#pragma mark - Action

- (void)videoCommunicationButtonClicked:(UIButton *)sender {
    
}
/***
 *添加好友
 */
- (void)messageCommunicationButtonClicked:(UIButton *)sender {
    switch (sender.tag) {
        case isAddContactUserTag:
        {
            //添加新用户
            loadingView = [[[CustomLoadingView alloc] init] getLoaidngViewByText:@"Loading..." Frame:self.view.frame];
            [self.view addSubview:loadingView];
            [NSThread  detachNewThreadSelector:@selector(addContactUser) toTarget:self withObject:nil];
            break;
        }
        case isSendButtonTag:
        {
            //发消息
            NSString *contactUser = [NSString stringWithFormat:@"'%@'",[contactUserDic objectForKey:@"USER_PRINCIPAL_NAME" ]];
            if (contactUser) {
                NSString * chatGroupId =  [[eChatDAO sharedChatDao] isExistOneByOneChatByUser:contactUser];
                if (![chatGroupId isEqualToString:@"-1"]) {
                    [self.navigationController popToRootViewControllerAnimated:NO];
                    [[ChatViewController sharedInstance].tabBarController setSelectedIndex:0];
                    ChatMessageViewController *cv = [ChatMessageViewController shareInstance] ;
                    cv.groupId = chatGroupId;
                    cv.nickName = [[CommUtilHelper sharedInstance] getNickName];
                    cv.groupTitle =[ contactUserDic objectForKey:@"SAM_ACCOUNT_NAME" ];
                    cv.navigationItem.title= cv.groupTitle;
                    [[ChatViewController sharedInstance]pushNextMessageViewController:cv];
                }else
                {
                    loadingView = [[[CustomLoadingView alloc] init] getLoaidngViewByText:@"Waiting..." Frame:self.view.frame];
                    [self.view addSubview:loadingView];
                 [NSThread detachNewThreadSelector:@selector(saveThreadCallBack:) toTarget:self withObject:contactUser];
                }
            }
            break;
        }
        default:
            break;
    }
   

}

//已存在组  只需插入person和aduser
-(void)saveThreadCallBack:(NSString *)contactUser
{
    
    ResponseModel *rs = [[ContactNetServiceUtil sharedInstance] addMember:contactUser From:[[[CommUtilHelper sharedInstance] GetNativeUserInfo] objectForKey:@"user"] GroupId:@"0" NickUser:[ contactUserDic objectForKey:@"SAM_ACCOUNT_NAME" ]];
    dispatch_async(dispatch_get_main_queue(), ^(void){
        [loadingView removeFromSuperview];
        if (rs.error !=nil) {
            [[CommUtilHelper sharedInstance] showAlertView:@"Prompt" Message:@"Request Failed" delegate:self];
            return ;
        }
        NSMutableDictionary *dic = rs.resultInfo;
        NSString *userjSON = [dic objectForKey:@"users"];
        //NSString *isGroup = [dic objectForKey:@"IsNewGroup"];
        NSMutableArray *arrs = [NSMutableArray arrayWithObjects:userjSON, nil];
        NSMutableArray *tempArr = [NSMutableArray array];
        
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
                NSString *lastUpdPerson =[user objectForKey:@"LASTUPD_PERSON"];
                NSString *createPerson =[user objectForKey:@"CREATE_PERSON"];
                NSString *chatGroupImage = [user objectForKey:@"CHAT_GROUP_IMAGE"];
                NSString *empNumber = [user objectForKey:@"EMPLOYEE_NUMBER"];
                NSString *phoneNumer=[user objectForKey:@"PHONE_NUMBER"];
                NSString *title =[user objectForKey:@"TITLE"];
                NSString *email = [user objectForKey:@"EMAIL"];
                NSString *headPhoto =[user objectForKey:@"HEAD_PHOTO"];
                NSString *chatGroupName = [user objectForKey:@"CHAT_GROUP_NAME"];
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
                [saveDic  setObject:sysDttm forKey:@"LAST_SYNC_TIME"];
                [saveDic setObject:nickName forKey:@"USER_NICK_NAME"];
                [saveDic setObject:empNumber forKey:@"EMPLOYEE_NUMBER"];
                [saveDic setObject:title forKey:@"TITLE"];
                [saveDic setObject:location forKey:@"LOCATION"];
                [saveDic setObject:email forKey:@"EMAIL"];
                [saveDic setObject:phoneNumer forKey:@"PHONE_NUMBER"];
                [saveDic setObject:headPhoto forKey:@"HEAD_PHOTO"];
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
                
                [saveDic setObject:lastSessionPerson forKey:@"LAST_SESSION_PERSON"];
                [saveDic setObject:isGroup forKey:@"IS_GROUP"];
                [saveDic setObject:chatGroupImage forKey:@"CHAT_GROUP_IMAGE"];
                [saveDic setObject:barCode forKey:@"LASTUPD_DATE"];
                [saveDic setObject:filePath forKey:@"FILE_PATH"];
                [saveDic setObject:lastUpdPerson forKey:@"LASTUPD_PERSON"];
                [saveDic setObject:lastSessionDate forKey:@"LAST_SESSION_DATE"];
                [saveDic setObject:lastUpdSession forKey:@"LAST_UPDATE_SESSION"];
                [saveDic setObject:chatGroupInfo forKey:@"CHAT_GROUP_INFO"];
                
                [tempArr addObject:saveDic];
                groupId = chatGroupId ;
            }
        }
        //send newMember消息
        NSString *deviceId = [CommUtilHelper getDeviceId];
         NSString *sID = [[CommUtilHelper sharedInstance] createDiffUUID];
        //[[ChatViewController sharedInstance] sendMsg:[NSDictionary dictionaryWithObjectsAndKeys:groupId,@"groupid",[[CommUtilHelper sharedInstance] getUser],@"from",[CommUtilHelper getDeviceId],@"deviceId", nil] Event:@"newMember"];
        
        [[ChatViewController sharedInstance] sendMsg:[NSDictionary dictionaryWithObjectsAndKeys:groupId,@"groupid",[[CommUtilHelper sharedInstance] getUser],@"from",deviceId,@"deviceId",@"You can start chat now.",@"msg",@"A",@"msgType",sID,@"sId", nil] Event:@"newMember"];
        
        
        [self.navigationController popToRootViewControllerAnimated:NO];
        
        [[ChatViewController sharedInstance].tabBarController setSelectedIndex:0];
        [[eChatDAO sharedChatDao] insertGroupPerson:tempArr];
        [[eChatDAO sharedChatDao] insertChatGroup:tempArr];
        ChatMessageViewController *cv = [ChatMessageViewController shareInstance] ;
        cv.groupId = groupId;
        cv.nickName = [[CommUtilHelper sharedInstance] getNickName];
        cv.groupTitle = [contactUserDic objectForKey:@"SAM_ACCOUNT_NAME" ];
        cv.navigationItem.title= cv.groupTitle;
        [[ChatViewController sharedInstance].tabBarController.tabBar setHidden:YES];
        [[ChatViewController sharedInstance].navigationController pushViewController:cv animated:YES];
    });
}
//
-(void)addContactUser
{
    NSString *contactUser = [NSString stringWithFormat:@"'%@'",[contactUserDic objectForKey:@"USER_PRINCIPAL_NAME" ]];
    NSDictionary *myUserDic =  [[CommUtilHelper sharedInstance] GetNativeUserInfo];
    NSString *myUser = [myUserDic objectForKey:@"user"];
    ResponseModel *rs = [[ContactNetServiceUtil sharedInstance] addFrineds:contactUser From:myUser];
    NSMutableArray *arr = rs.resultInfo;
    dispatch_async(dispatch_get_main_queue(), ^(void){
        [loadingView removeFromSuperview];
        if (rs.error !=nil) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Prompt" message:@"Network Error" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alertView show];
            return ;
        }
        if (arr  && [arr count] >0) {
            NSDictionary *dic = [arr objectAtIndex:0];
            NSString *sysDttm = [dic objectForKey:@"SYSDTTM"];
            NSMutableArray *chatUserArr = [NSMutableArray array];
            NSMutableArray *chatAdUserArr = [NSMutableArray array];
            if (sysDttm && ![@"" isEqualToString:sysDttm]) {
                for (int i=0; i<[arr count]; i++) {
                    NSMutableDictionary *chatUsersaveDic = [NSMutableDictionary dictionary ];
                     NSMutableDictionary *chatAdSaveDic = [NSMutableDictionary dictionary ];
                    [chatAdSaveDic setObject:[contactUserDic objectForKey:@"USER_PRINCIPAL_NAME" ]  forKey:@"USER_PRINCIPAL_NAME"];
                    [chatAdSaveDic setObject:[contactUserDic objectForKey:@"USER_PRINCIPAL_NAME" ] forKey:@"FREQUENT_CONTACT_USER"];
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
                    if ([@"N" isEqualToString:[dic objectForKey:@"LOGIN_STATUS"]]) {
                        self.contactCommunicationView.messageCommunicationButton.hidden = YES;
                    }
                    NSString *image =  [[CommUtilHelper sharedInstance] changeNullToStr: [dic objectForKey:@"HEAD_PHOTO"]];
                    NSString *image2 =  [[CommUtilHelper sharedInstance] changeNullToStr:[dic objectForKey:@"HEAD_PHOTO2"]];
                    NSString *image3 =  [[CommUtilHelper sharedInstance] changeNullToStr:[dic objectForKey:@"HEAD_PHOTO3"]];
                    NSString *image4 =  [[CommUtilHelper sharedInstance] changeNullToStr:[dic objectForKey:@"HEAD_PHOTO4"]];
                    NSString *image5 =  [[CommUtilHelper sharedInstance] changeNullToStr:[dic objectForKey:@"HEAD_PHOTO5"]];
                    NSString *commbineImage = [NSString stringWithFormat:@"%@%@%@%@%@",image,image2,image3,image4,image5];
                    NSString *HEAD_PHOTO = [[CommUtilHelper sharedInstance] saveImageToPath:commbineImage];
                    [chatAdSaveDic setObject:HEAD_PHOTO forKey:@"HEAD_PHOTO"];
                    //[chatAdSaveDic setObject:[dic objectForKey:@"HEAD_PHOTO"] forKey:@"HEAD_PHOTO"];
                    [chatAdSaveDic setObject:@"N" forKey:@"DISABLED"];
                    
  
                     [chatUsersaveDic setObject:[contactUserDic objectForKey:@"USER_PRINCIPAL_NAME" ] forKey:@"FREQUENT_CONTACT_USER"];
                    [chatUsersaveDic setObject:[dic objectForKey:@"SAM_ACCOUNT_NAME"] forKey:@"USER_NICK_NAME"];
                    [chatUsersaveDic setObject:[dic objectForKey:@"DISPLAY_NAME"] forKey:@"USER_DISPLAY_NAME"];
                    [chatUsersaveDic setObject:[dic objectForKey:@"SYSDTTM"] forKey:@"LAST_SYNC_TIME"];
                    [chatUsersaveDic setObject:@"N" forKey:@"DISABLED"];
                     [chatUsersaveDic setObject:[contactUserDic objectForKey:@"USER_PRINCIPAL_NAME" ]  forKey:@"USER_PRINCIPAL_NAME"];
                    [chatUsersaveDic setObject:myUser  forKey:@"USER_PRINCIPAL_NAME"];
                    [chatUserArr addObject:chatUsersaveDic];
                    [chatAdUserArr addObject:chatAdSaveDic];
                }
                [[eChatDAO sharedChatDao] insertChatUser:chatUserArr];
                [[eChatDAO sharedChatDao] insertChatAdUser:chatAdUserArr];
                [_contactCommunicationView.messageCommunicationButton setTitle:@"Send Message" forState:UIControlStateNormal];
                _contactCommunicationView.messageCommunicationButton.tag = isSendButtonTag;
            }else
            {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Prompt" message:@"Add Falied" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [alertView show];
                
            }
        }
    });
}
#pragma mark - Propertys

- (XHContactView *)contactUserInfoView {
    if (!_contactUserInfoView) {
        _contactUserInfoView = [[XHContactView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), kXHAlbumAvatorSpacing * 2 + kXHContactAvatorSize)];
    }
    _contactUserInfoView.displayContact = self.contact;
    return _contactUserInfoView;
}

- (XHContactCommunicationView *)contactCommunicationView {
    if (!_contactCommunicationView) {
        _contactCommunicationView = [[XHContactCommunicationView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), (kXHContactButtonHeight + kXHContactButtonSpacing) * 2)];
        _contactCommunicationView.backgroundColor = [UIColor clearColor];
        
        [_contactCommunicationView.messageCommunicationButton addTarget:self action:@selector(messageCommunicationButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    //判断是否好友
    _contactCommunicationView.messageCommunicationButton.tag = isAddContactUserTag;
    if (contactUserDic) {
        NSString *frequentContactUser = [contactUserDic objectForKey:@"friend"];
        if (frequentContactUser && ![frequentContactUser isEqualToString:@""]) {
            [_contactCommunicationView.messageCommunicationButton setTitle:@"Send Message" forState:UIControlStateNormal];
            _contactCommunicationView.messageCommunicationButton.tag = isSendButtonTag;
        }
    }

    return _contactCommunicationView;
}

#pragma mark - DataSource

- (void)loadDataSource {
    self.dataSource = (NSMutableArray *)@[self.contact.ContactTitile==nil?@"":self.contact.ContactTitile,self.contact.contactRegion==nil?@"":self.contact.contactRegion, self.contact.contactEmail==nil?@"":self.contact.contactEmail, self.contact.contactPhone==nil?@"":self.contact.contactPhone];
}

#pragma mark - Life Cycle
- (instancetype)initWithContact:(XHContact *)contact UserDic:(NSDictionary *)dic isNatvie:(BOOL)_isNative {

     self = [super init];
    if (self) {
        self.tableViewStyle = UITableViewStyleGrouped;
        self.contact = contact;
        self.contactUserDic =dic;
        isNative =_isNative;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //self.title = self.contact.contactName;
    self.title=@"Infomation";
    //如果是自己，则显示按钮
    if([[[CommUtilHelper sharedInstance] getUser] isEqualToString:self.contact.contactUser])
    {
        self.contactCommunicationView.messageCommunicationButton.hidden = YES;
    }
    if ([@"N" isEqualToString:self.contact.contactLoginStatus]){
       BOOL isFriend = [[eChatDAO sharedChatDao] isFriend:self.contact.contactUser];
        if (isNative) {
            self.contactCommunicationView.messageCommunicationButton.hidden = YES;
        }
        
        if (isFriend) {
            self.contactCommunicationView.messageCommunicationButton.hidden = YES;
        }
        
    }
    //
    self.tableView.tableHeaderView = self.contactUserInfoView;
    self.tableView.tableFooterView = self.contactCommunicationView;
    [self loadDataSource];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cellIdentifier";
    XHContactPhotosTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[XHContactPhotosTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        
        [cell.imageView setFrame:CGRectMake(0, 0, 40, 40)];
        [cell.imageView.layer setCornerRadius:CGRectGetHeight([cell.imageView bounds]) / 2];
        cell.imageView.layer.masksToBounds = YES;
        cell.imageView.layer.borderColor = [[UIColor whiteColor] CGColor];
        cell.imageView.backgroundColor = [UIColor whiteColor];
        //cell.imageView.layer.shadowColor = [UIColor grayColor].CGColor;
        //cell.imageView.layer.shadowOffset = CGSizeMake(4, 4);
        //cell.imageView.layer.shadowOpacity = 0.5;
        //cell.imageView.layer.shadowRadius = 2.0;
        //cell.imageView.layer.borderWidth = 2.0f;
    }
    [cell configureCellWithContactInfo:self.dataSource[indexPath.row] atIndexPath:indexPath];
    
    return cell;
}

#pragma mark - UITableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 3) {
        return 80;
    } else {
        return 44;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}




@end
