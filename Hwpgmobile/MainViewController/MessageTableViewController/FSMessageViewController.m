//
//  ChatMessageViewController.m
//  Chat
//
//  Created by hwpl hwpl on 14-10-30.
//  Copyright (c) 2014年 hwpl hwpl. All rights reserved.
//
#import "XHDisplayTextViewController.h"
#import "XHDisplayMediaViewController.h"
#import "XHDisplayLocationViewController.h"
#import "XHAudioPlayerHelper.h"

#import "FSMessageViewController.H"
#import "ChatViewController.h"
#import "MessageInfoSettingViewController.h"
#import "CharViewNetServiceUtil.h"
#import "TransPondViewController.h"

#import "AppDelegate.h"
#import "EmotionHelper.h"
#import "eChatDAO.h"
#import "SystemEmotionManagerView.h"
#import "ResponseModel.h"
#import "ErrorModel.h"
#import "FormatTime.h"
#import "CommUtilHelper.h"
#import "MessageUtilHelper.h"
#import "NSString+FontAwesome.h"
#import "NSString+HTML.h"
#import "UIWindow+YzdHUD.h"
#import "HeadPhotoDisViewController.h"
#import "PreDisImageViewController.h"
#import "CharViewNetServiceUtil.h"
#import "PushNotificationUtil.h"
#import "FSSettingViewController.h"
#import "NavWebViewController.h"
static FSMessageViewController *instance = nil;
@interface FSMessageViewController ()
{
    UIBarButtonItem *rightItem;
    NSString *strSendId;
    //SocketIO *socketClient;
    NSInteger minNumber;
    NSInteger maxNumber;
    NSMutableArray *userArr;
    UIBarButtonItem *rightButtonItem;
    XHPhotographyHelper *_photographyHelper;
    UIPageControl *pageControl;
    UIScrollView *scrollView;//表情滚动视图
    NSInteger *totalCount;
    BOOL doNotRefresh;
    NSInteger repeatTag;
    int maxSessionId;
    BOOL isFirstAllow;//是否第一次进入刷新
    
    UIView *subscribeLoadingView;
    NSString *lastGroupSessionId;
    
}
@property(nonatomic,strong)   NSString *tempheadPhoto ;
@property (nonatomic, strong) NSArray *emotionManagers;

@property (nonatomic, strong) XHMessageTableViewCell *currentSelectedCell;

@end

@implementation FSMessageViewController
@synthesize groupId;
@synthesize nickName;
@synthesize tempheadPhoto;
@synthesize groupTitle;
@synthesize socketClient;
@synthesize source;
+(FSMessageViewController *)shareInstance
{
    @synchronized(self)
    {
        if (instance == nil) {
            instance = [[FSMessageViewController alloc] init];
        }
    }
    return instance;
}
//
+(void) dealloc
{
    
    instance = nil;
}
//
-(NSDate *)strToDate:(NSString *)date
{
    NSDateFormatter *formate = [[NSDateFormatter alloc] init];
    [formate setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    [formate setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *_date = [formate dateFromString:date];
    return _date;
}
-(NSString *)dateToStr:(NSDate *)date
{
    NSDateFormatter *formate = [[NSDateFormatter alloc] init];
    [formate setDateFormat:@"yyyy-MM-dd HH24:mm:ss"];
    NSString *strDate = [formate stringFromDate:date];
    return strDate;
}

- (XHMessage *)getTextMessage:(NSString *) text sender:(NSString *)sender sendStrID:(NSString *) _strSendId  Date:(NSDate *) date BubbleMessageType:(XHBubbleMessageType)bubbleMessageType headPhoto:(NSString *)headPhoto handleDic:(NSMutableDictionary *) dic
{
    XHMessage *textMessage = [[XHMessage alloc] initWithText:text sender:sender sendStrId:_strSendId timestamp:date handleDic:dic IsSending:NO];
    if (headPhoto && ![@"" isEqualToString:headPhoto]) {
        UIImage *image =  [[CommUtilHelper sharedInstance] getImageByImageName:headPhoto Size:CGSizeMake(40, 40)];
        textMessage.avator = image;
    }
    else if([chatSystemUserName isEqualToString:sender])
    {
        textMessage.avator = [UIImage imageNamed:@"logo.png"];
        
    }
    else
    {
        textMessage.avator = [UIImage imageNamed:@"avator"];
    }
    
    textMessage.avatorUrl = nil;
    textMessage.bubbleMessageType = bubbleMessageType;
    return textMessage;
}

- (XHMessage *)getTextMessage:(NSString *) text sender:(NSString *)sender sendStrID:(NSString *) _strSendId  Date:(NSDate *) date BubbleMessageType:(XHBubbleMessageType)bubbleMessageType headPhoto:(NSString *)headPhoto handleDic:(NSMutableDictionary *) dic type:(NSString *)subType MessageDic:(NSMutableDictionary *)messageDic
{
    XHMessage *textMessage = [[XHMessage alloc] initWithText:text sender:sender sendStrId:_strSendId timestamp:date handleDic:dic IsSending:NO subType:subType];
    textMessage.avatorUrl = nil;
    textMessage.subType = subType;
    textMessage.bubbleMessageType = bubbleMessageType;
    textMessage.messageDic =  messageDic;
    return textMessage;
}


- (XHMessage *)getPhotoMessageWithBubbleMessageType:(XHBubbleMessageType)bubbleMessageType sender:(NSString *)sender sendStrId:(NSString *)senderStrId smallImgName:(NSString *)smallImgName bigImgUrl:(NSString *)bigimgUrl headPhoto:(NSString *)headPhoto Date:(NSDate *)date handleDic:(NSMutableDictionary *) dic{
    XHMessage *photoMessage = nil;
    NSMutableArray *imgArr =[[NSMutableArray alloc] initWithArray: [bigimgUrl  componentsSeparatedByString:@"/"]];
    NSString *fileName = nil;
    if ([imgArr count]) {
        fileName =  [imgArr objectAtIndex:imgArr.count-1];
    }
    NSString *_filePath = [[CommUtilHelper sharedInstance] dataImagePath:fileName ];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:_filePath]) {
        //如果有本地大图，直接显示
        NSData *imgData = [[NSData alloc] initWithContentsOfFile:_filePath];
        UIImage *img = [[UIImage alloc] initWithData:imgData];
        photoMessage =  [[XHMessage alloc] initWithPhoto:img thumbnailUrl:nil originPhotoUrl:nil sender:sender sendStrId:senderStrId timestamp:date NativePath:_filePath handleDic:dic IsSending:NO];
        photoMessage.nativePhoto = img;
    }else
    {
        //否则，先显示小图
        NSString *smallImgPath = [[CommUtilHelper sharedInstance] dataImagePath:smallImgName];
        //UIImage *img = [UIImage imageWithContentsOfFile:smallImgPath];
        UIImage *img = [UIImage imageNamed:smallImgPath];
        
        if (img==nil) {
            [CharViewNetServiceUtil synDownLoadImg:[NSString stringWithFormat:@"%@/fileTransfer/download?fileName=%@",charUrl,smallImgName] targetFilePath:smallImgPath];
            img = [UIImage imageNamed:smallImgPath];
        }
        
        
        
        photoMessage =  [[XHMessage alloc] initWithPhoto:img thumbnailUrl:smallImgName  originPhotoUrl:[NSString stringWithFormat:@"%@/fileTransfer/?fileName=%@",charUrl,bigimgUrl]  sender:sender sendStrId:senderStrId timestamp:date NativePath:bigimgUrl handleDic:dic IsSending:NO];
        photoMessage.nativePhoto = nil;
    }
    if (headPhoto && ![@"" isEqualToString:headPhoto]) {
        photoMessage.avator = [[CommUtilHelper sharedInstance] getImageByImageName:headPhoto Size:CGSizeMake(40, 40)];
    }
    else
    {
        photoMessage.avator = [UIImage imageNamed:@"avator"];
    }
    photoMessage.avatorUrl = nil;
    photoMessage.bubbleMessageType = bubbleMessageType;
    return photoMessage;
}

- (XHMessage *)getVideoMessageWithBubbleMessageType:(XHBubbleMessageType)bubbleMessageType {
    NSString *videoPath = [[NSBundle mainBundle] pathForResource:@"IMG_1555.MOV" ofType:@""];
    XHMessage *videoMessage = [[XHMessage alloc] initWithVideoConverPhoto:[XHMessageVideoConverPhotoFactory videoConverPhotoWithVideoPath:videoPath] videoPath:videoPath videoUrl:nil sender:@"ivan" timestamp:[NSDate date]];
    videoMessage.avator = [UIImage imageNamed:@"avator"];
    videoMessage.avatorUrl = @"";
    videoMessage.bubbleMessageType = bubbleMessageType;
    
    return videoMessage;
}

- (XHMessage *)getVoiceMessageWithBubbleMessageType:(XHBubbleMessageType)bubbleMessageType Sender:(NSString *)sender sendStrId:(NSString *)senderStrId  voiceUrl:(NSString *)url Date:(NSDate *)date headPhoto:(NSString *)headPhoto handleDic:(NSMutableDictionary *) dic{
    XHMessage *voiceMessage = [[XHMessage alloc] initWithVoicePath:nil voiceUrl:url voiceDuration:@"" sender:sender sendStrId:senderStrId timestamp:date handleDic:dic IsSending:NO];
    if (headPhoto && ![@"" isEqualToString:headPhoto]) {
        voiceMessage.avator = [[CommUtilHelper sharedInstance] getImageByImageName:headPhoto Size:CGSizeMake(40, 40)];
    }
    else
    {
        voiceMessage.avator = [UIImage imageNamed:@"avator"];
    }
    
    voiceMessage.avatorUrl = nil;
    voiceMessage.bubbleMessageType = bubbleMessageType;
    
    return voiceMessage;
}

