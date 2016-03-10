//
//  ContactViewController.m
//  Chart
//
//  Created by hwpl hwpl on 14-10-28.
//  Copyright (c) 2014年 hwpl hwpl. All rights reserved.
//
//#import "XHContactDetailTableViewController.h"
#import "XHContactTableViewCell.h"
#import "ContactViewController.h"
#import "CustomLoadingView.h"
#import "eChatDAO.h"
#import "CommUtilHelper.h"
#import "SearchContactViewController.h"
#import "ResponseModel.h"
#import "ContactNetServiceUtil.h"
#import "UserContactInfoViewController.h"
#import "HeadPhotoDisViewController.h"
@interface ContactViewController ()<UIGestureRecognizerDelegate,ContactTableViewImageDelegate>
{

    UIView *loadingView;
    BOOL isLeft;//是否滑动
    NSInteger sendInteger;
}
- (BOOL)validataWithContact:(XHContact *)contact;
@end

@implementation ContactViewController

- (void)viewDidLoad {
    self.isShowingSearchBar=NO;
    [super viewDidLoad];
    //self.navigationController.navigationBar.barTintColor=[CommUtilHelper getDefaultBackgroupColor];
    //self.navigationController.navigationBar.translucent=YES;
    //self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
       self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    self.navigationItem.title=@"Contacts";
    [self.view setBackgroundColor:[UIColor grayColor]];
    self.navigationController.navigationBar.barTintColor=kGetColor(248, 248, 248);
    //[self.navigationController.navigationBar setTintColor:[UIColor blueColor]];
    //[self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [self.tableView setBackgroundColor:[UIColor whiteColor]];
    self.tableViewStyle = UITableViewStyleGrouped;
    [[CommUtilHelper sharedInstance] setExtraCellLineHidden:self.tableView type:@"1" ];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(showAddContactUser)];
   // Do any additional setup after loading the view.
}
-(void)showAddContactUser
{
    [self.tabBarController.tabBar setHidden:YES];
    SearchContactViewController *sContact = [[SearchContactViewController alloc] init];
    [self.navigationController pushViewController:sContact animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden=NO;
    [self loadDataSource];
}

- (void)loadDataSource {
    self.sectionIndexTitles = [UILocalizedIndexedCollation.currentCollation sectionIndexTitles];
    //
    NSMutableArray *userArr = [self getContactConfigureArray];
    self.dataSource = userArr;
    [self.tableView reloadData];
    if(userArr){
        UILabel *lblTotl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 28)];
        lblTotl.textAlignment = NSTextAlignmentCenter;
        [lblTotl setTextColor:kGetColorAl(0, 0, 0, 0.53)];
        [lblTotl setFont:[UIFont systemFontOfSize:12]];
        [lblTotl setBackgroundColor:[UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1]];
        lblTotl.text = [[NSString stringWithFormat:@"%lu", userArr.count] stringByAppendingString:@" Contacts"];
        [self.tableView setTableFooterView:lblTotl];
    }
}

- (NSMutableArray *)getContactConfigureArray {
    
    NSDictionary *user = [[CommUtilHelper sharedInstance] GetNativeUserInfo];
    NSMutableArray *contacts = [[eChatDAO sharedChatDao] getNatvieContact:[user objectForKey:@"user"]];
    NSMutableArray *resourceArr=[NSMutableArray array];
    NSString *tempName = @"";
    for (int i = 0; i < [contacts count]; i ++) {
        XHContact *contact = [[XHContact alloc] init];
        NSDictionary *userDic = [contacts objectAtIndex:i];
        NSString *user =[userDic objectForKey:@"USER"];
        if ([tempName isEqualToString:user]) {
            continue;
        }
        //contact.contactName = [userDic objectForKey:@"NickName"];
        contact.contactUser =[userDic objectForKey:@"USER"];
        contact.contactName = [userDic objectForKey:@"COMMON_NAME"];
        contact.contactLoginStatus=[userDic objectForKey:@"LOGIN_STATUS"];
        NSString *imageName = [userDic objectForKey:@"HeadPhoto"] ;
        if (imageName) {
            UIImage *im =[[CommUtilHelper sharedInstance] getImageByImageName:imageName Size:CGSizeMake(40, 40)];
            if (im) {
                contact.headImage =im;
            }else
            {
                contact.headImage=[UIImage imageNamed:@"default2x@2x.png"];
            }
        }
       // contact.
        tempName =user;
        [resourceArr addObject:@[contact]];
    }
    
    return resourceArr;
}

