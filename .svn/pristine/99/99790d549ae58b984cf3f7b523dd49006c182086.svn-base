//
//  EventViewController.m
//  HPGApp
//
//  Created by hwpl on 16/1/19.
//  Copyright © 2016年 hwpl hwpl. All rights reserved.
//


#import "EventViewController.h"
#import "TestViewController.h"
#import "CharViewNetServiceUtil.h"
#import "ResponseModel.h"
#import  "ChatMessageViewController.h"
#import  "EmotionHelper.h"
#import "AppDelegate.h"
#import "eChatDAO.h"
#import "XHPopMenu.h"
#import "SearchContactViewController.h"
#import "AddChatGroupViewController.h"
#import "AppDelegate.h"
#import "CommUtilHelper.h"
#import "MessageUtilHelper.h"
#import "FormatTime.h"
#import "HeadPhotoDisViewController.h"
#import "PushNotificationUtil.h"
#import "FSMessageViewController.h"
#import "JSON.h"
#import "CiclrImageTableViewCell.h"
static EventViewController *instance= nil;

@interface EventViewController ()<UIAlertViewDelegate>
{
NSMutableArray *userArr;
    
}
@property (nonatomic, strong) XHPopMenu *popMenu;
@end

@implementation EventViewController
@synthesize imagePicker;
@synthesize eventListView;
@synthesize temMsg;
@synthesize popMenu;
@synthesize socketClient;
+(EventViewController *)sharedInstance
{
    @synchronized(self)
    {
        if (instance == nil) {
            instance = [[EventViewController alloc ] init];
        }
    }
    return instance;
}
//
+(void) dealloc{
    instance = nil;
}
//


- (void)viewDidLoad{
    [super viewDidLoad];
    [self SokcetIoContect];
    socketClient.delegate = self;
    
    
    self.navigationItem.title=@"Event";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addChatGroupUser)];
    [self.view setBackgroundColor:[UIColor clearColor]];
    [self.view setBackgroundColor:kGetColor(238, 238, 238)];
    
    self.navigationController.navigationBar.barTintColor=kGetColor(248, 248, 248);
    self.navigationController.navigationBar.tintColor = kGetColor(4, 118, 246);
    
    
    
    //
    eventListView = [[UITableView alloc] initWithFrame:CGRectMake(0, navBarHeight, screenWidth, screenHeight-self.tabBarController.tabBar.frame.size.height-navBarHeight) style:UITableViewStylePlain];
    [eventListView setBackgroundColor:[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:0.9]];
    eventListView.delegate=self;
    eventListView.dataSource=self;
    eventListView.userInteractionEnabled=YES;
    [self.view addSubview:eventListView];
    //[self getChartList];
   // [self setExtraCellLineHidden:eventListView];
    if (socketClient.isConnected==NO){
        NSLog(@" event is not connetcted ");
    }
    
    
    
    
    
    

};
- (void)setExtraCellLineHidden: (UITableView *)tableView{
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
    [tableView setTableHeaderView:view];
    
}




-(void)viewWillAppear:(BOOL)animated
{
    [self setBadageValue];
    userArr = [[eChatDAO sharedChatDao] getChatGroupList];
    self.tabBarController.tabBar.hidden=NO;
    socketClient.delegate=self;
    [self setMessageTitle:socketClient];
    [self reloadData];
    //isAtChatMessageViewCon = false;
    
    self.navigationController.navigationBar.barTintColor=kGetColor(248, 248, 248);
}
//
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}






