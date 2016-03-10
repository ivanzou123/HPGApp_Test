//
//  UserInfoHelper.m
//  Chat
//
//  Created by hwpl hwpl on 14-11-11.
//  Copyright (c) 2014年 hwpl hwpl. All rights reserved.
//
#define theVoicePath @"Voice"
#define theImagePath @"Image"
#import "CommUtilHelper.h"
#import "XHPhotographyHelper.h"
#import "JSON.h"
#import "FormatTime.h"
#import "ChatMessageViewController.h"
#import "WorkWebViewController.h"
#import "eChatDAO.h"
#import "ResponseModel.h"
#import "LoginNetServiceUtil.h"
#import "PushNotificationUtil.h"
#import "FSMessageViewController.h"
static CommUtilHelper *instance;
static NSMutableDictionary *newMessageCounterByGroupIdDic = nil;

@implementation CommUtilHelper

+(CommUtilHelper *)sharedInstance
{
    if (instance) {
        return instance;
    }else
    {
        instance = [[CommUtilHelper alloc] init];
        return instance;
    }
}

+(UIColor *) getDefaultBackgroupColor
{
    return [UIColor colorWithRed:34/255.0 green:34/255.0 blue:34/255.0 alpha:0.83];
}

+(BOOL) isSystemUser:(id) user
{
    if([chatSystemUserName isEqualToString:user]){
        return YES;
    }
    return NO;
}
//取得设备id
+(NSString *) getDeviceId{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    if(![ud objectForKey:@"deviceId"]){
        NSString *deviceId = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        [ud setObject:deviceId forKey:@"deviceId"];
    }
    return [ud objectForKey:@"deviceId"];
}
//
-(NSDictionary *)GetNativeUserInfo
{
    NSUserDefaults *userDefaluts = [NSUserDefaults standardUserDefaults];
    NSDictionary *d = [NSDictionary dictionaryWithObjectsAndKeys:[userDefaluts objectForKey:@"user"],@"user",[userDefaluts objectForKey:@"nickname"],@"nickname",[userDefaluts objectForKey:@"commonName"],@"commonName", nil];
    return d;
}
-(NSString *)getNickName
{
    return [[self GetNativeUserInfo] objectForKey:@"nickname"];
}
-(NSString *)getCommonName
{
    return [[self GetNativeUserInfo] objectForKey:@"commonName"];
}
-(NSString *)getUser
{
    return [[self GetNativeUserInfo] objectForKey:@"user"];
}
-(NSString *)createUUID
{
    CFUUIDRef uuidObject = CFUUIDCreate(kCFAllocatorDefault);
    
    // Get the string representation of CFUUID object.
    NSString *uuidStr = (NSString *)CFBridgingRelease(CFUUIDCreateString(kCFAllocatorDefault, uuidObject));
    
    // If needed, here is how to get a representation in bytes, returned as a structure
    // typedef struct {
    //   UInt8 byte0;
    //   UInt8 byte1;
    //   …
    //   UInt8 byte15;
    // } CFUUIDBytes;
    //CFUUIDBytes bytes = CFUUIDGetUUIDBytes(uuidObject);
    CFRelease(uuidObject);
    return uuidStr;
}
-(NSString *)createDiffUUID
{
    CFUUIDRef uuidObject = CFUUIDCreate(kCFAllocatorDefault);
    
    // Get the string representation of CFUUID object.
    NSString *uuidStr = (NSString *)CFBridgingRelease(CFUUIDCreateString(kCFAllocatorDefault, uuidObject));
    uuidStr = [uuidStr stringByAppendingString:[FormatTime getCurrentTime]];
    // If needed, here is how to get a representation in bytes, returned as a structure
    // typedef struct {
    //   UInt8 byte0;
    //   UInt8 byte1;
    //   …
    //   UInt8 byte15;
    // } CFUUIDBytes;
    //CFUUIDBytes bytes = CFUUIDGetUUIDBytes(uuidObject);
    CFRelease(uuidObject);
    return uuidStr;
}
-(void)showAlertView:(NSString *)titile Message:(NSString *)message delegate:(UIViewController *)controller
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:titile message:message delegate:controller cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alertView show];
}