-(void)handHeadTap:(UIGestureRecognizer *)getsture
{
   
}

#pragma mark - UITableView DataSource


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
     NSString *cellIdentifier =  [@"contactTableViewCellIdentifier_" stringByAppendingString:[NSString stringWithFormat:@"%li",(long)indexPath.section]];
    XHContactTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell){
        cell = [[XHContactTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        [cell.imageView.layer setCornerRadius:CGRectGetHeight([cell.imageView bounds]) / 2];
        cell.imageView.layer.masksToBounds = YES;
        cell.imageView.layer.borderColor = [[UIColor whiteColor] CGColor];
        cell.imageView.backgroundColor = [UIColor whiteColor];
        cell.delegate=self;
        cell.tag  =indexPath.section;
        //[cell.imageView addGestureRecognizer:getstur];
    }
    [cell.textLabel setFont:[UIFont systemFontOfSize:14]];
    cell.indexPath=indexPath;
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    NSArray *contacts;
    XHContact *contact;
    // 判断是否是搜索tableView
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        // 获取联系人数组
        contacts = self.filteredDataSource;
        // 判断数组越界问题
        if (row < contacts.count) {
            contact = contacts[row];
            
            if ([self validataWithContact:contact]) {
                [cell configureContact:contact inContactType:XHContactTypeFilter searchBarText:[self getSearchBarText]];
            }
        }
    } else {
        // 默认通信录的tableView
        if (section < self.dataSource.count) {
            // 获取联系人数组
            contacts = self.dataSource[section];
            
            // 判断数组越界问题
            if (row < [contacts count]) {
                contact = contacts[row];
                
                if ([self validataWithContact:contact]) {
                    [cell configureContact:contact inContactType:XHContactTypeNormal searchBarText:nil];
                }
            }
        }
    }
    [cell.textLabel setTextColor:[UIColor clearColor]];
    if ([@"N" isEqualToString: contact.contactLoginStatus] ) {
        [cell.textLabel setTextColor:[UIColor lightGrayColor]];
        cell.btnSendEmail.hidden = NO;
    }else
    {
       [cell.textLabel setTextColor:[UIColor blackColor]];
         cell.btnSendEmail.hidden = YES;
    }
    tableView.separatorInset=UIEdgeInsetsZero;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 55;
}

-(void)deleteContactUser:(NSIndexPath *)indexPath
{
    
    NSArray *contacts =  self.dataSource[indexPath.section];
    XHContact *contact = contacts[indexPath.row];
    NSDictionary *myUser = [[CommUtilHelper sharedInstance] GetNativeUserInfo];
    
    ResponseModel *rs = [[ContactNetServiceUtil sharedInstance] deleteFrineds:contact.contactUser  From:[myUser objectForKey:@"user"]];
    NSString *result =rs.resultInfo;
    dispatch_async(dispatch_get_main_queue(), ^(void){
        [loadingView removeFromSuperview];
        if (rs.error !=nil) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Prompt" message:@"Can not connect server" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alertView show];
            return;
        }
        if ([@"1" isEqualToString:result]) {
            [self.dataSource removeObjectAtIndex:[indexPath section]];
            //[self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationTop];
            
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationTop];

            [[eChatDAO sharedChatDao] deleteChatUser:contact.contactUser];
            
        }else
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Prompt" message:@"Delete Failed" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alertView show];
        }
    });
    
    
}
#pragma mark - Contact Helper Method