- (XHMessage *)getEmotionMessageWithBubbleMessageType:(XHBubbleMessageType)bubbleMessageType {
    /*
     XHMessage *emotionMessage = [[XHMessage alloc] initWithEmotionPath:[[NSBundle mainBundle] pathForResource:@"emotion1.gif" ofType:nil] sender:@"ivan" timestamp:[NSDate date]];
     emotionMessage.avator = [UIImage imageNamed:@"avator"];
     emotionMessage.avatorUrl = nil;
     emotionMessage.bubbleMessageType = bubbleMessageType;
     return emotionMessage;
     */
    return nil;
}

- (XHMessage *)getGeolocationsMessageWithBubbleMessageType:(XHBubbleMessageType)bubbleMessageType {
    /*
     XHMessage *localPositionMessage = [[XHMessage alloc] initWithLocalPositionPhoto:[UIImage imageNamed:@"Fav_Cell_Loc"] geolocations:@"中国广东省广州市天河区东圃二马路121号" location:[[CLLocation alloc] initWithLatitude:23.110387 longitude:113.399444] sender:@"Jack" timestamp:[NSDate date]];
     localPositionMessage.avator = [UIImage imageNamed:@"ivan"];
     localPositionMessage.avatorUrl = @"";
     localPositionMessage.bubbleMessageType = bubbleMessageType;
     
     return localPositionMessage;
     */
    return nil;
}

- (NSMutableArray *)getTestMessages {
    NSMutableArray *messages = [[NSMutableArray alloc] init];
    return messages;
}

- (void)loadDemoDataSource {
    maxNumber = [[eChatDAO sharedChatDao] getMaxSessionId:groupId];
    //minNumber=[[eChatDAO sharedChatDao] ]-10;
    //maxNumber=minNumber+10;
    minNumber = 0;
    NSLog(@"loadDemoDataSource");
    //userArr = [[eChatDAO sharedChatDao] getCHatGroupSessionByminPage:minNumber toMax:maxNumber GroupId:self.groupId];
    userArr = [self getMoreMessage];
    if (userArr) {
        self.messages = [self getListMessage:userArr];
        [self.messageTableView reloadData];
        [self scrollToBottomAnimated:NO];
    }
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [[XHAudioPlayerHelper shareInstance] stopAudio];
    [super viewWillDisappear:animated];
    
}

- (id)init {
    self = [super init];
    if (self) {
        // 配置输入框UI的样式
        //        self.allowsSendVoice = NO;
        //        self.allowsSendFace = NO;
        //        self.allowsSendMultiMedia = NO;
    }
    return self;
}

- (void)viewDidLoad
{
     [super viewDidLoad];
     self.allowLoadMenu=YES;
    
    
    doNotRefresh = NO;
    //设置left button
//    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [backBtn setFrame:CGRectMake(0, 0, 20, 44)];
//    [backBtn setTitle:@"" forState:UIControlStateNormal];
//    [backBtn addTarget:self action:@selector(doBack) forControlEvents:UIControlEventTouchUpInside];
//    backBtn.backgroundColor = [UIColor clearColor];
//    UILabel *backLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, backBtn.frame.size.width, backBtn.frame.size.height)];
//    backLabel.text = @"";
//    backLabel.textAlignment = NSTextAlignmentLeft;
//    backLabel.textColor = [UIColor whiteColor];
//    backLabel.backgroundColor = [UIColor clearColor];
//    backLabel.font = [UIFont fontWithName:kFontAwesomeFamilyName size:36];
//    backLabel.text = [NSString fontAwesomeIconStringForEnum:FAAngleLeft];
//    [backBtn addSubview:backLabel];
//    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
//    self.navigationItem.leftBarButtonItem = backItem;
    
    
    
    //
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    strSendId =  [ud objectForKey:@"user"];
    [self SokcetIoContect];
    socketClient.delegate = self;
    //
    [self setBackgroundColor:[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:0.9]];
    // 设置自身用户名
    self.messageSender = [ud objectForKey:@"nickname"];
    // 添加第三方接入数据
    NSMutableArray *shareMenuItems = [NSMutableArray array];
    NSArray *plugIcons = @[@"sharemore_pic", @"sharemore_video"];
    NSArray *plugTitle = @[@"Album", @"Camera"];
    for (NSString *plugIcon in plugIcons) {
        XHShareMenuItem *shareMenuItem = [[XHShareMenuItem alloc] initWithNormalIconImage:[UIImage imageNamed:plugIcon] title:[plugTitle objectAtIndex:[plugIcons indexOfObject:plugIcon]]];
        [shareMenuItems addObject:shareMenuItem];
    }
    //屏蔽自定义表情
    self.allowsSendFace=NO;
    
    /**
     NSMutableArray *emotionManagers = [NSMutableArray array];
     for (NSInteger i = 0; i < 1; i ++) {
     XHEmotionManager *emotionManager = [[XHEmotionManager alloc] init];
     emotionManager.emotionName = [NSString stringWithFormat:@"emotion"];
     
     NSMutableArray *emotions = [[NSMutableArray alloc] init];
     NSString *emojiPath = [[NSBundle mainBundle] resourcePath];
     NSArray *emojArr = [EmotionHelper getEmojis];
     for (int i=0; i<[emojArr count]; i++) {
     XHEmotion *emotion = [[XHEmotion alloc] init];
     NSString *imageName= [@"system_" stringByAppendingFormat:@"%@.png",emojArr[i]];
     emotion.emotionPath = [emojiPath stringByAppendingFormat:@"/emoji/%@",imageName];
     emotion.emotionConverPhoto = [UIImage imageNamed:imageName];
     [emotions addObject:emotion];
     }
     emotionManager.emotions = emotions;
     [emotionManagers addObject:emotionManager];
     }
     self.emotionManagers = emotionManagers;
     [self.emotionManagerView reloadData];
     */
    //创建表情键盘
    // [self.emotionManagerView addSubview:[[SystemEmotionManagerView alloc] initWithEmotionScrollView:self.emotionManagerView.frame]];
    self.shareMenuItems = shareMenuItems;
    [self.shareMenuView reloadData];
    //
    tempheadPhoto=[[eChatDAO sharedChatDao] getHeadPhotoNameByUser:[[CommUtilHelper sharedInstance] getUser]];
    
    
    
}

-(UIImage *)getMyHeadPhoto
{
    UIImage *image =   [[CommUtilHelper sharedInstance] getImageByImageName:tempheadPhoto Size:CGSizeMake(40, 40)];
    return image;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    self.emotionManagers = nil;
    subscribeLoadingView = nil;
    [[XHAudioPlayerHelper shareInstance] setDelegate:nil];
}

//
-(void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    //设置bagenumber
    [[CommUtilHelper sharedInstance] setMessageCountByGroupId:self.groupId withCount:0 withType:deleteCounter];
    [[CommUtilHelper sharedInstance] setBadageValue];
    
    isFirstAllow = YES;
    minNumber=-10;
    if (!doNotRefresh) {
        [self loadDemoDataSource];
        [[ChatViewController sharedInstance].tabBarController.tabBar setHidden:YES];
        //
        totalCount = [[eChatDAO sharedChatDao] getTotalNumberByGroup:self.groupId];
        self.navigationItem.title = self.groupTitle;
        //
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        socketClient.delegate=self;
        if(socketClient.isConnected) {
        }else
        {
            bool check = [[SocketIOConnect sharedInstance] doConnect];
            if (check){
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
                NSString *name = [ud objectForKey:@"user"];
                [dict setObject:name forKey:@"user"];
                [dict setObject:[CommUtilHelper getDeviceId] forKey:@"deviceId"];
                [dict setObject:@"1" forKey:@"onlineTimes"];
                [dict setObject:@"" forKey:@"where"];
                [socketClient sendEvent:@"online" withData:dict];
            }
        }
        [dict setObject:self.groupId forKey:@"groupid"];
        [self scrollToBottomAnimated:NO];
        doNotRefresh = NO;
    }
    //清除新消息计数
    //[[CommUtilHelper sharedInstance] newMessageCounterByGroupId:self.groupId MessageCounter:@"0"];
    
    //设置右边 button
    rightItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Profile.png"] style:UIBarButtonItemStylePlain target:self action:@selector(chatSetting)];
    NSString *createPerson = [[[eChatDAO alloc] init] getCreatePersonName:groupId];
    if (![chatSystemUserName isEqualToString:createPerson]) {
        self.navigationItem.rightBarButtonItem = rightItem;
    }else
    {
        self.navigationItem.rightBarButtonItem = nil;
    }
    
    
    NSDictionary *menu1=[NSDictionary dictionaryWithObjectsAndKeys:@"test123",@"title",@"http://www.baidu.com",@"url",nil];
    NSDictionary *menu2=[NSDictionary dictionaryWithObjectsAndKeys:@"test123",@"title",@"http://www.baidu.com",@"url",nil];
    NSDictionary *menu3=[NSDictionary dictionaryWithObjectsAndKeys:@"test123",@"title",@"http://www.baidu.com",@"url",nil];
    NSMutableArray *menuArr = [NSMutableArray arrayWithObjects:menu1,menu2,menu3, nil];
    self.menuArr = menuArr;
    [self setMenuMutableArr:self.menuArr];
}