- (NSString *)dataVoicePath:(NSString *)file
{
    
    NSString *path = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:theVoicePath];
    BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:path];
    if (!isExist) {
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString *result = [path stringByAppendingPathComponent:file];
    return  result;
    
}
- (NSString *)dataImagePath:(NSString *)file
{
    
    NSString *path = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:theImagePath];
    BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:path];
    if (!isExist) {
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString *result = [path stringByAppendingPathComponent:file];
    return  result;
    
}


- (void)setExtraCellLineHidden: (UITableView *)tableView type:(NSString *)type{
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    if (type) {
        [tableView setTableFooterView:view];
        
    }else
    {
        [tableView setTableFooterView:view];
        [tableView setTableHeaderView:view];
    }
    
}
-(void)setValueDefaults:(NSString *) value key:(NSString *) key
{
    NSUserDefaults *users = [NSUserDefaults standardUserDefaults];
    [users setObject:value forKey:key];
}
-(NSString *)getLastSyncTime:(NSString *)key
{
    NSUserDefaults *users = [NSUserDefaults standardUserDefaults];
    NSString *syncTime = [users objectForKey:key];
    if (syncTime) {
        return syncTime;
    }else
    {
        return nil;
    }
}
//
-(NSString *)removeBase64Prefix:(NSString *) base64String
{
    if(!base64String){
        return nil;
    }
    NSMutableString *str = [[NSMutableString alloc] initWithFormat:@"%@",base64String];
    NSString *resultStr = [[str stringByReplacingOccurrencesOfString:@"data:image/jpeg;base64," withString:@""] stringByReplacingOccurrencesOfString:@"data:image/png;base64," withString:@""];
    return [NSString stringWithFormat: @"%@",resultStr];
}
//
-(UIImage *)base64ToImage:(NSString *)base64Str
{
    if (base64Str) {
        NSData *imageData = [[NSData alloc] initWithBase64EncodedString:[self removeBase64Prefix:base64Str] options:NSDataBase64DecodingIgnoreUnknownCharacters];
        
        
        return  [[UIImage alloc] initWithData:imageData];
    }else
    {
        return nil;
    }
}
//
-(NSString *)saveImageToPath:(NSString *)commbineImage
{
    if (commbineImage && ![commbineImage isEqualToString:@""]) {
        NSString *base64ImageStr = [self removeBase64Prefix:commbineImage];
        NSData *imageData = [[NSData alloc] initWithBase64EncodedString:base64ImageStr options:0];
        UIImage *image = [UIImage imageWithData:imageData];
        
        NSString *photoName =[[[CommUtilHelper sharedInstance] createUUID] stringByAppendingString:@"@2x.jpg"];
        if (imageData) {
            NSString *savedImagePath=[[CommUtilHelper sharedInstance] dataImagePath:photoName];
            [imageData writeToFile:savedImagePath atomically:YES];
            return photoName;
        }else
        {
            return @"";
        }
        
    }else
    {
        return @"";
    }
}
//
-(UIImage *)getImageByImageName:(NSString *)imgaeName Size:(CGSize)size
{
    NSString *_filePath = [[CommUtilHelper sharedInstance] dataImagePath:imgaeName ];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //BOOL result = [fileManager fileExistsAtPath:_filePath];
    if ([fileManager fileExistsAtPath:_filePath]) {
        NSData *d = [[NSData alloc] initWithContentsOfFile:_filePath];
        UIImage *im = [[UIImage alloc] initWithData:d];
        UIImage *img= nil;
        if (im) {
            img =[[[XHPhotographyHelper alloc] init] imageWithImage:im scaledToSize:size];
           // img=im;
        }
        //[[ photographyHelper alloc]init]imageWithImage:photo scaledToSize:CGSizeMake(photo.size.width/4, photo.size.height/4)];
        return img;
    }
    else
    {
        return nil;
    }
}
//根据原图尺寸缩放
-(CGSize) scaleToSize:(CGSize) sourceSize MaxWidth:(float) maxWidth MaxHeight:(float) maxHeight
{
    if(sourceSize.width == 0 || sourceSize.height == 0){
        return CGSizeMake(maxWidth, maxHeight);
    }
    float newWidth = maxWidth;
    float newHeight = maxHeight;
    if(sourceSize.height < maxHeight){
        newHeight = sourceSize.height;
    }else{
        newHeight = maxHeight;
    }
    newWidth = round(newHeight * sourceSize.width / sourceSize.height);
    //如果计算出的宽度大于最大宽度，则以最大宽度来计算相应高度
    if(newWidth > maxWidth){
        newWidth = maxWidth;
        newHeight = round(newWidth * sourceSize.height / sourceSize.width);
    }
    return CGSizeMake(newWidth, newHeight);
}
////设置每个组的未读消息数量
//-(void) newMessageCounterByAll:(NSMutableArray *) newMessageAry
//{
//    
//    if(newMessageCounterByGroupIdDic == nil){
//        newMessageCounterByGroupIdDic = [[NSMutableDictionary alloc] init];
//    }
//    if(!newMessageAry) return;
//    //目前未读不标记数量，仅标记红点，这里可不计算数量
//    for(int i=0;i<[newMessageAry count];i++){
//        NSDictionary *dic = [newMessageAry objectAtIndex:i];
//        [newMessageCounterByGroupIdDic setObject:@"1" forKey:[dic objectForKey:@"CHAT_GROUP_ID"]];
//    }
//}
////设置每个组的未读消息数量
//-(void) newMessageCounterByGroupId:(NSString *) groupId MessageCounter:(NSString *) messageCounter
//{
//    if(newMessageCounterByGroupIdDic == nil){
//        newMessageCounterByGroupIdDic = [[NSMutableDictionary alloc] init];
//    }
//    if(groupId == nil || [@"" isEqualToString:groupId]){
//        return;
//    }
//    [newMessageCounterByGroupIdDic setObject:messageCounter forKey:groupId];
//}
////取得每个组的未读消息数量
//-(NSString *) getNewMessageCounterByGroupId:(NSString *) groupId
//{
//    if(newMessageCounterByGroupIdDic == nil){
//        return @"0";
//    }
//    NSString *counter = (NSString *)[newMessageCounterByGroupIdDic objectForKey:groupId];
//    if(counter){
//        return counter;
//    }
//    return @"0";
//}

