//
//  MessageInfoSettingViewController.m
//  HwpgMobile
//
//  Created by hwpl hwpl on 14-11-26.
//  Copyright (c) 2014年 hwpl hwpl. All rights reserved.
//
#define numnerRows 4
#define rowHeight 80
#define buttonTag 3800
#import "MessageInfoSettingViewController.h"
#import "UIGridViewLayOutCell.h"
#import "eChatDAO.h"
#import "CommUtilHelper.h"
#import "ResponseModel.h"
#import "ContactNetServiceUtil.h"
#import "CustomLoadingView.h"
#import "AddContactUserViewController.h"
#import "ManageNetServiceUitl.h"
#import "XHContact.h"
#import "UserContactInfoViewController.h"
#import "HeadImageCropper.h"

@interface MessageInfoSettingViewController ()
{
    NSMutableArray *contactArr;
    BOOL isDelete;
    UIView *loadingView;
    UIButton *actionButton;
    BOOL isFirsLoad ;
    BOOL isCretePerson;
    UIView *chatGroupNameView;
    UITextField *textField;
    NSString *headImagePath;
    HeadImageCropper *imageCropper;
    int tipTag;
    NSString *cretePerson;
}
@end

@implementation MessageInfoSettingViewController
@synthesize gridView;
@synthesize groupId;
@synthesize chatGroupName;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor grayColor]];
    isDelete = NO;
    isFirsLoad = YES;
    [self reloadView];
    
//    if (contactArr) {
//        [gridView setFrame:CGRectMake(0, 5, navBarWidth, navBarHeight)];
//    }
    // Do any additional setup after loading the view.
    //从本地数据库取得头像文件路径
    NSMutableArray *chatGroupArr = [[eChatDAO sharedChatDao] getChatGroup:self.groupId];
    if(chatGroupArr && chatGroupArr.count >0) {
        headImagePath =[chatGroupArr[0] objectForKey:@"HEAD_PHOTO"];
    }
    //
    imageCropper = [HeadImageCropper sharedImageCropper:self CanTap:YES GroupId:self.groupId];
}
-(void)reloadView
{
    if (isFirsLoad) {
        gridView =[[UIGridView alloc] initWithFrame:CGRectMake(0, 0, screenWidth,screenHeight) style:UITableViewStyleGrouped];
    }else
    {
     gridView =[[UIGridView alloc] initWithFrame:CGRectMake(0, navBarHeight, screenWidth,screenHeight) style:UITableViewStyleGrouped];
    }
    
    gridView.uiGridViewDelegate=self;
    gridView.uiGridViewDelegate=self;
    
    [gridView setBackgroundColor:kGetColor(232, 232, 232)];
    gridView.tableFooterView=[self getDeleteAction];
    //
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 30)];
    [headerView setBackgroundColor:[UIColor whiteColor]];
    UILabel *lblTableTitle=[[UILabel alloc] initWithFrame:CGRectMake(15, 8, 200, 20)];
    lblTableTitle.text = @"Group Members";
    
    //[lblTableTitle setBackgroundColor:[UIColor whiteColor]];
    [headerView addSubview:lblTableTitle];
    gridView.tableHeaderView = headerView;
    //
    [self.view addSubview:gridView];
    [gridView reloadData];
}
//
-(void)addContactUserReloadData:(NSMutableArray *)arr
{
    
}
//
-(void)viewWillAppear:(BOOL)animated
{
    contactArr=[self getContactUser];
    isCretePerson = NO;
    
    if ([contactArr count]>0) {
        NSDictionary *creDic = [contactArr objectAtIndex:0];
        cretePerson = [creDic objectForKey:@"CretePerson"];
        if ([[[[CommUtilHelper sharedInstance] GetNativeUserInfo] objectForKey:@"user"] isEqualToString:cretePerson]) {
            isCretePerson=YES;
        }
    }
    self.navigationItem.title = [[@"Setting(" stringByAppendingString:[NSString stringWithFormat:@"%lu",(unsigned long)[contactArr count]]] stringByAppendingString:@")"];
    [gridView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSMutableArray *)getContactUser
{
    NSDictionary *user = [[CommUtilHelper sharedInstance] GetNativeUserInfo];
    return [[eChatDAO sharedChatDao] getAllGroupUserByGroupId:groupId CurrUser:[user objectForKey:@"user"]];
    
}
                                 
-(NSInteger) getMaxRow
{
    return ((int)([contactArr count]+2)/numnerRows)+1;
}
-(float)getMaxHeight
{
    return [self getMaxRow]*rowHeight;
}
-(NSInteger)getMaxCount
{
    if (isCretePerson) {
         return [contactArr count]+2;
    }else
    {
     return [contactArr count]+1;
    }
   
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (CGFloat) gridView:(UIGridView *)grid widthForColumnAt:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return rowHeight;
    }else
    {
        return screenWidth;
    }
 }