-(NSMutableArray *)getListMessage:(NSMutableArray *)arr
{
    NSMutableArray *messages = [[NSMutableArray alloc] init];
    for (int i=0; i<[arr count]; i++) {
        NSDictionary *dic =[arr objectAtIndex:i];
        NSString *sender =[dic objectForKey:@"USER_NICK_NAME"];
        NSString *msg = [dic objectForKey:@"CHAT_CONTENT"];
        if([@"" isEqualToString:msg])
            continue;
        NSString *chatSmallPic = [dic objectForKey:@"CHAT_SMALLPIC"];
        NSString *filePic = [dic objectForKey:@"FILE_PATH"];
        NSString *createDate = [dic objectForKey:@"CREATE_DATE"];
        NSString *lastSyncTime = [dic objectForKey:@"LAST_SYNC_TIME"];
        NSString *sessionId   = [dic objectForKey:@"ID"];
        if (sessionId && (i==(int)[arr count]-1) && isFirstAllow) {
            maxSessionId = [sessionId intValue];
        }
        NSString *groupSessionId  = [dic objectForKey:@"GROUP_SESSION_ID"];
        NSDate *date = nil;
        if (lastSyncTime && ![@"" isEqualToString:lastSyncTime]) {
            date = [self strToDate:lastSyncTime];
        }
        
        if (i==[arr count]-1) {
            lastGroupSessionId=groupSessionId;
        }
        
        NSString *userPrincipalName = [dic objectForKey:@"USER_PRINCIPAL_NAME"];
        if([@"flatsalesftp@sz.hwpg.net" isEqualToString:userPrincipalName])
        {
            NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
            [userDefault setObject:@"12" forKey:@"fsSubScribeFont"];
            
            
            
        }
        
        
        
        NSMutableDictionary *handledic = [NSMutableDictionary dictionaryWithObjectsAndKeys:lastSyncTime,@"syncTime",sessionId,@"sessionId",userPrincipalName,@"user",groupSessionId,@"groupSessionId", nil];
        NSString *temp=[EmotionHelper disposalTextAndFace:msg];
        
        NSString *headPhoto=[dic objectForKey:@"HEAD_PHOTO"];
        //获取文件名字
        NSMutableArray *voiceArr =[[NSMutableArray alloc] initWithArray: [filePic  componentsSeparatedByString:@"/"]];
        NSString *fileName = nil;
        
        XHMessage *textMessage = nil;
        XHBubbleMessageType type = XHBubbleMessageTypeSending;
        if ([voiceArr count]) {
            fileName =  [voiceArr objectAtIndex:voiceArr.count-1];
        }
        
        if (![userPrincipalName isEqualToString:strSendId])
        {
            type=XHBubbleMessageTypeReceiving;
        }
        if ([msg hasPrefix:@"[audio]"])
        {
            textMessage=[self getVoiceMessageWithBubbleMessageType:type Sender:sender sendStrId:userPrincipalName voiceUrl:[NSString stringWithFormat:@"%@/%@",charUrl,filePic] Date:date headPhoto:headPhoto handleDic:handledic];
        }else if([msg hasPrefix:@"[image]"])
        {
            textMessage = [self getPhotoMessageWithBubbleMessageType:type sender:sender sendStrId:userPrincipalName smallImgName:chatSmallPic bigImgUrl:filePic headPhoto:headPhoto Date:date handleDic:handledic];
        }
        else
        {
            if(![[[CommUtilHelper sharedInstance] getUser] isEqualToString:userPrincipalName])
            {
                 NSMutableDictionary *messageDic = [[CommUtilHelper sharedInstance] getFSJsonValue:msg];
                 if(messageDic ==nil)
                 {
                      textMessage = [self getTextMessage:temp sender:sender sendStrID:userPrincipalName Date:date  BubbleMessageType:type headPhoto:headPhoto handleDic:handledic ];
                 }else
                 {
                  textMessage = [self getTextMessage:msg sender:sender sendStrID:userPrincipalName Date:date  BubbleMessageType:type headPhoto:headPhoto handleDic:handledic type:@"fs" MessageDic:messageDic];
                 }
                     
                
            }else
            {
              textMessage = [self getTextMessage:temp sender:sender sendStrID:userPrincipalName Date:date  BubbleMessageType:type headPhoto:headPhoto handleDic:handledic ];
            }

          
        }
        [messages addObject:textMessage];
    }
    return  messages;
}
/*
 [self removeMessageAtIndexPath:indexPath];
 [self insertOldMessages:self.messages];
 */

#pragma mark - XHMessageTableViewCell delegate

- (void)multiMediaMessageDidSelectedOnMessage:(id<XHMessageModel>)message atIndexPath:(NSIndexPath *)indexPath onMessageTableViewCell:(XHMessageTableViewCell *)messageTableViewCell
{
    UIViewController *disPlayViewController;
    switch (message.messageMediaType) {
        case XHBubbleMessageMediaTypeVideo:
        case XHBubbleMessageMediaTypePhoto:
        {
            //如果大图不存在，则先下载
            NSMutableArray *imgArr =[[NSMutableArray alloc] initWithArray: [message.imageNativePath  componentsSeparatedByString:@"/"]];
            NSString *fileName = nil;
            if ([imgArr count]) {
                fileName =  [imgArr objectAtIndex:imgArr.count-1];
            }else{
                fileName = message.imageNativePath;
            }
            NSString *filePath = [[CommUtilHelper sharedInstance] dataImagePath:fileName];
            if(![[NSFileManager defaultManager] fileExistsAtPath:filePath]){
                [CharViewNetServiceUtil asynDownLoadImg:[NSString stringWithFormat:@"%@/fileTransfer/download?fileName=%@",charUrl,fileName] targetFilePath:filePath ];
            }
            //
            
            XHDisplayMediaViewController *messageDisplayPhotoView = [[XHDisplayMediaViewController alloc] init];
            messageDisplayPhotoView.message = message;
            disPlayViewController = messageDisplayPhotoView;
            self.allowScrollToBottom=NO;//不允许滑倒底部
            break;
        }
            break;
        case XHBubbleMessageMediaTypeVoice: {
            //先下载多媒体声音
            NSString *voiceName  = nil;
            NSString *voPath =nil;
            NSLog(@"pa%@",message.voiceUrl);
            if (message.voiceUrl) {
                NSMutableArray *voiceArr =[[NSMutableArray alloc] initWithArray: [message.voiceUrl  componentsSeparatedByString:@"/"]];
                if ([voiceArr count]) {
                    voiceName =  [voiceArr objectAtIndex:voiceArr.count-1];
                }
                NSString *_filePath = [[CommUtilHelper sharedInstance] dataVoicePath:voiceName ];
                NSFileManager *fileManager = [NSFileManager defaultManager];
                BOOL result = [fileManager fileExistsAtPath:_filePath];
                if (result) {
                    voPath = _filePath;
                }else
                {
                    voPath =  [CharViewNetServiceUtil  downLoadVoice:[NSString stringWithFormat:@"%@/fileTransfer/download?fileName=%@",charUrl,voiceName] fileName:_filePath ];
                }
            }else
            {
                voPath = message.voicePath;
            }
            
            dispatch_async(dispatch_get_main_queue(), ^(void){
                DLog(@"message : %@", voPath);
                [[XHAudioPlayerHelper shareInstance] setDelegate:self];
                if (_currentSelectedCell) {
                    [_currentSelectedCell.messageBubbleView.animationVoiceImageView stopAnimating];
                }
                if (_currentSelectedCell == messageTableViewCell) {
                    [messageTableViewCell.messageBubbleView.animationVoiceImageView stopAnimating];
                    [[XHAudioPlayerHelper shareInstance] stopAudio];
                    self.currentSelectedCell = nil;
                } else {
                    self.currentSelectedCell = messageTableViewCell;
                    [messageTableViewCell.messageBubbleView.animationVoiceImageView startAnimating];
                    [[XHAudioPlayerHelper shareInstance] managerAudioWithFileName:voPath toPlay:YES];
                }
                
            });
            break;
            
        }
        case XHBubbleMessageMediaTypeEmotion:
            DLog(@"emotionPath : %@", message.emotionPath);
            break;
        case XHBubbleMessageMediaTypeLocalPosition: {
            DLog(@"localPositionPhoto : %@", message.localPositionPhoto);
            XHDisplayLocationViewController *displayLocationViewController = [[XHDisplayLocationViewController alloc] init];
            displayLocationViewController.message = message;
            disPlayViewController = displayLocationViewController;
            break;
        }
        default:
            break;
    }
    if (disPlayViewController) {
        UIBarButtonItem *temporaryBarButtonItem=[[UIBarButtonItem alloc] init];
        temporaryBarButtonItem.title=@"";
        self.navigationItem.backBarButtonItem = temporaryBarButtonItem;
        [self.navigationController pushViewController:disPlayViewController animated:YES];
        //doNotRefresh = YES;
    }
}

- (void)didDoubleSelectedOnTextMessage:(id<XHMessageModel>)message atIndexPath:(NSIndexPath *)indexPath {
    DLog(@"text : %@", message.text);
    //    XHDisplayTextViewController *displayTextViewController = [[XHDisplayTextViewController alloc] init];
    //    displayTextViewController.message = message;
    //    [self.navigationController pushViewController:displayTextViewController animated:YES];
}