-(void)setMessageCountByGroupId:(NSString *)groupId withCount:(NSInteger)_count withType:(MessageCountType)type
{
    
    NSString *changeGroupId = [NSString stringWithFormat:@"%@",groupId];
    
    NSUserDefaults *messageDefault = [NSUserDefaults standardUserDefaults];
    NSMutableArray *messageArr = [[messageDefault objectForKey:@"messageCountArr"] mutableCopy];
    if (messageArr == nil) {
        messageArr = [[NSMutableArray alloc] init];
    }
    
    if ([messageArr count] == 0) {
        if (type ==addCounter) {
            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:groupId,@"groupId",[NSString stringWithFormat:@"%li",_count],@"count",nil];
            [messageArr addObject:dic];
            [messageDefault setObject:messageArr forKey:@"messageCountArr"];
        }
    }else
    {
        BOOL isExistGroupId = false;
        for (int i=0; i<[messageArr count]; i++) {
            NSMutableDictionary *dic = [(NSMutableDictionary *)[messageArr objectAtIndex:i] mutableCopy];
            NSString *tempGroupId = [dic objectForKey:@"groupId"];
            NSString *count = [dic objectForKey:@"count"];
            //存在就更新
            if ([changeGroupId isEqualToString:tempGroupId]) {
                if (count && ![@"" isEqualToString:count]) {
                    NSInteger tempCount=0;
                    if (type == addCounter) {
                        tempCount = [count integerValue] + _count;
                    }else if(type == deleteCounter)
                    {
                        tempCount = 0;
                      
                    }
                    
                    [dic setValue:[NSString stringWithFormat:@"%li",tempCount] forKey:@"count"];
                    [messageArr removeObjectAtIndex:i];
                    [messageArr insertObject:dic atIndex:i];
                    [messageDefault setObject:messageArr forKey:@"messageCountArr"];
                     isExistGroupId = true;
                     break;
                }
               
            }
        }
        //若不存在，新增一条
        if (!isExistGroupId) {
            if (type==addCounter) {
                NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:groupId,@"groupId",[NSString stringWithFormat:@"%li",_count],@"count",nil];
                [messageArr addObject:dic];
                [messageDefault setObject:messageArr forKey:@"messageCountArr"];
            }
        }
    }
}