- (CGFloat) gridView:(UIGridView *)grid heightForRowAt:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 90;
    }else if(indexPath.section == 2){
        return 60;
    }else
    {
        return 48;
    }
    
}

-(NSInteger)numberOfSection:(UITableView *)tableView
{
    return 3;
}
-(NSInteger)numberOfRwosInSection:(UITableView *)tableView
{
    return 2;
}
- (NSInteger) numberOfColumnsOfGridView:(UIGridView *) grid
{
    return numnerRows;
}


- (NSInteger) numberOfCellsOfGridView:(UIGridView *) grid
{
    
    return [self getMaxCount];
}

-(void)reloadSections:(NSIndexSet *)indexSet
{
  
}
//
- (UIGridViewCell *) gridView:(UIGridView *)grid cellForRowAt:(int)rowIndex AndColumnAt:(int)columnIndex IndexPath:(NSIndexPath *)indexPath
{
    UIGridViewLayOutCell *cell = (UIGridViewLayOutCell *)[grid dequeueReusableCell];
    [cell.label setFont:[UIFont systemFontOfSize:14]];
    if (cell == nil) {
        cell = [[UIGridViewLayOutCell alloc] init];
    }
    if (isCretePerson) {
        if (  (rowIndex*4+columnIndex)==( [self getMaxCount]-2)) {
            
            cell.thumbnail.image = [UIImage imageNamed:@"gs-plus.png"];
            return cell;
        }else if((rowIndex*4+columnIndex)==[self getMaxCount]-1)
        {
            cell.thumbnail.image = [UIImage imageNamed:@"gs-minus.png"];
            return cell;
        }
    }
    else
    {
        if (  (rowIndex*4+columnIndex)==( [self getMaxCount]-1)) {
            
            cell.thumbnail.image = [UIImage imageNamed:@"gs-plus.png"];
            return cell;
        }
    }
    NSInteger count = rowIndex*numnerRows+columnIndex;
    NSDictionary *dic = [contactArr objectAtIndex:count];
    
    cell.label.text = [dic objectForKey:@"NickName"];
    NSString *_filePath = [[CommUtilHelper sharedInstance] dataImagePath:[dic objectForKey:@"HeadPhoto"] ];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    UIImage *img= nil;
    if ([fileManager fileExistsAtPath:_filePath]) {
        NSData *d = [[NSData alloc] initWithContentsOfFile:_filePath];
        UIImage *im = [[UIImage alloc] initWithData:d];
        
        if (im) {
            img =[[[XHPhotographyHelper alloc] init] imageWithImage:im scaledToSize:CGSizeMake(60, 60)];
        }
    }
    
    UIImage *headImage =img;
    if (headImage) {
        cell.thumbnail.image = headImage;
    }else
    {
        cell.thumbnail.image = [UIImage imageNamed:@"default2x@2x.png"];
        
    }
    cell.deleteButton.tag =buttonTag+ rowIndex*4+columnIndex;
    
    if ([[dic objectForKey:@"USER"] isEqualToString:[[CommUtilHelper sharedInstance] getUser] ]) {
        tipTag =buttonTag+ rowIndex*4+columnIndex;;
    }
    [cell.deleteButton setHidden:YES];
    [cell.deleteButton addTarget:self action:@selector(deleteContactAction:) forControlEvents:UIControlEventTouchUpInside];
    [cell.deleteButton setUserInteractionEnabled:YES];
    if (isDelete){
        if (![[dic objectForKey:@"USER"] isEqualToString:[[CommUtilHelper sharedInstance] getUser] ]) {
            
            [cell.deleteButton setHidden:NO];
        }
       
    }else
    {
        [cell.deleteButton setHidden:YES];
    }
    //[cell.deleteButton setTitle:[NSString stringWithFormat:@"%i",rowIndex*4+columnIndex] forState:UIControlStateNormal];
    [cell.deleteButton setBackgroundImage:[UIImage imageNamed:@"ico-remove.png"] forState:UIControlStateNormal];
    return cell;
}
//
- (void) gridView:(UIGridView *)grid didSelectRowAt:(int)rowIndex AndColumnAt:(int)colIndex Cell:(UIGridViewCell *)cell
{
    int index =rowIndex*4+colIndex;
    if (isCretePerson) {
        if (index ==[self getMaxCount]-2) {//表示新增成员
            AddContactUserViewController *av =[[AddContactUserViewController alloc] init];
            av.groupId=groupId;
            isDelete = YES;
            [self SetDeleButtonHidden];
            [self.navigationController pushViewController:av animated:YES];
        }else if(index ==[self getMaxCount]-1)//表示删除某个成员
        {
            [self SetDeleButtonHidden];
            
        }else
        {
            [self didSelectHeadCellInfoIndex:index];
        }
    }else
    {
        if (index ==[self getMaxCount]-1) {//表示新增成员
            AddContactUserViewController *av =[[AddContactUserViewController alloc] init];
            av.groupId=groupId;
            isDelete = YES;
            [self SetDeleButtonHidden];
            [self.navigationController pushViewController:av animated:YES];
        }else
        {
            [self didSelectHeadCellInfoIndex:index];
        }
    }
    
}
//
-(void)didSelectHeadCellInfoIndex:(NSInteger)index
{
    NSDictionary *tempdic = [contactArr objectAtIndex:index];
    NSString *selectUser = [tempdic objectForKey:@"USER"];
    NSMutableArray *arr = [[eChatDAO sharedChatDao] getUserInfo:selectUser];
    XHContact *contact = [[XHContact alloc] init];
    for (NSMutableDictionary *dic in arr) {
        if ([dic objectForKey:@"HEAD_PHOTO"]) {
            NSString *_filePath = [[CommUtilHelper sharedInstance] dataImagePath:[dic objectForKey:@"HEAD_PHOTO"] ];
            NSFileManager *fileManager = [NSFileManager defaultManager];
            if ([fileManager fileExistsAtPath:_filePath]) {
                NSData *fileData = [[NSData alloc] initWithContentsOfFile:_filePath];
                UIImage *img = [[UIImage alloc] initWithData:fileData];
                if (img) {
                    contact.headImage =[[[XHPhotographyHelper alloc] init] imageWithImage:img scaledToSize:CGSizeMake(60, 60)];
                }
                else
                {
                    contact.headImage = [UIImage imageNamed:@"default2x@2x.png"];
                }
            }
        }
        contact.contactUser =[dic objectForKey:@"USER_PRINCIPAL_NAME"];
        contact.contactName = [dic objectForKey:@"SAM_ACCOUNT_NAME"];
        contact.ContactTitile = [dic objectForKey:@"TITLE"];
        contact.contactRegion = [dic objectForKey:@"LOCATION"];
        contact.contactEmail = [dic objectForKey:@"EMAIL"];
        contact.contactPhone =[dic objectForKey:@"PHONE"];
        contact.contactLoginStatus =[dic objectForKey:@"LOGIN_STATUS"];
        if ([[eChatDAO sharedChatDao] isFriend:selectUser]) {
            [dic setObject:selectUser forKey:@"friend"];
        }else
        {
            [dic setObject:@"" forKey:@"friend"];
        }
        [dic setObject:selectUser forKey:@"USER_PRINCIPAL_NAME"];
        UserContactInfoViewController *infoCon = [[UserContactInfoViewController alloc] initWithContact:contact UserDic:dic isNatvie:YES];
        UIBarButtonItem *temporaryBarButtonItem=[[UIBarButtonItem alloc] init];
        temporaryBarButtonItem.title=@"";
        self.navigationItem.backBarButtonItem = temporaryBarButtonItem;
        [self.tabBarController.tabBar setHidden:YES];
        [self.navigationController pushViewController:infoCon animated:YES];
    }
}
-(void)SetDeleButtonHidden
{
    
    if (isDelete) {
        isDelete=NO;
    }else
    {
        isDelete=YES;
    }
    for (int i=0; i<[self getMaxCount]; i++) {
        UIButton *b = (UIButton *)[self.view viewWithTag:buttonTag+i];
        
        if (buttonTag+i==tipTag)
            continue;
        if (isDelete)
            b.hidden=NO;
        else
            [b setHidden:YES];
        
    }
}