- (void)didSelectedAvatorOnMessage:(id<XHMessageModel>)message atIndexPath:(NSIndexPath *)indexPath {
    
    HeadPhotoDisViewController *headDisCon = [[HeadPhotoDisViewController alloc] init];
    [headDisCon loadHeadPohtoImageFromUser:message.senderStrId groupId:nil];
    [self.navigationController pushViewController:headDisCon animated:YES];
}

- (void)menuDidSelectedAtBubbleMessageMenuSelecteType:(XHBubbleMessageMenuSelecteType)bubbleMessageMenuSelecteType {
    
}

#pragma mark - XHAudioPlayerHelper Delegate

- (void)didAudioPlayerStopPlay:(AVAudioPlayer *)audioPlayer {
    if (!_currentSelectedCell) {
        return;
    }
    [_currentSelectedCell.messageBubbleView.animationVoiceImageView stopAnimating];
    self.currentSelectedCell = nil;
}

#pragma mark - XHEmotionManagerView DataSource

- (NSInteger)numberOfEmotionManagers {
    return self.emotionManagers.count;
}

- (XHEmotionManager *)emotionManagerForColumn:(NSInteger)column {
    return [self.emotionManagers objectAtIndex:column];
}

- (NSArray *)emotionManagersAtManager {
    return self.emotionManagers;
}

#pragma mark - XHMessageTableViewController Delegate

- (BOOL)shouldLoadMoreMessagesScrollToTop {
    return YES;
}

- (void)loadMoreMessagesScrollTotop{
    isFirstAllow = NO;
    if (!self.loadingMoreMessage) {
        self.loadingMoreMessage = YES;
        //minNumber=minNumber+10;
        minNumber = minNumber+10;
        //maxSessionId=maxSessionId-10;
        //maxNumber=minNumber+10;
        WEAKSELF
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSLog(@"loadMoreMessagesScrollTotop");
           // userArr = [[eChatDAO sharedChatDao] getCHatGroupSessionByminPage:minNumber toMax:maxNumber GroupId:self.groupId];
            userArr =  [self getMoreMessage];
            if (userArr == nil) {
                minNumber = minNumber+10;
                maxSessionId=maxSessionId+10;
            }
            NSMutableArray *messages = [weakSelf getListMessage:userArr];
            sleep(1);
            dispatch_async(dispatch_get_main_queue(), ^
                           {
                               if (userArr && [userArr count] >0) {
                                   [weakSelf insertOldMessages:messages];
                               }
                               [self setLoadingMoreMessage:NO];
                           }
                           );
        });
    }
}

/**
 *  发送文本消息的回调方法
 *
 *  @param text   目标文本字符串
 *  @param sender 发送者的名字
 *  @param date   发送时间
 */
- (void)didSendText:(NSString *)text fromSender:(NSString *)sender onDate:(NSDate *)date {
    NSString *newText = [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if(newText.length == 0){
        return;
    }
    //保存数据库
    
    NSMutableArray *nativeArr = [NSMutableArray arrayWithObject:[NSDictionary dictionaryWithObjectsAndKeys:self.groupId,@"CHAT_GROUP_ID",newText,@"CHAT_CONTENT",[FormatTime dateToStr:[NSDate date]],@"CREATE_DATE",strSendId,@"USER_PRINCIPAL_NAME",@"",@"FILE_PATH",@"", @"CHAT_SMALLPIC",nil]];
    NSInteger sessionId =[[eChatDAO sharedChatDao] insertNativeMsg:nativeArr];
    //NSString *diffUUID = [[CommUtilHelper sharedInstance] createDiffUUID] ;
    NSString *diffUUID = [CommUtilHelper getDeviceId];
    NSString *strSessionId = [[diffUUID stringByAppendingString:@"_"] stringByAppendingString:[NSString stringWithFormat:@"%li",(long)sessionId]];
    //添加消息
    XHMessage *textMessage = [[XHMessage alloc] initWithText:newText sender:sender  sendStrId:strSendId timestamp:date handleDic:nil IsSending:YES];
    
    NSMutableDictionary *handledic = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"notime",@"syncTime",[NSString stringWithFormat:@"%li",(long)sessionId],@"sessionId",strSendId,@"user", nil];
    
    if(!socketClient.isConnected) {
        textMessage =[[XHMessage alloc] initWithText:newText sender:sender  sendStrId:strSendId timestamp:date handleDic:handledic IsSending:YES];
    }
    UIImage *image =[self getMyHeadPhoto];
    textMessage.avator =image;
    textMessage.avatorUrl = nil;
    [self addMessage:textMessage];
    [self finishSendMessageWithBubbleMessageType:XHBubbleMessageMediaTypeText];
    
    //发送文本数据
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:strSendId forKey:@"from"];
    [dict setObject:self.groupId forKey:@"groupid"];
    [dict setObject:nickName forKey:@"nickname"];
    [dict setObject:strSessionId forKey:@"sId"];
    [dict setObject:[self dateToStr:[NSDate date]] forKey:@"date"];
    [dict setObject:newText forKey:@"msg"];
    [dict setObject:@"COMMAND" forKey:@"msgSubType"];
    [dict setObject:source forKey:@"source"];
    [dict setObject:[CommUtilHelper getDeviceId] forKey:@"deviceId"];
    [socketClient sendEvent:@"sendMsg" withData:dict];
    if(socketClient.isConnected)
    {
        [[MessageUtilHelper sharedInstance] setUnSendMessageID:[NSString stringWithFormat:@"%li",(long)sessionId ]];
    }
    
    //
    
    if (subscribeLoadingView !=nil) {
        [self.view addSubview:subscribeLoadingView];
       
        [UIView animateWithDuration:2 animations:^{
            subscribeLoadingView.frame = CGRectMake(0, navBarHeight, self.view.frame.size.width, 30);
            [self addTimerSchdule];
        }];
    }else
    {
        
        subscribeLoadingView  = [[SubscribeLoadingView alloc] getLoaidngViewByText:@"获取中..." Frame:CGRectMake(0, navBarHeight, self.view.frame.size.width, 30)];
        [subscribeLoadingView setFrame:CGRectMake(0, 0, screenWidth, 0)];
        [self.view addSubview:subscribeLoadingView];
        [self.view bringSubviewToFront:subscribeLoadingView];
        [UIView animateWithDuration:2 animations:^{
            subscribeLoadingView.frame = CGRectMake(0, navBarHeight, self.view.frame.size.width, 30);
            [self addTimerSchdule];
        }];
    }
    
    //调用查询接口
    //[[FSWebServiceUtil sharedInstance] getSearchMessageByParam:text user:fsUser];
}

-(void)addTimerSchdule
{
   NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:20.0 target:self selector:@selector(timerFired:) userInfo:nil repeats:NO];
   [[NSRunLoop currentRunLoop]addTimer:timer forMode:NSDefaultRunLoopMode];
}

-(void)timerFired:(NSTimer *)timer
{
    [UIView animateWithDuration:2 animations:^{
         [subscribeLoadingView setFrame:CGRectMake(0, 0, screenWidth, 0)];
        
    }];

}


/**
 *  发送图片消息的回调方法
 *
 *  @param photo  目标图片对象，后续有可能会换
 *  @param sender 发送者的名字
 *  @param date   发送时间
 */