-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identier = [@"cell" stringByAppendingString:[NSString stringWithFormat:@"%i",(int)indexPath.row]];
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identier];
    cell.textLabel.backgroundColor = [UIColor clearColor];
    if(!cell)
    {
        cell= [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identier];
        [cell.imageView setFrame:CGRectMake(0, 0, 40, 40)];
        [cell.imageView.layer setCornerRadius:CGRectGetHeight([cell.imageView bounds]) / 2];
        cell.imageView.layer.masksToBounds = YES;
        cell.imageView.clipsToBounds=YES;
        //[cell.imageView setContentMode:UIViewContentModeScaleAspectFill];
        cell.imageView.layer.borderColor = [[UIColor whiteColor] CGColor];
        cell.imageView.backgroundColor = [UIColor whiteColor];
        [cell.textLabel setFrame:CGRectMake(0, 0, screenWidth-80, 20)];
    }
    tableView.separatorColor=kGetColorAl(221, 221, 221, 1);
    //设置间隔色
    // if(indexPath.row%2 == 0){
    [cell setBackgroundColor:[UIColor whiteColor]];
    //    }else{
    //        [cell setBackgroundColor:[UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1]];
    //    }
    tableView.separatorInset=UIEdgeInsetsZero;
    //
    NSArray *contentViewArr = [cell.contentView subviews];
    for (int i=0;i<[contentViewArr count];i++) {
        if ([[contentViewArr objectAtIndex:i] isKindOfClass:[UILabel class]]) {
            UILabel *tempLable = [contentViewArr objectAtIndex:i];
            if (tempLable.tag ==100) {
                [tempLable removeFromSuperview];
            }
        }
        if ([[contentViewArr objectAtIndex:i] isKindOfClass:[UIImageView class]]) {
            UIImageView *tempLable = [contentViewArr objectAtIndex:i];
            if (tempLable.tag ==101) {
                [tempLable removeFromSuperview];
            }
        }
    }
    NSDictionary *dic = [userArr objectAtIndex:indexPath.row];
    cell.textLabel.text=[dic objectForKey:@"CHAT_GROUP_NAME"];//group name
    [cell.textLabel setTextColor:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.87]];
    [cell.textLabel setFont:[UIFont boldSystemFontOfSize:14]];
    
    //
    UILabel *lblSession = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 70, 15)];
    lblSession.tag = 100;
    if([@"" isEqualToString:[dic objectForKey:@"LAST_UPDATE_SESSION"]]){
        //如果没有最后一条消息，则显示当天日期
        lblSession.text = nil;
        //lblSession.text = [FormatTime dateToStr:[NSDate date] Format:@"yyyy-MM-dd"];
    }else{
        //否则，当天显示事件，其他显示日期
        NSDate *date = [FormatTime strToDate:[dic objectForKey:@"LAST_SESSION_DATE"]];
        if ([[FormatTime dateToStr:date Format:@"yyyy-MM-dd"] isEqualToString:[FormatTime dateToStr:[NSDate date] Format:@"yyyy-MM-dd"]]) {
            lblSession.text = [FormatTime dateToStr:date Format:@"HH:mm"];
        }else
        {
            lblSession.text = [FormatTime dateToStr:date Format:@"yyyy-MM-dd"];
        }
    }
    lblSession.font=[UIFont systemFontOfSize:10];
    lblSession.textAlignment = NSTextAlignmentRight;
    [lblSession setTextColor:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.53]];
    [cell.accessoryView setFrame:CGRectMake(0, 30, 80, 60)];
    cell.accessoryView = lblSession;
    //
    cell.tag = [[dic objectForKey:@"CHAT_GROUP_ID"] integerValue];
    NSString *detailText = nil;
    NSString *createPerson =[dic objectForKey:@"CREATE_PERSON"];
    NSString *type = [dic objectForKey:@"TYPE"];
    if([@"" isEqualToString:[dic objectForKey:@"LAST_UPDATE_SESSION"]]){
        detailText = @"";
    }else{
        //NSString *createPerson = [dic objectForKey:@"CREATE_PERSON"];
        
        if ([@"PUBLIC" isEqualToString:type]){
            NSString *titleContent = @"";
            if (![[dic objectForKey:@"LAST_UPDATE_SESSION"] isKindOfClass:[NSNull class]]) {
                NSDictionary *messageDic = [[dic objectForKey:@"LAST_UPDATE_SESSION"] JSONValue];
                
                if (messageDic != nil) {
                    titleContent = [messageDic objectForKey:@"TITIL"];
                }else
                {
                    titleContent =[dic objectForKey:@"LAST_UPDATE_SESSION"];
                }
                //detailText = [[[dic objectForKey:@"CHAT_GROUP_NAME"] stringByAppendingString:@":"] stringByAppendingString:titleContent];
                detailText=titleContent;
            }
            
            
        }else
        {
            detailText = [[[dic objectForKey:@"LAST_COMMON_NAME"] stringByAppendingString:@":"] stringByAppendingString:[dic objectForKey:@"LAST_UPDATE_SESSION"]];
        }
    }
    cell.detailTextLabel.text=[EmotionHelper disposalTextAndFace:detailText];
    [cell.detailTextLabel setFont:[UIFont systemFontOfSize:12]];
    [cell.detailTextLabel setBackgroundColor:[UIColor clearColor]];
    [cell.detailTextLabel setTextColor:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.53]];
    //
    NSString *imageName = [dic objectForKey:@"HEAD_PHOTO"];
    NSString *isGroup =[dic objectForKey:@"IS_GROUP"];
    if ([@"N" isEqualToString: isGroup]){
        NSMutableArray *friendInfoArr = [[eChatDAO sharedChatDao] getAllGroupUserByGroupId:[dic objectForKey:@"CHAT_GROUP_ID"] CurrUser:[[CommUtilHelper sharedInstance] getUser]];
        for (int i=0; i<[friendInfoArr count]; i++) {
            NSDictionary *dicnameInfo = [friendInfoArr objectAtIndex:i];
            if (![[[CommUtilHelper sharedInstance] getUser] isEqualToString:[dicnameInfo objectForKey:@"USER"]])
            {
                cell.textLabel.text=[dicnameInfo objectForKey:@"NickName"];//group name
            }
            
        }
        
        NSString *type=[dic objectForKey:@"TYPE"];
        
        if( [@"PUBLIC" isEqualToString:type]) {
            cell.textLabel.text =[dic objectForKey:@"CHAT_GROUP_NAME"];//group name
        }
        imageName = [[eChatDAO sharedChatDao] getSingleContactHead:[dic objectForKey:@"CHAT_GROUP_ID"] myUser:[[CommUtilHelper sharedInstance] getUser]];
        if(imageName && ![@"" isEqualToString:imageName]) {
            UIImage *image= [[CommUtilHelper sharedInstance] getImageByImageName:imageName Size:CGSizeMake(40, 40)];
            
            if (image) {
                cell.imageView.image = image;
            }else
            {
                cell.imageView.image=[UIImage imageNamed:@"default2x@2x.png"];
            }
        }else
        {
            cell.imageView.image=[UIImage imageNamed:@"default2x@2x.png"];
        }
    }else
    {
        
        if(imageName && ![@"" isEqualToString:imageName]) {
            UIImage *image= [[CommUtilHelper sharedInstance] getImageByImageName:imageName Size:CGSizeMake(40, 40)];
            
            if (image) {
                cell.imageView.image = image;
            }else
            {
                cell.imageView.image=[UIImage imageNamed:@"dusers2x@2x.png"];
            }
        }else
        {
            cell.imageView.image=[UIImage imageNamed:@"dusers2x@2x.png"];
        }
    }
    UIImageView *rightImageView = [[UIImageView alloc] initWithFrame:CGRectMake(screenWidth-20, 0, 20, 20)];
    rightImageView.tag=101;
    rightImageView.image = [UIImage imageNamed:@"delta@2x.png"];
    [cell.contentView addSubview:rightImageView];
    if( [@"PUBLIC" isEqualToString:type]) {
        cell.imageView.image=[UIImage imageNamed:@"public-group.png"];
        //cell.imageView.image=[UIImage imageNamed:@"tes123.jpg"];
        [cell setBackgroundColor:kGetColor(252, 238, 236)];
        rightImageView.hidden=NO;
    }else
    {
        
        [cell setBackgroundColor:[UIColor whiteColor]];
        rightImageView.hidden=YES;
        [rightImageView removeFromSuperview];
    }
    
    
    
    //cell imageview 添加手势
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] init];
    [tapGesture addTarget:self action:@selector(loadHeadBigPhoto:)];
    cell.imageView.userInteractionEnabled=YES;
    cell.imageView.tag = indexPath.row;
    [cell.imageView addGestureRecognizer:tapGesture];
    
    //由于cell.imageView设置了masksToBounds=YES，导致超出部分会被剪掉，所以使用cell.textLabel
    NSInteger newMessageCounter = [[CommUtilHelper sharedInstance] getMessageCountByGroupId:[dic objectForKey:@"CHAT_GROUP_ID"]];
    //如果有新消息，则显示红点
    //移除旧视图
    for(int i=0;i<[cell.textLabel.subviews count];i++){
        if([cell.textLabel.subviews[i] isKindOfClass:[UIImageView class]]){
            [cell.textLabel.subviews[i] removeFromSuperview];
        }
    }
    if(newMessageCounter >0){
        UIImageView *badge = nil;
        
        badge = [[UIImageView alloc] initWithFrame:CGRectMake(-15, -10, 14, 14)];
        [badge setAlpha:0.7];
        
        UILabel *numbLable = [[UILabel alloc] initWithFrame:CGRectMake(2, 2, 10, 10)];
        [numbLable setText:[NSString stringWithFormat:@"%li",newMessageCounter]];
        [numbLable setTextAlignment:NSTextAlignmentCenter];
        [numbLable setTextColor:[UIColor  whiteColor]];
        [numbLable setFont:[UIFont systemFontOfSize:8]];
        [badge addSubview:numbLable];
        [badge.layer setCornerRadius:CGRectGetHeight([badge bounds])/2];
        badge.backgroundColor = [UIColor redColor];
        [cell.textLabel addSubview:badge];
    }
    //
    return cell;
}