- (UITableViewCell *) gridView:(UITableView *)tableview  otherIndexPath:(NSIndexPath *)indexPath Identifer:(NSString *)identifer
{
    if (indexPath.section ==1) {
        UITableViewCell *cell =  [tableview dequeueReusableCellWithIdentifier:identifer];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifer];
            
        }
        [cell.textLabel setFont:[UIFont systemFontOfSize:14]];
        [cell setBackgroundColor:kGetColor(255, 255, 255)];
        if (indexPath.row == 0) {
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.text= @"Group Name";
            cell.detailTextLabel.text = chatGroupName;
        }else if(indexPath.row ==1)
        {
            cell.accessoryType=UITableViewCellAccessoryNone;
            cell.textLabel.text= @"Administrator";
            if (cretePerson !=nil) {
                NSString *name =  [[cretePerson componentsSeparatedByString:@"@"] objectAtIndex:0];
                NSArray *arr = [name componentsSeparatedByString:@"."];
                if ([arr count]>1) {
                     cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ %@",[arr objectAtIndex:0],[arr objectAtIndex:1]];
                }else
                {
                  cell.detailTextLabel.text = [arr objectAtIndex:0];
                }
                
            }
           
        }
        return cell;
    }else if(indexPath.section ==2){
        UITableViewCell *cell =  [tableview dequeueReusableCellWithIdentifier:identifer];
        [cell.textLabel setFont:[UIFont systemFontOfSize:14]];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifer];
            
        }
        
        NSMutableArray *groupArr = [[eChatDAO sharedChatDao] getChatGroup:groupId];
        if ([groupArr count] >0) {
            NSDictionary *groupDic = [groupArr objectAtIndex:0];
            NSString *isGroup = [groupDic objectForKey:@"IS_GROUP"];
             [cell setBackgroundColor:kGetColor(255, 255, 255)];
            if ([@"Y" isEqualToString:isGroup]) {
                
                [cell setBackgroundColor:kGetColor(255, 255, 255)];
                if(indexPath.row == 0){
                    cell.textLabel.text= @"<--Click image to change";
                    NSString *_filePath = [[CommUtilHelper sharedInstance] dataImagePath:headImagePath ];
                    NSFileManager *fileManager = [NSFileManager defaultManager];
                    UIImage *img= nil;
                    if ([fileManager fileExistsAtPath:_filePath]) {
                        NSData *d = [[NSData alloc] initWithContentsOfFile:_filePath];
                        UIImage *im = [[UIImage alloc] initWithData:d];
                        if (im) {
                            
                            UIImage *image= [[CommUtilHelper sharedInstance] getImageByImageName:headImagePath Size:CGSizeMake(40, 40)];
                            img = image;
                        }else
                        {
                            img = [UIImage imageNamed:@"dusers-60.png"];
                        }
                    }else
                    {
                        img = [UIImage imageNamed:@"dusers-60.png"];
                    }
                    
                    cell.imageView.image=img;
                    [imageCropper setImageView:cell.imageView];
                }else{
                    cell.hidden=true;
                }
                return cell;
                
                
            }else
            {
              [cell setBackgroundColor:[UIColor clearColor]];
            }
            
        }
        return cell;
    }
    else
    {
        return nil;
    }
}
//
-(void)tableView:(UITableView *)tableView didSelectIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if (section == 1){
        if (row ==0) {
            //修改群名称
            [self.navigationController.navigationBar setHidden:YES];
            UIView *nagationView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, navBarHeight)];
            [nagationView setBackgroundColor:[UIColor blackColor]];
            [nagationView setAlpha:0.7];
            UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 25, 60, 25)];
            [cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
            [cancelButton addTarget:self action:@selector(dismissView) forControlEvents:UIControlEventTouchUpInside];
            //
            UILabel *titleLable = [[UILabel alloc] initWithFrame:CGRectMake(screenWidth/2-30, 25, 60, 25)];
            titleLable.text=@"Modify title";
            UIButton *saveButton = [[UIButton alloc] initWithFrame:CGRectMake(screenWidth-50, 25, 50, 25)];
            [saveButton setTitle:@"Save" forState:UIControlStateNormal];
            [saveButton addTarget:self action:@selector(threadSaveGroupName) forControlEvents:UIControlEventTouchUpInside];
            [nagationView addSubview:cancelButton];
            [nagationView addSubview:titleLable];
            [nagationView addSubview:saveButton];
            //
             chatGroupNameView  = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
            [chatGroupNameView setBackgroundColor:[UIColor whiteColor]];
            textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 70, chatGroupNameView.frame.size.width, 40)];
            [textField setBorderStyle:UITextBorderStyleRoundedRect];
            //[textField setBackgroundColor:[UIColor lightGrayColor]];
            [textField becomeFirstResponder];
            textField.text=chatGroupName;
            [chatGroupNameView addSubview:nagationView];
            [chatGroupNameView addSubview:textField];
            [self.view addSubview:chatGroupNameView];
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
//
-(void)threadSaveGroupName
{
    NSString *groupName = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (groupName.length == 0 ) {
        return;
    }
    loadingView =[[[CustomLoadingView alloc] init] getLoaidngViewByText:@"Please Waiting..." Frame:self.view.frame];
    [self.view addSubview:loadingView];
    [NSThread detachNewThreadSelector:@selector(saveChatGroupName) toTarget:self withObject:nil];
}
//
-(void)saveChatGroupName
{
    
    NSString *groupName = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
       ResponseModel *rs =  [[ContactNetServiceUtil sharedInstance] saveGroupTitleFun:groupId Name:groupName User:[[CommUtilHelper sharedInstance] getUser]];
        [loadingView removeFromSuperview];
        dispatch_async(dispatch_get_main_queue(), ^(void){
            NSDictionary *dic = rs.resultInfo;
            if (rs.error !=nil) {
                return;
            }
            [textField resignFirstResponder];
            [chatGroupNameView removeFromSuperview];
            if ([dic count]>0) {
                NSString *regroupId= [dic objectForKey:@"groupid"];
                if (regroupId) {
                    ResponseModel *rs = [[ContactNetServiceUtil sharedInstance] checkIsSingleChat:regroupId];
                    NSMutableArray *chatGroupArr = rs.resultInfo;
                    if ([chatGroupArr count]>0) {
                        NSDictionary *dicx = [chatGroupArr objectAtIndex:0];
                        NSString *isGroup = [dicx objectForKey:@"IS_GROUP"];
                        if (![@"Y" isEqualToString:isGroup]) {
                            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Tip" message:@"Can not rename single chat" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                            [alertView show];
                            return;
                        }
                    }
                    [ChatMessageViewController shareInstance].navigationItem.title = groupName;
                    [[eChatDAO sharedChatDao] updateChatGroupName:groupName GroupId:regroupId];
                    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:1];
                    UITableViewCell *cell=  [self.gridView cellForRowAtIndexPath:indexPath];
                    cell.detailTextLabel.text = groupName;
                    chatGroupName = groupName;
                    [ChatMessageViewController shareInstance].groupTitle=groupName;
                    //
                    NSString *sId = [[CommUtilHelper sharedInstance] createDiffUUID];
                    NSString *msg = [[[CommUtilHelper sharedInstance] getCommonName] stringByAppendingFormat:@" changed the group name to %@",groupName];
                    NSDictionary *socketMsgDic = [NSDictionary dictionaryWithObjectsAndKeys:msg,@"msg",regroupId,@"groupid",sId,@"sId",[[CommUtilHelper sharedInstance] getUser],@"from",@"E",@"msgType",groupName,@"groupName",[CommUtilHelper getDeviceId],@"deviceId", nil];
                    [[ChatMessageViewController shareInstance] sendMsg:socketMsgDic Event:@"sendSysMsg"];
                }
            }
        });
    [self.navigationController.navigationBar setHidden:NO];
}
-(void)dismissView
{
    [self.navigationController.navigationBar setHidden:NO];
    [chatGroupNameView removeFromSuperview];
}
-(UIView *)getDeleteAction
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 10, screenWidth, 60)];
    actionButton = [[UIButton alloc] initWithFrame:CGRectMake(20,10,screenWidth-40,50)];
    actionButton.layer.cornerRadius = 4;
    actionButton.backgroundColor = [UIColor colorWithRed:0.263 green:0.717 blue:0.031 alpha:1.000];
    [actionButton setHighlighted:YES];
    [actionButton setTag:100];
    [actionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [actionButton setTitle:@"Delete And Leave" forState:UIControlStateNormal];
    [actionButton addTarget:self action:@selector(deleteAndQuitChatGroup) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:actionButton];
    
    return view;
}
-(void)deleteAndQuitChatGroup
{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"You will no longer receive the message from this group" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"Confirm" otherButtonTitles:@"Cancel", nil];
    sheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [sheet setBackgroundColor:kGetColor(245,245 , 245)];
    [sheet showFromRect:self.view.bounds inView:self.view animated:YES];
}