- (XHPhotographyHelper *)photographyHelper {
    if (!_photographyHelper) {
        _photographyHelper = [[XHPhotographyHelper alloc] init];
    }
    return _photographyHelper;
}
//
-(void)didSendPhoto:(UIImage *)photo fromSender:(NSString *)sender onDate:(NSDate *)date {
    NSString *photoName =[[[CommUtilHelper sharedInstance] createUUID] stringByAppendingString:@".png"];
    NSString *savedImagePath=[[CommUtilHelper sharedInstance] dataImagePath:photoName];
    NSData *imageData =UIImageJPEGRepresentation(photo, 0.5);
    [imageData writeToFile:savedImagePath atomically:YES];
    //保存数据库
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSMutableArray *nativeArr = [NSMutableArray arrayWithObject:[NSDictionary dictionaryWithObjectsAndKeys:self.groupId,@"CHAT_GROUP_ID",@"[image]",@"CHAT_CONTENT",[FormatTime dateToStr:[NSDate date]],@"CREATE_DATE",strSendId,@"USER_PRINCIPAL_NAME",savedImagePath,@"FILE_PATH",savedImagePath, @"CHAT_SMALLPIC",nil]];
    NSInteger sessionId =[[eChatDAO sharedChatDao] insertNativeMsg:nativeArr];
    //NSString *diffUUID = [[CommUtilHelper sharedInstance] createDiffUUID] ;
    NSString *diffUUID = [CommUtilHelper getDeviceId];
    NSString *strSessionId = [[diffUUID stringByAppendingString:@"_"] stringByAppendingString:[NSString stringWithFormat:@"%li",(long)sessionId]];
    /**
     //添加消息
     XHMessage *photoMessage = [[XHMessage alloc] initWithPhoto:photo thumbnailUrl:nil originPhotoUrl:nil sender:sender timestamp:date NativePath:savedImagePath handleDic:nil];
     photoMessage.avator = [self getMyHeadPhoto];
     photoMessage.avatorUrl = nil;
     [self addMessage:photoMessage];
     [self finishSendMessageWithBubbleMessageType:XHBubbleMessageMediaTypePhoto];
     8*/
    //缩放图片大小
    UIImage *img =  [[self photographyHelper] imageWithImage:photo scaledToSize:[[CommUtilHelper sharedInstance] scaleToSize:photo.size MaxWidth:1024.0f MaxHeight:768.0f]];
    //
    NSData *iamgedata = UIImageJPEGRepresentation(img, 0.25f);
    NSString *_encodeBase64 = [iamgedata base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    [dict setObject:strSendId forKey:@"from"];
    [dict setObject:strSessionId forKey:@"sId"];
    [dict setObject:self.groupId forKey:@"groupid"];
    [dict setObject:nickName forKey:@"nickname"];
    [dict setObject:[NSString stringWithFormat:@"%f",img.size.width]  forKey:@"imgWidth"];
    [dict setObject:[NSString stringWithFormat:@"%f",img.size.height] forKey:@"imgHeight"];
    [dict setObject:_encodeBase64 forKey:@"imgData"];
    [dict setObject:[CommUtilHelper getDeviceId] forKey:@"deviceId"];
    [NSThread detachNewThreadSelector:@selector(asySendImage:) toTarget:self withObject:dict];
    //[self asySendImage:dict];
    if (socketClient.isConnected) {
        [[MessageUtilHelper sharedInstance] setUnSendMessageID:[NSString stringWithFormat:@"%li",(long)sessionId ]];
    }
    [self loadDemoDataSource];
}

/**
 *  发送视频消息的回调方法
 *
 *  @param videoPath 目标视频本地路径
 *  @param sender    发送者的名字
 *  @param date      发送时间
 */
- (void)didSendVideoConverPhoto:(UIImage *)videoConverPhoto videoPath:(NSString *)videoPath fromSender:(NSString *)sender onDate:(NSDate *)date {
    XHMessage *videoMessage = [[XHMessage alloc] initWithVideoConverPhoto:videoConverPhoto videoPath:videoPath videoUrl:nil sender:sender timestamp:date];
    videoMessage.avator =[self getMyHeadPhoto];;
    videoMessage.avatorUrl = nil;
    [self addMessage:videoMessage];
    [self finishSendMessageWithBubbleMessageType:XHBubbleMessageMediaTypeVideo];
}

/**
 *  发送语音消息的回调方法
 *
 *  @param voicePath        目标语音本地路径
 *  @param voiceDuration    目标语音时长
 *  @param sender           发送者的名字
 *  @param date             发送时间
 */
- (void)didSendVoice:(NSString *)voicePath voiceDuration:(NSString *)voiceDuration fromSender:(NSString *)sender  onDate:(NSDate *)date {
    NSLog(@"voice patch%@",voicePath);
    //保存数据库
    
    if ([voiceDuration integerValue] <1.0) {
        [self.view.window showHUDWithText:@"语音时间太短!" Type:ShowPhotoNo Enabled:YES];
        
        return;
    }
    
    NSMutableArray *nativeArr = [NSMutableArray arrayWithObject:[NSDictionary dictionaryWithObjectsAndKeys:self.groupId,@"CHAT_GROUP_ID",@"[audio]",@"CHAT_CONTENT",[FormatTime dateToStr:[NSDate date]],@"CREATE_DATE",strSendId,@"USER_PRINCIPAL_NAME",voicePath,@"FILE_PATH",@"", @"CHAT_SMALLPIC",nil]];
    NSInteger sessionId =[[eChatDAO sharedChatDao] insertNativeMsg:nativeArr];
    //NSString *diffUUID = [[CommUtilHelper sharedInstance] createDiffUUID];
    NSString *diffUUID = [CommUtilHelper getDeviceId];
    NSString *strSessionId = [[diffUUID stringByAppendingString:@"_"] stringByAppendingString:[NSString stringWithFormat:@"%li",(long)sessionId]];
    NSData *voiceData = [NSData dataWithContentsOfFile:voicePath];
    NSString *bas64Voice = [voiceData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    //添加消息
    XHMessage *voiceMessage = [[XHMessage alloc] initWithVoicePath:voicePath voiceUrl:nil voiceDuration:voiceDuration sender:sender sendStrId:strSendId timestamp:date handleDic:nil IsSending:YES];
    NSMutableDictionary *handledic = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"notime",@"syncTime",[NSString stringWithFormat:@"%li",(long)sessionId],@"sessionId",strSendId,strSessionId,@"sId",@"user", nil];
    
    if(!socketClient.isConnected) {
        voiceMessage = [[XHMessage alloc] initWithVoicePath:voicePath voiceUrl:nil voiceDuration:voiceDuration sender:sender sendStrId:strSendId timestamp:date handleDic:handledic IsSending:YES];
    }
    voiceMessage.avator =[self getMyHeadPhoto];
    voiceMessage.avatorUrl = nil;
    [self addMessage:voiceMessage];
    [self finishSendMessageWithBubbleMessageType:XHBubbleMessageMediaTypeVoice];
    //
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:strSendId forKey:@"from"];
    [dict setObject:self.groupId forKey:@"groupid"];
    [dict setObject:nickName forKey:@"nickname"];
    [dict setObject:strSessionId forKey:@"sId"];
    [dict setObject:@"temp.caf"  forKey:@"filePath"];
    [dict setObject:bas64Voice  forKey:@"fileData"];
    [dict setObject:[CommUtilHelper getDeviceId] forKey:@"deviceId"];
    [NSThread detachNewThreadSelector:@selector(asySendVoice:) toTarget:self withObject:dict];
    
    if (socketClient.isConnected) {
        [[MessageUtilHelper sharedInstance] setUnSendMessageID:[NSString stringWithFormat:@"%li",(long)sessionId ]];
    }
    
    
    
}

/**
 *  发送第三方表情消息的回调方法
 *
 *  @param facePath 目标第三方表情的本地路径
 *  @param sender   发送者的名字
 *  @param date     发送时间
 */
- (void)didSendEmotion:(NSString *)emotionPath fromSender:(NSString *)sender onDate:(NSDate *)date {
    XHMessage *emotionMessage = [[XHMessage alloc] initWithEmotionPath:emotionPath sender:sender timestamp:date];
    emotionMessage.avator = [UIImage imageNamed:@"logo"];
    emotionMessage.avatorUrl = nil;
    [self addMessage:emotionMessage];
    [self finishSendMessageWithBubbleMessageType:XHBubbleMessageMediaTypeEmotion];
}
/**
 *  是否显示时间轴Label的回调方法
 *
 *  @param indexPath 目标消息的位置IndexPath
 *
 *  @return 根据indexPath获取消息的Model的对象，从而判断返回YES or NO来控制是否显示时间轴Label
 */
- (BOOL)shouldDisplayTimestampForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row % 3)
        return YES;
    else
        return NO;
}

/**
 *  配置Cell的样式或者字体
 *
 *  @param cell      目标Cell
 *  @param indexPath 目标Cell所在位置IndexPath
 */
- (void)configureCell:(XHMessageTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
}

/**
 *  协议回掉是否支持用户手动滚动
 *
 *  @return 返回YES or NO
 */
- (BOOL)shouldPreventScrollToBottomWhileUserScrolling {
    return YES;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}
#pragma socket io delegate

-(void)SokcetIoContect
{
    socketClient = [SocketIOConnect sharedInstance].socketIOClient;
    if (!socketClient) {
        [[SocketIOConnect sharedInstance] doConnect];
    }
    socketClient.delegate = self;
}