- (BOOL)validataWithContact:(XHContact *)contact {
    return (contact && [contact isKindOfClass:[XHContact class]] && contact.contactName);
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
     if (tableView == self.searchDisplayController.searchResultsTableView) {
         return NO;
     }else
     {
         //isLeft = YES;
         return YES;
     }
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
    }else
    {
        NSArray *contacts =  self.dataSource[indexPath.section];
        XHContact *userContact = contacts[indexPath.row];
       
        NSMutableArray *arr = [[eChatDAO sharedChatDao] getUserInfo:userContact.contactUser];
        for (NSMutableDictionary *dic in arr) {
            XHContact *contact = [[XHContact alloc] init];
            if ([dic objectForKey:@"HEAD_PHOTO"]) {
                
                contact.headImage =userContact.headImage;
            }
            contact.contactUser = [dic objectForKey:@"USER_PRINCIPAL_NAME"];
            contact.contactName = [dic objectForKey:@"COMMON_NAME"];
            contact.ContactTitile = [dic objectForKey:@"TITLE"];
            contact.contactRegion = [dic objectForKey:@"LOCATION"];
            contact.contactEmail = [dic objectForKey:@"EMAIL"];
            contact.contactPhone =[dic objectForKey:@"PHONE"];
             contact.contactLoginStatus =[dic objectForKey:@"LOGIN_STATUS"];
            
            [dic setObject:userContact.contactUser forKey:@"friend"];
            [dic setObject:userContact.contactUser forKey:@"USER_PRINCIPAL_NAME"];
            UserContactInfoViewController *infoCon = [[UserContactInfoViewController alloc] initWithContact:contact UserDic:dic isNatvie:YES];
            
            [infoCon.navigationItem.backBarButtonItem setTintColor:[UIColor clearColor]];
            [infoCon.navigationItem.backBarButtonItem  setTintColor:[UIColor whiteColor]];
            [self.tabBarController.tabBar setHidden:YES];
            [self.navigationController pushViewController:infoCon animated:YES];
        }
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
 return @"Delete";
}
-(void)tableView:(UITableView *)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    isLeft = NO;
    
}
-(void)tableView:(UITableView *)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    isLeft = YES;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    isLeft = NO;
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //删除好友
        loadingView = [[CustomLoadingView alloc] getLoaidngViewByText:@"" Frame:self.view.frame];
        [self.view addSubview:loadingView];
        [NSThread detachNewThreadSelector:@selector(deleteContactUser:) toTarget:self withObject:indexPath];
        //[self.dataSource removeObjectAtIndex:[indexPath row]];
        //[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationTop];
    }
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark -gestureReconinzer delegate
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
//    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
//        return NO;
//    }
    return YES;
}



-(void)ImageViewTapGesture:(NSInteger)index
{
    NSArray *contacts =  self.dataSource[index];
    if ([contacts count]>0) {
         XHContact *userContact = contacts[0];
         NSString *contactUser = userContact.contactUser;
         HeadPhotoDisViewController *headPhotoDisViewCon = [[HeadPhotoDisViewController alloc] init];
         [headPhotoDisViewCon loadHeadPohtoImageFromUser:contactUser groupId:nil];
        
        [headPhotoDisViewCon setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:headPhotoDisViewCon animated:YES];
    }
   

}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag ==2001) {
        if (buttonIndex == 0) {
            NSArray *contacts =  self.dataSource[sendInteger];
            if ([contacts count]>0) {
                loadingView = [[CustomLoadingView alloc] getLoaidngViewByText:@"inviting..." Frame:self.view.frame];
                [self.view addSubview:loadingView];
                XHContact *userContact = contacts[0];
                NSString *contactUser = userContact.contactUser;
                
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^(void){
                    
                    ResponseModel *rs = [[ContactNetServiceUtil sharedInstance] inviteUserFrom:[[CommUtilHelper sharedInstance] getUser] ToUser:contactUser];
                    NSDictionary *result =rs.resultInfo;
                    dispatch_async(dispatch_get_main_queue(), ^(void){
                        [loadingView removeFromSuperview];
                        if (rs.error !=nil) {
                            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Prompt" message:@"Can not connect server" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                            [alertView show];
                            return;
                        }
                        //NSString *success = [result objectForKey:@"response"];
                        NSString *reSucess = [@"Invitation sent to " stringByAppendingString:userContact.contactName];
                        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:reSucess delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                        [alertView show];
                    });
                    
                });
 
            }

        }
    }
}
-(void)advriteFriend:(NSInteger)index
{
    if (isLeft) {
        return;
    }
    
    NSArray *contacts =  self.dataSource[index];
    XHContact *userContact = nil;
    if ([contacts count]>0) {
        userContact = contacts[0];
        
    }
    sendInteger=index;
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Confirm" message:[NSString stringWithFormat:@"Do you want to send an invitation to %@",userContact.contactName] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Cancel", nil];
    alertView.tag = 2001;
    [alertView show];
    
}


@end

