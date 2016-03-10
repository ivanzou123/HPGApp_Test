//
//  TransPondViewController.m
//  HwpgMobile
//
//  Created by hwpl hwpl on 14-12-6.
//  Copyright (c) 2014年 hwpl hwpl. All rights reserved.
//

#import "TransPondViewController.h"
#import "eChatDAO.h"
#import "FormatTime.h"
#import "CommUtilHelper.h"
#import "ChatMessageViewController.h"
#import "XHPhotographyHelper.h"
#import "MessageUtilHelper.h"
@interface TransPondViewController ()
{
    NSMutableArray *userArr;
    NSString *targetGroupId;
    NSString *targetGroupName;
    UIView *messageView;
}
@end

@implementation TransPondViewController
@synthesize message;
@synthesize groupId;
- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navigationController.navigationBar.barTintColor= [CommUtilHelper getDefaultBackgroupColor];
//    self.navigationController.navigationBar.translucent=YES;
//    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
//    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    //self.navigationController.navigationBar.barTintColor=kGetColor(248, 248, 248);
    //self.navigationController.navigationBar.tintColor = kGetColor(4, 118, 246);
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(doBack)];
    self.navigationItem.leftBarButtonItem=leftButton;
     userArr = [[eChatDAO sharedChatDao] getTransChatGroupList];
    // Do any additional setup after loading the view.
}
/*
-(void)dismissView
{
    [self dismissViewControllerAnimated:YES completion:^(void){}];
}
*/
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [userArr count];
}
//
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
    targetGroupId = [NSString stringWithFormat:@"%i",(int)cell.tag];
    targetGroupName = cell.textLabel.text;
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Confirm share?" message:targetGroupName delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Confirm", nil];
    [alertView show];
}
//
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identier = [@"cell" stringByAppendingString:[NSString stringWithFormat:@"%i",(int)indexPath.row]];
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identier];
    cell.textLabel.backgroundColor = [UIColor clearColor];
    if(!cell)
    {
        cell= [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identier];
        [cell.imageView setFrame:CGRectMake(0, 0, 40, 40)];
        [cell.imageView.layer setCornerRadius:CGRectGetHeight([cell.imageView bounds]) / 2];
        cell.imageView.layer.masksToBounds = YES;
        cell.imageView.layer.borderWidth = 1;
        
        cell.imageView.layer.borderColor = [[UIColor grayColor] CGColor];
    }
    tableView.separatorInset=UIEdgeInsetsZero;
    
    NSArray *contentViewArr = [cell.contentView subviews];
    for (int i=0;i<[contentViewArr count];i++) {
        if ([[contentViewArr objectAtIndex:i] isKindOfClass:[UILabel class]]) {
            UILabel *tempLable = [contentViewArr objectAtIndex:i];
            if (tempLable.tag ==100) {
                [tempLable removeFromSuperview];
            }
        }
    }
    NSDictionary *dic = [userArr objectAtIndex:indexPath.row];
    cell.textLabel.text=[dic objectForKey:@"CHAT_GROUP_NAME"];//group name
    [cell.textLabel setFont:[UIFont systemFontOfSize:18]];
    // data:image/jpeg;base64,
    cell.tag = [[dic objectForKey:@"CHAT_GROUP_ID"] integerValue];//group id
    NSString *imageName = @"";
    NSString *isGroup =[dic objectForKey:@"IS_GROUP"];
    
    if ([@"N" isEqualToString: isGroup]){
        NSMutableArray *friendInfoArr = [[eChatDAO sharedChatDao] getAllGroupUserByGroupId:[dic objectForKey:@"CHAT_GROUP_ID"] CurrUser:[[CommUtilHelper sharedInstance] getUser]];
        if ([friendInfoArr count] >1) {
            for (int x=0; x<[friendInfoArr count]; x++) {
                NSDictionary *dicnameInfo = [friendInfoArr objectAtIndex:x];
                if (![[dicnameInfo objectForKey:@"USER"] isEqualToString:[[CommUtilHelper sharedInstance] getUser]]) {
                     cell.textLabel.text=[dicnameInfo objectForKey:@"NickName"];//group name
                }
               
            }
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
    return cell;
}
//-tableview


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(NSString *)dateToStr:(NSDate *)date
{
    NSDateFormatter *formate = [[NSDateFormatter alloc] init];
    [formate setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *strDate = [formate stringFromDate:date];
    return strDate;
}
-(void)doBack
{
    [self.navigationController popToViewController:[ChatMessageViewController shareInstance] animated:YES];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
   NSString *title = [alertView  buttonTitleAtIndex:buttonIndex];
   NSDictionary *handleDic= message.handleDic;
   NSString *transSessionId = @"";
    NSString *sId = @"";
    if (handleDic) {
        transSessionId = [handleDic objectForKey:@"groupSessionId"];
        if (transSessionId == nil || [@"" isEqualToString:transSessionId]) {
            sId = [handleDic objectForKey:@"sId"];
            transSessionId = sId;
        }
    }
    if ([title isEqualToString:@"Confirm"]) {
        NSString *myuser = [[CommUtilHelper sharedInstance] getUser];
        NSString *nickName = [[CommUtilHelper sharedInstance] getNickName];
        XHBubbleMessageMediaType mediaType = message.messageMediaType;
        NSMutableArray *nativeArr =nil;
        switch (mediaType) {
            case XHBubbleMessageMediaTypeText:
            {
                nativeArr = [NSMutableArray arrayWithObject:[NSDictionary dictionaryWithObjectsAndKeys:targetGroupId,@"CHAT_GROUP_ID",message.text,@"CHAT_CONTENT",[FormatTime dateToStr:[NSDate date]],@"CREATE_DATE",myuser,@"USER_PRINCIPAL_NAME",@"",@"FILE_PATH",@"", @"CHAT_SMALLPIC",nil]];
                NSInteger sessionId =[[eChatDAO sharedChatDao] insertNativeMsg:nativeArr];
                 NSString *strSessionId = [[[CommUtilHelper getDeviceId] stringByAppendingString:@"_" ] stringByAppendingString:[NSString stringWithFormat:@"%li",(long)sessionId]];
                
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                [dict setObject:myuser forKey:@"from"];
                [dict setObject:targetGroupId forKey:@"groupid"];
                [dict setObject:nickName forKey:@"nickname"];
                [dict setObject:transSessionId forKey:@"sessionid"];
                [dict setObject:strSessionId forKey:@"sId"];
                [dict setObject:[self dateToStr:[NSDate date]] forKey:@"date"];
                
                
                //[dict setObject:message.text forKey:@"msg"];
                [dict setObject:[CommUtilHelper getDeviceId]  forKey:@"deviceId"];
                [[ChatMessageViewController shareInstance] sendMsg:dict Event:@"forwardMessage"];
                [[MessageUtilHelper sharedInstance] setUnSendMessageID:[NSString stringWithFormat:@"%li",(long)sessionId]];
                
            }
                break;
            case XHBubbleMessageMediaTypePhoto:
            {
                NSString *imagePath = @"";
                UIImage *isNativePath =[UIImage imageNamed:message.imageNativePath];
                if (isNativePath) {
                    imagePath =message.imageNativePath;
                }
                NSString *thumbUrl =@"";
                if (message.thumbnailUrl) {
                    thumbUrl = message.thumbnailUrl;
                }else
                {
                    thumbUrl =imagePath;
                }
               
                
                
                nativeArr = [NSMutableArray arrayWithObject:[NSDictionary dictionaryWithObjectsAndKeys:targetGroupId,@"CHAT_GROUP_ID",@"[image]",@"CHAT_CONTENT",[FormatTime dateToStr:[NSDate date]],@"CREATE_DATE",myuser,@"USER_PRINCIPAL_NAME",message.imageNativePath,@"FILE_PATH",thumbUrl, @"CHAT_SMALLPIC",nil]];
                NSInteger sessionId =[[eChatDAO sharedChatDao] insertNativeMsg:nativeArr];
                //按原图尺寸缩放图片
                 NSString *strSessionId = [[[CommUtilHelper getDeviceId] stringByAppendingString:@"_" ] stringByAppendingString:[NSString stringWithFormat:@"%li",(long)sessionId]];
                UIImage *img =  [[[XHPhotographyHelper alloc] init] imageWithImage:message.photo scaledToSize:[[CommUtilHelper sharedInstance] scaleToSize:message.photo.size MaxWidth:1024.0f MaxHeight:768.0f]];
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                NSData *iamgedata = UIImageJPEGRepresentation(img, 1.0f);
                NSString *_encodeBase64 = [iamgedata base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
                [dict setObject:myuser forKey:@"from"];
                
                [dict setObject:transSessionId forKey:@"sessionid"];
                [dict setObject:strSessionId forKey:@"sId"];
                [dict setObject:targetGroupId forKey:@"groupid"];
                [dict setObject:nickName forKey:@"nickname"];
                //[dict setObject:_encodeBase64 forKey:@"imgData"];
                [dict setObject:[CommUtilHelper getDeviceId]  forKey:@"deviceId"];
                [[ChatMessageViewController shareInstance] sendMsg:dict Event:@"forwardMessage"];
                [[MessageUtilHelper sharedInstance] setUnSendMessageID:[NSString stringWithFormat:@"%i",sessionId]];
            }
                break;
            case XHBubbleMessageMediaTypeVoice:
            {
                
                NSString *voiceUrl = message.voiceUrl;
                NSString *filePath = @"";
                if (voiceUrl) {
                    NSArray *arr = [voiceUrl componentsSeparatedByString:@"/"];
                   NSString * fileName = [arr objectAtIndex:[arr count]-1];
                    filePath = [[CommUtilHelper sharedInstance] dataVoicePath:fileName];
                }
                nativeArr = [NSMutableArray arrayWithObject:[NSDictionary dictionaryWithObjectsAndKeys:targetGroupId,@"CHAT_GROUP_ID",@"[audio]",@"CHAT_CONTENT",[FormatTime dateToStr:[NSDate date]],@"CREATE_DATE",myuser,@"USER_PRINCIPAL_NAME",filePath,@"FILE_PATH",@"", @"CHAT_SMALLPIC",nil]];
                NSInteger sessionId =[[eChatDAO sharedChatDao] insertNativeMsg:nativeArr];
              
                 NSString *strSessionId = [[[CommUtilHelper getDeviceId] stringByAppendingString:@"_"] stringByAppendingString:[NSString stringWithFormat:@"%li",(long)sessionId]];
                NSData *voiceData = [NSData dataWithContentsOfFile:filePath];
                if (voiceData) {
                    NSString *bas64Voice = [voiceData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
                    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                    [dict setObject:myuser forKey:@"from"];
                    [dict setObject:targetGroupId forKey:@"groupid"];
                    [dict setObject:nickName forKey:@"nickname"];
                    [dict setObject:strSessionId forKey:@"sId"];
                    [dict setObject:transSessionId forKey:@"sessionid"];
                    //[dict setObject:@"temp.caf"  forKey:@"filePath"];
                    [dict setObject:bas64Voice  forKey:@"fileData"];
                    [dict setObject:[CommUtilHelper getDeviceId]  forKey:@"deviceId"];
                    [[ChatMessageViewController shareInstance] sendMsg:dict Event:@"forwardMessage"];
                    [[MessageUtilHelper sharedInstance] setUnSendMessageID:[NSString stringWithFormat:@"%i",sessionId]];
                }
                
            }
                break;
            default:
                break;
        }
        ChatMessageViewController *cmv = [ChatMessageViewController shareInstance];
        cmv.groupId = targetGroupId;
        cmv.groupTitle = targetGroupName;
        [self.navigationController popToViewController:cmv animated:YES];
        /*
        messageView = [[UIView alloc ] initWithFrame:self.view.frame];
        [messageView setBackgroundColor:[UIColor clearColor]];
        UIView *disView = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-50, self.view.frame.size.height/2-40, 100, 80)];
        [disView.layer  setShadowOpacity:0.5 ];
        [disView.layer setCornerRadius:10];
        [disView.layer setBackgroundColor:[UIColor blackColor].CGColor];
        [disView.layer setBorderWidth:1];
        [disView setAlpha:0.5];
        
        UILabel  *lblName = [[UILabel alloc] initWithFrame:CGRectMake(5, 10, 95, 40)];
        [lblName setTextColor:[UIColor grayColor]];
        [lblName setFont:[UIFont boldSystemFontOfSize:16]];
        [lblName setBackgroundColor:[UIColor clearColor]];
        [lblName setTextAlignment:NSTextAlignmentCenter];
        [lblName setText:@"Transmit Success"];
        [lblName setTextColor:[UIColor whiteColor]];
        [lblName setNumberOfLines:0];
        [lblName setTag:801];
        [disView addSubview: lblName];
        [messageView addSubview:disView];
        [self.view addSubview:messageView];

        NSTimer *connectionTimer;  //timer对象
        connectionTimer=[NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(dismissView) userInfo:nil repeats:NO];
        [[NSRunLoop currentRunLoop]addTimer:connectionTimer forMode:NSDefaultRunLoopMode];
        //用timer作为延时的一种方法
        [[NSRunLoop currentRunLoop ] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:1.0]];
        */
    }
   }

@end