-(void)socketIO:(SocketIO *)socket didReceiveMessage:(SocketIOPacket *)packet
{
    //NSLog(@"received from server data:%@",packet.data);
    //NSLog(@"recievie message");
}
- (void) socketIO:(SocketIO *)socket didReceiveEvent:(SocketIOPacket *)packet
{
    @try {
        NSLog(@"received from server data:%@",packet.data);
    // NSArray *aryEventName = [NSArray arrayWithObjects:@"online",@"getOnlineNum",@"newMember",@"delMember",@"sendMsg",@"sendSysMsg",@"DisbandGroup",@"sendImg",@"setHeaderPhoto",@"disconnect",@"sendAudio",nil];
    NSArray *aryEventName = [NSArray arrayWithObjects:@"online",@"getOnlineNum",@"sendMessage",nil];
    //0是事    //0是事件名称＝packet.name,1才是json数据
    
    if (![@"sendMessage" isEqualToString:packet.name]) {
        return;
    }
    NSMutableArray *dataArr = [[CommUtilHelper sharedInstance] jsonToObject:packet.data];
    for (int i=0; i<[dataArr count]; i++) {
        NSMutableDictionary *dictReceivedMsg =[dataArr objectAtIndex:i];
        int eventIndex = (int)[aryEventName indexOfObject:packet.name];
        //服务器发过来的groupid是整数，应该转成字符串，否则会造成crash
        NSString *sendGroupId = [NSString stringWithFormat:@"%@",[dictReceivedMsg objectForKey:@"groupId"]];
        NSString *sender =[dictReceivedMsg objectForKey:@"nickname"];
        NSString *sourceMsg = [dictReceivedMsg objectForKey:@"msg"];
        NSString *msg = [sourceMsg htmlDecode:sourceMsg];
        NSString *from =[dictReceivedMsg objectForKeyedSubscript:@"from"];
        NSString *msgType = [dictReceivedMsg objectForKey:@"msgType"];
        BOOL isCalclateCount = true;
        if ([self.groupId isEqualToString:sendGroupId]) {
            isCalclateCount = false;
        }
        /***内存过滤
         if ([[[MessageUtilHelper sharedInstance] getMessageUUID] containsObject:[dictReceivedMsg objectForKey:@"uuid"]]) {
         NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[CommUtilHelper getDeviceId],@"deviceId",[[CommUtilHelper sharedInstance] getUser],@"username",[dictReceivedMsg objectForKey:@"uuid"],@"successIds",@"",@"failureIds",@"",@"failureMsgs", nil];
         [[MessageUtilHelper sharedInstance] sendMessageFun:nil SendDic:dic UUID:[dictReceivedMsg objectForKey:@"uuid"] Suceess:YES];
         
         continue;
         }else
         {
         [[MessageUtilHelper sharedInstance] setMessageUUID:[dictReceivedMsg objectForKey:@"uuid"]];
         }
         
         *///
        switch (eventIndex) {
            case 2:
            {
                
                if ([@"NEW_MEMBER" isEqualToString:msgType]) {
                    //newMember
                    //newMember是先发一个msgType=A的sendSysMsg消息，再发newMember
                    [[MessageUtilHelper sharedInstance] MessageHandle:packet   DicData:dictReceivedMsg GroupId:self.groupId delegate:self isCalculteCount:isCalclateCount];
                    //
                    totalCount = [[eChatDAO sharedChatDao] getTotalNumberByGroup:self.groupId];
                    self.navigationItem.title = self.groupTitle;
                    [self loadDemoDataSource];
                    
                    break;
                }else if([@"DEL_MEMBER" isEqualToString:msgType])
                {
                    //delMember
                    //delMember是直接只发一个delMember消息
                    [[MessageUtilHelper sharedInstance] MessageHandle:packet  DicData:dictReceivedMsg GroupId:self.groupId delegate:self isCalculteCount:isCalclateCount];
                    //
                    NSString *msgType= [dictReceivedMsg objectForKey:@"msgType"];
                    NSString *user =[dictReceivedMsg objectForKeyedSubscript:@"delMembers"];
                    long losessionid =[[dictReceivedMsg objectForKey:@"sessionId"] longValue];
                    NSString *groupSessionId = [NSString stringWithFormat:@"%i",(int)losessionid];
                    NSString *serverDate =[dictReceivedMsg objectForKey:@"date"];
                    NSString *theMsg = nil;
                    //NSString *msgSubType =[dictReceivedMsg objectForKey:@"msgSubType"];
                    //if ([@"T" isEqualToString:msgSubType]) {
                    if ([user isEqualToString:strSendId]) {
                        //自己被踢出
                        [self showAlertView:msg];
                        [self doBack];
                    }else
                    {
                        theMsg = [dictReceivedMsg objectForKey:@"msgAll"];
                    }
                    //}
                    if(theMsg == nil){
                        theMsg = msg;
                    }
                    //
                    XHMessage *textMessage = [self getTextMessage:theMsg sender:chatSystemUserName sendStrID:chatSystemUserName Date:[self strToDate:[self dateToStr:[NSDate date]]] BubbleMessageType:XHBubbleMessageTypeReceiving headPhoto:nil handleDic:[NSMutableDictionary dictionaryWithObjectsAndKeys:serverDate,@"syncTime",groupSessionId,@"sessionId", nil]];
                    textMessage.avator = [UIImage imageNamed:@"logo"];
                    textMessage.avatorUrl = nil;
                    if ([self checkIsCUrrMsg:sendGroupId currGroupId:self.groupId]) {
                        [self addMessage:textMessage];
                        //[self loadDemoDataSource];
                    }
                    
                    totalCount = [[eChatDAO sharedChatDao] getTotalNumberByGroup:self.groupId];
                    self.navigationItem.title = self.groupTitle ;
                    
                    break;
                    
                }else if([@"TEXT" isEqualToString:msgType])
                {
                    
                    
                    //sendMsg
                    BOOL sucess= [[MessageUtilHelper sharedInstance]  MessageHandle:packet DicData:dictReceivedMsg  GroupId:self.groupId delegate:self isCalculteCount:isCalclateCount];
                    //[from isEqualToString:strSendId] &&
                    if ([from isEqualToString:strSendId] && [self checkIsCUrrMsg:sendGroupId currGroupId:self.groupId])
                    {
                        [self loadDemoDataSource];
                        break;
                    }
                    if (subscribeLoadingView !=nil) {
                        [UIView animateWithDuration:2 animations:^{
                            [subscribeLoadingView setFrame:CGRectZero];
                            [UIView animateWithDuration:1 animations:^{
                                [subscribeLoadingView removeFromSuperview];
                            }];
                        }];
                        
                    }
                    
                    NSString *temp =[EmotionHelper disposalTextAndFace:msg];
                    NSString *imageName = [[eChatDAO sharedChatDao] getHeadPhotoNameByUser:from];
                   float losessionid =[[dictReceivedMsg objectForKey:@"sessionId"] floatValue];
                    NSString *groupSessionId = [NSString stringWithFormat:@"%li",losessionid];
                    NSString *serverDate =[dictReceivedMsg objectForKey:@"date"];
                    temp = [[CommUtilHelper sharedInstance] getFlatSaleMessage:temp];
                    //
                    XHMessage *textMessage = [self getTextMessage:temp sender:sender sendStrID:sender Date:[self strToDate:[self dateToStr:[NSDate date]]] BubbleMessageType:XHBubbleMessageTypeReceiving headPhoto:imageName handleDic:[NSMutableDictionary dictionaryWithObjectsAndKeys:serverDate,@"syncTime",groupSessionId,@"sessionId",groupSessionId,@"groupSessionId", nil]];
                    if ([self checkIsCUrrMsg:sendGroupId currGroupId:self.groupId]) {
                        if (sucess) {
                            [self addMessage:textMessage];
                        }
                        
                        [self loadDemoDataSource];
                    }
                    
                    break;
                    
                }else if([@"SYS" isEqualToString:msgType])
                {
                    //sendSysMsg
                    [[MessageUtilHelper sharedInstance] MessageHandle:packet  DicData:dictReceivedMsg GroupId:self.groupId delegate:self isCalculteCount:isCalclateCount];
                    //
                    long losessionid =[[dictReceivedMsg objectForKey:@"sessionId"] longValue];
                    NSString *groupSessionId = [NSString stringWithFormat:@"%i",(int)losessionid];
                    NSString *serverDate =[dictReceivedMsg objectForKey:@"date"];
                    XHMessage *textMessage = [self getTextMessage:msg sender:chatSystemUserName sendStrID:chatSystemUserName Date:[self strToDate:[self dateToStr:[NSDate date]]] BubbleMessageType:XHBubbleMessageTypeReceiving headPhoto:nil handleDic:[NSMutableDictionary dictionaryWithObjectsAndKeys:serverDate,@"syncTime",groupSessionId,@"sessionId", nil]];
                    textMessage.avator = [UIImage imageNamed:@"logo"];
                    textMessage.avatorUrl = nil;
                    if ([self checkIsCUrrMsg:sendGroupId currGroupId:self.groupId]) {
                        [self addMessage:textMessage];
                        //[self loadDemoDataSource];
                    }
                    
                    if([@"E" isEqualToString:[dictReceivedMsg objectForKey:@"msgSubType"]]){
                        //修改群名称事件
                        if ([self checkIsCUrrMsg:sendGroupId currGroupId:self.groupId]) {
                            self.groupTitle = [dictReceivedMsg objectForKey:@"groupName"];
                            self.navigationItem.title = self.groupTitle ;
                        }
                        
                    }
                    //[self loadDemoDataSource];
                    break;
                    
                }else if([@"IMAGE" isEqualToString:msgType])
                {
                    BOOL sucess= [[MessageUtilHelper sharedInstance]  MessageHandle:packet  DicData:dictReceivedMsg GroupId:self.groupId delegate:self isCalculteCount:isCalclateCount];
                    if ([from isEqualToString:strSendId] && [self checkIsCUrrMsg:sendGroupId currGroupId:self.groupId])
                    {
                        [self loadDemoDataSource];
                        break;
                    }
                    //
                    NSString *imgData = [dictReceivedMsg objectForKey:@"fileData"];
                    NSString *smallImgName = [[CommUtilHelper sharedInstance] saveImageToPath:imgData];
                    NSString *filePic = [dictReceivedMsg objectForKey:@"filePath"];
                    NSMutableArray *voiceArr =[[NSMutableArray alloc] initWithArray: [filePic  componentsSeparatedByString:@"/"]];
                    NSString *fileName = nil;
                    if ([voiceArr count]) {
                        fileName =  [voiceArr objectAtIndex:voiceArr.count-1];
                    }
                    long losessionid =[[dictReceivedMsg objectForKey:@"sessionId"] longValue];
                    NSString *groupSessionId = [NSString stringWithFormat:@"%i",(int)losessionid];
                    NSString *serverDate =[dictReceivedMsg objectForKey:@"date"];
                    //
                    NSString *headPhotoName = [[eChatDAO sharedChatDao] getHeadPhotoNameByUser:from];
                    XHMessage *imageMessage  = [self getPhotoMessageWithBubbleMessageType:XHBubbleMessageTypeReceiving sender:sender sendStrId:from smallImgName:smallImgName bigImgUrl:fileName headPhoto:headPhotoName Date:[self strToDate:[self dateToStr:[NSDate date]]] handleDic:[NSMutableDictionary dictionaryWithObjectsAndKeys:serverDate,@"syncTime",groupSessionId,@"sessionId", groupSessionId,@"groupSessionId",nil]];
                    if ([self checkIsCUrrMsg:sendGroupId currGroupId:self.groupId]){
                        if (sucess) {
                            [self addMessage:imageMessage];
                        }
                        
                        //[self loadDemoDataSource];
                    }
                    
                    break;
                    
                }else if([@"AUDIO" isEqualToString:msgType])
                {
                    //sendAudio
                    BOOL suceess =   [[MessageUtilHelper sharedInstance]  MessageHandle:packet  DicData:dictReceivedMsg GroupId:self.groupId delegate:self isCalculteCount:isCalclateCount];
                    if ([from isEqualToString:strSendId]  && [self checkIsCUrrMsg:sendGroupId currGroupId:self.groupId])
                    {
                        [self loadDemoDataSource];
                        break;
                    }
                    NSString *sender =[dictReceivedMsg objectForKey:@"nickname"];
                    NSString *filePatch = [dictReceivedMsg objectForKey:@"filePath"];
                    long losessionid =[[dictReceivedMsg objectForKey:@"sessionId"] longValue];
                    NSString *groupSessionId = [NSString stringWithFormat:@"%i",(int)losessionid];
                    NSString *serverDate =[dictReceivedMsg objectForKey:@"date"];
                    NSString *imageName = [[eChatDAO sharedChatDao] getHeadPhotoNameByUser:from];
                    XHMessage *voiceMessage = [self getVoiceMessageWithBubbleMessageType:XHBubbleMessageTypeReceiving Sender:sender sendStrId:from voiceUrl:[NSString stringWithFormat:@"%@/%@",charUrl,filePatch] Date: [self strToDate:[self dateToStr:[NSDate date]]] headPhoto:imageName handleDic:[NSMutableDictionary dictionaryWithObjectsAndKeys:serverDate,@"syncTime",groupSessionId,@"sessionId",groupSessionId,@"groupSessionId", nil]];
                    if ([self checkIsCUrrMsg:sendGroupId currGroupId:self.groupId]) {
                        if (suceess) {
                            [self addMessage:voiceMessage];
                            
                        }
                        
                        //[self loadDemoDataSource];
                    }
                    
                    break;
                    
                }else
                {
                    [[MessageUtilHelper sharedInstance] MessageHandle:packet   DicData:dictReceivedMsg GroupId:self.groupId delegate:self isCalculteCount:isCalclateCount];
                }
                
            }
            case 9:
            {
                /*
                 //disconnect
                 NSString *navigationTitle =self.navigationItem.title;
                 NSString *textTitle = @"";
                 if (navigationTitle) {
                 NSArray *arr=[navigationTitle componentsSeparatedByString:@"("];
                 textTitle = [arr objectAtIndex:0];
                 if ([arr count]>1) {
                 NSArray *arr1 = [[arr objectAtIndex:1] componentsSeparatedByString:@"/"];
                 NSString *number = arr1[0];
                 if (number) {
                 int total = 0;
                 if ([number intValue]>1) {
                 total = [number intValue]-1;
                 }
                 self.navigationItem.title= [textTitle stringByAppendingString:[NSString stringWithFormat:@"(%i/%i)",total,(int)totalCount]];
                 }
                 }
                 }
                 */
                break;
            }
                
            default:
                
                break;
        }
        
    }
        
    }
    @catch (NSException *exception) {
        NSLog(@"%@",[exception description]);
    }
    
    //清除新消息计数
    //[[CommUtilHelper sharedInstance] newMessageCounterByGroupId:self.groupId MessageCounter:@"0"];
}