-(NSInteger)getMessageCountByGroupId:(NSString *)groupId
{
    NSUserDefaults *messageDefault = [NSUserDefaults standardUserDefaults];
    NSMutableArray *messageArr = [[messageDefault objectForKey:@"messageCountArr"] mutableCopy];
    NSInteger reCount = 0;
    for (int i=0; i<[messageArr count]; i++) {
        NSMutableDictionary *dic = [messageArr objectAtIndex:i];
        NSString *tempGroupId = [dic objectForKey:@"groupId"];
        NSString *count = [dic objectForKey:@"count"];
        //存在就更新
        if ([groupId isEqualToString:tempGroupId]) {
            if (count && ![@"" isEqualToString:count]) {
                reCount = [count integerValue];
            }
        }
    }
    return reCount;
}
-(void)setBadageValue
{
    NSInteger count = [[CommUtilHelper sharedInstance] getAllMessageCount];
    if (count >0) {
        
        [PushNotificationUtil clearBadge:count];
    }else
    {
        [PushNotificationUtil clearBadge:0];
        
    }
    
}
-(NSInteger)getAllMessageCount
{
    
    NSUserDefaults *messageDefault = [NSUserDefaults standardUserDefaults];
    NSMutableArray *messageArr = [[messageDefault objectForKey:@"messageCountArr"] mutableCopy];
    NSInteger reCount = 0;
    for (int i=0; i<[messageArr count]; i++) {
        NSMutableDictionary *dic = [messageArr objectAtIndex:i];
        //NSString *tempGroupId = [dic objectForKey:@"groupId"];
        NSString *count = [dic objectForKey:@"count"];
        //存在就更新
        
       if (count && ![@"" isEqualToString:count]) {
            reCount += [count integerValue];
            
     }
    }
//    
//    NSString *workBageValue = [messageDefault objectForKey:@"workBageValue"];
//    if (workBageValue && ![@"" isEqualToString:workBageValue]) {
//        reCount = [workBageValue integerValue];
//    }
    return reCount;
}

-(NSInteger)getWorkBageNumber
{
    NSInteger reCount = 0;
     NSUserDefaults *messageDefault = [NSUserDefaults standardUserDefaults];
        NSString *workBageValue = [messageDefault objectForKey:@"workBageValue"];
        if (workBageValue && ![@"" isEqualToString:workBageValue]) {
            reCount = [workBageValue integerValue];
        }
    return  reCount;
}

//将包含数组的json字符串转为json数组对象 格式为["method",[{'from':@'123'}]];
-(id)jsonToObject:(NSString *)jsonStr
{
    NSMutableArray *arr = [jsonStr JSONValue];
    NSMutableArray *jsonObject = [[arr objectAtIndex:1] JSONValue];
    
    return jsonObject;
}
-(NSString *)changeNullToStr:(NSString *)str
{
    if ([str isKindOfClass:[NSNull class]]) {
        return  @"";
    }else
    {
        return str;
    }
}