#pragma actionsheet delege



-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Confirm"]) {
        loadingView = [[CustomLoadingView alloc] getLoaidngViewByText:@"Deleting..." Frame:self.view.frame];
        [self.view addSubview:loadingView];
        [NSThread detachNewThreadSelector:@selector(dropGroupFun) toTarget:self withObject:nil];
    }
}

-(void)dropGroupFun
{
    NSString *myUser=[[CommUtilHelper sharedInstance] getUser];
    ResponseModel *rs= [[ContactNetServiceUtil sharedInstance]deleteMember:myUser From:myUser GroupId:groupId ];
    dispatch_async(dispatch_get_main_queue(), ^(void){
        if (rs.error !=nil) {
            [[CommUtilHelper sharedInstance] showAlertView:@"tip" Message:@"Delete failure" delegate:self];
            return;
        }
        NSString *msg = [[[CommUtilHelper sharedInstance] getNickName] stringByAppendingString:@" left the group chat"];
         NSString *sID = [[CommUtilHelper sharedInstance] createDiffUUID];
        [[ChatMessageViewController shareInstance] sendMsg:[NSDictionary dictionaryWithObjectsAndKeys:myUser,@"from",groupId,@"groupid",myUser,@"user",msg,@"msg",msg,@"msgAll",@"T",@"msgType",[CommUtilHelper getDeviceId],@"deviceId",sID,@"sId", nil] Event:@"delMember"];
        //删除本地信息
        [[eChatDAO sharedChatDao] deleteChatGroup:groupId];
        [[eChatDAO sharedChatDao] deleteGroupSession:groupId];
        [[eChatDAO sharedChatDao] deleteChatUserByGroupId:groupId];
        [self.navigationController popToRootViewControllerAnimated:YES];
        
        [[CommUtilHelper sharedInstance] setMessageCountByGroupId:self.groupId withCount:0 withType:deleteCounter];
        [[CommUtilHelper sharedInstance] setBadageValue];
    });
    
}