//
-(NSString *)integerToString:(NSInteger) num
{
    return [NSString stringWithFormat:@"%i",(int)num];
}
////
-(void)showAlertView:(NSString *)message
{
    NSString *m = message;
    if (message == nil) {
        m=@"error";
    }
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:m delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alertView show];
}

-(void)socketIODidConnect:(SocketIO *)socket
{
    NSLog(@"%@",@"connect");
    self.navigationItem.title = self.groupTitle;
    //[self sendUnSendMessage];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *name = [ud objectForKey:@"user"];
    [dict setObject:name forKey:@"user"];
    [dict setObject:[CommUtilHelper getDeviceId] forKey:@"deviceId"];
    [socketClient sendEvent:@"online" withData:dict];
    
}

//断线发消息
-(void)sendUnSendMessage:(NSString *)sessionid
{
    //    NSMutableArray *infoArr = [[MessageUtilHelper sharedInstance] getUnSendMessage];
    //
    //    if ([infoArr count]>0) {
    //        for (int i=0; i<[infoArr count]; i++) {
    //            NSString *sessionid = [infoArr objectAtIndex:i];
    NSString *diffUUID = [[CommUtilHelper sharedInstance] createDiffUUID];
    NSString *strSid = [[diffUUID stringByAppendingString:@"_"] stringByAppendingString:sessionid];
    NSMutableArray *arr = [[eChatDAO sharedChatDao] getCHatGroupSessionbySessionId:sessionid];
    if ([arr count]>0) {
        NSDictionary *dic= [arr objectAtIndex:0];
        NSString *msg = [dic objectForKey:@"CHAT_CONTENT"];
        NSString *from = [dic objectForKey:@"USER_PRINCIPAL_NAME"];
        NSString *chatGroupId = [dic objectForKey:@"CHAT_GROUP_ID"];
        NSString *pic = [dic objectForKey:@"FILE_PATH"];
        NSString *NnickName = [[CommUtilHelper sharedInstance] getNickName];
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        //[dic setObject:[rs stringForColumn:@"CHAT_SMALLPIC"] forKey:@"CHAT_SMALLPIC"];
        //[dic setObject:[rs stringForColumn:@"FILE_PATH"] forKey:@"FILE_PATH"];
        //更新本地时间
        [[eChatDAO sharedChatDao] updateTimeBySessionId:sessionid];
        [self loadDemoDataSource];
        if ([@"[image]" isEqualToString:msg]) {
            NSMutableArray *imgArr =[[NSMutableArray alloc] initWithArray: [pic  componentsSeparatedByString:@"/"]];
            NSString *fileName = nil;
            if ([imgArr count]) {
                fileName =  [imgArr objectAtIndex:imgArr.count-1];
            }
            NSString *_filePath = [[CommUtilHelper sharedInstance] dataImagePath:fileName ];
            NSFileManager *fileManager = [NSFileManager defaultManager];
            if ([fileManager fileExistsAtPath:_filePath]) {
                
                NSData *imgData = [[NSData alloc] initWithContentsOfFile:_filePath];
                UIImage *imgPhoto = [[UIImage alloc] initWithData:imgData];
                UIImage *img =  [[self photographyHelper] imageWithImage:imgPhoto scaledToSize:[[CommUtilHelper sharedInstance] scaleToSize:imgPhoto.size MaxWidth:1024.0f MaxHeight:768.0f]];
                NSData *iamgedata1 = UIImageJPEGRepresentation(img, 0.5f);
                NSString *_encodeBase64 = [iamgedata1 base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
                [dict setObject:from forKey:@"from"];
                [dict setObject:strSid forKey:@"sId"];
                [dict setObject:chatGroupId forKey:@"groupid"];
                [dict setObject:NnickName forKey:@"nickname"];
                [dict setObject:[NSString stringWithFormat:@"%f",img.size.width]  forKey:@"imgWidth"];
                [dict setObject:[NSString stringWithFormat:@"%f",img.size.height] forKey:@"imgHeight"];
                [dict setObject:_encodeBase64 forKey:@"imgData"];
                [dict setObject:[CommUtilHelper getDeviceId] forKey:@"deviceId"];
                //[self asySendImage:dict];
                [NSThread detachNewThreadSelector:@selector(asySendImage:) toTarget:self withObject:dict];
                
                [[MessageUtilHelper sharedInstance] setUnSendMessageID:sessionid];
                
            }
        }else if([@"[audio]" isEqualToString:msg])
        {
            
            NSMutableArray *imgArr =[[NSMutableArray alloc] initWithArray: [pic  componentsSeparatedByString:@"/"]];
            NSString *fileName = nil;
            if ([imgArr count]) {
                fileName =  [imgArr objectAtIndex:imgArr.count-1];
            }
            NSString *_filePath = [[CommUtilHelper sharedInstance] dataVoicePath:fileName ];
            NSData *voiceData = [NSData dataWithContentsOfFile:_filePath];
            NSString *bas64Voice = [voiceData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            [dict setObject:from forKey:@"from"];
            [dict setObject:chatGroupId forKey:@"groupid"];
            [dict setObject:NnickName forKey:@"nickname"];
            [dict setObject:strSid forKey:@"sId"];
            [dict setObject:@"temp.caf"  forKey:@"filePath"];
            [dict setObject:bas64Voice  forKey:@"fileData"];
            [dict setObject:[CommUtilHelper getDeviceId] forKey:@"deviceId"];
            [socketClient sendEvent:@"sendImg" withData:dict];
            [NSThread detachNewThreadSelector:@selector(asySendVoice:) toTarget:self withObject:dict];
            [[MessageUtilHelper sharedInstance] setUnSendMessageID:sessionid];
        }else
        {
            //发送文本数据
            [dict setObject:from forKey:@"from"];
            [dict setObject:chatGroupId forKey:@"groupid"];
            [dict setObject:NnickName forKey:@"nickname"];
            [dict setObject:strSid forKey:@"sId"];
            [dict setObject:[self dateToStr:[NSDate date]] forKey:@"date"];
            [dict setObject:msg forKey:@"msg"];
            [dict setObject:[CommUtilHelper getDeviceId] forKey:@"deviceId"];
            [socketClient sendEvent:@"sendMsg" withData:dict];
            [[MessageUtilHelper sharedInstance] setUnSendMessageID:sessionid];
        }
    }
    //        }
    //    }
}

-(void)asySendImage:(NSMutableDictionary *)dict
{
    [socketClient sendEvent:@"sendImg" withData:dict];
}
-(void)asySendVoice:(NSMutableDictionary *)dict
{
    [socketClient sendEvent:@"sendAudio" withData:dict];
}
-(void)socketIO:(SocketIO *)socket onError:(NSError *)error
{
    if (error) {
        if (!socketClient.isConnected) {
            self.navigationItem.title=@"Disconnect";
            if (socketClient.isConnecting) {
                self.navigationItem.title=@"Connecting...";
            }
        }else
        {
            self.navigationItem.title = self.groupTitle;
        }
        bool check = [[SocketIOConnect sharedInstance] doConnect];
        if (check) {
            //            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            //            NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
            //            NSString *name = [ud objectForKey:@"user"];
            //            [dict setObject:name forKey:@"user"];
            //            [dict setObject:[CommUtilHelper getDeviceId] forKey:@"deviceId"];
            //            [socketClient sendEvent:@"online" withData:dict];
        }
        else
        {
            [self showAlertView:@"Can not connect server"];
        }
    }
}
-(BOOL)checkIsCUrrMsg:(NSString *)s1 currGroupId:(NSString *)s2
{
    if ([s1 isEqualToString:s2]) {
        return true;
    }else
    {
        return  false;
    }
}


-(void)socketIODidDisconnect:(SocketIO *)socket disconnectedWithError:(NSError *)error
{
    
    bool check = [[SocketIOConnect sharedInstance] doConnect];
    if (check) {
        //NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        //NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        //NSString *name = [ud objectForKey:@"user"];
        //[dict setObject:name forKey:@"user"];
        //[dict setObject:[CommUtilHelper getDeviceId] forKey:@"deviceId"];
        //[dict setObject:@"1" forKey:@"onlineTimes"];
        //[dict setObject:@"" forKey:@"where"];
        //[socketClient sendEvent:@"online" withData:dict];
    }
    else
    {
        self.navigationItem.title=@"Disconnect";
        
    }
    
}

//

-(void) doBack
{
    doNotRefresh = NO;
    [self.navigationController popToRootViewControllerAnimated:YES];
}
//成员设置
-(void)chatSetting
{
    
    doNotRefresh = NO;
    FSSettingViewController *miSetting = [[FSSettingViewController alloc] init] ;
    UIBarButtonItem *temporaryBarButtonItem=[[UIBarButtonItem alloc] init];
    temporaryBarButtonItem.title=@"";
    miSetting.source = source;
    self.navigationItem.backBarButtonItem = temporaryBarButtonItem;
    [self.navigationController pushViewController:miSetting animated:YES];
}


//发消息
-(void)sendMsg:(NSDictionary *)dic Event:(NSString *)event
{
    [socketClient sendEvent:event withData:dic];
}
//转发
-(void)transPondMessage:(id<XHMessageModel>)_message
{
    doNotRefresh = NO;
    [self.tabBarController.tabBar setHidden:YES];
    TransPondViewController *v = [[TransPondViewController alloc] init];
    v.message = _message;
    v.navigationItem.title=@"Select Target";
    [self.navigationController pushViewController:v animated:YES];
    
    
    
    //UINavigationController *av = [[UINavigationController alloc] initWithRootViewController:v];
    //[self presentViewController:av animated:YES completion:^(void){}];
}
//重发消息
-(void)repeatSendButton:(UIButton *)sendButton
{
    if (socketClient.isConnected) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Prompt" message:@"Try Send Message?" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Cancel", nil];
        [alertView show];
        repeatTag = sendButton.tag;
    }else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Prompt" message:@"NetWork Error,Try Again later?" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Cancel", nil];
        repeatTag = -1;
        [alertView show];
    }
    
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
        {
            if (repeatTag && repeatTag>0) {
                UIButton *repeatButton =(UIButton *)[self.view viewWithTag:repeatTag];
                UIActivityIndicatorView *loadView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                XHMessageTableViewCell *cell =  (XHMessageTableViewCell *)[repeatButton superview].superview;
                cell.isSending=YES;
                [loadView setFrame:CGRectMake(repeatButton.frame.origin.x,repeatButton.frame.origin.y, 30, 30)];
                [repeatButton setHidden:YES];
                [cell.sendLoadView startAnimating];
                [self sendUnSendMessage:[NSString stringWithFormat:@"%li",(long)repeatTag]];
                //[repeatButton setHidden:YES];
            }
        }
            break;
        case 1:
        {
            
        }
        default:
            break;
    }
}
/*
 *
 *长按头像操作
 */