-(BOOL)checkIsUpdate:(NSInteger)serverVersionNo
{
    NSString *version_No = [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleVersionKey];
    if ([version_No integerValue] < serverVersionNo) {
        return YES;
    }
    return NO;
    
}
-(void)setErrorMsg:(NSString *)errMsg
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *errArr = [[userDefaults objectForKey:@"ErrorMsgArr"] mutableCopy];
    if (errArr == nil) {
        errArr = [[NSMutableArray alloc] init];
        [errArr addObject:errMsg];
        [userDefaults setObject:errArr forKey:@"ErrorMsgArr"];
    }else
    {
        [errArr addObject:errMsg];
        [userDefaults setObject:errArr forKey:@"ErrorMsgArr"];
    }
}
-(NSMutableArray *)getErrorMsg
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *errArr = [userDefaults objectForKey:@"ErrorMsgArr"];
    if (errArr !=nil) {
        return errArr;
    }else
    {
        return nil;
    }
}


//保存远程通知自定义参数
-(void)setRemoteNotic:(NSDictionary *) userInfo
{
    @try{
        if(!userInfo) return;
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        NSString *category = [userInfo valueForKey:@"category"];
        if([category isEqualToString:@"message"]){
            NSString *groupId = [userInfo valueForKey:@"groupId"];
            [ud setObject:category forKey:@"Notic_Category"];
            [ud setObject:groupId forKey:@"Notic_GroupId"];
            
            //增加一条消息
            //[[CommUtilHelper sharedInstance] setMessageCountByGroupId:groupId withCount:1 withType:addCounter];
            //[[NSNotificationCenter defaultCenter] postNotificationName:@"recevieMessageNotifaction" object:groupId];
        }else if([category isEqualToString:@"work"]){
            [ud setObject:category forKey:@"Notic_Category"];
            [ud setObject:@"" forKey:@"Notic_GroupId"];
        }else{
            [self clearRemoteNotic];
        }
    }@catch(NSException *ex){
        NSLog(@"setRemoteNotic error:%@",ex);
    }
}
//清除远程通知自定义参数
-(void)clearRemoteNotic
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:@"" forKey:@"Notic_Category"];
    [ud setObject:@"" forKey:@"Notic_GroupId"];
}
//如果用户是从通知点击进入App，则根据点击的通知参数自动显示相应页面
-(void)pushVeiwByRemoteNotic:(UINavigationController *) nav
{
    @try{
        if(!nav) return;
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        NSString *category = [ud valueForKey:@"Notic_Category"];
        NSString *groupId = [ud valueForKey:@"Notic_GroupId"];
        if([category isEqualToString:@"message"]){
            NSMutableArray *groupAry = [[eChatDAO sharedChatDao] getChatGroup:groupId];
            if(groupAry && groupAry.count>0){
                NSDictionary *groupDic = [groupAry objectAtIndex:0];
                NSString *groupTitle = [groupDic valueForKey:@"CHAT_GROUP_NAME"];
                NSString *nickName = [ud objectForKey:@"nickname"];
                nav.tabBarController.selectedIndex = 0;
                
                NSMutableArray *arr = [[eChatDAO sharedChatDao] getChatGroup:groupId];
                if ([arr count]>0) {
                    NSDictionary *dic = [arr objectAtIndex:0];
                   NSString *type =  [dic objectForKey:@"TYPE"];
                   if([@"PUBLIC" isEqualToString:type])
                   {
                       FSMessageViewController *cmVC = [FSMessageViewController shareInstance];
                       cmVC.groupId= groupId;
                       cmVC.nickName = nickName;
                       cmVC.groupTitle = groupTitle;
                       nav.navigationItem.backBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];

                       [nav popToRootViewControllerAnimated:YES];
                       [nav pushViewController:cmVC animated:YES];

                   }else
                   {
                       ChatMessageViewController *cmVC = [ChatMessageViewController shareInstance];
                       cmVC.groupId= groupId;
                       cmVC.nickName = nickName;
                       cmVC.groupTitle = groupTitle;
                        nav.navigationItem.backBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
                       [nav popToRootViewControllerAnimated:YES];
                       [nav pushViewController:cmVC animated:YES];
                   }
                }
                
                
            }
        }else if([category isEqualToString:@"work"]){
             nav.tabBarController.selectedIndex = 2;
             //[nav.tabBarController.tabBar setHidden:NO];
             //WorkWebViewController *wwVC= (WorkWebViewController *)nav.tabBarController.selectedViewController;
             //[wwVC reloadHtml];
        }
        [self clearRemoteNotic];
    }@catch(NSException *ex){
        NSLog(@"pushVeiwByRemoteNotic error:%@",ex);
    }
}