//-tableview
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CiclrImageTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    //增加type类型
    NSInteger row = indexPath.row;
    NSDictionary *rsDic = [userArr objectAtIndex:row];
    NSString *createPerson = [rsDic objectForKey:@"CREATE_PERSON"];
    NSString *source = [rsDic objectForKey:@"SOURCE"];
    NSString *type = [rsDic objectForKey:@"TYPE"];
    //flatsalesftp@sz.hwpg.net
    if ([@"PUBLIC" isEqualToString:type] ){
        FSMessageViewController *v = [FSMessageViewController shareInstance];
        
        v.groupId= [NSString stringWithFormat:@"%li",cell.tag];
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        NSString *nickName = [ud objectForKey:@"nickname"];
        v.nickName = nickName;
        v.source = source;
        if (cell.textLabel.text) {
            if(cell.textLabel.text.length>12)
            {
                v.groupTitle = [[cell.textLabel.text substringToIndex:11] stringByAppendingString:@"..."];
            }else
            {
                v.groupTitle =cell.textLabel.text;
            }
        }
        
        
        self.navigationItem.backBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
        self.tabBarController.tabBar.hidden=YES;
        [self.navigationController pushViewController:v animated:YES];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        self.tabBarItem.badgeValue = nil;
      //  isAtChatMessageViewCon=true;
    }else
    {
        ChatMessageViewController *v =[ChatMessageViewController shareInstance];
        v.groupId= [NSString stringWithFormat:@"%li",cell.tag];
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        NSString *nickName = [ud objectForKey:@"nickname"];
        v.nickName = nickName;
        if (cell.textLabel.text) {
            if(cell.textLabel.text.length>12)
            {
                v.groupTitle = [[cell.textLabel.text substringToIndex:11] stringByAppendingString:@"..."];
            }else
            {
                v.groupTitle =cell.textLabel.text;
            }
        }
        
        
        self.navigationItem.backBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
        self.tabBarController.tabBar.hidden=YES;
        [self.navigationController pushViewController:v animated:YES];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        self.tabBarItem.badgeValue = nil;
       // isAtChatMessageViewCon=true;
    }
    //
    
    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 160;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [userArr count];
}