-(void)didLongPressHead:(id<XHMessageModel>)message atIndexPath:(NSIndexPath *)indexPath
{
    NSString *avadorName =  message.sender;
    NSString *currText  = self.messageInputView.inputTextView.text;
    avadorName = [@"@" stringByAppendingString:avadorName];
    if ([currText rangeOfString:avadorName].location != NSNotFound) {
        return;
    }
    self.messageInputView.inputTextView.text =[currText stringByAppendingString:avadorName];
    [self.messageInputView.inputTextView becomeFirstResponder];
}
-(void)preDisSendImageView:(PreDisImageViewController *)con
{
    [self.navigationController pushViewController:con animated:YES];
    //[self presentViewController:con animated:YES completion:nil];
}

-(BOOL)textView:(SETextView *)textView clickedOnLink:(SELinkText *)link atIndex:(NSUInteger)charIndex
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[link text]]];
    return YES;
}
-(void)sigleSubscribeViewTapGestureRecognizerHandle:(id<XHMessageModel>)message atIndexPath:(NSIndexPath *)indexPath onMessageTableViewCell:(XHMessageTableViewCell *)messageTableViewCell
{
    NSMutableDictionary *messageDic = message.messageDic;
    if (messageDic !=nil){
        NSString *url = [messageDic objectForKey:@"LINKURL"];
        if (url !=nil && ![@"" isEqualToString:url] && ![url isKindOfClass:[NSNull class]]) {
            NSMutableArray *userInfo =[[eChatDAO sharedChatDao] getUserInfo:[[CommUtilHelper sharedInstance] getUser]];
            NSDictionary *userDic=nil;
            if (userInfo && [userInfo count]>0) {
                userDic = [userInfo objectAtIndex:0];
            }
            NSString *email = nil;
            NSString *staffCode = nil;
            if (userDic) {
                email = [userDic objectForKey:@"EMAIL"];
                
                staffCode = [userDic objectForKey:@"EMPLOYEE_NUMBER"];
            }
            NSRange range =  [url rangeOfString:@"?"];
            if (range.length == 0) {
              url=  [NSString stringWithFormat:@"%@%@",url,@"?"];
            }
            url= [NSString stringWithFormat:@"%@&userName=%@&deviceId=%@&email=%@&staffCode=%@",url, [[CommUtilHelper sharedInstance] getUser],[CommUtilHelper getDeviceId],email,staffCode];
            NavWebViewController *webViewCon = [[NavWebViewController alloc] initWithUrl:url];
            webViewCon.navigationItem.hidesBackButton=YES;
            [webViewCon reloadHtml];
            [self.navigationController pushViewController:webViewCon animated:YES];
        }

    }
}


-(NSMutableArray *)getMoreMessage
{
    
    userArr = [[eChatDAO sharedChatDao] getCHatGroupSessionByminPage:minNumber toMax:maxNumber GroupId:self.groupId];
    if ([userArr count] == 0){
        if (lastGroupSessionId == nil) {
            lastGroupSessionId = @"0";
        }
//        ResponseModel *rs =  [CharViewNetServiceUtil getMoreMessageInfo:[[CommUtilHelper sharedInstance] getUser] GroupSessionId:lastGroupSessionId groupId:groupId row:10];
//        NSMutableArray *marr = rs.resultInfo;
//        [[eChatDAO sharedChatDao] insertHisMsgFromServer:marr];
//        maxNumber = [[eChatDAO sharedChatDao] getMaxSessionId:groupId];
//        userArr = [[eChatDAO sharedChatDao] getCHatGroupSessionByminPage:minNumber toMax:maxNumber GroupId:self.groupId];
        
    }
    return userArr;
}

-(void)didClickMenuButton:(NSString *)URL
{
    
        if (URL !=nil && ![@"" isEqualToString:URL]) {
             NavWebViewController *webViewCon = [[NavWebViewController alloc] initWithUrl:URL];
            [webViewCon reloadHtml];
            [self.navigationController pushViewController:webViewCon animated:YES];
        }
        
    
}
-(void)didClickSubscirbImage:(NSString *)url
{
    XHDisplayMediaViewController *messageDisplayPhotoView = [[XHDisplayMediaViewController alloc] init];
    messageDisplayPhotoView.linkUrl = url;
    self.allowScrollToBottom=NO;//不允许滑倒底部
    UIBarButtonItem *temporaryBarButtonItem=[[UIBarButtonItem alloc] init];
    temporaryBarButtonItem.title=@"";
    self.navigationItem.backBarButtonItem = temporaryBarButtonItem;
    [self.navigationController pushViewController:messageDisplayPhotoView animated:YES];
}
@end

