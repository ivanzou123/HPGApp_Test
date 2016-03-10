  //
//  MessageUtilHelper.m
//  HwpgMobile
//
//  Created by hwpl hwpl on 14-12-4.
//  Copyright (c) 2014年 hwpl hwpl. All rights reserved.
//

#import "MessageUtilHelper.h"
#import "eChatDAO.h"
#import "CommUtilHelper.h"
#import "FormatTime.h"
#import "ChatViewController.h"
#import "NSString+HTML.h"
#import "ChatMessageViewController.h"
#import "CharViewNetServiceUtil.h"
#import "FSMessageViewController.h";
static MessageUtilHelper *instance = nil;
static NSMutableArray *AllMessageUUIDArr = nil;
static NSMutableArray *unSendMessageIdArr = nil;
@implementation MessageUtilHelper
+(MessageUtilHelper *)sharedInstance
{
 @synchronized(self)
{
    if (instance == nil) {
        instance = [[MessageUtilHelper alloc] init];
        AllMessageUUIDArr = [[NSMutableArray alloc] init];
        unSendMessageIdArr = [[NSMutableArray alloc] init];
    }
}
    return instance;
}

-(void)setMessageUUID:(NSString *)UUID
{
    [AllMessageUUIDArr addObject:UUID];
}

-(NSMutableArray *)getMessageUUID
{
    return AllMessageUUIDArr;
}

-(void)setUnSendMessageID:(NSString *)sessionId
{
    [unSendMessageIdArr addObject:sessionId];
}

-(NSMutableArray *)getUnSendMessage
{
    return unSendMessageIdArr;
}

-(void)sendMessageFun:(NSMutableArray *)messageUUIDArr SendDic:(NSDictionary *)dic UUID:(NSString *)uuid Suceess:(BOOL)success
{
    if (success) {
        [self sendClearMessage:dic];
    }else
    {
        if ([messageUUIDArr containsObject:uuid]) {
            
            [messageUUIDArr removeObject:uuid];
        }
    }
}
-(void)sendClearMessage:(NSDictionary *)dic
{
    //判断当前socket应用在哪个controller
    BOOL control = [[ChatViewController sharedInstance].socketClient.delegate isKindOfClass:[ChatViewController class]];
    BOOL FsControl = [[FSMessageViewController shareInstance].socketClient.delegate isKindOfClass:[FSMessageViewController class]];
    if (control) {
        [[ChatViewController sharedInstance] sendMsg:dic Event:@"clearMessage"];
    }else if(FsControl)
    {
      [[FSMessageViewController shareInstance] sendMsg:dic Event:@"clearMessage"];
    }
    {
        [[ChatMessageViewController shareInstance] sendMsg:dic Event:@"clearMessage"];
    }
}