-(void)deleteContactAction:(UIButton *)button
{
    loadingView = [[[CustomLoadingView alloc] init]getLoaidngViewByText:@"Deleting..." Frame:self.view.frame];
    [self.view addSubview:loadingView];
//       [contactArr removeObjectAtIndex:button.tag- buttonTag];
//    isDelete=NO;
//    [gridView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
//    NSLog(@"%i",button.tag);
    [NSThread detachNewThreadSelector:@selector(deleteMember:) toTarget:self withObject:button];
    
}
-(void)deleteMember:(UIButton *)button
{
    NSDictionary *dic = [contactArr objectAtIndex:button.tag-buttonTag];
    NSString *deleteUser = [dic objectForKey:@"USER"];
    NSString *deleNickName = [dic objectForKey:@"NickName"];
    NSString *myUser = [[CommUtilHelper sharedInstance] getUser];
    NSString *myCommonUser = [[CommUtilHelper sharedInstance] getCommonName];
    ResponseModel *rs = [[ContactNetServiceUtil sharedInstance] deleteMember:deleteUser From:myUser GroupId:groupId];
    dispatch_async(dispatch_get_main_queue(), ^(void){
        [loadingView removeFromSuperview];
        if (rs.error !=nil) {
            return;
        }
        NSDictionary *redic = rs.resultInfo;
        if ([redic count ]==0) {
            return;
        }
        NSString *msg = [myCommonUser stringByAppendingString:@" removed you from the group chat"];
        NSString *msgAll = [myCommonUser stringByAppendingFormat:@" removed %@ from the group chat",deleNickName];
        NSString *sId = [[CommUtilHelper sharedInstance] createDiffUUID];
        [[ChatMessageViewController shareInstance] sendMsg:[NSDictionary dictionaryWithObjectsAndKeys:myUser,@"from",msgAll,@"msgAll",[CommUtilHelper getDeviceId],@"deviceId",groupId,@"groupid",sId,@"sId", @"T",@"msgType",deleteUser,@"user",msg,@"msg",nil] Event:@"delMember"];
        [[eChatDAO sharedChatDao] deleteChatUserByGroupId:groupId User:deleteUser];
        [contactArr removeObjectAtIndex:button.tag- buttonTag];
        isFirsLoad=NO;
        [gridView removeFromSuperview];
        [self reloadView];
    });
   
}
@end