-(BOOL)checkNeedLgoin
{
    @try {
        
        
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        NSString *name = [ud objectForKey:@"user"];
        if (name == nil) {
            return false;
        }
        NSString *password = [ud objectForKey:@"commPassword"];
        if (password == nil) {
            return false;
        }
        
        BOOL  check = false;
        
        ResponseModel *response = [LoginNetServiceUtil LoginChat:name Password:@""];
        if (response.error !=nil) {
                return false;
        }
        NSDictionary *_resultDic = response.resultInfo;
        
        
        
        if(response.resultInfo== nil )
        {
            return false;
            
        }
        if ([_resultDic count] >0) {
            NSDictionary *infoDic = [_resultDic objectForKey:@"RESULT"];
            if (infoDic == nil) {
                return false;
            }
            NSString *dicStr = [infoDic objectForKey:@"AppCommandResult"];
            NSDictionary *dic = [dicStr JSONValue];
            
            NSString *isPass = [dic objectForKey:@"RESULT"];
            if (![@"1" isEqual:isPass]) {
                check = true;
            }else
            {
                check = false;
            }
        }
        return check;
        
    }
    @catch (NSException *exception) {
        return false;
    }
    
}

//售楼格式解析
-(NSMutableDictionary *)getFSJsonValue:(NSString *)msg
{
    if (msg && ![@"" isEqualToString:msg]) {
        NSMutableDictionary *rsDic = [msg JSONValue];
        return rsDic;
    }else
    {
        return nil;
    }
}
//售楼格式解析
-(NSString *)getFlatSaleMessage:(NSString *)msg
{
    @try {
        if (msg && ![@"" isEqualToString:msg]) {
            NSDictionary *rsDic = [msg JSONValue];
            if (rsDic == nil) {
                return  msg;
            }
            NSString *type = [rsDic objectForKey:@"TYPE"];
            if (type && ![@"" isEqualToString:type] && ![type isKindOfClass:[NSNull class]] ) {
//                NSDictionary *jsonResult = [[rsDic objectForKey:@"JSONRESULT"] JSONValue];
//                if (jsonResult && ![jsonResult isKindOfClass:[NSNull class]]) {
//                   
//                    return  [self handleFlatSaleTypeMsg:jsonResult type:type withAllMessage: rsDic];
//                }else
//                {
//                    return msg;
//                }
                NSString *htmlResult = [rsDic objectForKey:@"HTMLRESULT"];
                if (htmlResult == nil) {
                    htmlResult = @"";
                }
                return htmlResult;
            }else
            {
                return msg;
            }
        }else
        {
            return msg;
        }
        
    }
    @catch (NSException *exception) {
        return [exception description];
    }

}
-(NSString *)handleFlatSaleTypeMsg:(NSDictionary *)rsDic type:(NSString *)type withAllMessage:(NSDictionary *) allDic
{
    NSString *msg = nil;
   
    if ([@"new_sale" isEqualToString:type]) {
        NSString *project = [rsDic objectForKey:@"project"];
        NSString *unit =[rsDic objectForKey:@"unit"];
        NSString *listPrice =[rsDic objectForKey:@"listPrice"];
        NSString *salePrice =[rsDic objectForKey:@"salePrice"];
        NSString *priceOne =[rsDic objectForKey:@"priceOne"];
        NSString *seller =[rsDic objectForKey:@"seller"];
        NSString *opDttm =[rsDic objectForKey:@"opdttm"];
        msg = [NSString stringWithFormat:@" %@ \n 时间: %@ \n \n 单位: %@ \n 定价: %@ \n 售价: %@ \n 批核价: %@ \n 销售员: %@ \n \n  查看详情",project,opDttm,unit,listPrice,salePrice,priceOne,seller];
    }else if([@"sign_contract" isEqualToString:type])
    {
        NSString *project = [rsDic objectForKey:@"project"];
        NSString *unit =[rsDic objectForKey:@"unit"];
        NSString *listPrice =[rsDic objectForKey:@"listPrice"];
        NSString *salePrice =[rsDic objectForKey:@"salePrice"];
        NSString *priceOne =[rsDic objectForKey:@"priceOne"];
        NSString *seller =[rsDic objectForKey:@"seller"];
        NSString *opDttm =[rsDic objectForKey:@"opdttm"];
        NSString *contrNo =[rsDic objectForKey:@"contrNo"];
        msg = [NSString stringWithFormat:@"%@ \n单位: %@\n定价: %@\n售价: %@\n批核价: %@\n合同号: %@\n签约时间: %@\n销售员: %@",project,unit,listPrice,salePrice,priceOne,contrNo, opDttm,seller];
    }else if([@"change_product" isEqualToString:type])
    {
        NSString *project = [rsDic objectForKey:@"project"];
        NSString *unit =[rsDic objectForKey:@"unit"];
        NSString *salePrice =[rsDic objectForKey:@"salePrice"];
        NSString *cancelReson =[rsDic objectForKey:@"cancelReson"];
        NSString *opDttm =[rsDic objectForKey:@"opdttm"];
        NSString *seller =[rsDic objectForKey:@"seller"];
        msg = [NSString stringWithFormat:@"%@ \n单位: %@\n售价: %@\n原因: %@\n时间: %@\n销售员: %@",project,unit,salePrice,cancelReson, opDttm,seller];
    }else if([@"online_search" isEqualToString:type])
    {
        NSArray *arr = (NSArray *)rsDic;
        
        NSString *serachDesc =[allDic objectForKey:@"SEARCHDESC"];
        NSString *searchCondition = [allDic objectForKey:@"SEARCHCONDITION"];
        NSString *endDate =[allDic objectForKey:@"ENDDATE"];
        NSString *title =[allDic objectForKey:@"TITLE"];
        msg = [NSString stringWithFormat:@"截止到 : %@ \n查询条件 : %@ \n\n\n",endDate,searchCondition];
        for (int i=0;i< arr.count; i++) {
            NSDictionary *rsdic = [arr objectAtIndex:i];
            NSString *category = [rsdic objectForKey:@"category"];
            NSString *mscnt = [rsdic objectForKey:@"mscnt"];
            NSString *msgfa = [rsdic objectForKey:@"msgfa"];
            NSString *mssp = [rsdic objectForKey:@"mssp"];
            NSString *_tmsg =[NSString stringWithFormat:@"%@ : %@套 \n销售价格: %@元 \n建筑面积 :%@ 平方米 \n \n",category,mscnt,mssp,msgfa];
            if (i==(arr.count-1)) {
             _tmsg =[NSString stringWithFormat:@"%@ : %@套 \n销售价格: %@元 \n建筑面积 :%@ 平方米 \n \n",category,mscnt,mssp,msgfa];
            }
            if (msg !=nil) {
                 msg = [msg stringByAppendingString:_tmsg];
            }else
            {
                msg = _tmsg;
            }
           
        }
    }
    return  msg;
}

@end