-(void)reloadData
{
    userArr = [[eChatDAO sharedChatDao] getChatGroupList];
    [eventListView reloadData];
}





-(void)SokcetIoContect
{
    socketClient = [SocketIOConnect sharedInstance].socketIOClient;
    [[SocketIOConnect sharedInstance] doConnect];
    [self setMessageTitle:socketClient];
}


-(void)setMessageTitle:(SocketIO *) client
{
    if(client.isConnecting == YES)
    {
        self.navigationItem.title=@"Connecting...";
    }
    else if(client.isConnected == YES)
    {
        self.navigationItem.title=@"Event";
    }
    if (client.isConnected == NO) {
        bool check = [[SocketIOConnect sharedInstance] doConnect];
        if (!check) {
            self.navigationItem.title=@"Disconnect";
            [self SokcetIoContect];
        }
    }
}


-(void)socketIO:(SocketIO *)socket didReceiveMessage:(SocketIOPacket *)packet
{
}
-(void)socketIO:(SocketIO *)socket didReceiveEvent:(SocketIOPacket *)packet
{
    NSLog(@"received from server data:%@",packet.data);
    //0是事件名称＝packet.name,1才是json数据
    if (![@"sendMessage" isEqualToString:packet.name]) {
        return;
    }
    NSMutableArray *dataArr = [[CommUtilHelper sharedInstance] jsonToObject:packet.data];
    for (int i=0; i<[dataArr count]; i++) {
        
        NSMutableDictionary *dictReceivedMsg = [dataArr objectAtIndex:i];
        //如果服务器给的是数字，则转为字符串
        
        NSString *groupid = [NSString stringWithFormat:@"%@",[dictReceivedMsg objectForKey:@"groupId"]];
 
        
        [[MessageUtilHelper sharedInstance] MessageHandle:packet   DicData:dictReceivedMsg GroupId:groupid delegate:self isCalculteCount:YES];
        
        
    }
    //以下事件需要刷新界面
    [self  reloadData];
  [self setBadageValue];
    
   }
//
-(void)setBadageValue
{
    NSInteger count = [[CommUtilHelper sharedInstance] getAllMessageCount];
    if (count >0) {
        
        self.tabBarItem.badgeValue = [NSString stringWithFormat:@"%li",count];
        
        
        [PushNotificationUtil clearBadge:count];
    }else
    {
        [PushNotificationUtil clearBadge:0];
        self.tabBarItem.badgeValue = nil;
    }
    
}




@end