-(BOOL)MessageHandle:(SocketIOPacket *)packet DicData:(NSMutableDictionary *) dictReceivedMsg  GroupId:(NSString *)groupId delegate:(UIViewController *)controller isCalculteCount:(BOOL)isCalculteCount ;
{
     //NSArray *aryEventName = [NSArray arrayWithObjects:@"online",@"getOnlineNum",@"newMember",@"delMember",@"sendMsg",@"sendSysMsg",@"DisbandGroup",@"sendImg",@"setHeadPhoto",@"disconnect",@"sendAudio",nil];
    //0是事件名称＝packet.name,1才是json数据
    //NSDictionary *dictReceivedMsg = [[packet dataAsJSON] objectAtIndex:1];
    //int eventIndex = (int)[aryEventName indexOfObject:packet.name];
    
    @try {
    
   
        
    NSString *EventName =packet.name;
    NSString *from =[dictReceivedMsg objectForKeyedSubscript:@"from"];
    NSString *sourceMsg = [dictReceivedMsg objectForKey:@"msg"];
     NSString *msg=@"";
    if (sourceMsg) {
          msg = [sourceMsg htmlDecode:sourceMsg];
    }
  
    NSString *sID =[dictReceivedMsg objectForKey:@"sId"];
    
    NSString *losessionid =[dictReceivedMsg objectForKey:@"sessionId"];
     NSString *groupSessionId = losessionid;
    if ([losessionid isKindOfClass:[NSDecimalNumber class]]) {
        groupSessionId = [NSString stringWithFormat:@"%ld",(long)[losessionid integerValue]];
    }
   
    //NSString *groupSessionId = [NSString stringWithFormat:@"%i",(int)losessionid];
    NSString *serverDate =[dictReceivedMsg objectForKey:@"serverTime"];
    NSString *strSendId = [[CommUtilHelper sharedInstance] getUser];
    NSString *msgType = [dictReceivedMsg objectForKey:@"msgType"];
    NSString *msgSubType = [dictReceivedMsg objectForKey:@"msgSubType"];
    NSString *uuid = [dictReceivedMsg objectForKey:@"uuid"];
    NSString *deviceId = [CommUtilHelper  getDeviceId];
    NSMutableArray *messageUUIDArr = [[MessageUtilHelper sharedInstance] getMessageUUID];
    //如果服务器给的是数字，则转为字符串
    NSString *reGroupId = [NSString stringWithFormat:@"%@",[dictReceivedMsg objectForKey:@"groupId"]];
    //未发送消息
    NSMutableArray *unSendMessageArr = [self getUnSendMessage];
    
    if ([@"sendMessage" isEqualToString:EventName]) {
        if([@"NEW_MEMBER" isEqualToString:msgType]) {
            //newMember
            NSMutableArray *memerArr = [NSMutableArray arrayWithObject:[dictReceivedMsg objectForKey:@"addMembers"]] ;
            //NSMutableArray *memerArr = [NSMutableArray arrayWithObject:jsonStr];
            
            if ([memerArr count]>0 && [[memerArr objectAtIndex:0] count] >2) {
                [[eChatDAO sharedChatDao] updateGroupStatus:reGroupId];
            }
            NSMutableArray *tempArr = [NSMutableArray array];
            for (int i=0; i<[memerArr count]; i++) {
                NSArray *arrs = [memerArr objectAtIndex:i];
                for (int j=0; j<[arrs count]; j++) {
                    NSDictionary *user = [arrs objectAtIndex:j] ;
                    NSMutableDictionary  *saveDic = [NSMutableDictionary dictionary];
                    NSString *sysDttm = [user objectForKey:@"SYSDTTM"];
                    NSString *userPrincipalName = [user objectForKey:@"USER_PRINCIPAL_NAME"];
                    NSString *barCode =  [user objectForKey:@"CHAT_GROUP_BARCODE"];
                    //NSString *lastSessionNick = [user objectForKey:@"LAST_SESSION_NICK	"];
                    NSString *nickName = [user objectForKey:@"USER_NICK_NAME"];
                    NSString *lastUpdPerson =[user objectForKey:@"LASTUPD_PERSON"];
                    NSString *createPerson =[user objectForKey:@"CREATE_PERSON"];
                    
                    NSString *chatGroupImage = [user objectForKey:@"CHAT_GROUP_IMAGE"];
                     NSString *chatGroupImage2 = [user objectForKey:@"CHAT_GROUP_IMAGE2"];
                     NSString *chatGroupImage3 = [user objectForKey:@"CHAT_GROUP_IMAGE3"];
                     NSString *chatGroupImage4 = [user objectForKey:@"CHAT_GROUP_IMAGE4"];
                     NSString *chatGroupImage5 = [user objectForKey:@"CHAT_GROUP_IMAGE5"];
                    
                    NSString *empNumber = [user objectForKey:@"EMPLOYEE_NUMBER"];
                    NSString *phoneNumer=[user objectForKey:@"PHONE_NUMBER"];
                    NSString *title =[user objectForKey:@"TITLE"];
                    NSString *email = [user objectForKey:@"EMAIL"];
                    NSString *headPhoto =[user objectForKey:@"HEAD_PHOTO"];
                    NSString *headPhoto2 =[user objectForKey:@"HEAD_PHOTO2"];
                    NSString *headPhoto3 =[user objectForKey:@"HEAD_PHOTO3"];
                    NSString *headPhoto4 =[user objectForKey:@"HEAD_PHOTO4"];
                    NSString *headPhoto5 =[user objectForKey:@"HEAD_PHOTO5"];
                    NSString *headBigPhoto =[user objectForKey:@"HEAD_BIG_PHOTO"];
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
                    NSString  *chatGroupId = [user objectForKey:@"CHAT_GROUP_ID"];
                    NSString *lastUpdSession = [user objectForKey:@"LAST_UPDATE_SESSION"];
                    NSString *loginStatus = [user objectForKey:@"LOGIN_STATUS"];
                    
                    NSString *type =[user objectForKey:@"TYPE"]==nil?@"":[user objectForKey:@"TYPE"];
                    NSString *is_top =[user objectForKey:@"IS_TOP"]==nil?@"":[user objectForKey:@"IS_TOP"];
                    NSString *source =[user objectForKey:@"SOURCE"]==nil?@"":[user objectForKey:@"SOURCE"];
                    NSString *order_no =[user objectForKey:@"ORDER_NO"]==nil?@"":[user objectForKey:@"ORDER_NO"];
                    
                    [saveDic  setObject:sysDttm forKey:@"LAST_SYNC_TIME"];
                    [saveDic setObject:nickName forKey:@"USER_NICK_NAME"];
                    [saveDic setObject:empNumber forKey:@"EMPLOYEE_NUMBER"];
                    [saveDic setObject:title forKey:@"TITLE"];
                    [saveDic setObject:location forKey:@"LOCATION"];
                    [saveDic setObject:email forKey:@"EMAIL"];
                    [saveDic setObject:phoneNumer forKey:@"PHONE_NUMBER"];
                    [saveDic setObject:headPhoto forKey:@"HEAD_PHOTO"];
                    [saveDic setObject:headPhoto2 forKey:@"HEAD_PHOTO2"];
                    [saveDic setObject:headPhoto3 forKey:@"HEAD_PHOTO3"];
                    [saveDic setObject:headPhoto4 forKey:@"HEAD_PHOTO4"];
                    [saveDic setObject:headPhoto5 forKey:@"HEAD_PHOTO5"];
                    [saveDic setObject:headBigPhoto forKey:@"HEAD_BIG_PHOTO"];
                    [saveDic setObject:userPrincipalName forKey:@"USER_PRINCIPAL_NAME"];
                    [saveDic setObject:chatGroupId forKey:@"CHAT_GROUP_ID"];
                    [saveDic setObject:lastUpdPerson forKey:@"LAST_UPDATEBY"];
                    [saveDic setObject:lastUpdDate forKey:@"LAST_UPDATEDTTM"];
                    [saveDic setObject:disabled forKey:@"DISABLED"];
                    [saveDic setObject:[user objectForKey:@"COMMON_NAME"] forKey:@"COMMON_NAME"];
                    //group info
                    [saveDic setObject:groupPersonId forKey:@"GROUP_PERSON_ID"];
                    [saveDic setObject:chatGroupName forKey:@"CHAT_GROUP_NAME"];
                    [saveDic setObject:barCode forKey:@"CHAT_GROUP_BARCODE"];
                    [saveDic setObject:createPerson forKey:@"CREATE_PERSON"];
                    [saveDic setObject:loginStatus forKey:@"LOGIN_STATUS"];
                    [saveDic setObject:lastSessionPerson forKey:@"LAST_SESSION_PERSON"];
                    [saveDic setObject:isGroup forKey:@"IS_GROUP"];
                    [saveDic setObject:chatGroupImage forKey:@"CHAT_GROUP_IMAGE"];
                    [saveDic setObject:chatGroupImage2 forKey:@"CHAT_GROUP_IMAGE2"];
                    [saveDic setObject:chatGroupImage3 forKey:@"CHAT_GROUP_IMAGE3"];
                    [saveDic setObject:chatGroupImage4 forKey:@"CHAT_GROUP_IMAGE4"];
                    [saveDic setObject:chatGroupImage5 forKey:@"CHAT_GROUP_IMAGE5"];
                    [saveDic setObject:barCode forKey:@"LASTUPD_DATE"];
                    [saveDic setObject:filePath forKey:@"FILE_PATH"];
                    [saveDic setObject:lastUpdPerson forKey:@"LASTUPD_PERSON"];
                    [saveDic setObject:lastSessionDate forKey:@"LAST_SESSION_DATE"];
                    [saveDic setObject:lastUpdSession forKey:@"LAST_UPDATE_SESSION"];
                    [saveDic setObject:chatGroupInfo forKey:@"CHAT_GROUP_INFO"];
                    [saveDic setObject:order_no forKey:@"ORDER_NO"];
                    [saveDic setObject:source forKey:@"SOURCE"];
                    [saveDic setObject:is_top forKey:@"IS_TOP"];
                    [saveDic setObject:type forKey:@"TYPE"];
                    [tempArr addObject:saveDic];
                }
            }
            [[eChatDAO sharedChatDao] insertChatAdUser:tempArr];
            [[eChatDAO sharedChatDao] insertGroupPerson:tempArr];
           BOOL success= [[eChatDAO sharedChatDao] insertChatGroup:tempArr];
            //
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:deviceId,@"deviceId",strSendId,@"username",uuid,@"successIds",@"",@"failureIds",@"",@"failureMsgs", nil];
            [self sendMessageFun:messageUUIDArr SendDic:dic UUID:uuid Suceess:success];//反馈消息是否保存
            
            //[[CommUtilHelper sharedInstance] newMessageCounterByGroupId:reGroupId MessageCounter:@"1"];
            if ([controller isKindOfClass:[ChatViewController class]]) {
                if (isCalculteCount) {
                    [[CommUtilHelper sharedInstance] setMessageCountByGroupId:groupId withCount:1 withType:addCounter];
                }
            }
            
            NSMutableArray *natvieArr = [NSMutableArray array];
            NSMutableDictionary *msgDic = [NSMutableDictionary dictionary];
            [msgDic setObject:msg forKey:@"CHAT_CONTENT"];
            [msgDic setObject:reGroupId forKey:@"CHAT_GROUP_ID"];
            [msgDic setObject:[NSString stringWithFormat:@"%i",[groupSessionId intValue]] forKey:@"GROUP_SESSION_ID"];
            [msgDic setObject:@"system" forKey:@"USER_PRINCIPAL_NAME"];
            [msgDic setObject:serverDate forKey:@"RES_SYSDTTM" ];
            [msgDic setObject:[NSString stringWithFormat:@"%i",[groupSessionId intValue]] forKey:@"SESSION_ID"];
            [msgDic setObject:@"" forKey:@"FILE_PATH"];
            [msgDic setObject:@"" forKey:@"CHAT_SMALLPIC"];
            [natvieArr addObject:msgDic];
            
             [[eChatDAO sharedChatDao] insertMsgFromServer:natvieArr];

        }else if ([@"DEL_MEMBER" isEqualToString:msgType])
        {
            //delMember,删除成员
            //NSString *msgType= [dictReceivedMsg objectForKey:@"msgSuType"];
            NSString *user =[dictReceivedMsg objectForKeyedSubscript:@"delMembers"];
            NSString *theMsg = nil;
            //if ([@"T" isEqualToString:msgSubType]) {
                if (![user isEqualToString:strSendId]) {
                    theMsg = [dictReceivedMsg objectForKey:@"msgAll"];
                    [[eChatDAO sharedChatDao] deleteChatUserByGroupId:reGroupId User:user];
                    [[eChatDAO sharedChatDao] updateChatGroup:theMsg From:user ResysDttm:serverDate GroupId:reGroupId];
                    
                                if ([controller isKindOfClass:[ChatViewController class]]) {
                                    if (isCalculteCount) {
                                        [[CommUtilHelper sharedInstance] setMessageCountByGroupId:groupId withCount:1 withType:addCounter];
                                    }
                                }
                    //
                }else//剔除自己
                {
                    [[eChatDAO sharedChatDao] deleteChatUserByGroupId:reGroupId ];
                    [[eChatDAO sharedChatDao] deleteChatGroup:reGroupId];
                    [[eChatDAO sharedChatDao ] deleteGroupSession:reGroupId];
                    
                    
                    [[CommUtilHelper sharedInstance] setMessageCountByGroupId:reGroupId withCount:0 withType:deleteCounter];
                    [[CommUtilHelper sharedInstance] setBadageValue];
                    if ([controller isKindOfClass:[ChatViewController class]]) {
                        ChatViewController *cnnn = (ChatViewController*)controller;
                        [cnnn setBadageValue];
                    }
                }
           // }
//            else if([@"D" isEqualToString:msgSubType])
//            {
//                if (![user isEqualToString:strSendId]) {
//                    [[eChatDAO sharedChatDao] deleteChatUserByGroupId:reGroupId User:user];
//                    [[eChatDAO sharedChatDao] updateChatGroup:msg From:user ResysDttm:serverDate GroupId:reGroupId];
//                    //[[eChatDAO sharedChatDao] deleteChatGroup:reGroupId];
//                    //[[eChatDAO sharedChatDao ] deleteGroupSession:reGroupId];
//                }
//            }
            if(theMsg == nil){
                theMsg = msg;
            }
            NSMutableDictionary *msgDic =[NSMutableDictionary dictionaryWithObjectsAndKeys:@"100",@"SESSION_ID",groupSessionId,@"GROUP_SESSION_ID", serverDate,@"RES_SYSDTTM",reGroupId,@"CHAT_GROUP_ID",chatSystemUserName,@"USER_PRINCIPAL_NAME",theMsg,@"CHAT_CONTENT",nil];
            [msgDic setValue:@"" forKey:@"FILE_PATH"];
            [msgDic setValue:@"" forKey:@"CHAT_SMALLPIC"];
            BOOL success =  [[eChatDAO sharedChatDao] insertMsgFromServer:[NSMutableArray arrayWithObject:msgDic]];
            //[[CommUtilHelper sharedInstance] newMessageCounterByGroupId:reGroupId MessageCounter:@"1"];
//            if ([controller isKindOfClass:[ChatViewController class]]) {
//                if (isCalculteCount) {
//                    [[CommUtilHelper sharedInstance] setMessageCountByGroupId:groupId withCount:1 withType:addCounter];
//                }
//            }
             NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:deviceId,@"deviceId",strSendId,@"username",uuid,@"successIds",@"",@"failureIds",@"",@"failureMsgs", nil];
            [self sendMessageFun:messageUUIDArr SendDic:dic UUID:uuid Suceess:success];//反馈消息是否保存
        }else if ([@"TEXT" isEqualToString:msgType])
        {
            //sendMsg
            NSMutableDictionary *msgDic =[NSMutableDictionary dictionaryWithObjectsAndKeys:sID,@"SESSION_ID",groupSessionId,@"GROUP_SESSION_ID", serverDate,@"RES_SYSDTTM",reGroupId ,@"CHAT_GROUP_ID",from,@"USER_PRINCIPAL_NAME",msg,@"CHAT_CONTENT",nil];
            if ([from isEqualToString:strSendId]) {
                //表示自己发送的消息回调
                
               NSString *tempStrId = [[sID componentsSeparatedByString:@"_"] lastObject];
               [msgDic setObject:tempStrId forKey:@"ID"];
               BOOL success = [[eChatDAO sharedChatDao] updateGroupSession:msgDic];
                NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:deviceId,@"deviceId",strSendId,@"username",uuid,@"successIds",@"",@"failureIds",@"",@"failureMsgs", nil];
                
                [self sendMessageFun:messageUUIDArr SendDic:dic UUID:uuid Suceess:success];//反馈消息是否保存
                if ([unSendMessageArr containsObject:tempStrId]) {
                    [unSendMessageArr removeObject:tempStrId];
                }
              
            }else
            {
              [msgDic setValue:@"" forKey:@"FILE_PATH"];
              [msgDic setValue:@"" forKey:@"CHAT_SMALLPIC"];
              BOOL success= [[eChatDAO sharedChatDao] insertMsgFromServer:[NSMutableArray arrayWithObject:msgDic]];
              //
                
              //[[CommUtilHelper sharedInstance] newMessageCounterByGroupId:reGroupId MessageCounter:@"1"];
                if ([controller isKindOfClass:[ChatViewController class]]) {
                    if (isCalculteCount) {
                        [[CommUtilHelper sharedInstance] setMessageCountByGroupId:groupId withCount:1 withType:addCounter];
                    }
                }

                NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:deviceId,@"deviceId",strSendId,@"username",uuid,@"successIds",@"",@"failureIds",@"",@"failureMsgs", nil];

                [self sendMessageFun:messageUUIDArr SendDic:dic UUID:uuid Suceess:success];//反馈消息是否保存
               
            }
        }else if([@"SYS" isEqualToString:msgType])
        {
            //sendSysMsg
             NSString *type =[dictReceivedMsg objectForKey:@"TYPE"]==nil?@"":[dictReceivedMsg objectForKey:@"TYPE"];
            if (type !=nil) {
                if ([@"PUBLIC" isEqualToString:type]) {
                    return YES;
                }
            }
            NSString *msgType = [dictReceivedMsg objectForKey:@"msgType"];
            NSString *groupId = [dictReceivedMsg objectForKey:@"groupId"];
            NSString *groupName = [dictReceivedMsg objectForKey:@"groupName"];
            NSMutableArray *natvieArr = [NSMutableArray array];
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            [dic setObject:msg forKey:@"CHAT_CONTENT"];
            [dic setObject:reGroupId forKey:@"CHAT_GROUP_ID"];
            [dic setObject:[NSString stringWithFormat:@"%i",[groupSessionId intValue]] forKey:@"GROUP_SESSION_ID"];
            [dic setObject:@"system" forKey:@"USER_PRINCIPAL_NAME"];
            [dic setObject:serverDate forKey:@"RES_SYSDTTM" ];
            [dic setObject:[NSString stringWithFormat:@"%i",[groupSessionId intValue]] forKey:@"SESSION_ID"];
            [dic setObject:@"" forKey:@"FILE_PATH"];
            [dic setObject:@"" forKey:@"CHAT_SMALLPIC"];
            //修改群名称
            if ([@"E" isEqualToString:msgSubType]) {
                [[eChatDAO sharedChatDao] updateChatGroupName:groupName GroupId:groupId];
                
                [dic setObject:msg forKey:@"CHAT_CONTENT"];
                
            }
            [natvieArr addObject:dic];
            
            BOOL success = [[eChatDAO sharedChatDao] insertMsgFromServer:natvieArr];
            //
            //[[CommUtilHelper sharedInstance] newMessageCounterByGroupId:reGroupId MessageCounter:@"1"];
            if ([controller isKindOfClass:[ChatViewController class]]) {
                if (isCalculteCount) {
                    [[CommUtilHelper sharedInstance] setMessageCountByGroupId:groupId withCount:1 withType:addCounter];
                }
            }

            NSDictionary *clearDic = [NSDictionary dictionaryWithObjectsAndKeys:deviceId,@"deviceId",strSendId,@"username",uuid,@"successIds",@"",@"failureIds",@"",@"failureMsgs", nil];
            [self sendMessageFun:messageUUIDArr SendDic:clearDic UUID:uuid Suceess:success];//反馈消息是否保存

        }else if([@"IMAGE" isEqualToString:msgType])
        {
            //sendImg
            NSMutableDictionary *msgDic =[NSMutableDictionary dictionaryWithObjectsAndKeys:sID,@"SESSION_ID",groupSessionId,@"GROUP_SESSION_ID", serverDate,@"RES_SYSDTTM",reGroupId ,@"CHAT_GROUP_ID",from,@"USER_PRINCIPAL_NAME",@"[image]",@"CHAT_CONTENT",nil];
            NSString *filePic = [dictReceivedMsg objectForKey:@"filePath"];
            [msgDic setValue:filePic forKey:@"FILE_PATH"];
            //
            //UIImage *img= [[CommUtilHelper sharedInstance] base64ToImage:[dictReceivedMsg objectForKey:@"imgData"]];
           
            //NSData *imageData =UIImageJPEGRepresentation(img, 1.0);
            //[imageData writeToFile:savedImagePath atomically:YES];
            NSString *chatSmallPic = [dictReceivedMsg objectForKey:@"thumbnailFileName"];
            //NSString *photoName =[[[CommUtilHelper sharedInstance] createUUID] stringByAppendingString:@".png"];
            [msgDic setValue:chatSmallPic forKey:@"CHAT_SMALLPIC"];
            //
            if ([from isEqualToString:strSendId]) {
                //表示自己发送的消息回调
                NSString *tempStrId = [[sID componentsSeparatedByString:@"_"] lastObject];
                [msgDic setObject:tempStrId forKey:@"ID"];
               BOOL success = [[eChatDAO sharedChatDao] updateGroupSession:msgDic];
                NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:deviceId,@"deviceId",strSendId,@"username",uuid,@"successIds",@"",@"failureIds",@"",@"failureMsgs", nil];
                
                [self sendMessageFun:messageUUIDArr SendDic:dic UUID:uuid Suceess:success];//反馈消息是否保存
                //移除未发送消息
                if ([unSendMessageArr containsObject:tempStrId]) {
                    [unSendMessageArr removeObject:tempStrId];
                }
               
            }else
            {
             BOOL success= [[eChatDAO sharedChatDao] insertMsgFromServer:[NSMutableArray arrayWithObject:msgDic]];
                if (success) {
                    
                        NSString *filePath = [[CommUtilHelper sharedInstance] dataImagePath:chatSmallPic];
                        if(![[NSFileManager defaultManager] fileExistsAtPath:filePath]){
                            [CharViewNetServiceUtil asynDownLoadImg:[NSString stringWithFormat:@"%@/fileTransfer/download?fileName=%@",charUrl,chatSmallPic] targetFilePath:filePath ];
                        }
                    
                    //
                    //[[CommUtilHelper sharedInstance] newMessageCounterByGroupId:reGroupId MessageCounter:@"1"];
                    if ([controller isKindOfClass:[ChatViewController class]]) {
                        if (isCalculteCount) {
                            [[CommUtilHelper sharedInstance] setMessageCountByGroupId:groupId withCount:1 withType:addCounter];
                        }
                    }

                    NSDictionary *clearDic = [NSDictionary dictionaryWithObjectsAndKeys:deviceId,@"deviceId",strSendId,@"username",uuid,@"successIds",@"",@"failureIds",@"",@"failureMsgs", nil];
                    
                    [self sendMessageFun:messageUUIDArr SendDic:clearDic UUID:uuid Suceess:success];//反馈消息是否保存

                }
                
            }

        }else if([@"SET_HEAD_PHOTO" isEqualToString:msgType])
        {
            //setHeadPhoto,保存头像为文件
            NSString *imageName = [[CommUtilHelper sharedInstance] saveImageToPath:[dictReceivedMsg objectForKey:@"fileData"]];
            //
            NSString *serverDate = [dictReceivedMsg objectForKey:@"serverTime"];
            BOOL success1 = NO;
            BOOL success2 = NO;
            if ([reGroupId integerValue] > 0) {
                //群头像,groupId大于0表示是群头像
                if (![from isEqualToString:strSendId]) {
                    //如果是别人发出的信息，则需要将文件路径更新到本地数据库
                  success1 =  [[eChatDAO sharedChatDao] updateGroupHeadPhoto:reGroupId ImagePath:imageName];
                   
                }
                //更新服务器时间到本地，避免再次同步
               success2= [[eChatDAO sharedChatDao] updateChatGroupHeadDate:serverDate groupId:reGroupId];
            }else
            {
                //个人头像
                if (![from isEqualToString:strSendId]) {
                    //如果是别人发出的信息，则需要将文件路径更新到本地数据库
                    success1=[[eChatDAO sharedChatDao] updateHeadPhoto:from ImagePath:imageName];
                }
                //更新服务器时间到本地，避免再次同步
               success2= [[eChatDAO sharedChatDao] updateChatAdUserHeadnPhotoDate:serverDate from:from];
            }
            //
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:deviceId,@"deviceId",strSendId,@"username",uuid,@"successIds",@"",@"failureIds",@"",@"failureMsgs", nil];
            [self sendMessageFun:messageUUIDArr SendDic:dic UUID:uuid Suceess:success1 || success2];//反馈消息是否保存
            //[[CommUtilHelper sharedInstance] newMessageCounterByGroupId:reGroupId MessageCounter:@"1"];

        }else if([@"AUDIO" isEqualToString:msgType])
        {
            //sendAudio
            NSMutableDictionary *msgDic =[NSMutableDictionary dictionaryWithObjectsAndKeys:sID,@"SESSION_ID",groupSessionId,@"GROUP_SESSION_ID", serverDate,@"RES_SYSDTTM",reGroupId ,@"CHAT_GROUP_ID",from,@"USER_PRINCIPAL_NAME",@"[audio]",@"CHAT_CONTENT",nil];
            
            if ([from isEqualToString:strSendId]) {
                //表示自己发送的消息回调
                NSString *tempStrId = [[sID componentsSeparatedByString:@"_"] lastObject];
                [msgDic setObject:tempStrId forKey:@"ID"];
                BOOL success= [[eChatDAO sharedChatDao] updateGroupSession:msgDic];
                NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:deviceId,@"deviceId",strSendId,@"username",uuid,@"successIds",@"",@"failureIds",@"",@"failureMsgs", nil];
                
                [self sendMessageFun:messageUUIDArr SendDic:dic UUID:uuid Suceess:success];//反馈消息是否保存
                //移除未发送消息
                if ([unSendMessageArr containsObject:tempStrId]) {
                    [unSendMessageArr removeObject:tempStrId];
                }
            }else
            {
              //NSString *sender =[dictReceivedMsg objectForKey:@"nickname"];
              NSString *filePatch = [dictReceivedMsg objectForKey:@"filePath"];
              [msgDic setValue:filePatch forKey:@"FILE_PATH"];
              [msgDic setValue:@"" forKey:@"CHAT_SMALLPIC"];
            
              BOOL success= [[eChatDAO sharedChatDao] insertMsgFromServer:[NSMutableArray arrayWithObject:msgDic]];
              //
                if (success) {
                    //[[CommUtilHelper sharedInstance] newMessageCounterByGroupId:reGroupId MessageCounter:@"1"];
                    if ([controller isKindOfClass:[ChatViewController class]]) {
                        if (isCalculteCount) {
                            [[CommUtilHelper sharedInstance] setMessageCountByGroupId:groupId withCount:1 withType:addCounter];
                        }
                    }

                    NSDictionary *clearDic = [NSDictionary dictionaryWithObjectsAndKeys:deviceId,@"deviceId",strSendId,@"username",uuid,@"successIds",@"",@"failureIds",@"",@"failureMsgs", nil];
                    [self sendMessageFun:messageUUIDArr SendDic:clearDic UUID:uuid Suceess:success];//反馈消息是否保存
                }
              
            }

        }else
        {
          NSLog(@"unknow event:%@",packet.name);
        }
    
     }
        return YES;
    }
    @catch (NSException *exception) {
        //异常处理
        
        [[CommUtilHelper sharedInstance] showAlertView:@"Prompt" Message:[exception description] delegate:controller];
        return NO;
    }

    
}
@end
