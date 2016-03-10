//
//  eChatDAO.m
//  HwpgMobile
//
//  Created by hwpl hwpl on 14-11-13.
//  Copyright (c) 2014年 hwpl hwpl. All rights reserved.
//
#define CHAT_AD_USER @"CHAT_AD_USER"
#define CHAT_GROUP @"CHAT_GROUP"
#define CHAT_USERS @"CHAT_USERS"
#define CHAT_GROUP_PERSON @"CHAT_GROUP_PERSON"
#define CHAT_GROUP_SESSION @"CHAT_GROUP_SESSION"


#import "eChatDAO.h"
#import "FormatTime.h"
#import "CommUtilHelper.h"
#import "JSON.h"
#import "MessageUtilHelper.h"
#import "FormatTime.h"
#import "CharViewNetServiceUtil.h"
#import "LoginNetServiceUtil.h"
static eChatDAO *instance = nil;
@implementation eChatDAO

//初始化单例
+(eChatDAO *)sharedChatDao
{
  @synchronized(self)
  {
      if (!instance) {
          instance = [[eChatDAO alloc] init];
      }
  }
    return instance;
}
//创建表
-(BOOL)creteTable
{
    @try {
        [dataBase open];
        NSString *adUsers=[NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (Id INTEGER PRIMARY KEY AUTOINCREMENT,USER_PRINCIPAL_NAME text NOT NULL,  SAM_ACCOUNT_NAME text ,COMMON_NAME TEXT, EMPLOYEE_NUMBER text, DISABLED TEXT, TITLE TEXT,LOCATION TEXT,EMAIL TEXT,PHONE_NUMBER TEXT,HEAD_PHOTO TEXT,HEAD_PHOTO2 TEXT,HEAD_PHOTO3 TEXT,HEAD_PHOTO4 TEXT,HEAD_PHOTO5 TEXT, HEAD_BIG_PHOTO TEXT,LAST_SYNC_TIME TEXT,LOGIN_STATUS TEXT);",CHAT_AD_USER];
        
        NSString *createChatUsers=[NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (Id INTEGER PRIMARY KEY AUTOINCREMENT,USER_PRINCIPAL_NAME text not null, FREQUENT_CONTANCT_USER text , CREATE_DATE text, DEL_FLAG INTEGER, USER_NICK_NAME TEXT,USER_DISPLAY_NAME TEXT,LAST_SYNC_TIME TEXT);",CHAT_USERS];
        
        NSString *creteChatGroup = [NSString stringWithFormat :@"CREATE TABLE IF NOT EXISTS %@ (Id INTEGER PRIMARY KEY AUTOINCREMENT, CHAT_GROUP_ID integer, CHAT_GROUP_NAME text,CHAT_GROUP_LIMIT INTEGER,CHAT_GROUP_INFO TEXT,CHAT_GROUP_BARCODE TEXT,LAST_UPDATE_SESSION TEXT,CREATE_PERSON TEXT,DEL_FLAG INTEGER,CREATE_DATE TEXT,LAST_SESSION_PERSON TEXT,LAST_SESSION_DATE TEXT,CHAT_GROUP_IMAGE TEXT,IS_GROUP TEXT,LASTUPD_PERSON TEXT,LASTUPD_DATE TEXT,FILE_PATH TEXT,LAST_SYNC_TIME TEXT,TYPE TEXT,IS_TOP TEXT,ORDER_NO INTEGER,SOURCE TEXT,STATUS TEXT);",CHAT_GROUP];
        
        NSString *createGroupPerson = [NSString stringWithFormat :@"CREATE TABLE IF NOT EXISTS %@ (Id INTEGER PRIMARY KEY AUTOINCREMENT,GROUP_PERSON_ID INTEGER , CHAT_GROUP_ID INTEGER  , USER_PRINCIPAL_NAME text,USER_NICK_NAME TEXT,CREATE_DATE TEXT,DEL_FLAG INTEGER,LAST_UPDATEBY TEXT,LAST_UPDATEDTTM TEXT,LAST_SYNC_TIME TEXT);",CHAT_GROUP_PERSON];
        
        NSString *createChatGroupSession = [NSString stringWithFormat :@"CREATE TABLE IF NOT EXISTS %@ (ID INTEGER PRIMARY KEY AUTOINCREMENT,GROUP_SESSION_ID INTEGER, CHAT_GROUP_ID INTEGER,USER_PRINCIPAL_NAME text, CHAT_CONTENT text,CREATE_DATE TEXT,SERVER_DATE TEXT,LOCAL_CREATE_DATE TEXT,DEL_FLAG INTEGER,FILE_PATH TEXT,CHAT_SMALLPIC TEXT,SESSION_ID TEXT,LAST_SYNC_TIME TEXT,TYPE TEXT,SUB_TYPE TEXT,DETAIL_DESC TEXT,THUMBNAIL_FILE_NAME TEXT,ORIGIN_FILE_NAME TEXT,FILE_TYPE TEXT,FILE_SIZE TEXT,FILE_DURATION TEXT);",CHAT_GROUP_SESSION];
        
        NSString *testTable = [NSString stringWithFormat :@"CREATE TABLE IF NOT EXISTS %@ (name text,password text);",@"testTable"];
        //
        [dataBase executeUpdate:adUsers];
        [dataBase executeUpdate:createChatUsers];
        [dataBase executeUpdate:creteChatGroup];
        [dataBase executeUpdate:createGroupPerson];
        [dataBase executeUpdate:createChatGroupSession];
        [dataBase executeUpdate:testTable];
        //
        NSString *createChatGroupDetail = @"CREATE TABLE IF NOT EXISTS CHAT_GROUP_DETAIL(ID INTEGER PRIMARY KEY AUTOINCREMENT,GROUP_DETAIL_ID INTEGER, CHAT_GROUP_ID INTEGER,TYPE text, NAME text,DESCRIPTION TEXT,VALUE_TYPE TEXT,VALUE TEXT,ORDER_NO INTEGER,CREATE_DATE TEXT,CREATED_BY TEXT);";
        [dataBase executeUpdate:createChatGroupDetail];
        NSString *createChatSessionDetail = @"CREATE TABLE IF NOT EXISTS CHAT_SESSION_DETAIL(ID INTEGER PRIMARY KEY AUTOINCREMENT,CLIENT_DETAIL_ID TEXT,SESSION_DETAIL_ID INTEGER, GROUP_SESSION_ID INTEGER,SESSION_ID TEXT,TYPE text, NAME text,DESCRIPTION TEXT,VALUE_TYPE TEXT,VALUE TEXT,FILE_NAME TEXT,THUMBNAIL_FILE_NAME TEXT,ORIGIN_FILE_NAME TEXT,FILE_TYPE TEXT,FILE_SIZE TEXT,FILE_DURATION TEXT,ORDER_NO INTEGER,CREATE_DATE TEXT,CREATED_BY TEXT);";
        [dataBase executeUpdate:createChatSessionDetail];
        //[dataBase close];
        //新字段插入
        [self insertNewKey];
        //
        if ([dataBase hadError]) {
            NSLog(@"Err initDatabase %d: %@", [dataBase lastErrorCode], [dataBase lastErrorMessage]);
        }
        return YES;
    }
    @catch (NSException *exception) {
        NSLog(@"creteTable error:%@",exception);
        return NO;
    }
    @finally {
        //判断是否增加字段
        //[self initAddField];
    }
}
-(void)insertNewKey
{
    NSString *sql1 = [NSString stringWithFormat:@"alter table %@ add TYPE TEXT",CHAT_GROUP];
    NSString *sql2 = [NSString stringWithFormat:@"alter table %@ add IS_TOP TEXT",CHAT_GROUP];
    NSString *sql3 = [NSString stringWithFormat:@"alter table %@ add ORDER_NO INTEGER",CHAT_GROUP];
    NSString *sql4 = [NSString stringWithFormat:@"alter table %@ add SOURCE TEXT",CHAT_GROUP];
    //
    [dataBase executeUpdate:sql1];
    [dataBase executeUpdate:sql2];
    [dataBase executeUpdate:sql3];
    [dataBase executeUpdate:sql4];
    //
    NSString *sql5 = [NSString stringWithFormat:@"alter table %@ add STATUS TEXT",CHAT_GROUP];
    [dataBase executeUpdate:sql5];
    NSString *sql6 = [NSString stringWithFormat:@"alter table %@ add TYPE TEXT",CHAT_GROUP_SESSION];
    [dataBase executeUpdate:sql6];
    NSString *sql7 = [NSString stringWithFormat:@"alter table %@ add SUB_TYPE TEXT",CHAT_GROUP_SESSION];
    [dataBase executeUpdate:sql7];
    NSString *sql8 = [NSString stringWithFormat:@"alter table %@ add DETAIL_DESC TEXT",CHAT_GROUP_SESSION];
    [dataBase executeUpdate:sql8];
    NSString *sql9 = [NSString stringWithFormat:@"alter table %@ add THUMBNAIL_FILE_NAME TEXT",CHAT_GROUP_SESSION];
    [dataBase executeUpdate:sql9];
    NSString *sql10 = [NSString stringWithFormat:@"alter table %@ add ORIGIN_FILE_NAME TEXT",CHAT_GROUP_SESSION];
    [dataBase executeUpdate:sql10];
    NSString *sql11 = [NSString stringWithFormat:@"alter table %@ add FILE_TYPE TEXT",CHAT_GROUP_SESSION];
    [dataBase executeUpdate:sql11];
    NSString *sql12 = [NSString stringWithFormat:@"alter table %@ add FILE_SIZE TEXT",CHAT_GROUP_SESSION];
    [dataBase executeUpdate:sql12];
    NSString *sql13 = [NSString stringWithFormat:@"alter table %@ add FILE_DURATION TEXT",CHAT_GROUP_SESSION];
    [dataBase executeUpdate:sql13];
}
-(void)initAddField
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *user = [ud objectForKey:@"user"];
    if (user == nil) {
        //标示第一次安装
        [self addLoginStatuSql];
        [ud setObject:@"YES" forKey:@"loginStatsFlag"];
    }else
    {
        NSString *loginStatsFlag = [ud objectForKey:@"loginStatsFlag"];
        if (loginStatsFlag == nil) {
            [self addLoginStatuSql];
            [ud setObject:@"YES" forKey:@"loginStatsFlag"];
        }
    }
}
-(void)addLoginStatuSql
{
    NSString *loginStausSql = [NSString stringWithFormat :@"ALTER TABLE %@ ADD  COLUMN LOGIN_STATUS TEXT",CHAT_AD_USER];
    [dataBase executeUpdate:loginStausSql];
}

-(NSString *)getLastSyncTimeByTable:(NSString *)table
{
    @try {
        NSString *sql = [NSString stringWithFormat:@"select count(*) from %@ ", table];
        NSString *reValue = nil;
        if ([dataBase  open]) {
            
            
            FMResultSet *rs = [dataBase executeQuery:sql];
            int isNeverSync=0;
            while ([rs next]) {
                //category = [rs stringForColumn:@"Category"];;
                isNeverSync = [rs intForColumnIndex:0];
            }
            [rs close];
            if (isNeverSync >0) {
                NSString *sycTimeSql = [NSString stringWithFormat:@"select  max(strftime('%%Y-%%m-%%d %%H:%%M:%%S',LAST_SYNC_TIME))  from %@  where LAST_SYNC_TIME is not null ", table];
                FMResultSet *sycRs = [dataBase executeQuery:sycTimeSql];
                while ([sycRs next]) {
                    reValue= [sycRs stringForColumnIndex:0];
                }
                [sycRs close];
            }else
            {
                reValue = @"-1"; //表示从没同步过;
            }
            
        }
        //[dataBase close];
        return reValue;
    }
    @catch (NSException *exception) {
        [[CommUtilHelper sharedInstance] setErrorMsg:[@"getLastSyncTimeByTable" stringByAppendingString:[exception description]]];
        NSLog(@"getLastSyncTimeByTable error:%@",exception);
    }
    @finally {
    }
}
//检查chatgrouId是否存在
-(BOOL) isExistChatGroupID:(NSString *)chatGroupId
{
    BOOL check=false;
    NSString *sql = [NSString stringWithFormat:@"select count(*) from %@  where chat_group_id=%@", CHAT_GROUP,chatGroupId];
    @try {
        
        if ([dataBase open]) {
            FMResultSet *rs = [dataBase executeQuery:sql];
            
            if ([rs next]) {
                int count = [rs intForColumnIndex:0];
                if (count >0) {
                    
                    check=true;
                }else
                {
                    
                    check=false;
                }
            }
            [rs close];
            //[dataBase close];
        }
    }
    @catch (NSException *exception) {
        [[CommUtilHelper sharedInstance] setErrorMsg:[@"getLastSyncTimeByTable" stringByAppendingString:[exception description]]];
        NSLog(@"isExistChatGroupID error:%@",exception);
    }
    @finally {
    }
    return check;
}

-(NSString *)getChatGroupImage:(NSString *)chatGroupId
{
     NSString *sql = [NSString stringWithFormat:@"select CHAT_GROUP_IMAGE from %@  where chat_group_id=%@", CHAT_GROUP,chatGroupId];
    @try {
        NSString *reValue=@"";
       
        if ([dataBase open]) {
            FMResultSet *rs = [dataBase executeQuery:sql];
            
            if ([rs next]) {
                reValue = [rs stringForColumn:@"CHAT_GROUP_IMAGE"];
            }
            [rs close];
            //[dataBase close];
        }
        return reValue;
    }
    @catch (NSException *exception) {
        [[CommUtilHelper sharedInstance] setErrorMsg:[@"getChatGroupImage:" stringByAppendingString:[exception description]]];
        NSLog(@"getChatGroupImage error:%@",exception);
    }
    @finally {
    }
}
-(BOOL)initChatGroupList:(NSMutableArray *)listArr
{
    @try {
        //是否第一次同步g
        //NSString *syncTime = [self getLastSyncTimeByTable:CHAT_GROUP];
        NSString *syncTime = [[CommUtilHelper sharedInstance] getLastSyncTime:CHAT_GROUP];
        BOOL isFirsSync = NO;
        if (!syncTime){
            //第一次同步
            isFirsSync = YES;
        }
    
    for (int i=0; i<[listArr count]; i++) {
        NSDictionary *temp=[listArr objectAtIndex:i];
        NSString *sysDttm =[temp objectForKey:@"SYSDTTM"];
        if (isFirsSync || [FormatTime CompareDate:sysDttm SecondDate:syncTime]) {
        NSString *ChatGroupId = [temp objectForKey:@"CHAT_GROUP_ID"];
        NSString *lastSessionDate = [temp objectForKey:@"LAST_SESSION_DATE"];
        NSString *lastUpdateSession = [temp objectForKey:@"LAST_UPDATE_SESSION"];
        //若是第一次同步 则清空组里面的 最后一条聊天信息
        if (isFirsSync) {
             lastUpdateSession=@"";
        }
        
            NSString *lastSessionPerson = [temp objectForKey:@"LAST_SESSION_PERSON"];
            NSString *ChatGroupName = [temp objectForKey:@"CHAT_GROUP_NAME"];
            NSString *isGroup = [temp objectForKey:@"IS_GROUP"];
            
            NSString *image = [self changeNullToStr:[temp objectForKey:@"CHAT_GROUP_IMAGE"]] ;
            NSString *image2 =[self changeNullToStr: [temp objectForKey:@"CHAT_GROUP_IMAGE2"]];
            NSString *image3 = [self changeNullToStr:[temp objectForKey:@"CHAT_GROUP_IMAGE3"]];
            NSString *image4 = [self changeNullToStr:[temp objectForKey:@"CHAT_GROUP_IMAGE4"]];
            NSString *image5 =[self changeNullToStr: [temp objectForKey:@"CHAT_GROUP_IMAGE5"]];
            NSString *commbineImage = [NSString stringWithFormat:@"%@%@%@%@%@",image,image2,image3,image4,image5];
            NSString *chatGroupImg = [[CommUtilHelper sharedInstance] saveImageToPath:commbineImage];
           
            NSString *type =[temp objectForKey:@"TYPE"]==nil?@"":[temp objectForKey:@"TYPE"];
            NSString *is_top =[temp objectForKey:@"IS_TOP"]==nil?@"":[temp objectForKey:@"IS_TOP"];
            NSString *source =[temp objectForKey:@"SOURCE"]==nil?@"":[temp objectForKey:@"SOURCE"];
            NSString *order_no =[temp objectForKey:@"ORDER_NO"]==nil?@"":[temp objectForKey:@"ORDER_NO"];
            //若存在该组 则更新最后会话内容
            if ([self isExistChatGroupID:ChatGroupId ]) {
                if ([dataBase open]) {
                    NSString *existGroupImage = [self getChatGroupImage:ChatGroupId];
                    if (existGroupImage && ![@"" isEqualToString:existGroupImage]) {
                       NSString *imgPath = [[CommUtilHelper sharedInstance] dataImagePath:existGroupImage];
                        NSFileManager *fileManager = [NSFileManager defaultManager];
                        [fileManager removeItemAtPath:imgPath error:nil];
                    }
            
                        [dataBase executeUpdate:[NSString stringWithFormat:@"update %@ set CHAT_GROUP_IMAGE=?,LAST_UPDATE_SESSION=?,LAST_SESSION_DATE=?,LAST_SYNC_TIME=?,CHAT_GROUP_NAME=?,LAST_SESSION_PERSON=?,TYPE=?,IS_TOP=?,SOURCE=?,ORDER_NO=? where chat_group_id=?",CHAT_GROUP] withArgumentsInArray:[NSArray arrayWithObjects:chatGroupImg,lastUpdateSession,lastSessionDate,sysDttm,ChatGroupName,lastSessionPerson,ChatGroupId,nil]];
                    
            }
            
            continue;
        }
        
        
        NSString *ChatGroupINfo = [temp objectForKey:@"CHAT_GROUP_INFO"];
        NSString *ChatGroupBarCode = [temp objectForKey:@"CHAT_GROUP_BARCODE"];
        
        
        NSString *createPerson = [temp objectForKey:@"CREATE_PERSON"];
        NSString *delFlag = [temp objectForKey:@"DEL_FLAG"];
        NSString *createDate = [temp objectForKey:@"CREATE_DATE"];

        
        
       
            
        NSString *lastupdPerson = [temp objectForKey:@"LASTUPD_PERSON"];
        NSString *lastUpdDate = [temp objectForKey:@"LASTUPD_DATE"];
        NSString *filePath = [temp objectForKey:@"FILE_PATH"];
            
        
        //
       
       //
        NSString *sql=[NSString stringWithFormat:@"insert into %@ (ID,CHAT_GROUP_ID,CHAT_GROUP_NAME,LAST_UPDATE_SESSION,CREATE_PERSON,DEL_FLAG,CREATE_DATE,LAST_SESSION_PERSON,LAST_SESSION_DATE,IS_GROUP,LASTUPD_PERSON,LASTUPD_DATE,CHAT_GROUP_INFO,CHAT_GROUP_BARCODE,CHAT_GROUP_IMAGE,FILE_PATH,LAST_SYNC_TIME,TYPE,IS_TOP,SOURCE,ORDER_NO) values (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)",CHAT_GROUP];
         //[dataBase executeUpdate:sql,[NSNull null],ChatGroupId,ChatGroupName,lastUpdateSession,createPerson,[delFlag intValue],createDate,lastSessionPerson,lastSessionDate,isGroup,lastupdPerson,lastUpdDate,ChatGroupINfo,ChatGroupBarCode,chatGroupImg,filePath,sysDttm];
            NSArray *arr = [NSArray arrayWithObjects:[NSNull null],ChatGroupId,ChatGroupName,lastUpdateSession,createPerson,delFlag ,createDate,lastSessionPerson,lastSessionDate,isGroup,lastupdPerson,lastUpdDate,ChatGroupINfo,ChatGroupBarCode,chatGroupImg,filePath,sysDttm,type,is_top,source,order_no,nil];
            if ([dataBase open]) {
                if([dataBase executeUpdate:sql withArgumentsInArray:arr])
                //更新同步时间
                [[CommUtilHelper sharedInstance] setValueDefaults:sysDttm key:CHAT_GROUP];
            }
            
            if ([dataBase hadError]) {
                NSLog(@"Err insertEscore %d: %@", [dataBase lastErrorCode], [dataBase lastErrorMessage]);
                return NO;
            }
        }
     }
        //[dataBase commit];
        return YES;
    }
    @catch (NSException *exception) {
       //[dataBase rollback];
        [[CommUtilHelper sharedInstance] setErrorMsg:[@"initChatGroupList error:" stringByAppendingString:[exception description]]];
       NSLog(@"initChatGroupList error:%@",exception);
       return NO;
    }
    @finally {
       // [dataBase close];
    }
    return NO;
}

-(BOOL)initChatPersonList:(NSMutableArray *)listArr
{
    @try {
        //是否第一次同步
       // NSString *syncTime = [self getLastSyncTimeByTable:CHAT_GROUP_PERSON];
         NSString *syncTime = [[CommUtilHelper sharedInstance] getLastSyncTime:CHAT_GROUP_PERSON];
        BOOL isFirsSync = NO;
        if (!syncTime){
            //第一次同步
            isFirsSync = YES;
        }
      
        //[dataBase beginTransaction];
        for (int i=0; i<[listArr count]; i++) {
            NSDictionary *temp=[listArr objectAtIndex:i];
            NSString *sysDttm =[temp objectForKey:@"SYSDTTM"];
            if (isFirsSync || [FormatTime CompareDate:sysDttm SecondDate:syncTime]) {
                NSString *userPrincipalName = [temp objectForKey:@"USER_PRINCIPAL_NAME"];
                NSString *ChatGroupId = [temp objectForKey:@"CHAT_GROUP_ID"];
                 NSString *delFlag = [temp objectForKey:@"DEL_FLAG"];
                NSString *ChatGroupPersonId = [temp objectForKey:@"GROUP_PERSON_ID"];
                NSString *userNickName = [temp objectForKey:@"USER_NICK_NAME"];
                NSString *creteDate = [temp objectForKey:@"CREATE_DATE"];
                NSString *lastUpdateBy = [temp objectForKey:@"LAST_UPDATEBY"];
                NSString *lastUpdateDttm = [temp objectForKey:@"LAST_UPDATEDTTM"];
                //是否存在该人 若存在 则更新 若delflag=1则删除
                BOOL check =  [self isExistUserRecord:[NSString stringWithFormat:@"select count(*) from %@ where CHAT_GROUP_ID='%@' and USER_PRINCIPAL_NAME='%@' and del_flag=0",CHAT_GROUP_PERSON,ChatGroupId,userPrincipalName]];
                if (check) {
                    if ([@"1" isEqualToString:delFlag]) {
                        [dataBase executeUpdate:[NSString stringWithFormat: @"delete from %@ where chat_group_id=%@ and USER_PRINCIPAL_NAME='%@'",CHAT_GROUP_PERSON,ChatGroupId,userPrincipalName]];
                    }else
                    {
                        [dataBase executeUpdate:[NSString stringWithFormat:@"update %@ set LAST_SYNC_TIME='%@' where chat_group_id=%@ and USER_PRINCIPAL_NAME='%@'",CHAT_GROUP_PERSON,sysDttm,ChatGroupId,userPrincipalName]];
                    }
                    continue;
                }
                
               
                NSString *sql=[NSString stringWithFormat:@"insert into %@ (Id ,GROUP_PERSON_ID  , CHAT_GROUP_ID   , USER_PRINCIPAL_NAME ,USER_NICK_NAME ,CREATE_DATE ,DEL_FLAG ,LAST_UPDATEBY ,LAST_UPDATEDTTM ,LAST_SYNC_TIME) values (?,?,?,?,?,?,?,?,?,?) ",CHAT_GROUP_PERSON];
                 //[dataBase executeUpdate:sql,[NSNull null],ChatGroupPersonId,ChatGroupId,userPrincipalName,userNickName,creteDate,delFlag,lastUpdateBy,lastUpdateDttm,sysDttm];
                if ([dataBase open]) {
                    if([dataBase executeUpdate:sql withArgumentsInArray:[NSArray arrayWithObjects:[NSNull null],ChatGroupPersonId,ChatGroupId,userPrincipalName,userNickName,creteDate,delFlag,lastUpdateBy,lastUpdateDttm,sysDttm, nil]])
                    [[CommUtilHelper sharedInstance] setValueDefaults:sysDttm key:CHAT_GROUP_PERSON];
                }
                
                if ([dataBase hadError]) {
                    NSLog(@"Err insertEscore %d: %@", [dataBase lastErrorCode], [dataBase lastErrorMessage]);
                    return NO;
                }
            }
        }
        //[dataBase commit];
        return YES;
    }
    @catch (NSException *exception) {
        //[dataBase rollback];
         [[CommUtilHelper sharedInstance] setErrorMsg:[@"initChatPersonList error:" stringByAppendingString:[exception description]]];
        NSLog(@"initChatPersonList error:%@",exception);
        return NO;
    }
    @finally {
        //[dataBase close];
    }
    return NO;
}

-(BOOL)isExistSessionId:(NSString *)sessionId GroupId:(NSString *)groupId
{
    BOOL reCheck = NO;
    NSString *sql =[NSString stringWithFormat:@"select count(*) from %@ where chat_group_id =%@ and id=%@",CHAT_GROUP_SESSION,groupId,sessionId];
    if ([dataBase open]) {
        @try {
            FMResultSet *rs = [dataBase executeQuery:sql];
            while ([rs  next]) {
                if ([rs intForColumnIndex:0]>0) {
                    reCheck=YES;
                }
            }
            
        }
        @catch (NSException *exception) {
            NSLog(@"isExistSessionId error:%@",exception);
            reCheck=NO;
        }
        @finally {
        }
    }
    return reCheck;
}
-(NSMutableArray *)iniChatSessionList:(NSMutableArray *)listArr
{
    NSMutableArray *reMutabeArr = [[NSMutableArray alloc] init];
    @try {
        
        //是否第一次同步
        //NSString *syncTime = [self getLastSyncTimeByTable:CHAT_GROUP_SESSION];
         NSString *syncTime = [[CommUtilHelper sharedInstance] getLastSyncTime:CHAT_GROUP_SESSION];
        BOOL isFirsSync = NO;
        if (!syncTime){
            //第一次同步
            isFirsSync = YES;
        }
        //NSString *deviceId = [CommUtilHelper getDeviceId];
        NSString *clearStr = [NSString new];
        for (int i=0; i<[listArr count]; i++) {
            
            NSData *data =  [[listArr objectAtIndex:i] dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *temp= [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            //NSDictionary *temp=[[listArr objectAtIndex:i] JSONValue];
            NSString *msgType = [temp objectForKey:@"msgType"];
            if (!([@"TEXT" isEqualToString:msgType] || [@"IMAGE" isEqualToString:msgType]|| [@"AUDIO" isEqualToString:msgType] || [@"SYS" isEqualToString:msgType])) {
                continue;
            }
            NSString *sysDttm =[temp objectForKey:@"serverTime"];
            if (isFirsSync || [FormatTime CompareDate:sysDttm SecondDate:syncTime]) {
                NSString *GroupSessionId = [[temp objectForKey:@"sessionId"] stringValue];
                NSString *sId = [temp objectForKey:@"sId"] ;
                NSString *fromDeviceId = [temp objectForKey:@"fromDeviceId"] ;
                NSString *chatGroupId = [temp objectForKey:@"groupId"];
                NSArray *tempSIDArr = [sId componentsSeparatedByString:@"_"];
                //如果已收到过此消息，则不再处理
                if ([self checkIsExistSession:GroupSessionId ChatGroupId:chatGroupId]) {
                    continue;
                }
                NSString *tempStrId = @"";
                if ([tempSIDArr count]>1) {
                    tempStrId =[tempSIDArr objectAtIndex:[tempSIDArr count]-1];
                }
                //如果是当前设备，且已存在相同的sId，则仅更新
                if ([self isExistSessionId:tempStrId GroupId:chatGroupId] &&[fromDeviceId isEqualToString:[CommUtilHelper getDeviceId]]){
                    
                    NSString *sql = @"update %@ set LAST_SYNC_TIME = '%@' ,GROUP_SESSION_ID=%@ where chat_group_id=%@ and id=%@";
                    if ([dataBase open]) {
                           [dataBase executeUpdate:[NSString stringWithFormat:sql,CHAT_GROUP_SESSION,sysDttm,GroupSessionId,chatGroupId,tempStrId]];
                    }
                    continue;
                }
                NSString *chatContent = [temp objectForKey:@"msg"];
                NSString *createDate = [temp objectForKey:@"date"];
                NSString *localCreateDate = [FormatTime dateToStr:[NSDate date]] ;
               
                NSString *userPrincipalName = [temp objectForKey:@"from"];
                if (!([@"TEXT" isEqualToString:msgType] || [@"AUDIO" isEqualToString:msgType] ||[@"IMAGE" isEqualToString:msgType] ||[@"SYS" isEqualToString:msgType]) ) {
                    //userPrincipalName=@"system";
                    continue;
                }
               
                
                NSString *filePath = [temp objectForKey:@"filePath"];
                NSString *chatSmallPic = [temp objectForKey:@"thumbnailFileName"];
              
                if ([@"TEXT" isEqualToString:msgType]) {
                    filePath =@"";
                    chatSmallPic = @"";
                }
                if ([@"IMAGE" isEqualToString:msgType]) {
                    NSString *filePath = [[CommUtilHelper sharedInstance] dataImagePath:chatSmallPic];
                    if(![[NSFileManager defaultManager] fileExistsAtPath:filePath]){
                        [CharViewNetServiceUtil asynDownLoadImg:[NSString stringWithFormat:@"%@/fileTransfer/download?fileName=%@",charUrl,chatSmallPic] targetFilePath:filePath ];
                    }
                }
//              NSString *chatSmallPic2 = [temp objectForKey:@"CHAT_SMALLPIC2"];
//              NSString *chatSmallPic3 = [temp objectForKey:@"CHAT_SMALLPIC3"];
//              NSString *chatSmallPic4 = [temp objectForKey:@"CHAT_SMALLPIC4"];
//              NSString *chatSmallPic5 = [temp objectForKey:@"CHAT_SMALLPIC5"];
                //NSMutableString *smallPic = [[NSMutableString alloc] initWithString:chatSmallPic];
//                [smallPic appendString:chatSmallPic2];
//                [smallPic appendString:chatSmallPic3];
//                [smallPic appendString:chatSmallPic4];
//                [smallPic appendString:chatSmallPic5];
                //NSString * smallPicName = [[CommUtilHelper sharedInstance] saveImageToPath:smallPic];
                NSString *sessionId = [[temp objectForKey:@"sessionId"] stringValue];
                NSString *delFlag = @"0";
                NSString *sql=[NSString stringWithFormat:@"insert into %@ (ID ,GROUP_SESSION_ID , CHAT_GROUP_ID ,USER_PRINCIPAL_NAME , CHAT_CONTENT ,CREATE_DATE ,DEL_FLAG ,FILE_PATH ,CHAT_SMALLPIC ,SESSION_ID ,LAST_SYNC_TIME,LOCAL_CREATE_DATE) values (?,?,?,?,?,?,?,?,?,?,?,?)",CHAT_GROUP_SESSION];
                
                if ([dataBase open]) {
                   BOOL isoK= [dataBase executeUpdate:sql withArgumentsInArray:[NSArray arrayWithObjects:[NSNull null],GroupSessionId,chatGroupId,userPrincipalName,chatContent,localCreateDate,delFlag ,filePath,chatSmallPic,sessionId,sysDttm,localCreateDate, nil]];
                    if (isoK) {
                         [[CommUtilHelper sharedInstance] setValueDefaults:sysDttm key:CHAT_GROUP_SESSION];
                         NSString *uuid = [[temp objectForKey:@"uuid"] stringValue];
                         [[MessageUtilHelper sharedInstance] setMessageUUID:uuid];
                        if ([@"" isEqualToString:clearStr]) {
                            //clearStr = [[@"[\"" stringByAppendingString:[clearStr stringByAppendingString:uuid] ]stringByAppendingString:@"\""];
                            clearStr = [clearStr stringByAppendingString:uuid];
                        }else
                        {
                          //  clearStr = [[[[clearStr stringByAppendingString:@","]  stringByAppendingString:@"\""] stringByAppendingString:uuid] stringByAppendingString:@"\""];
                            clearStr = [[clearStr stringByAppendingString:@","] stringByAppendingString:uuid];
                        }
                        
                        
                         //[[CommUtilHelper sharedInstance] newMessageCounterByGroupId:chatGroupId MessageCounter:@"1"];
                        //[[CommUtilHelper sharedInstance] setMessageCountByGroupId:chatGroupId withCount:1 withType:addCounter];
                    }
                }
                if ([dataBase hadError]) {
                    NSLog(@"Err insertEscore %d: %@", [dataBase lastErrorCode], [dataBase lastErrorMessage]);
                    return nil;
                }
            }
        }
        
        [reMutabeArr addObject:clearStr];
        return reMutabeArr;
    }
    @catch (NSException *exception) {
       //[dataBase rollback];
        [[CommUtilHelper sharedInstance] setErrorMsg:[@"initChatSessionList error:" stringByAppendingString:[exception description]]];
       NSLog(@"initChatSessionList error:%@",exception);
        
       return nil;
    }
    @finally {
        //[dataBase close];
    }
    return nil;
}


-(BOOL)initChatUserList:(NSMutableArray *)listArr
{
    @try {
        //是否第一次同步
        //NSString *syncTime = [self getLastSyncTimeByTable:CHAT_USERS];
         NSString *syncTime = [[CommUtilHelper sharedInstance] getLastSyncTime:CHAT_USERS];
        BOOL isFirsSync = NO;
        if (!syncTime){
            //第一次同步
            isFirsSync = YES;
        }

        for (int i=0; i<[listArr count]; i++) {
            NSDictionary *temp=[listArr objectAtIndex:i];
            NSString *sysDttm =[temp objectForKey:@"SYSDTTM"];
            if (isFirsSync || [FormatTime CompareDate:sysDttm SecondDate:syncTime]) {
                NSString *principalName = [temp objectForKey:@"USER_PRINCIPAL_NAME"];
                NSString *contactUser = [temp objectForKey:@"FREQUENT_CONTACT_USER"];
                //若有重复
                if ([self checkIsEsixtContactByChatUser:principalName FrequentContactUser:contactUser]) {
                    continue;
                }
                NSString *createDate = [temp objectForKey:@"CREATE_DATE"];
                NSString *delFlag = [temp objectForKey:@"DEL_FLAG"];
                
                NSString *nickName = [temp objectForKey:@"USER_NICK_NAME"];
                NSString *displayName = [temp objectForKey:@"USER_DISPLAY_NAME"];
             
                NSString *sql=[NSString stringWithFormat:@"insert into %@ (Id ,USER_PRINCIPAL_NAME , FREQUENT_CONTANCT_USER  , CREATE_DATE , DEL_FLAG , USER_NICK_NAME ,USER_DISPLAY_NAME ,LAST_SYNC_TIME) values (?,?,?,?,?,?,?,?)  ",CHAT_USERS];
               //[dataBase executeUpdate:sql,[NSNull null],principalName,contactUser,createDate,[delFlag intValue],nickName,displayName,sysDttm];
                if ([dataBase open]) {
                    if([dataBase executeUpdate:sql withArgumentsInArray:[NSArray arrayWithObjects:[NSNull null],principalName,contactUser,createDate,delFlag,nickName,displayName,sysDttm, nil]])
                    [[CommUtilHelper sharedInstance] setValueDefaults:sysDttm key:CHAT_USERS];

                }
                   if ([dataBase hadError]) {
                    NSLog(@"Err insertEscore %d: %@", [dataBase lastErrorCode], [dataBase lastErrorMessage]);
                    return NO;
                }
            }
        }
        //[dataBase commit];
        return YES;
    }
    @catch (NSException *exception) {
        //[dataBase rollback];
         [[CommUtilHelper sharedInstance] setErrorMsg:[@"initChatUserList error:" stringByAppendingString:[exception description]]];
        NSLog(@"initChatUserList error:%@",exception);
        return NO;
    }
    @finally {
        //[dataBase close];
    }
    return NO;
}

-(BOOL)checkIsEsixtContactByChatUser:(NSString *)user FrequentContactUser:(NSString *) fuser
{
    BOOL reCheck = NO;
    NSString *sql =[NSString stringWithFormat:@"select count(*) from %@ where del_flag=0 and  USER_PRINCIPAL_NAME =%@ and FREQUENT_CONTANCT_USER=%@",CHAT_USERS,user,fuser];
    if ([dataBase open]) {
        @try {
            FMResultSet *rs = [dataBase executeQuery:sql];
            while ([rs  next]) {
                if ([rs intForColumnIndex:0]>0) {
                    reCheck=YES;
                }
            }
            
        }
        @catch (NSException *exception) {
            NSLog(@"isExistSessionId error:%@",exception);
            reCheck=NO;
        }
        @finally {
        }
    }
    return reCheck;

}

-(NSString *)changeNullToStr:(NSString *)str
{
    if ([str isKindOfClass:[NSNull class]]) {
        return  @"";
    }else if(str == nil)
    {
     return @"";
    }else
    {
        return str;
    }
}
-(BOOL)initADUser:(NSMutableArray *)listArr
{
    @try {
        //是否第一次同步
        //NSString *syncTime = [self getLastSyncTimeByTable:CHAT_AD_USER];
         NSString *syncTime = [[CommUtilHelper sharedInstance] getLastSyncTime:CHAT_AD_USER];
        BOOL isFirsSync = NO;
        if (!syncTime){
            //第一次同步
            isFirsSync = YES;
        }
        [dataBase open];
        //[dataBase beginTransaction];
        for (int i=0; i<[listArr count]; i++) {
            NSDictionary *temp=[listArr objectAtIndex:i];
            NSString *sysDttm =[temp objectForKey:@"SYSDTTM"];
            if (isFirsSync || [FormatTime CompareDate:sysDttm SecondDate:syncTime]) {
                
                NSString *principalName = [temp objectForKey:@"USER_PRINCIPAL_NAME"];
                NSString *TITLE = [temp objectForKey:@"TITLE"];
                
                
                NSString *LOCATION = [temp objectForKey:@"LOCATION"];
                NSString *DISABLED = [temp objectForKey:@"DISABLED"];
                 NSString *COMMNAME = [temp objectForKey:@"COMMON_NAME"];
                NSString *EMAIL = [temp objectForKey:@"EMAIL"];
                NSString *PHONE_NUMBER = [temp objectForKey:@"PHONE_NUMBER"];
                NSString *LOGIN_STATUS = [temp objectForKey:@"LOGIN_STATUS"];
                //NSString *HEAD_PHOTO = [temp objectForKey:@"HEAD_PHOTO"];
                NSString *image =  [self  changeNullToStr:[temp objectForKey:@"HEAD_PHOTO"]];
                NSString *image2 = [self  changeNullToStr:[temp objectForKey:@"HEAD_PHOTO2"]];
                NSString *image3 = [self  changeNullToStr:[temp objectForKey:@"HEAD_PHOTO3"]];
                NSString *image4 = [self  changeNullToStr:[temp objectForKey:@"HEAD_PHOTO4"]];
                NSString *image5 = [self  changeNullToStr:[temp objectForKey:@"HEAD_PHOTO5"]];
                
                BOOL check =  [self isExistUserRecord:[NSString stringWithFormat:@"select count(*) from %@ where USER_PRINCIPAL_NAME='%@'",CHAT_AD_USER,principalName]];
               
                
                if (check) {
                    NSString *commbineImage = [NSString stringWithFormat:@"%@%@%@%@%@",image,image2,image3,image4,image5];
                    NSString *HEAD_PHOTO = [[CommUtilHelper sharedInstance] saveImageToPath:commbineImage];
                    if ([[[CommUtilHelper sharedInstance]getUser] isEqualToString:principalName]) {
                        [dataBase executeUpdate:[NSString stringWithFormat:@"update %@ set PHONE_NUMBER='%@',EMAIL='%@',LAST_SYNC_TIME='%@',LOGIN_STATUS='%@' where USER_PRINCIPAL_NAME='%@' ",CHAT_AD_USER,PHONE_NUMBER,EMAIL,sysDttm,LOGIN_STATUS,principalName]];
                    }else
                    {
                     [dataBase executeUpdate:[NSString stringWithFormat:@"update %@ set HEAD_PHOTO='%@',PHONE_NUMBER='%@',EMAIL='%@',LAST_SYNC_TIME='%@',LOGIN_STATUS='%@' where USER_PRINCIPAL_NAME='%@' ",CHAT_AD_USER,HEAD_PHOTO,PHONE_NUMBER,EMAIL,sysDttm,LOGIN_STATUS,principalName]];
                    }
                    
                    
                    continue;
                }

                NSString *contactUser = [temp objectForKey:@"SAM_ACCOUNT_NAME"];
                
                NSString *EMPLOYEE_NUMBER = [temp objectForKey:@"EMPLOYEE_NUMBER"];
                
               
                NSString *HEAD_BIG_PHOTO = [temp objectForKey:@"HEAD_BIG_PHOTO"];
           
                NSString *sql=[NSString stringWithFormat:@"insert into %@ (Id ,USER_PRINCIPAL_NAME,  SAM_ACCOUNT_NAME, EMPLOYEE_NUMBER , DISABLED , TITLE ,LOCATION ,EMAIL ,PHONE_NUMBER ,HEAD_PHOTO ,HEAD_BIG_PHOTO ,LAST_SYNC_TIME,COMMON_NAME,LOGIN_STATUS  ) values (?,?,?,?,?,?,?,?,?,?,?,?,?,?)  ",CHAT_AD_USER];
                //[dataBase executeUpdate:sql,[NSNull null],principalName,contactUser,EMPLOYEE_NUMBER,DISABLED,TITLE,LOCATION,EMAIL,PHONE_NUMBER,HEAD_PHOTO,HEAD_BIG_PHOTO,sysDttm];
                if ([dataBase open]) {
                    NSString *commbineImage = [NSString stringWithFormat:@"%@%@%@%@%@",image,image2,image3,image4,image5];
                    NSString *HEAD_PHOTO = [[CommUtilHelper sharedInstance] saveImageToPath:commbineImage];
                    if([dataBase executeUpdate:sql withArgumentsInArray:[NSArray arrayWithObjects:[NSNull null],principalName,contactUser,EMPLOYEE_NUMBER,DISABLED,TITLE,LOCATION,EMAIL,PHONE_NUMBER,HEAD_PHOTO,HEAD_BIG_PHOTO,sysDttm,COMMNAME,LOGIN_STATUS, nil]])
                  [[CommUtilHelper sharedInstance] setValueDefaults:sysDttm key:CHAT_AD_USER];
                }
                if ([dataBase hadError]) {
                    NSLog(@"Err insertEscore %d: %@", [dataBase lastErrorCode], [dataBase lastErrorMessage]);
                    return NO;
                }
            }
        }
        //[dataBase commit];
        return YES;
    }
    @catch (NSException *exception) {
        //[dataBase rollback];
        [[CommUtilHelper sharedInstance] setErrorMsg:[@"initADUser error:" stringByAppendingString:[exception description]]];
        NSLog(@"initADUser error:%@",exception);
        return NO;
    }
    @finally {
        //[dataBase close];
    }
    return NO;
}



///////////////////获取本地数据
//获取组
-(NSMutableArray *)getChatGroupList
{
    @try {
        NSString *sql = @"Select t1.*, ifnull((Select COMMON_NAME From CHAT_AD_USER as t2 Where t1.LAST_SESSION_PERSON=t2.USER_PRINCIPAL_NAME),t1.LAST_SESSION_PERSON) as LAST_COMMON_NAME From CHAT_GROUP as t1 Where del_flag=0 And ifnull(type,'')!='EVENT' Order by ifnull(IS_TOP,'N') DESC, LAST_SESSION_DATE  DESC";
        if ([dataBase open]) {
            FMResultSet *rs = [dataBase executeQuery:sql];
            NSMutableArray *chatGroupDic = [NSMutableArray array];
            while ([rs next]) {
                NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
                
                [dic setObject:[rs stringForColumn:@"CHAT_GROUP_ID"] forKey:@"CHAT_GROUP_ID"];
                NSString *groupName =  [rs stringForColumn:@"CHAT_GROUP_NAME"];
                if ([groupName isKindOfClass:[NSNull class]] || groupName == nil) {
                    groupName = @"null";
                }
                [dic setObject:groupName forKey:@"CHAT_GROUP_NAME"];
              
                NSString *lastUpdateSession =[rs stringForColumn:@"LAST_UPDATE_SESSION"];
                if (lastUpdateSession && ![@"" isEqualToString:lastUpdateSession]) {
                    [dic setObject:lastUpdateSession forKey:@"LAST_UPDATE_SESSION"];
                }else
                {
                  [dic setObject:@"" forKey:@"LAST_UPDATE_SESSION"];
                }
                NSString *lastSessionPerson =[rs stringForColumn:@"LAST_SESSION_PERSON"];
                if (lastSessionPerson &&![@"" isEqualToString: lastSessionPerson]) {
                    [dic setObject:lastSessionPerson forKey:@"LAST_SESSION_PERSON"];
                }else
                {
                    [dic setObject:@""forKey:@"LAST_SESSION_PERSON"];
                }
                

                NSString *lastCommName =  [rs stringForColumn:@"LAST_COMMON_NAME"];
                if (lastCommName &&![@"" isEqualToString: lastCommName] ) {
                    [dic setObject:lastCommName forKey:@"LAST_COMMON_NAME"];
                }else
                {
                  [dic setObject:@"" forKey:@"LAST_COMMON_NAME"];
                }
                
                NSString *source = [rs stringForColumn:@"SOURCE"];
                if (source &&![@"" isEqualToString: source] ) {
                    [dic setObject:source forKey:@"SOURCE"];
                }else
                {
                    [dic setObject:@"" forKey:@"SOURCE"];
                }
                
                NSString *type = [rs stringForColumn:@"TYPE"];
                if (type &&![@"" isEqualToString: type] ) {
                    [dic setObject:type forKey:@"TYPE"];
                }else
                {
                    [dic setObject:@"" forKey:@"TYPE"];
                }
                
                [dic setObject:[rs stringForColumn:@"LAST_SESSION_DATE"] forKey:@"LAST_SESSION_DATE"];
                [dic setObject:[rs stringForColumn:@"IS_GROUP"] forKey:@"IS_GROUP"];
                [dic setObject:[rs stringForColumn:@"CHAT_GROUP_IMAGE"] forKey:@"HEAD_PHOTO"];
                [dic setObject:[rs stringForColumn:@"CREATE_PERSON"] forKey:@"CREATE_PERSON"];

                [chatGroupDic addObject:dic];
            }
            [rs close];
            return chatGroupDic;
        }else
        {
            return nil;
        }
    }
    @catch (NSException *exception) {
        [[CommUtilHelper sharedInstance] setErrorMsg:[@"getChatGroupList error:" stringByAppendingString:[exception description]]];
        NSLog(@"getChatGroupList error:%@",exception);
        return nil;
    }
    @finally {
    }
}
//获取消息

-(NSMutableArray *)getCHatGroupSessionByminPage:(NSInteger)minCount toMax:(NSInteger)maxCout GroupId:(NSString *)groupId
{
    @try {
        NSString *sql = [NSString stringWithFormat:@"select b.*,(select sam_account_name  from %@ where user_principal_name =b.user_principal_name) as nickName ,(select HEAD_PHOTO  from %@ where user_principal_name =b.user_principal_name) as HEAD_PHOTO from( select a.*,a.rowid as sortId from %@ as a   WHERE a.chat_group_id = %@  and a.id<=%li  order   by  strftime('%%Y-%%m-%%d %%H:%%M:%%S',a.LAST_SYNC_TIME) desc ,a.id desc limit 10 offset %li ) as b order by strftime('%%Y-%%m-%%d %%H:%%M:%%S',b.LAST_SYNC_TIME),b.id", CHAT_AD_USER, CHAT_AD_USER,CHAT_GROUP_SESSION,groupId,(long)maxCout,minCount];
        if ([dataBase open]) {
            
            FMResultSet *rs = [dataBase executeQuery:sql];
            NSMutableArray *chatGroupDic = [NSMutableArray array];
            while ([rs next]) {
                NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
                
                if ([rs stringForColumn:@"nickName"]) {
                    [dic setObject:[rs stringForColumn:@"nickName"] forKey:@"USER_NICK_NAME"];
                }else
                {
                    //[dic setObject:@"system" forKey:@"USER_NICK_NAME"];
                     [dic setObject:[rs stringForColumn:@"USER_PRINCIPAL_NAME"] forKey:@"USER_NICK_NAME"];
                }
                NSString *headPhoto = [rs stringForColumn:@"HEAD_PHOTO"];
                if (headPhoto) {
                    [dic setObject:[rs stringForColumn:@"HEAD_PHOTO"] forKey:@"HEAD_PHOTO"];
                }else
                {
                    [dic setObject:@"" forKey:@"HEAD_PHOTO"];
                }
                NSString *lastSyncTime = [rs stringForColumn:@"LAST_SYNC_TIME"];
                if (lastSyncTime) {
                    [dic setObject:lastSyncTime forKey:@"LAST_SYNC_TIME"];
                }
                else
                {
                    [dic setObject:[rs stringForColumn:@"CREATE_DATE"] forKey:@"LAST_SYNC_TIME"];
                }
                [dic setObject:[rs stringForColumn:@"ID"] forKey:@"ID"];
                if ([rs stringForColumn:@"GROUP_SESSION_ID"]) {
                    [dic setObject:[rs stringForColumn:@"GROUP_SESSION_ID"] forKey:@"GROUP_SESSION_ID"];
                }else
                {
                  [dic setObject:@"" forKey:@"GROUP_SESSION_ID"];
                }
               
                [dic setObject:[rs stringForColumn:@"CHAT_CONTENT"] forKey:@"CHAT_CONTENT"];
                
                NSString *chatSamllPic =[rs stringForColumn:@"CHAT_SMALLPIC"];
                if (chatSamllPic !=nil && ![chatSamllPic isKindOfClass:[NSNull class]]) {
                    [dic setObject:[rs stringForColumn:@"CHAT_SMALLPIC"] forKey:@"CHAT_SMALLPIC"];
                }else
                {
                    [dic setObject:@"" forKey:@"CHAT_SMALLPIC"];
                }
                NSString *FILE_PATH =[rs stringForColumn:@"FILE_PATH"];
                if (FILE_PATH !=nil && ![FILE_PATH isKindOfClass:[NSNull class]]) {
                    [dic setObject:[rs stringForColumn:@"FILE_PATH"] forKey:@"FILE_PATH"];
                }else
                {
                    [dic setObject:@"" forKey:@"FILE_PATH"];
                }
                
                
                [dic setObject:[rs stringForColumn:@"CREATE_DATE"] forKey:@"CREATE_DATE"];
                [dic setObject:[rs stringForColumn:@"USER_PRINCIPAL_NAME"] forKey:@"USER_PRINCIPAL_NAME"];
                //
                [chatGroupDic addObject:dic];
            }
            [rs close];
            if (chatGroupDic) {
                return chatGroupDic;
            }else
            {
                return nil;
            }
            
        }else
        {
            return  nil;
        }
    }
    @catch (NSException *exception) {
        [[CommUtilHelper sharedInstance] setErrorMsg:[@"getCHatGroupSessionByminPage error:" stringByAppendingString:[exception description]]];
        NSLog(@"getCHatGroupSessionByminPage error:%@",exception);
        return nil;
    }
    @finally {
    }
}

-(NSMutableArray *)getCHatGroupSessionbySessionId:(NSString *)sessionId
{
    @try {
        NSString *sql = [NSString stringWithFormat:@"select * from %@ where id= %@",CHAT_GROUP_SESSION,sessionId];
        if ([dataBase open]) {
            
            FMResultSet *rs = [dataBase executeQuery:sql];
            NSMutableArray *chatGroupDic = [NSMutableArray array];
            while ([rs next]) {
                NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
                
                if ([rs stringForColumn:@"USER_NICK_NAME"]) {
                    [dic setObject:[rs stringForColumn:@"USER_NICK_NAME"] forKey:@"USER_NICK_NAME"];
                }else
                {
                    [dic setObject:@"system" forKey:@"USER_NICK_NAME"];
                }
                [dic setObject:[rs stringForColumn:@"ID"] forKey:@"ID"];
                [dic setObject:[rs stringForColumn:@"CHAT_GROUP_ID"] forKey:@"CHAT_GROUP_ID"];
                [dic setObject:[rs stringForColumn:@"CHAT_CONTENT"] forKey:@"CHAT_CONTENT"];
                [dic setObject:[rs stringForColumn:@"CHAT_SMALLPIC"] forKey:@"CHAT_SMALLPIC"];
                [dic setObject:[rs stringForColumn:@"FILE_PATH"] forKey:@"FILE_PATH"];
                [dic setObject:[rs stringForColumn:@"CREATE_DATE"] forKey:@"CREATE_DATE"];
                [dic setObject:[rs stringForColumn:@"USER_PRINCIPAL_NAME"] forKey:@"USER_PRINCIPAL_NAME"];
                //
                [chatGroupDic addObject:dic];
            }
            [rs close];
            if (chatGroupDic) {
                return chatGroupDic;
            }else
            {
                return nil;
            }
            
        }else
        {
            return  nil;
        }
    }
    @catch (NSException *exception) {
        [[CommUtilHelper sharedInstance] setErrorMsg:[@"getCHatGroupSessionbySessionId:" stringByAppendingString:[exception description]]];
        NSLog(@"getCHatGroupSessionByminPage error:%@",exception);
        return nil;
    }
    @finally {
    }

}

-(NSInteger)insertNativeMsg:(NSMutableArray *)sessionArr
{
    @try {
        //n表示本地信息  s表示从服务器的信息
        if ([dataBase open]) {
            [dataBase beginTransaction];
        }
        NSInteger revalue = 0;
        for (int i=0; i<[sessionArr count]; i++) {
            NSDictionary *temp=[sessionArr objectAtIndex:i];
            //NSString *GroupSessionId = [temp objectForKey:@"GROUP_SESSION_ID"];
            NSString *chatGroupId = [temp objectForKey:@"CHAT_GROUP_ID"];
            NSString *chatContent = [temp objectForKey:@"CHAT_CONTENT"];
            NSString *createDate = [temp objectForKey:@"CREATE_DATE"];
            NSString *userPrincipalName = [temp objectForKey:@"USER_PRINCIPAL_NAME"];
            //NSString *userNickName = [temp objectForKey:@"USER_NICK_NAME"];
            NSString *filePath = [temp objectForKey:@"FILE_PATH"];
            NSString *chatSmallPic = [temp objectForKey:@"CHAT_SMALLPIC"];
            //NSString *sessionId = [temp objectForKey:@"SESSION_ID"];
            //NSString *delFlag = [temp objectForKey:@"DEL_FLAG"];
            //NSString *reSysDttm = [temp objectForKey:@"RES_SYSDTTM"];
            NSString *sql=[NSString stringWithFormat:@"insert into %@ (ID  , CHAT_GROUP_ID ,USER_PRINCIPAL_NAME , CHAT_CONTENT ,CREATE_DATE ,DEL_FLAG ,FILE_PATH ,CHAT_SMALLPIC ) values (?,?,?,?,?,?,?,?)",CHAT_GROUP_SESSION];
            if ([dataBase open]) {
                [dataBase executeUpdate:sql withArgumentsInArray:[NSArray arrayWithObjects:[NSNull null],chatGroupId,userPrincipalName,chatContent,createDate,@"0",filePath,chatSmallPic, nil]];
                NSString *maxSql =[NSString stringWithFormat:@"select max(id) from %@",CHAT_GROUP_SESSION] ;
                FMResultSet *rs = [dataBase executeQuery:maxSql];
                while ([rs next]) {
                    id obj= [rs objectForColumnIndex:0];
                    if (obj) {
                        revalue = [obj integerValue];
                    }
                }
            }
            if ([dataBase hadError]) {
                NSLog(@"Err insertEscore %d: %@", [dataBase lastErrorCode], [dataBase lastErrorMessage]);
                return 0;
            }
        }
        [dataBase commit];
        return revalue;
    }
    @catch (NSException *exception) {
        [dataBase rollback];
         [[CommUtilHelper sharedInstance] setErrorMsg:[@"insertNativeMsg error:" stringByAppendingString:[exception description]]];
        NSLog(@"insertNativeMsg error:%@",exception);
        return  0;
    }
    @finally {
    }
}

-(int)getMaxSessionId:(NSString *)groupId
{
    int revalue = 0;
    NSString *maxSql =[NSString stringWithFormat:@"select max(id) from %@ Where ifnull(sub_type,'')!='WELCOME' And chat_group_id=%@",CHAT_GROUP_SESSION,groupId] ;
    FMResultSet *rs = [dataBase executeQuery:maxSql];
    while ([rs next]) {
        id obj= [rs objectForColumnIndex:0];
        if (obj) {
            if ([obj isKindOfClass:[NSNull class]]) {
                revalue=0;
            }else
            {
            revalue = (int)[obj integerValue];
            }
        }
    }
    return revalue;
}

-(BOOL)checkIsExistSession:(NSString *)groupSessionId ChatGroupId:(NSString *)chatGroupId
{
    BOOL reCheck = NO;
    NSString *sql =[NSString stringWithFormat:@"select count(*) from %@ where chat_group_id =%@ and GROUP_SESSION_ID=%@",CHAT_GROUP_SESSION,chatGroupId,groupSessionId];
    if ([dataBase open]) {
        @try {
            FMResultSet *rs = [dataBase executeQuery:sql];
            while ([rs  next]) {
                if ([rs intForColumnIndex:0]>0) {
                    reCheck=YES;
                }
            }
            
        }
        @catch (NSException *exception) {
            NSLog(@"isExistSessionId error:%@",exception);
            reCheck=NO;
        }
        @finally {
        }
    }
    return reCheck;
}

//
-(BOOL)checkIsExistSID:(NSString *)groupSessionId ChatGroupId:(NSString *)chatGroupId
{
    BOOL reCheck = NO;
    NSString *sql =[NSString stringWithFormat:@"select count(*) from %@ where chat_group_id =%@ and ID=%@",CHAT_GROUP_SESSION,chatGroupId,groupSessionId];
    if ([dataBase open]) {
        @try {
            FMResultSet *rs = [dataBase executeQuery:sql];
            while ([rs  next]) {
                if ([rs intForColumnIndex:0]>0) {
                    reCheck=YES;
                }
            }
            
        }
        @catch (NSException *exception) {
            NSLog(@"isExistSessionId error:%@",exception);
            reCheck=NO;
        }
        @finally {
        }
    }
    return reCheck;
}

-(BOOL)insertHisMsgFromServer:(NSMutableArray *)sessionArr
{
    @try {
        //n表示本地信息  s表示从服务器的信息
        if ([dataBase open]) {
            [dataBase beginTransaction];
        }
        for (int i=0; i<[sessionArr count]; i++) {
            NSMutableDictionary *temp=[sessionArr objectAtIndex:i];
            NSString *GroupSessionId = [temp objectForKey:@"SESSION_ID"];
            NSString *chatGroupId = [temp objectForKey:@"GROUPID"];
             NSString *msgType = [temp objectForKey:@"MSG_TYPE"];
            //如果存在本条数据
            if ([self checkIsExistSession:GroupSessionId ChatGroupId:chatGroupId]) {
                continue;
            }
            
            
            NSString *chatContent = [temp objectForKey:@"MSG"];
            NSString *createDate = [FormatTime dateToStr:[NSDate date]];
            NSString *userPrincipalName = [temp objectForKey:@"USER_PRINCIPAL_NAME"];
            NSString *filePath = [temp objectForKey:@"FILE_PATH"];
            NSString *chatSmallPic = [temp objectForKey:@"THUMBNAILFILENAME"];
            
            
            
   
            
            if ([@"TEXT" isEqualToString:msgType]) {
                filePath =@"";
                chatSmallPic = @"";
            }
            if (filePath == nil || chatSmallPic == nil) {
                filePath =@"";
                chatSmallPic = @"";
            }
            if ([@"IMAGE" isEqualToString:msgType]) {
                NSString *filePath = [[CommUtilHelper sharedInstance] dataImagePath:chatSmallPic];
                if(![[NSFileManager defaultManager] fileExistsAtPath:filePath]){
                    [CharViewNetServiceUtil asynDownLoadImg:[NSString stringWithFormat:@"%@/fileTransfer/download?fileName=%@",charUrl,chatSmallPic] targetFilePath:filePath ];
                }
            }

            
            
            NSString *sessionId = [temp objectForKey:@"SID"];
            NSString *reSysDttm = [temp objectForKey:@"SERVER_TIME"];
            NSString *sql=[NSString stringWithFormat:@"insert into %@ (ID  , CHAT_GROUP_ID ,USER_PRINCIPAL_NAME , CHAT_CONTENT ,CREATE_DATE ,DEL_FLAG ,FILE_PATH ,CHAT_SMALLPIC,GROUP_SESSION_ID ,LAST_SYNC_TIME,SESSION_ID) values (?,?,?,?,?,?,?,?,?,?,?)",CHAT_GROUP_SESSION];
            
            if ([dataBase open]) {
                
                [dataBase executeUpdate:sql withArgumentsInArray:[NSArray arrayWithObjects:[NSNull null],chatGroupId,userPrincipalName,chatContent,createDate,@"0",filePath,chatSmallPic,GroupSessionId,reSysDttm,sessionId, nil]];
           
            }
            
            if ([dataBase hadError]) {
                NSLog(@"Err insertEscore %d: %@", [dataBase lastErrorCode], [dataBase lastErrorMessage]);
                
            }
        }
        [dataBase commit];
    }
    @catch (NSException *exception) {
        [dataBase rollback];
        [[CommUtilHelper sharedInstance] setErrorMsg:[@"insertMsgFromServer error:" stringByAppendingString:[exception description]]];
        NSLog(@"insertMsgFromServer error:%@",exception);
        return NO;
    }
    @finally {
        
    }
    return YES;

}

-(BOOL)insertMsgFromServer:(NSMutableArray *)sessionArr
{
    @try {
        //n表示本地信息  s表示从服务器的信息
        if ([dataBase open]) {
            [dataBase beginTransaction];
        }
        for (int i=0; i<[sessionArr count]; i++) {
            NSMutableDictionary *temp=[sessionArr objectAtIndex:i];
            NSString *GroupSessionId = [temp objectForKey:@"GROUP_SESSION_ID"];
            NSString *chatGroupId = [temp objectForKey:@"CHAT_GROUP_ID"];
            //如果存在本条数据
            if ([self checkIsExistSession:GroupSessionId ChatGroupId:chatGroupId]) {
                continue;
            }
            
            
            NSString *chatContent = [temp objectForKey:@"CHAT_CONTENT"];
            NSString *createDate = [FormatTime dateToStr:[NSDate date]];
            NSString *userPrincipalName = [temp objectForKey:@"USER_PRINCIPAL_NAME"];
            NSString *filePath = [temp objectForKey:@"FILE_PATH"];
            NSString *chatSmallPic = [temp objectForKey:@"CHAT_SMALLPIC"];
            NSString *sessionId = [temp objectForKey:@"SESSION_ID"];
            NSString *reSysDttm = [temp objectForKey:@"RES_SYSDTTM"];
            //
            NSString *type = [temp objectForKey:@"TYPE"];
            NSString *subType = [temp objectForKey:@"SUB_TYPE"];
            NSString *detailDesc = [temp objectForKey:@"DETAIL_DESC"];
            NSString *thumbnailFileName = [temp objectForKey:@"THUMBNAIL_FILE_NAME"];
            NSString *originFileName = [temp objectForKey:@"ORIGIN_FILE_NAME"];
            NSString *fileType = [temp objectForKey:@"FILE_TYPE"];
            NSString *fileSize = [temp objectForKey:@"FILE_SIZE"];
            NSString *fileDuration = [temp objectForKey:@"FILE_DURATION"];
            //
            NSString *sql=[NSString stringWithFormat:@"insert into %@ (ID, CHAT_GROUP_ID ,USER_PRINCIPAL_NAME, CHAT_CONTENT ,CREATE_DATE ,DEL_FLAG ,FILE_PATH ,CHAT_SMALLPIC,GROUP_SESSION_ID ,LAST_SYNC_TIME,SESSION_ID,TYPE,SUB_TYPE,DETAIL_DESC,THUMBNAIL_FILE_NAME,ORIGIN_FILE_NAME,FILE_TYPE,FILE_SIZE,FILE_DURATION) values (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)",CHAT_GROUP_SESSION];
            
            if ([dataBase open]) {
                
                [dataBase executeUpdate:sql withArgumentsInArray:[NSArray arrayWithObjects:[NSNull null],chatGroupId,userPrincipalName,chatContent,createDate,@"0",filePath,chatSmallPic,GroupSessionId,reSysDttm,sessionId,type,subType,detailDesc,thumbnailFileName,originFileName,fileType,fileSize,fileDuration, nil]];
                [self updateChatGroup:chatContent From:userPrincipalName ResysDttm:reSysDttm GroupId:chatGroupId];
                [[CommUtilHelper sharedInstance] setValueDefaults:reSysDttm key:CHAT_GROUP_SESSION];
            }
            
            if ([dataBase hadError]) {
                NSLog(@"Err insertEscore %d: %@", [dataBase lastErrorCode], [dataBase lastErrorMessage]);
                
            }
        }
        [dataBase commit];
    }
    @catch (NSException *exception) {
        [dataBase rollback];
        [[CommUtilHelper sharedInstance] setErrorMsg:[@"insertMsgFromServer error:" stringByAppendingString:[exception description]]];
        NSLog(@"insertMsgFromServer error:%@",exception);
        return NO;
    }
    @finally {
        
    }
    return YES;
}
/*
 *
*/
-(BOOL)updateGroupSession:(NSDictionary *)dic
{
    @try {
        if (dic) {
             NSString *ID = [dic objectForKey:@"ID"];
            NSString *sessionId = [dic objectForKey:@"SESSION_ID"];
            NSString *GroupSessionId = [dic objectForKey:@"GROUP_SESSION_ID"];
            NSString *reSysDttm = [dic objectForKey:@"RES_SYSDTTM"];
            NSString *groupID = [dic objectForKey:@"CHAT_GROUP_ID"];
            NSString *from = [dic objectForKey:@"USER_PRINCIPAL_NAME"];
            NSString *msg = [dic objectForKey:@"CHAT_CONTENT"];
            NSString *sql = @"update %@ set GROUP_SESSION_ID=?,SESSION_ID=?,LAST_SYNC_TIME=? WHERE CHAT_GROUP_ID=? AND ID=?";
            NSString *updateSql = [NSString stringWithFormat:sql,CHAT_GROUP_SESSION];
            if ([dataBase open]) {
                [dataBase beginTransaction];
                if([dataBase executeUpdate:updateSql withArgumentsInArray:[NSArray arrayWithObjects:GroupSessionId,sessionId,reSysDttm,groupID,ID, nil]])
                    [[CommUtilHelper sharedInstance] setValueDefaults:reSysDttm key:CHAT_GROUP];
                [self updateChatGroup:msg From:from ResysDttm:reSysDttm GroupId:groupID];
                [[CommUtilHelper sharedInstance] setValueDefaults:reSysDttm key:CHAT_GROUP_SESSION];
                [dataBase commit];
            }
            return  YES;
        }else
        {
            return NO;
        }
    }
    @catch (NSException *exception) {
        [[CommUtilHelper sharedInstance] setErrorMsg:[@"updateGroupSession error:" stringByAppendingString:[exception description]]];
        NSLog(@"updateGroupSession error:%@",exception);
        return NO;
    }
    @finally {
    }
}
//
-(BOOL)updateChatGroup:(NSString *)msg From:(NSString *)from ResysDttm:(NSString *)reSysDttm GroupId:(NSString *)groupID
{
    @try {
        NSString *groupSql = @"update %@ set del_flag=0, LAST_UPDATE_SESSION=?,LAST_SESSION_PERSON=?,LAST_SESSION_DATE=? WHERE CHAT_GROUP_ID=?";
        NSString *updateGroupSql = [NSString stringWithFormat:groupSql,CHAT_GROUP];
        BOOL check = [dataBase executeUpdate:updateGroupSql withArgumentsInArray:[NSArray arrayWithObjects:msg,from,reSysDttm,groupID, nil]];
        
        if (check) {
            [[CommUtilHelper sharedInstance] setValueDefaults:reSysDttm key:CHAT_GROUP];
            return YES;
        }else
        {
            return NO;
        }
    }
    @catch (NSException *exception) {
        
        NSLog(@"updateChatGroup error:%@",exception);
        return NO;
    }
    @finally {
    }
}

/*
 *获取通讯录信息
 */
-(NSMutableArray *)getNatvieContact:(NSString *)user
{
    @try {
        NSString *sql =[NSString stringWithFormat:@"SELECT a.*,b.TITLE,b.HEAD_PHOTO,b.COMMON_NAME,b.LOGIN_STATUS FROM %@ as a left join %@ as b on a.FREQUENT_CONTANCT_USER=b.USER_principal_NAME  WHERE  a.USER_principal_NAME=? order by b.common_name ",CHAT_USERS,CHAT_AD_USER];
        NSMutableArray *contactArr=[NSMutableArray array];
        if ([dataBase open]) {
            FMResultSet *rs = [dataBase executeQuery:sql withArgumentsInArray:[NSArray arrayWithObjects:user, nil]];
            while ([rs next]) {
                NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                
                NSString *userNickName =[rs stringForColumn:@"USER_NICK_NAME"];
                if (userNickName == nil || [@"" isEqualToString:userNickName]) {
                    [dic setObject:@"null" forKey:@"NickName"];
                }else
                {
                 
                    [dic setObject:[rs stringForColumn:@"USER_NICK_NAME"] forKey:@"NickName"];
                }
                
                NSString *COMMON_NAME =[rs stringForColumn:@"COMMON_NAME"];
                if (COMMON_NAME == nil || [@"" isEqualToString:COMMON_NAME]) {
                    [dic setObject:@"null" forKey:@"COMMON_NAME"];
                }else
                {
                    
                    [dic setObject:[rs stringForColumn:@"COMMON_NAME"] forKey:@"COMMON_NAME"];
                }
                
                //[dic setObject:[rs stringForColumn:@"COMMON_NAME"] forKey:@"COMMON_NAME"];
                
                if ([rs stringForColumn:@"HEAD_PHOTO"]) {
                    [dic setObject:[rs stringForColumn:@"HEAD_PHOTO"] forKey:@"HeadPhoto"];
                }else
                {
                    [dic setObject:@"" forKey:@"HeadPhoto"];
                }
                
                NSString *loginStagus =[rs stringForColumn:@"LOGIN_STATUS"];
                if (loginStagus == nil || [@"" isEqualToString:loginStagus]) {
                    [dic setObject:@"N" forKey:@"LOGIN_STATUS"];
                }else
                {
                   
                    [dic setObject:[rs stringForColumn:@"LOGIN_STATUS"] forKey:@"LOGIN_STATUS"];
                }
                
               
                NSString *TITLE =[rs stringForColumn:@"TITLE"];
                if (TITLE == nil || [@"" isEqualToString:TITLE]) {
                    [dic setObject:@"null" forKey:@"LOGIN_STATUS"];
                }else
                {
                    
                   [dic setObject:[rs stringForColumn:@"TITLE"] forKey:@"TITLE"];
                }

                
                NSString *FREQUENT_CONTANCT_USER =[rs stringForColumn:@"FREQUENT_CONTANCT_USER"];
                if (FREQUENT_CONTANCT_USER == nil || [@"" isEqualToString:FREQUENT_CONTANCT_USER]) {
                    [dic setObject:@"null" forKey:@"LOGIN_STATUS"];
                }else
                {
                    
                    [dic setObject:[rs stringForColumn:@"FREQUENT_CONTANCT_USER"] forKey:@"USER"];

                }

                
                                [contactArr addObject:dic];
            }
        }
        return contactArr;
    }
    @catch (NSException *exception) {
        [[CommUtilHelper sharedInstance] setErrorMsg:[@"getNatvieContact error:" stringByAppendingString:[exception description]]];
        
        return nil;
    }
    @finally {
    }
}
-(NSMutableArray *)getAddChatGroupMember:(NSString *)user
{
    @try {
        NSString *sql =[NSString stringWithFormat:@"SELECT  a.*,b.TITLE,b.HEAD_PHOTO,b.COMMON_NAME,b.LOGIN_STATUS FROM %@ as a inner join %@ as b on a.FREQUENT_CONTANCT_USER=b.USER_principal_NAME  WHERE b.LOGIN_STATUS='Y' and a.USER_principal_NAME=? and a.del_flag=0 order by b.common_name ",CHAT_USERS,CHAT_AD_USER];
        NSMutableArray *contactArr=[NSMutableArray array];
        NSString *tempContactUser = @"";
        if ([dataBase open]) {
            FMResultSet *rs = [dataBase executeQuery:sql withArgumentsInArray:[NSArray arrayWithObjects:user, nil]];
            while ([rs next]) {
                NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                NSString *freContactUser = [rs stringForColumn:@"FREQUENT_CONTANCT_USER"];
                if (![tempContactUser isEqualToString:freContactUser]) {
                    [dic setObject:[rs stringForColumn:@"USER_NICK_NAME"] forKey:@"NickName"];
                    [dic setObject:[rs stringForColumn:@"COMMON_NAME"] forKey:@"COMMON_NAME"];
                    if ([rs stringForColumn:@"HEAD_PHOTO"]) {
                        [dic setObject:[rs stringForColumn:@"HEAD_PHOTO"] forKey:@"HeadPhoto"];
                    }else
                    {
                        [dic setObject:@"" forKey:@"HeadPhoto"];
                    }
                    
                    [dic setObject:[rs stringForColumn:@"TITLE"] forKey:@"TITLE"];
                    [dic setObject:[rs stringForColumn:@"FREQUENT_CONTANCT_USER"] forKey:@"USER"];
                    [contactArr addObject:dic];
                    tempContactUser = freContactUser;
                }
                
                
            }
        }
        return contactArr;
    }
    @catch (NSException *exception) {
        [[CommUtilHelper sharedInstance] setErrorMsg:[@"getAddChatGroupMember error:" stringByAppendingString:[exception description]]];
   
        return nil;
    }
    @finally {
    }
}

//是否存在用户记录
-(BOOL)isExistUserRecord:(NSString *)sql;
{
    @try {
        BOOL check=false;
        if ([dataBase open]) {
            FMResultSet *rs = [dataBase executeQuery:sql];
            if ([rs next]) {
                int count = [rs intForColumnIndex:0];
                if (count >0) {
                    
                    check=true;
                }else
                {
                    check=false;
                }
            }
            [rs close];
            //[dataBase close];
        }
        return  check;
    }
    @catch (NSException *exception) {
        NSLog(@"isExistUserRecord error:%@",exception);
        return NO;
    }
    @finally {
    }
}
//添加好友
-(BOOL)insertChatUser:(NSMutableArray *)userArr
{
    @try {
        for (int i=0; i<[userArr count]; i++) {
            NSDictionary *temp = [userArr objectAtIndex:i];
            NSString *principalName = [temp objectForKey:@"USER_PRINCIPAL_NAME"];
            NSString *contactUser = [temp objectForKey:@"FREQUENT_CONTACT_USER"];
            BOOL check =  [self isExistUserRecord:[NSString stringWithFormat:@"select count(*) from %@ where FREQUENT_CONTANCT_USER='%@'",CHAT_USERS,contactUser]];
            if (check) {
                continue;
            }
            NSString *createDate = [FormatTime dateToStr:[NSDate date]];
            NSString *delFlag = @"0";
            
            NSString *nickName = [temp objectForKey:@"USER_NICK_NAME"];
            NSString *displayName = [temp objectForKey:@"USER_DISPLAY_NAME"];
            NSString *sysDttm = [temp objectForKey:@"LAST_SYNC_TIME"];
            
            NSString *sql=[NSString stringWithFormat:@"insert into %@ (Id ,USER_PRINCIPAL_NAME , FREQUENT_CONTANCT_USER  , CREATE_DATE , DEL_FLAG , USER_NICK_NAME ,USER_DISPLAY_NAME ,LAST_SYNC_TIME) values (?,?,?,?,?,?,?,?)  ",CHAT_USERS];
            //[dataBase executeUpdate:sql,[NSNull null],principalName,contactUser,createDate,[delFlag intValue],nickName,displayName,sysDttm];
            if ([dataBase open]) {
                if([dataBase executeUpdate:sql withArgumentsInArray:[NSArray arrayWithObjects:[NSNull null],principalName,contactUser,createDate,delFlag,nickName,displayName,sysDttm, nil]])
                    [[CommUtilHelper sharedInstance] setValueDefaults:sysDttm key:CHAT_USERS];
            }
            
        }
        return YES;
    }
    @catch (NSException *exception) {
         [[CommUtilHelper sharedInstance] setErrorMsg:[@"insertChatUser error:" stringByAppendingString:[exception description]]];
        NSLog(@"insertChatUser error:%@",exception);
        return NO;
    }
    @finally {
    }

}
//添加ad user
-(BOOL)insertChatAdUser:(NSMutableArray *)userArr
{
    @try {
        for (int i=0; i<[userArr count]; i++) {
            NSDictionary *temp = [userArr objectAtIndex:i];
            NSString *principalName = [temp objectForKey:@"USER_PRINCIPAL_NAME"];
            BOOL check =  [self isExistUserRecord:[NSString stringWithFormat:@"select count(*) from %@ where USER_PRINCIPAL_NAME='%@'",CHAT_AD_USER,principalName]];
            
            NSString *contactUser = [temp objectForKey:@"USER_NICK_NAME"];
            NSString *commName = [temp objectForKey:@"COMMON_NAME"];
            NSString *EMPLOYEE_NUMBER = [temp objectForKey:@"EMPLOYEE_NUMBER"];
            NSString *TITLE = [temp objectForKey:@"TITLE"];
            NSString *LOCATION = [temp objectForKey:@"LOCATION"];
            NSString *DISABLED = [temp objectForKey:@"DISABLED"];
            NSString *EMAIL = [temp objectForKey:@"EMAIL"];
            NSString *PHONE_NUMBER = [temp objectForKey:@"PHONE_NUMBER"];
            NSString *LOGIN_STATUS = [temp objectForKey:@"LOGIN_STATUS"];
            NSString *image =  [self changeNullToStr:[temp objectForKey:@"HEAD_PHOTO"]];
            NSString *image2 = [self changeNullToStr:[temp objectForKey:@"HEAD_PHOTO2"]];
            NSString *image3 = [self changeNullToStr:[temp objectForKey:@"HEAD_PHOTO3"]];
            NSString *image4 = [self changeNullToStr:[temp objectForKey:@"HEAD_PHOTO4"]];
            NSString *image5 = [self changeNullToStr:[temp objectForKey:@"HEAD_PHOTO5"]];
            NSString *commbineImage = [NSString stringWithFormat:@"%@%@%@%@%@",image,image2,image3,image4,image5];
            NSString *HEAD_PHOTO = [[CommUtilHelper sharedInstance] saveImageToPath:commbineImage];
            NSString *HEAD_BIG_PHOTO = [temp objectForKey:@"HEAD_BIG_PHOTO"];
            NSString *sysDttm = [temp objectForKey:@"LAST_SYNC_TIME"];
            NSString *sql=[NSString stringWithFormat:@"insert into %@ (Id ,USER_PRINCIPAL_NAME,  SAM_ACCOUNT_NAME, EMPLOYEE_NUMBER , DISABLED , TITLE ,LOCATION ,EMAIL ,PHONE_NUMBER ,HEAD_PHOTO ,HEAD_BIG_PHOTO ,LAST_SYNC_TIME,COMMON_NAME,LOGIN_STATUS  ) values (?,?,?,?,?,?,?,?,?,?,?,?,?,?)  ",CHAT_AD_USER];
            
            if (check) {
                if ([dataBase open]) {
                    sql =[NSString stringWithFormat:@"UPDATE %@ SET TITLE='%@' ,LOCATION='%@' ,EMAIL='%@' ,PHONE_NUMBER='%@' ,HEAD_PHOTO='%@' ,HEAD_BIG_PHOTO='%@' ,LAST_SYNC_TIME='%@',COMMON_NAME='%@',LOGIN_STATUS='%@' WHERE USER_PRINCIPAL_NAME='%@'"  ,CHAT_AD_USER,TITLE,LOCATION,EMAIL,PHONE_NUMBER,HEAD_PHOTO,HEAD_BIG_PHOTO,sysDttm,commName,LOGIN_STATUS,principalName];
                    [dataBase executeUpdate:sql];
                }
                    continue;
            }
            //[dataBase executeUpdate:sql,[NSNull null],principalName,contactUser,EMPLOYEE_NUMBER,DISABLED,TITLE,LOCATION,EMAIL,PHONE_NUMBER,HEAD_PHOTO,HEAD_BIG_PHOTO,sysDttm];
            if ([dataBase open]) {
                if([dataBase executeUpdate:sql withArgumentsInArray:[NSArray arrayWithObjects:[NSNull null],principalName,contactUser,EMPLOYEE_NUMBER,DISABLED,TITLE,LOCATION,EMAIL,PHONE_NUMBER,HEAD_PHOTO,HEAD_BIG_PHOTO,sysDttm,commName,LOGIN_STATUS, nil]])
                    [[CommUtilHelper sharedInstance] setValueDefaults:sysDttm key:CHAT_AD_USER];
            }
        }
        return YES;
    }
    @catch (NSException *exception) {
        [[CommUtilHelper sharedInstance] setErrorMsg:[@"insertChatAdUser error:" stringByAppendingString:[exception description]]];
        NSLog(@"insertChatAdUser error:%@",exception);
        return NO;
    }
    @finally {
    }
}

-(BOOL)deleteChatUser:(NSString *)user
{
    @try {
        NSString *sql = [NSString stringWithFormat:@"delete from %@ where frequent_contanct_user = '%@'",CHAT_USERS,user];
        if ([dataBase open]) {
            [dataBase executeUpdate:sql];
            return YES;
        }
        return NO;
    }
    @catch (NSException *exception) {
        NSLog(@"deleteChatUser error:%@",exception);
        return NO;
    }
    @finally {
    }
}
// 获取组内所有成员
-(NSMutableArray *)getAllGroupUserByGroupId:(NSString *)groupId CurrUser:(NSString *)curruser
{
    @try {
        NSString *sql = [NSString stringWithFormat:@"SELECT a.*,b.HEAD_PHOTO,(select create_person from %@ where chat_group_id=a.chat_group_id) as cretePerson FROM %@ as a left join %@ as b on a.USER_principal_NAME=b.USER_principal_NAME WHERE a.CHAT_GROUP_ID=%@  and a.del_flag = 0  order by a.USER_NICK_NAME",CHAT_GROUP,CHAT_GROUP_PERSON,CHAT_AD_USER,groupId];
        NSMutableArray *arr = [NSMutableArray array];
        NSString *tempUser=@"";
        if ([dataBase open]){
            FMResultSet *rs=[dataBase executeQuery:sql];
            while([rs  next]){
                NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                NSString *user =[rs stringForColumn:@"USER_PRINCIPAL_NAME"];
                if (![tempUser isEqualToString:user]) {
                    [dic setObject:[rs stringForColumn:@"USER_PRINCIPAL_NAME"] forKey:@"USER"];
                    [dic setObject:[rs stringForColumn:@"USER_NICK_NAME"] forKey:@"NickName"];
                    if ([rs stringForColumn:@"HEAD_PHOTO"]) {
                        [dic setObject:[rs stringForColumn:@"HEAD_PHOTO"] forKey:@"HeadPhoto"];
                    }else
                    {
                        [dic setObject:@"" forKey:@"HeadPhoto"];
                    }
                    [dic setObject:[rs stringForColumn:@"CRETEPERSON"] forKey:@"CretePerson"];
                    
//                    if ([curruser isEqualToString:[rs stringForColumn:@"USER_PRINCIPAL_NAME"]]) {
//                        [arr insertObject:dic atIndex:0];
//                    }else
//                    {
//                        [arr addObject:dic];
//                    }
                    [arr addObject:dic];
                    tempUser = user;
                }
            }
        }
        return arr;
    }
    @catch (NSException *exception) {
         [[CommUtilHelper sharedInstance] setErrorMsg:[@"getAllGroupUserByGroupId error:" stringByAppendingString:[exception description]]];
        NSLog(@"getAllGroupUserByGroupId error:%@",exception);
        return nil;
    }
    @finally {
    }
}

-(BOOL)deleteChatUserByGroupId:(NSString *)groupId User:(NSString *)user;
{
    @try {
        BOOL reCheck = NO;
        NSString *sql =[NSString stringWithFormat:@"delete from  %@   where chat_group_id=%@ and user_principal_name='%@'",CHAT_GROUP_PERSON,groupId,user];
        if ([dataBase open]) {
            @try {
                [dataBase executeUpdate:sql];
                reCheck = YES;
            }
            @catch (NSException *exception) {
                reCheck=NO;
            }
            @finally {
                
            }
            
        }
        return reCheck;
    }
    @catch (NSException *exception) {
        NSLog(@"deleteChatUserByGroupId error:%@",exception);
        return NO;
    }
    @finally {
    }

}
-(NSMutableArray *)getNotInGroupUserByGroupId:(NSString *)groupId User:(NSString *)user
{
    @try {
        NSString *sql = [NSString stringWithFormat:@"SELECT a.*,b.TITLE as TITLE,b.HEAD_PHOTO as HEADIMAGE,b.COMMON_NAME as COMMON_NAME FROM (select * from %@ where frequent_contanct_user not in (select user_principal_name from %@ where chat_group_id=%@ and del_flag=0) and del_flag=0) as a left join %@ as b on a.FREQUENT_CONTANCT_USER=b.USER_principal_NAME  where   b.login_status='Y'  order by b.common_name ",CHAT_USERS,CHAT_GROUP_PERSON,groupId,CHAT_AD_USER];
        NSMutableArray *arr = [NSMutableArray array];
        if ([dataBase open]) {
            FMResultSet *rs = [dataBase executeQuery:sql];
            while ([rs  next]) {
                NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                [dic setObject:[rs stringForColumn:@"COMMON_NAME"] forKey:@"COMMON_NAME"];
                [dic setObject:[rs stringForColumn:@"USER_NICK_NAME"] forKey:@"SAM_ACCOUNT_NAME"];
                if ([rs stringForColumn:@"HEADIMAGE"]) {
                    [dic setObject:[rs stringForColumn:@"HEADIMAGE"] forKey:@"HEAD_PHOTO"];
                }else
                {
                    [dic setObject:@"" forKey:@"HEAD_PHOTO"];
                }
                [dic setObject:[rs stringForColumn:@"TITLE"] forKey:@"TITLE"];
                [dic setObject:[rs stringForColumn:@"frequent_contanct_user"] forKey:@"USER_PRINCIPAL_NAME"];
                [arr addObject:dic];
            }
        }
        return arr;
    }
    @catch (NSException *exception) {
        [[CommUtilHelper sharedInstance] setErrorMsg:[@"getNotInGroupUserByGroupId error:" stringByAppendingString:[exception description]]];
        NSLog(@"getNotInGroupUserByGroupId error:%@",exception);
        return nil;
    }
    @finally {
    }
}

-(BOOL)insertGroupPerson:(NSMutableArray *)userArr
{
    @try {
       
        
        for (int i=0; i<[userArr count]; i++) {
            NSDictionary *temp = [userArr objectAtIndex:i];
            NSString *principalName = [temp objectForKey:@"USER_PRINCIPAL_NAME"];
            NSString *nickName = [temp objectForKey:@"USER_NICK_NAME"];
            NSString *chatGrupId = [temp objectForKey:@"CHAT_GROUP_ID"];
             //更新所有标志
            if (i==0) {
                NSString *eupdateSql = [NSString stringWithFormat:@"Upldate %@ Set Del_Flag=1 Where CHAT_GROUP_ID=%@ ",CHAT_GROUP_PERSON,chatGrupId];
                if ([dataBase open]) {
                [dataBase executeUpdate:eupdateSql];
                }
            }
            NSString *lastUpdBy = [temp objectForKey:@"LAST_UPDATEBY"];
            NSString *lastUpdDttm = [temp objectForKey:@"LAST_UPDATEDTTM"];
            NSString *syncTime = [temp objectForKey:@"LAST_SYNC_TIME"];
            BOOL check =  [self isExistUserRecord:[NSString stringWithFormat:@"select count(*) from %@ where CHAT_GROUP_ID=%@ and USER_PRINCIPAL_NAME='%@'",CHAT_GROUP_PERSON,chatGrupId,principalName]];
            if (check) {
                
                NSString *eupdateSql = [NSString stringWithFormat:@"Upldate %@ Set Del_Flag=0 Where CHAT_GROUP_ID=%@ and USER_PRINCIPAL_NAME='%@'",CHAT_GROUP_PERSON,chatGrupId,principalName];
                if ([dataBase open]) {
                [dataBase executeUpdate:eupdateSql];
                }
                //[dataBase executeUpdate:updateSql,CHAT_GROUP_PERSON,chatGrupId,principalName];
               
            }else{
                NSString *createdate = [FormatTime dateToStr:[NSDate date]];
                NSString *groupPersonID = [temp objectForKey:@"GROUP_PERSON_ID"];
                NSString *sql = [NSString stringWithFormat: @"insert into %@ (ID,CHAT_GROUP_ID,USER_PRINCIPAL_NAME,USER_NICK_NAME,CREATE_DATE,DEL_FLAG,LAST_UPDATEBY,LAST_UPDATEDTTM,LAST_SYNC_TIME,GROUP_PERSON_ID) VALUES (?,?,?,?,?,?,?,?,?,?)",CHAT_GROUP_PERSON];
                //[dataBase executeUpdate:sql,[NSNull null],principalName,contactUser,EMPLOYEE_NUMBER,DISABLED,TITLE,LOCATION,EMAIL,PHONE_NUMBER,HEAD_PHOTO,HEAD_BIG_PHOTO,sysDttm];
                if ([dataBase open]) {
                    if([dataBase executeUpdate:sql withArgumentsInArray:[NSArray arrayWithObjects:[NSNull null],chatGrupId, principalName,nickName,createdate,@"0",lastUpdBy,lastUpdDttm ,syncTime,groupPersonID, nil]])
                        [[CommUtilHelper sharedInstance] setValueDefaults:syncTime key:CHAT_GROUP_PERSON];
                }
            }
        }
        return YES;
    }
    @catch (NSException *exception) {
         [[CommUtilHelper sharedInstance] setErrorMsg:[@"insertGroupPerson error:" stringByAppendingString:[exception description]]];
        NSLog(@"insertGroupPerson error:%@",exception);
        return NO;
    }
    @finally {
    }

}

-(BOOL)insertChatGroup:(NSMutableArray *)listArr
{
    @try {
        
        for (int i=0; i<[listArr count]; i++) {
            NSDictionary *temp =[listArr objectAtIndex:i];
             NSString *ChatGroupId = [temp objectForKey:@"CHAT_GROUP_ID"];
            BOOL check =  [self isExistUserRecord:[NSString stringWithFormat:@"select count(*) from %@ where CHAT_GROUP_ID='%@'",CHAT_GROUP,ChatGroupId]];
            if (check) {
                continue;
            }

            NSString *sysDttm =[temp objectForKey:@"LAST_SYNC_TIME"];
            NSString *ChatGroupName = [temp objectForKey:@"CHAT_GROUP_NAME"];
            NSString *ChatGroupINfo = [temp objectForKey:@"CHAT_GROUP_INFO"];
            NSString *ChatGroupBarCode = [temp objectForKey:@"CHAT_GROUP_BARCODE"];
                
           
            NSString *createPerson = [temp objectForKey:@"CREATE_PERSON"];
            NSString *createDate = [FormatTime dateToStr:[NSDate date]];
            NSString *lastSessionPerson = [temp objectForKey:@"LAST_SESSION_PERSON"];
            NSString *isGroup = [temp objectForKey:@"IS_GROUP"];
           // NSString *chatGroupImg = [temp objectForKey:@"CHAT_GROUP_IMAGE"];
            NSString *lastupdPerson = [temp objectForKey:@"LASTUPD_PERSON"];
            NSString *lastUpdDate = [temp objectForKey:@"LASTUPD_DATE"];
            NSString *filePath = [temp objectForKey:@"FILE_PATH"];
            
            NSString *image = [self changeNullToStr:[temp objectForKey:@"CHAT_GROUP_IMAGE"]] ;
            NSString *image2 = [self changeNullToStr:[temp objectForKey:@"CHAT_GROUP_IMAGE2"]];
            NSString *image3 = [self changeNullToStr:[temp objectForKey:@"CHAT_GROUP_IMAGE3"]];
            NSString *image4 = [self changeNullToStr:[temp objectForKey:@"CHAT_GROUP_IMAGE4"]];
            NSString *image5 = [self changeNullToStr:[temp objectForKey:@"CHAT_GROUP_IMAGE5"]];
            NSString *commbineImage = [NSString stringWithFormat:@"%@%@%@%@%@",image,image2,image3,image4,image5];
            NSString *chatGroupImg = [[CommUtilHelper sharedInstance] saveImageToPath:commbineImage];
            
            NSString *lastSessionDate = [temp objectForKey:@"LAST_SESSION_DATE"];
            NSString *lastUpdateSession = [temp objectForKey:@"LAST_UPDATE_SESSION"];
            
            //
            NSString *type =[temp objectForKey:@"TYPE"]==nil?@"":[temp objectForKey:@"TYPE"];
            NSString *is_top =[temp objectForKey:@"IS_TOP"]==nil?@"":[temp objectForKey:@"IS_TOP"];
            NSString *source =[temp objectForKey:@"SOURCE"]==nil?@"":[temp objectForKey:@"SOURCE"];
            NSString *order_no =[temp objectForKey:@"ORDER_NO"]==nil?@"":[temp objectForKey:@"ORDER_NO"];
            NSString *status =[temp objectForKey:@"STATUS"]==nil?@"":[temp objectForKey:@"STATUS"];
            
            NSString *sql=[NSString stringWithFormat:@"insert into %@  (ID,CHAT_GROUP_ID,CHAT_GROUP_NAME,LAST_UPDATE_SESSION,CREATE_PERSON,DEL_FLAG,CREATE_DATE,LAST_SESSION_PERSON,LAST_SESSION_DATE,IS_GROUP,LASTUPD_PERSON,LASTUPD_DATE,CHAT_GROUP_INFO,CHAT_GROUP_BARCODE,CHAT_GROUP_IMAGE,FILE_PATH,LAST_SYNC_TIME,TYPE,IS_TOP,SOURCE,ORDER_NO,STATUS) values (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)",CHAT_GROUP];
                //[dataBase executeUpdate:sql,[NSNull null],ChatGroupId,ChatGroupName,lastUpdateSession,createPerson,[delFlag intValue],createDate,lastSessionPerson,lastSessionDate,isGroup,lastupdPerson,lastUpdDate,ChatGroupINfo,ChatGroupBarCode,chatGroupImg,filePath,sysDttm];
                NSArray *arr = [NSArray arrayWithObjects:[NSNull null],ChatGroupId,ChatGroupName,lastUpdateSession,createPerson,@"0" ,createDate,lastSessionPerson,lastSessionDate,isGroup,lastupdPerson,lastUpdDate,ChatGroupINfo,ChatGroupBarCode,chatGroupImg,filePath,sysDttm,type,is_top,source,order_no,status,nil];
                if ([dataBase open]) {
                   if( [dataBase executeUpdate:sql withArgumentsInArray:arr])
                    //更新同步时间
                    [[CommUtilHelper sharedInstance] setValueDefaults:sysDttm key:CHAT_GROUP];
                }
            
                if ([dataBase hadError]) {
                    NSLog(@"Err insertEscore %d: %@", [dataBase lastErrorCode], [dataBase lastErrorMessage]);
                    return NO;
                }
            
        }
        //[dataBase commit];
        return YES;
    }
    @catch (NSException *exception) {
        //[dataBase rollback];
         [[CommUtilHelper sharedInstance] setErrorMsg:[@"insertChatGroup error:" stringByAppendingString:[exception description]]];
        NSLog(@"insertChatGroup error:%@",exception);
        return NO;
    }
    @finally {
        // [dataBase close];
    }
    return NO;
}


-(BOOL)deleteChatGroup:(NSString *)groupId
{
    @try {
        BOOL isdelete = NO;
        NSString *sql = @"delete from %@ where chat_group_id=%@";
        if ([dataBase open]) {
            isdelete= [dataBase executeUpdate:[NSString stringWithFormat:sql,CHAT_GROUP,groupId]];
        }
        return  isdelete;
    }
    @catch (NSException *exception) {
        NSLog(@"deleteChatGroup error:%@",exception);
        return NO;
    }
    @finally {
    }
}

-(BOOL)deleteGroupSession:(NSString *)groupId
{
    @try {
        BOOL isdelete = NO;
        NSString *sql = @"delete from %@ where chat_group_id=%@";
        if ([dataBase open]) {
            isdelete= [dataBase executeUpdate:[NSString stringWithFormat:sql,CHAT_GROUP_SESSION,groupId]];
        }
        return  isdelete;
    }
    @catch (NSException *exception) {
        NSLog(@"deleteGroupSession error:%@",exception);
        return NO;
    }
    @finally {
    }
}
-(NSString *)isExistOneByOneChatByUser:(NSString *)user
{
    @try {
        NSString *chatGroupId = @"-1";
        NSString *sql = [NSString stringWithFormat:@"select chat_group_id from (select count(*) as count,chat_group_id from %@ where chat_group_id in (select a.chat_group_id from %@ as a ,%@ as b where a.user_principal_name =b.frequent_contanct_user and a.user_principal_name = %@ and a.del_flag=0)  group by chat_group_id) where count=2 ",CHAT_GROUP_PERSON,CHAT_GROUP_PERSON,CHAT_USERS,user];
        if ([dataBase open]) {
            FMResultSet *rs = [dataBase executeQuery:sql];
            while ([rs  next]) {
                if ([rs objectForColumnIndex:0]) {
                    chatGroupId = [NSString stringWithFormat:@"%i",[rs intForColumnIndex:0]] ;
                }
            }
            
        }
        return chatGroupId;
    }
    @catch (NSException *exception) {
        NSLog(@"isExistOneByOneChatByUser error:%@",exception);
        return nil;
    }
    @finally {
    }

}
//获取用户信息
-(NSMutableArray *)getUserInfo:(NSString *)user
{
    NSMutableArray *arr = [NSMutableArray array];
    NSString *sql = [NSString stringWithFormat:@"select * from %@  where user_principal_name='%@'",CHAT_AD_USER,user];
    @try {
        if ([dataBase open]) {
            FMResultSet *rs = [dataBase executeQuery:sql];
            while ([rs  next]) {
                NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                [dic setObject:[rs stringForColumn:@"USER_PRINCIPAL_NAME"] forKey:@"USER_PRINCIPAL_NAME"];
                [dic setObject:[rs stringForColumn:@"COMMON_NAME"] forKey:@"COMMON_NAME"];
                 [dic setObject:[rs stringForColumn:@"EMPLOYEE_NUMBER"] forKey:@"EMPLOYEE_NUMBER"];
                [dic setObject:[rs stringForColumn:@"SAM_ACCOUNT_NAME"] forKey:@"SAM_ACCOUNT_NAME"];
                [dic setObject:[rs stringForColumn:@"EMAIL"] forKey:@"EMAIL"];
                if ([rs stringForColumn:@"PHONE_NUMBER"]) {
                    [dic setObject:[rs stringForColumn:@"PHONE_NUMBER"] forKey:@"PHONE"];
                }else
                {
                [dic setObject:@"" forKey:@"PHONE"];
                }
                
                [dic setObject:[rs stringForColumn:@"LOCATION"] forKey:@"LOCATION"];
                [dic setObject:[rs stringForColumn:@"HEAD_PHOTO"] forKey:@"HEAD_PHOTO"];
                [dic setObject:[rs stringForColumn:@"TITLE"] forKey:@"TITLE"];
                if ([rs stringForColumn:@"LOGIN_STATUS"] == nil) {
                     [dic setObject:@"Y" forKey:@"LOGIN_STATUS"];
                }else
                {
                 [dic setObject:[rs stringForColumn:@"LOGIN_STATUS"]  forKey:@"LOGIN_STATUS"];
                }
               
                [arr addObject:dic];
            }
            
        }
        return arr;
    }
    @catch (NSException *exception) {
        NSLog(@"getUserInfo error:%@",exception);
        [[CommUtilHelper sharedInstance] setErrorMsg:[sql stringByAppendingString:[exception description]]];
        return nil;
    }
    @finally {
    }
}

-(void)updateChatGroupFlag:(NSString *)chatGroupId
{
    @try {
        NSString *sql = @"update %@ set del_flag = 1  where chat_group_id=%@";
        if ([dataBase open]) {
            [dataBase executeUpdate:[NSString stringWithFormat:sql,CHAT_GROUP,chatGroupId]];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"updateChatGroupFlag error:%@",exception);
    }
    @finally {
    }
}
//
-(void)updateChatGroupName:(NSString *)name GroupId:(NSString *)groupId
{
    @try {
        NSString *sql = @"update %@ set CHAT_GROUP_NAME = '%@'  where chat_group_id=%@";
        if ([dataBase open]) {
            [dataBase executeUpdate:[NSString stringWithFormat:sql,CHAT_GROUP,name,groupId]];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"updateChatGroupName error:%@",exception);
    }
    @finally {
    }
}

-(BOOL)deleteChatUserByGroupId:(NSString *)groupId
{
    @try {
        BOOL reCheck = NO;
        NSString *sql =[NSString stringWithFormat:@"delete  from  %@   where chat_group_id=%@ ",CHAT_GROUP_PERSON,groupId];
        if ([dataBase open]) {
            [dataBase executeUpdate:sql];
            reCheck = YES;
            return reCheck;
        }
    }
    @catch (NSException *exception) {
        NSLog(@"deleteChatUserByGroupId error:%@",exception);
        return NO;
    }
    @finally {
    }
}
-(BOOL)isFriend:(NSString *)user
{
    @try {
        BOOL reCheck = NO;
        NSString *sql =[NSString stringWithFormat:@"select count(*) from %@ where FREQUENT_CONTANCT_USER ='%@'",CHAT_USERS,user];
        if ([dataBase open]) {
            FMResultSet *rs = [dataBase executeQuery:sql];
            while ([rs  next]) {
                if ([rs intForColumnIndex:0]>0) {
                    reCheck=YES;
                }
            }
        }
        return reCheck;
        
    }
    @catch (NSException *exception) {
        NSLog(@"isFriend error:%@",exception);
        return NO;
    }
    @finally {
    }
    
}
//更新用户头像文件路径
-(BOOL)updateHeadPhoto:(NSString *)user ImagePath:(NSString *) imagePath
{
    @try {
        BOOL isUpdated = NO;
        NSString *sql = @"Update %@ Set HEAD_PHOTO='%@' where user_principal_name='%@'";
        if ([dataBase open]) {
            isUpdated= [dataBase executeUpdate:[NSString stringWithFormat:sql,CHAT_AD_USER,imagePath,user]];
        }
        return  isUpdated;
    }
    @catch (NSException *exception) {
         [[CommUtilHelper sharedInstance] setErrorMsg:[@"updateHeadPhoto error:" stringByAppendingString:[exception description]]];
        NSLog(@"updateHeadPhoto error:%@",exception);
        return NO;
    }
    @finally {
    }
}
//取得某一个组的信息
-(NSMutableArray *)getChatGroup:(NSString *) groupId
{
    NSString *sql = [NSString stringWithFormat:@"select * from %@ where CHAT_GROUP_ID='%@'", CHAT_GROUP,groupId];
    @try {
        
        if ([dataBase open]) {
            FMResultSet *rs = [dataBase executeQuery:sql];
            NSMutableArray *chatGroupDic = [NSMutableArray array];
            while ([rs next]) {
                NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
                [dic setObject:[rs stringForColumn:@"CHAT_GROUP_ID"] forKey:@"CHAT_GROUP_ID"];
                [dic setObject:[rs stringForColumn:@"CHAT_GROUP_NAME"] forKey:@"CHAT_GROUP_NAME"];
                [dic setObject:[rs stringForColumn:@"LAST_UPDATE_SESSION"] forKey:@"LAST_UPDATE_SESSION"];
                [dic setObject:[rs stringForColumn:@"LAST_SESSION_PERSON"] forKey:@"LAST_SESSION_PERSON"];
                [dic setObject:[rs stringForColumn:@"LAST_SESSION_DATE"] forKey:@"LAST_SESSION_DATE"];
                [dic setObject:[rs stringForColumn:@"IS_GROUP"] forKey:@"IS_GROUP"];
                [dic setObject:[rs stringForColumn:@"CHAT_GROUP_IMAGE"] forKey:@"HEAD_PHOTO"];
                [dic setObject:[self getValue:[rs stringForColumn:@"TYPE"]] forKey:@"TYPE"];
                [dic setObject:[self getValue:[rs stringForColumn:@"IS_TOP"]] forKey:@"IS_TOP"];
                [dic setObject:[self getValue:[rs stringForColumn:@"ORDER_NO"]] forKey:@"ORDER_NO"];
                [dic setObject:[self getValue:[rs stringForColumn:@"SOURCE"]] forKey:@"SOURCE"];
                [dic setObject:[self getValue:[rs stringForColumn:@"STATUS"]] forKey:@"STATUS"];
                [chatGroupDic addObject:dic];
            }
            [rs close];
            
            return chatGroupDic;
            
        }else
        {
            return nil;
        }
    }
    @catch (NSException *exception) {
        [[CommUtilHelper sharedInstance] setErrorMsg:[sql stringByAppendingString:[exception description]]];
        
        NSLog(@"getChatGroup error:%@",exception);
        return nil;
    }
    @finally {
    }
}
//更新群头像文件路径
-(BOOL)updateGroupHeadPhoto:(NSString *)groupId ImagePath:(NSString *) imagePath
{
    @try {
        BOOL isUpdated = NO;
        NSString *sql = @"Update %@ Set CHAT_GROUP_IMAGE='%@' where CHAT_GROUP_ID='%@'";
        if ([dataBase open]) {
            isUpdated= [dataBase executeUpdate:[NSString stringWithFormat:sql,CHAT_GROUP,imagePath,groupId]];
        }
        return  isUpdated;
    }
    @catch (NSException *exception) {
        NSLog(@"updateGroupHeadPhoto error:%@",exception);
        return NO;
    }
    @finally {
    }
}
//
-(BOOL)updateChatAdUserHeadnPhotoDate:(NSString *)date from:(NSString *)from
{
    @try {
        BOOL isUpdated = NO;
        NSString *sql = @"Update %@ Set LAST_SYNC_TIME='%@' where user_principal_name='%@'";
        if ([dataBase open]) {
            isUpdated= [dataBase executeUpdate:[NSString stringWithFormat:sql, CHAT_AD_USER,date,from]];
            [[CommUtilHelper sharedInstance] setValueDefaults:date key:CHAT_AD_USER];
        }
        return  isUpdated;
    }
    @catch (NSException *exception) {
        NSLog(@"updateChatAdUserHeadnPhotoDate error:%@",exception);
        return NO;
    }
    @finally {
    }
}
//
-(BOOL)updateChatGroupHeadDate:(NSString *)date groupId:(NSString *)groupId
{
    @try {
        BOOL isUpdated = NO;
        NSString *sql = @"Update %@ Set LAST_SYNC_TIME='%@' where chat_group_id=%@";
        if ([dataBase open]) {
            isUpdated= [dataBase executeUpdate:[NSString stringWithFormat:sql, CHAT_GROUP,date,groupId]];
            [[CommUtilHelper sharedInstance] setValueDefaults:date key:CHAT_GROUP];
        }
        return  isUpdated;
    }
    @catch (NSException *exception) {
        [[CommUtilHelper sharedInstance] setErrorMsg:[@"updateChatGroupHeadDate error:" stringByAppendingString:[exception description]]];
        NSLog(@"updateChatGroupHeadDate error:%@",exception);
        return NO;
    }
    @finally {
    }
}

-(NSString *)getHeadPhotoNameByUser:(NSString *)user
{
    @try {
        NSString *imageName = @"";
        NSString *sql =[NSString stringWithFormat:@"select HEAD_PHOTO from %@ where user_principal_name ='%@'",CHAT_AD_USER,user];
        if ([dataBase open]) {
            FMResultSet *rs = [dataBase executeQuery:sql];
            while ([rs  next]) {
                imageName=[rs stringForColumn:@"HEAD_PHOTO"];
            }
        }
        return imageName;
    }
    @catch (NSException *exception) {
        NSLog(@"getHeadPhotoNameByUser error:%@",exception);
        return nil;
    }
    @finally {
    }
}
//
-(NSInteger *)getTotalNumberByGroup:(NSString *)groupId
{
    @try {
        NSInteger *count = 0;
        NSString *sql =[NSString stringWithFormat:@"Select count(*) From %@ Where Del_flag=0 And chat_group_id =%@",CHAT_GROUP_PERSON,groupId];
        if ([dataBase open]) {
            FMResultSet *rs = [dataBase executeQuery:sql];
            while ([rs  next]) {
                count =[rs intForColumnIndex:0];
            }
        }
        return count;
    }
    @catch (NSException *exception) {
        NSLog(@"getTotalNumberByGroup error:%@",exception);
        return 0;
    }
    @finally {
        
    }
}
-(NSString *)getSingleContactHead:(NSString *)groupid myUser:(NSString *)myUser
{
 
    
    @try {
        NSString *name = @"";
        NSString *sql =[NSString stringWithFormat:@"select  head_photo from  (select *  from chat_GROUP_PERSON where chat_group_id=%@ and del_flag=0 and user_principal_name != '%@' ) as a,chat_AD_USER as b where a.user_principal_name = b.user_principal_name",groupid,myUser];
        if ([dataBase open]) {
            FMResultSet *rs = [dataBase executeQuery:sql];
            while ([rs  next]) {
                name = [rs stringForColumn:@"head_photo"];
                break;
            }
        }
        return name;
    }
    @catch (NSException *exception) {
        NSLog(@"getTotalNumberByGroup error:%@",exception);
        return @"";
    }
    @finally {
        
    }

}
//‘y’是群聊
-(BOOL)updateIsGroup:(NSString *)chatGroupId
{
    @try {
     
        NSString *sql =[NSString stringWithFormat:@"update %@  set IS_GROUP='Y' WHERE CHAT_GROUP_ID=%@",CHAT_GROUP,chatGroupId];
        if ([dataBase open]) {
            [dataBase executeUpdate:sql];
        }
        return true;
    }
    @catch (NSException *exception) {
        NSLog(@"getTotalNumberByGroup error:%@",exception);
        return false;
    }
    @finally {
        
    }

}
-(BOOL)updateTimeBySessionId:(NSString *)sessionId
{
    NSString *date = [FormatTime dateToStr:[NSDate date]];
    NSString *sql =[NSString stringWithFormat:@"update %@  set CREATE_DATE='%@'  WHERE ID=%@",CHAT_GROUP_SESSION,date,sessionId];
    @try {
        
        
        if ([dataBase open]) {
            [dataBase executeUpdate:sql];
        }
        return true;
    }
    @catch (NSException *exception) {
        NSLog(@" error:%@",exception);
        return false;
    }
    @finally {
        
    }
}
-(NSString *)getCreatePersonName:(NSString *)groupid
{
  
    @try {
        NSString *name = @"";
        NSString *sql =[NSString stringWithFormat:@"select create_person from %@ where chat_group_id=%@",CHAT_GROUP,groupid];
        if ([dataBase open]) {
            FMResultSet *rs = [dataBase executeQuery:sql];
            while ([rs  next]) {
                name = [rs stringForColumn:@"create_person"];
                break;
            }
        }
        return name;
    }
    @catch (NSException *exception) {
        NSLog(@"getTotalNumberByGroup error:%@",exception);
        return @"";
    }
    @finally {
        
    }

}

///////////////////获取转发组别
//获取组
-(NSMutableArray *)getTransChatGroupList
{
    @try {
        NSString *sql = @"Select distinct t1.*, ifnull((Select COMMON_NAME From CHAT_AD_USER as t2 Where t1.LAST_SESSION_PERSON=t2.USER_PRINCIPAL_NAME),t1.LAST_SESSION_PERSON) as LAST_COMMON_NAME From CHAT_GROUP as t1 Where del_flag=0 Order by IS_GROUP DESC,LAST_SESSION_DATE  DESC";
        if ([dataBase open]) {
            FMResultSet *rs = [dataBase executeQuery:sql];
            NSMutableArray *chatGroupDic = [NSMutableArray array];
            while ([rs next]) {
                NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
                
                [dic setObject:[rs stringForColumn:@"CHAT_GROUP_ID"] forKey:@"CHAT_GROUP_ID"];
                [dic setObject:[rs stringForColumn:@"CHAT_GROUP_NAME"] forKey:@"CHAT_GROUP_NAME"];
                
                NSString *lastUpdateSession =[rs stringForColumn:@"LAST_UPDATE_SESSION"];
                if (lastUpdateSession && ![@"" isEqualToString:lastUpdateSession]) {
                    [dic setObject:lastUpdateSession forKey:@"LAST_UPDATE_SESSION"];
                }else
                {
                    [dic setObject:@"" forKey:@"LAST_UPDATE_SESSION"];
                }
                NSString *lastSessionPerson =[rs stringForColumn:@"LAST_SESSION_PERSON"];
                if (lastSessionPerson &&![@"" isEqualToString: lastSessionPerson]  ) {
                    [dic setObject:lastSessionPerson forKey:@"LAST_SESSION_PERSON"];
                }else
                {
                    [dic setObject:@""forKey:@"LAST_SESSION_PERSON"];
                }
                
                
                NSString *lastCommName =  [rs stringForColumn:@"LAST_COMMON_NAME"];
                if (lastCommName &&![@"" isEqualToString: lastCommName] ) {
                    [dic setObject:lastCommName forKey:@"LAST_COMMON_NAME"];
                }else
                {
                    [dic setObject:@"" forKey:@"LAST_COMMON_NAME"];
                }
                
                [dic setObject:[rs stringForColumn:@"LAST_SESSION_DATE"] forKey:@"LAST_SESSION_DATE"];
                [dic setObject:[rs stringForColumn:@"IS_GROUP"] forKey:@"IS_GROUP"];
                [dic setObject:[rs stringForColumn:@"CHAT_GROUP_IMAGE"] forKey:@"HEAD_PHOTO"];
                
                [chatGroupDic addObject:dic];
            }
            [rs close];
            return chatGroupDic;
        }else
        {
            return nil;
        }
    }
    @catch (NSException *exception) {
        [[CommUtilHelper sharedInstance] setErrorMsg:[@"getChatGroupList error:" stringByAppendingString:[exception description]]];
        NSLog(@"getChatGroupList error:%@",exception);
        return nil;
    }
    @finally {
    }
}
//
-(BOOL)insertGroupDetail:(NSArray *)theArr
{
    BOOL result = NO;
    @try {
        if(!(theArr && [theArr isKindOfClass:[NSArray class]])){
            return result;
        }
        int i = 0;
        for (NSDictionary *dic in theArr) {
            NSString *groupDetailId = [dic objectForKey:@"GROUP_DETAIL_ID"];
            NSString *chatGroupId = [dic objectForKey:@"CHAT_GROUP_ID"];
            NSString *type = [dic objectForKey:@"TYPE"];
            NSString *name = [dic objectForKey:@"NAME"];
            NSString *value = [dic objectForKey:@"VALUE"];
            NSString *description = [dic objectForKey:@"DESCRIPTION"];
            NSString *valueType = [dic objectForKey:@"VALUE_TYPE"];
            NSString *orderNo = [dic objectForKey:@"ORDER_NO"];
            NSString *createdBy = [dic objectForKey:@"CREATED_BY"];
            NSString *createDate = [dic objectForKey:@"CREATE_DATE"];
            //
            if(i==0){
                NSString *eupdateSql = [NSString stringWithFormat:@"Delete From CHAT_GROUP_DETAIL Where CHAT_GROUP_ID=%@ ",chatGroupId];
                if ([dataBase open]) {
                    result = [dataBase executeUpdate:eupdateSql];
                }                
            }
            NSString *sql = @"insert into CHAT_GROUP_DETAIL (GROUP_DETAIL_ID,CHAT_GROUP_ID,TYPE,NAME,DESCRIPTION,VALUE_TYPE,VALUE,ORDER_NO,CREATE_DATE,CREATED_BY) VALUES (?,?,?,?,?,?,?,?,?,?)";
            if ([dataBase open]) {
                result = [dataBase executeUpdate:sql withArgumentsInArray:[NSArray arrayWithObjects:groupDetailId,chatGroupId, type,name,description,valueType,value,orderNo,createdBy,createDate, nil]];
            }
            i++;
        }
        return result;
    }
    @catch (NSException *exception) {
        [[CommUtilHelper sharedInstance] setErrorMsg:[@"insertGroupDetail error:" stringByAppendingString:[exception description]]];
        NSLog(@"insertGroupDetail error:%@",exception);
        result = NO;
    }
    @finally {
        return result;
    }
    
}
//
-(NSString *)getValue:(NSString *)value{
    return value?value:@"";
}
//
-(NSMutableArray *)getChatGroupListByType:(NSString *)groupType
{
    NSMutableArray *ary = [NSMutableArray array];
    @try {
        NSString *sql = [NSString stringWithFormat:@"Select t1.*, ifnull((Select COMMON_NAME From CHAT_AD_USER as t2 Where t1.CREATE_PERSON=t2.USER_PRINCIPAL_NAME),t1.CREATE_PERSON) as CREATE_COMMON_NAME,ifnull((Select Count(*) From CHAT_GROUP_SESSION gs Where gs.CHAT_GROUP_ID=t1.CHAT_GROUP_ID And gs.Sub_Type!='WELCOME'),0) as SESSION_COUNTER From CHAT_GROUP as t1 Where del_flag=0 And type='%@'Order by ifnull(IS_TOP,'N') DESC, LAST_SESSION_DATE  DESC",groupType];
        if ([dataBase open]) {
            FMResultSet *rs = [dataBase executeQuery:sql];
            while ([rs next]) {
                NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
                [dic setObject:[rs stringForColumn:@"CHAT_GROUP_ID"] forKey:@"CHAT_GROUP_ID"];
                [dic setObject:[self getValue:[rs stringForColumn:@"CHAT_GROUP_NAME"]] forKey:@"CHAT_GROUP_NAME"];
                [dic setObject:[self getValue:[rs stringForColumn:@"LAST_UPDATE_SESSION"]] forKey:@"LAST_UPDATE_SESSION"];
                [dic setObject:[self getValue:[rs stringForColumn:@"LAST_SESSION_PERSON"]] forKey:@"LAST_SESSION_PERSON"];
                [dic setObject:[self getValue:[rs stringForColumn:@"CREATE_COMMON_NAME"]] forKey:@"CREATE_COMMON_NAME"];
                [dic setObject:[self getValue:[rs stringForColumn:@"SOURCE"]] forKey:@"SOURCE"];
                [dic setObject:[self getValue:[rs stringForColumn:@"TYPE"]] forKey:@"TYPE"];
                [dic setObject:[self getValue:[rs stringForColumn:@"LAST_SESSION_DATE"]] forKey:@"LAST_SESSION_DATE"];
                [dic setObject:[self getValue:[rs stringForColumn:@"IS_GROUP"]] forKey:@"IS_GROUP"];
                [dic setObject:[self getValue:[rs stringForColumn:@"CHAT_GROUP_IMAGE"]] forKey:@"CHAT_GROUP_IMAGE"];
                [dic setObject:[self getValue:[rs stringForColumn:@"CREATE_PERSON"]] forKey:@"CREATE_PERSON"];
                [dic setObject:[self getValue:[rs stringForColumn:@"CREATE_DATE"]] forKey:@"CREATE_DATE"];
                [dic setObject:[self getValue:[rs stringForColumn:@"CHAT_GROUP_INFO"]] forKey:@"CHAT_GROUP_INFO"];
                [dic setObject:[self getValue:[rs stringForColumn:@"STATUS"]] forKey:@"STATUS"];
                [dic setObject:[self getValue:[rs stringForColumn:@"SESSION_COUNTER"]] forKey:@"SESSION_COUNTER"];
                //
                NSArray *aryGroupDetail = [self getGroupDetail:[rs stringForColumn:@"CHAT_GROUP_ID"]];
                [dic setObject:aryGroupDetail forKey:@"GROUP_DETAIL"];
                //
                [ary addObject:dic];
            }
            [rs close];
        }
    }
    @catch (NSException *exception) {
        [[CommUtilHelper sharedInstance] setErrorMsg:[@"getChatGroupListByType error:" stringByAppendingString:[exception description]]];
        NSLog(@"getChatGroupListByType error:%@",exception);
    }
    @finally {
        return ary;
    }
}
//
-(NSMutableArray *)getGroupDetail:(NSString *)groupId
{
    NSMutableArray *ary = [NSMutableArray array];
    @try {
        NSString *sql = [NSString stringWithFormat:@"Select * From CHAT_GROUP_DETAIL Where Chat_Group_Id='%@'",groupId];
        if ([dataBase open]) {
            FMResultSet *rs = [dataBase executeQuery:sql];
            while ([rs next]) {
                NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
                [dic setObject:[rs stringForColumn:@"CHAT_GROUP_ID"] forKey:@"CHAT_GROUP_ID"];
                [dic setObject:[self getValue:[rs stringForColumn:@"GROUP_DETAIL_ID"]] forKey:@"GROUP_DETAIL_ID"];
                [dic setObject:[self getValue:[rs stringForColumn:@"TYPE"]] forKey:@"TYPE"];
                [dic setObject:[self getValue:[rs stringForColumn:@"NAME"]] forKey:@"NAME"];
                [dic setObject:[self getValue:[rs stringForColumn:@"DESCRIPTION"]] forKey:@"DESCRIPTION"];
                [dic setObject:[self getValue:[rs stringForColumn:@"VALUE_TYPE"]] forKey:@"VALUE_TYPE"];
                [dic setObject:[self getValue:[rs stringForColumn:@"VALUE"]] forKey:@"VALUE"];
                [dic setObject:[self getValue:[rs stringForColumn:@"ORDER_NO"]] forKey:@"ORDER_NO"];
                [dic setObject:[self getValue:[rs stringForColumn:@"CREATE_DATE"]] forKey:@"CREATE_DATE"];
                [dic setObject:[self getValue:[rs stringForColumn:@"CREATED_BY"]] forKey:@"CREATED_BY"];
                [ary addObject:dic];
            }
            [rs close];
        }
    }
    @catch (NSException *exception) {
        [[CommUtilHelper sharedInstance] setErrorMsg:[@"getGroupDetail error:" stringByAppendingString:[exception description]]];
        NSLog(@"getGroupDetail error:%@",exception);
    }
    @finally {
        return ary;
    }
}
//
-(BOOL)insertSession:(NSDictionary *)dic
{
    BOOL result = NO;;
    @try {
        if ([dataBase open]) {
            [dataBase beginTransaction];
            NSString *checkSql = [NSString stringWithFormat:@"Select count(*) From CHAT_GROUP_SESSION Where SESSION_ID='%@'",[self getValue:[dic objectForKey:@"sId"]]];
            BOOL isExists = [self isExistUserRecord:checkSql];
            if(isExists){
                NSString *sql = [NSString stringWithFormat:@"Update CHAT_GROUP_SESSION Set GROUP_SESSION_ID='%@',SERVER_DATE='%@',CREATE_DATE='%@',LAST_SYNC_TIME='%@' Where SESSION_ID='%@'",[self getValue:[dic objectForKey:@"sessionId"]],[self getValue:[dic objectForKey:@"serverTime"]],[self getValue:[dic objectForKey:@"date"]],[self getValue:[dic objectForKey:@"serverTime"]],[self getValue:[dic objectForKey:@"sId"]]];
                result = [dataBase executeUpdate:sql];
            }else{
                NSString *sql = @"insert into CHAT_GROUP_SESSION (CHAT_GROUP_ID,USER_PRINCIPAL_NAME,CHAT_CONTENT,GROUP_SESSION_ID,SESSION_ID,FILE_PATH,TYPE,SUB_TYPE,DETAIL_DESC,THUMBNAIL_FILE_NAME,ORIGIN_FILE_NAME,FILE_TYPE,FILE_SIZE,FILE_DURATION,DEL_FLAG,SERVER_DATE,LAST_SYNC_TIME,CREATE_DATE ) values (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
                NSMutableArray *theAry = [[NSMutableArray alloc] init];
                [theAry addObject:[self getValue:[dic objectForKey:@"groupId"]]];
                [theAry addObject:[self getValue:[dic objectForKey:@"from"]]];
                [theAry addObject:[self getValue:[dic objectForKey:@"msg"]]];
                [theAry addObject:[self getValue:[dic objectForKey:@"sessionId"]]];
                [theAry addObject:[self getValue:[dic objectForKey:@"sId"]]];
                [theAry addObject:[self getValue:[dic objectForKey:@"filePath"]]];
                [theAry addObject:[self getValue:[dic objectForKey:@"type"]]];
                [theAry addObject:[self getValue:[dic objectForKey:@"subType"]]];
                [theAry addObject:[self getValue:[dic objectForKey:@"detailDesc"]]];
                [theAry addObject:[self getValue:[dic objectForKey:@"thumbnailFileName"]]];
                [theAry addObject:[self getValue:[dic objectForKey:@"originFileName"]]];
                [theAry addObject:[self getValue:[dic objectForKey:@"fileType"]]];
                [theAry addObject:[self getValue:[dic objectForKey:@"fileSize"]]];
                [theAry addObject:[self getValue:[dic objectForKey:@"fileDuration"]]];
                [theAry addObject:@"0"];
                [theAry addObject:[self getValue:[dic objectForKey:@"serverTime"]]];
                [theAry addObject:[self getValue:[dic objectForKey:@"serverTime"]]];
                [theAry addObject:[self getValue:[dic objectForKey:@"date"]]];
                //
                result = [dataBase executeUpdate:sql withArgumentsInArray:theAry];
                [self updateChatGroup:[self getValue:[dic objectForKey:@"msg"]] From:[self getValue:[dic objectForKey:@"from"]] ResysDttm:[self getValue:[dic objectForKey:@"date"]] GroupId:[self getValue:[dic objectForKey:@"groupId"]]];
            }
            [dataBase commit];
        }
    }
    @catch (NSException *exception) {
        [dataBase rollback];
        [[CommUtilHelper sharedInstance] setErrorMsg:[@"insertSession error:" stringByAppendingString:[exception description]]];
        NSLog(@"insertSession error:%@",exception);
    }
    @finally {
        return result;
    }
}
//
-(BOOL)insertSessionDetail:(NSArray *)theArr
{
    BOOL result = NO;
    @try {
        if(!(theArr && [theArr isKindOfClass:[NSArray class]])){
            return result;
        }
        if ([dataBase open]) {
            [dataBase beginTransaction];
        }
        for (NSDictionary *dic in theArr) {
            NSString *checkSql = [NSString stringWithFormat:@"Select count(*) From CHAT_SESSION_DETAIL Where CLIENT_DETAIL_ID='%@'",[self getValue:[dic objectForKey:@"CLIENT_DETAIL_ID"]]];
            BOOL isExists = [self isExistUserRecord:checkSql];
            if(isExists){
                NSString *sql = [NSString stringWithFormat:@"Update CHAT_SESSION_DETAIL Set SESSION_DETAIL_ID='%@',GROUP_SESSION_ID='%@' Where CLIENT_DETAIL_ID='%@'",[self getValue:[dic objectForKey:@"SESSION_DETAIL_ID"]],[self getValue:[dic objectForKey:@"GROUP_SESSION_ID"]],[self getValue:[dic objectForKey:@"CLIENT_DETAIL_ID"]]];
                result = [dataBase executeUpdate:sql];
            }else{
                NSString *sessionDetailId = [self getValue:[dic objectForKey:@"SESSION_DETAIL_ID"]];
                NSString *groupSessionId = [self getValue:[dic objectForKey:@"GROUP_SESSION_ID"]];
                NSString *sessionId = [self getValue:[dic objectForKey:@"SESSION_ID"]];
                NSString *clientDetailId = [self getValue:[dic objectForKey:@"CLIENT_DETAIL_ID"]];
                NSString *type = [self getValue:[dic objectForKey:@"TYPE"]];
                NSString *name = [self getValue:[dic objectForKey:@"NAME"]];
                NSString *value = [self getValue:[dic objectForKey:@"VALUE"]];
                NSString *description = [self getValue:[dic objectForKey:@"DESCRIPTION"]];
                NSString *valueType = [self getValue:[dic objectForKey:@"VALUE_TYPE"]];
                NSString *orderNo = [self getValue:[dic objectForKey:@"ORDER_NO"]];
                NSString *fileName = [self getValue:[dic objectForKey:@"FILE_NAME"]];
                NSString *thumbnailFileName = [self getValue:[dic objectForKey:@"THUMBNAIL_FILE_NAME"]];
                NSString *originFileName = [self getValue:[dic objectForKey:@"ORIGIN_FILE_NAME"]];
                NSString *fileType = [self getValue:[dic objectForKey:@"FILE_TYPE"]];
                NSString *fileSize = [self getValue:[dic objectForKey:@"FILE_SIZE"]];
                NSString *fileDuration = [self getValue:[dic objectForKey:@"FILE_DURATION"]];
                NSString *createdBy = [self getValue:[dic objectForKey:@"CREATED_BY"]];
                NSString *createDate = [self getValue:[dic objectForKey:@"CREATE_DATE"]];
                NSString *sql = @"insert into CHAT_SESSION_DETAIL (SESSION_DETAIL_ID,CLIENT_DETAIL_ID,GROUP_SESSION_ID,SESSION_ID,TYPE,NAME,DESCRIPTION,VALUE_TYPE,VALUE,FILE_NAME,THUMBNAIL_FILE_NAME,ORIGIN_FILE_NAME,FILE_TYPE,FILE_SIZE,FILE_DURATION,ORDER_NO,CREATE_DATE,CREATED_BY) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
                result = [dataBase executeUpdate:sql withArgumentsInArray:[NSArray arrayWithObjects:sessionDetailId,clientDetailId,groupSessionId,sessionId,type,name,description,valueType,value,fileName,thumbnailFileName,originFileName,fileType,fileSize,fileDuration,orderNo,createDate,createdBy, nil]];
            }
        }
        [dataBase commit];
    }
    @catch (NSException *exception) {
        [dataBase rollback];
        [[CommUtilHelper sharedInstance] setErrorMsg:[@"insertSessionDetail error:" stringByAppendingString:[exception description]]];
        NSLog(@"insertSessionDetail error:%@",exception);
        result = NO;
    }
    @finally {
        return result;
    }
    
}
//
-(BOOL)updateSession:(NSString *)sId GroupSessionId:(NSString *)groupSessionId ServerTime:(NSString *)serverTime Message:(NSString *)message Username:(NSString *)username GroupId:(NSString *)groupId
{
    BOOL result = NO;
    @try {
        NSString *sql = @"Update CHAT_GROUP_SESSION Set GROUP_SESSION_ID=?,LAST_SYNC_TIME=? WHERE SESSION_ID=?";
        if ([dataBase open]) {
            [dataBase beginTransaction];
            if([dataBase executeUpdate:sql withArgumentsInArray:[NSArray arrayWithObjects:groupSessionId,serverTime,sId, nil]]){
                NSString *groupSql = @"Update CHAT_GROUP Set del_flag=0, LAST_UPDATE_SESSION=?,LAST_SESSION_PERSON=?,LAST_SESSION_DATE=? WHERE CHAT_GROUP_ID=?";
                result = [dataBase executeUpdate:groupSql withArgumentsInArray:[NSArray arrayWithObjects:message,username,serverTime,groupId, nil]];
            }
            [dataBase commit];
        }
    }
    @catch (NSException *exception) {
        [[CommUtilHelper sharedInstance] setErrorMsg:[@"updateSession error:" stringByAppendingString:[exception description]]];
        NSLog(@"updateSession error:%@",exception);
    }
    @finally {
        return result;
    }
}
//
-(BOOL)updateSessionDetail:(NSArray *)sessionDetail
{
    BOOL result = NO;
    @try {
        if(!(sessionDetail && [sessionDetail isKindOfClass:[NSArray class]])){
            return result;
        }
        if ([dataBase open]) {
            [dataBase beginTransaction];
            //
            for (NSDictionary *dic in sessionDetail) {
                NSString *sql = [NSString stringWithFormat:@"Update CHAT_SESSION_DETAIL Set SESSION_DETAIL_ID='%@',GROUP_SESSION_ID='%@' Where CLIENT_DETAIL_ID='%@'",[dic objectForKey:@"SESSION_DETAIL_ID"],[dic objectForKey:@"GROUP_SESSION_ID"],[dic objectForKey:@"CLIENT_DETAIL_ID"]];
                result = [dataBase executeUpdate:sql];
            }
            [dataBase commit];
        }
    }
    @catch (NSException *exception) {
        [dataBase rollback];
        [[CommUtilHelper sharedInstance] setErrorMsg:[@"updateSessionDetail error:" stringByAppendingString:[exception description]]];
        NSLog(@"updateSessionDetail error:%@",exception);
    }
    @finally {
        return result;
    }
}
//
-(BOOL)deleteSession:(NSString *)sessionId GroupId:(NSString *)groupId
{
    BOOL result = NO;
    @try {
        if ([dataBase open]) {
            NSString *sql = [NSString stringWithFormat:@"Delete From CHAT_GROUP_SESSION Where SESSION_ID='%@' And CHAT_GROUP_ID='%@'",sessionId,groupId];
            result = [dataBase executeUpdate:sql];
        }
    }
    @catch (NSException *exception) {
        [[CommUtilHelper sharedInstance] setErrorMsg:[@"deleteSession error:" stringByAppendingString:[exception description]]];
        NSLog(@"deleteSession error:%@",exception);
    }
    @finally {
        return result;
    }
}
//
-(NSMutableArray *)getSession:(NSString *)groupId
{
    NSMutableArray *ary = [NSMutableArray array];
    @try {
        NSString *sql = [NSString stringWithFormat:@"Select a.*,(select sam_account_name  from CHAT_AD_USER where user_principal_name =a.user_principal_name) as USER_NICK_NAME ,(select HEAD_PHOTO  from CHAT_AD_USER where user_principal_name =a.user_principal_name) as HEAD_PHOTO From CHAT_GROUP_SESSION as a  WHERE ifnull(sub_type,'')!='WELCOME' And chat_group_id = %@  Order   by id desc", groupId];
        if ([dataBase open]) {
            FMResultSet *rs = [dataBase executeQuery:sql];
            while ([rs next]) {
                NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
                [dic setObject:[self getValue:[rs stringForColumn:@"ID"]] forKey:@"ID"];
                [dic setObject:[self getValue:[rs stringForColumn:@"GROUP_SESSION_ID"]] forKey:@"GROUP_SESSION_ID"];
                [dic setObject:[self getValue:[rs stringForColumn:@"SESSION_ID"]] forKey:@"SESSION_ID"];
                [dic setObject:[self getValue:[rs stringForColumn:@"USER_NICK_NAME"]] forKey:@"USER_NICK_NAME"];
                [dic setObject:[self getValue:[rs stringForColumn:@"HEAD_PHOTO"]] forKey:@"HEAD_PHOTO"];
                [dic setObject:[self getValue:[rs stringForColumn:@"LAST_SYNC_TIME"]] forKey:@"LAST_SYNC_TIME"];
                [dic setObject:[self getValue:[rs stringForColumn:@"CHAT_CONTENT"]] forKey:@"CHAT_CONTENT"];
                [dic setObject:[self getValue:[rs stringForColumn:@"CHAT_SMALLPIC"]] forKey:@"CHAT_SMALLPIC"];
                [dic setObject:[self getValue:[rs stringForColumn:@"FILE_PATH"]] forKey:@"FILE_PATH"];
                [dic setObject:[self getValue:[rs stringForColumn:@"CREATE_DATE"]] forKey:@"CREATE_DATE"];
                [dic setObject:[self getValue:[rs stringForColumn:@"USER_PRINCIPAL_NAME"]] forKey:@"USER_PRINCIPAL_NAME"];
                [dic setObject:[self getValue:[rs stringForColumn:@"TYPE"]] forKey:@"TYPE"];
                [dic setObject:[self getValue:[rs stringForColumn:@"SUB_TYPE"]] forKey:@"SUB_TYPE"];
                [dic setObject:[self getValue:[rs stringForColumn:@"DETAIL_DESC"]] forKey:@"DETAIL_DESC"];
                [dic setObject:[self getValue:[rs stringForColumn:@"THUMBNAIL_FILE_NAME"]] forKey:@"THUMBNAIL_FILE_NAME"];
                [dic setObject:[self getValue:[rs stringForColumn:@"ORIGIN_FILE_NAME"]] forKey:@"ORIGIN_FILE_NAME"];
                [dic setObject:[self getValue:[rs stringForColumn:@"FILE_TYPE"]] forKey:@"FILE_TYPE"];
                [dic setObject:[self getValue:[rs stringForColumn:@"FILE_SIZE"]] forKey:@"FILE_SIZE"];
                [dic setObject:[self getValue:[rs stringForColumn:@"FILE_DURATION"]] forKey:@"FILE_DURATION"];
                //
                [dic setObject:[self getSessionDetailBySid:[self getValue:[rs stringForColumn:@"SESSION_ID"]]] forKey:@"sessionDetail"];
                //
                [ary addObject:dic];
            }
            [rs close];
        }
    }
    @catch (NSException *exception) {
        [[CommUtilHelper sharedInstance] setErrorMsg:[@"getSession error:" stringByAppendingString:[exception description]]];
        NSLog(@"getSession error:%@",exception);
    }
    @finally {
        return ary;
    }
}
//
-(NSMutableArray *)getSessionDetailBySid:(NSString *)sID
{
    NSMutableArray *ary = [NSMutableArray array];
    @try {
        NSString *sql = [NSString stringWithFormat:@"Select * From Chat_Session_Detail Where SESSION_ID='%@'", sID];
        if ([dataBase open]) {
            FMResultSet *rs = [dataBase executeQuery:sql];
            while ([rs next]) {
                NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
                [dic setObject:[self getValue:[rs stringForColumn:@"ID"]] forKey:@"ID"];
                [dic setObject:[self getValue:[rs stringForColumn:@"CLIENT_DETAIL_ID"]] forKey:@"CLIENT_DETAIL_ID"];
                [dic setObject:[self getValue:[rs stringForColumn:@"SESSION_ID"]] forKey:@"SESSION_ID"];
                [dic setObject:[self getValue:[rs stringForColumn:@"SESSION_DETAIL_ID"]] forKey:@"SESSION_DETAIL_ID"];
                [dic setObject:[self getValue:[rs stringForColumn:@"GROUP_SESSION_ID"]] forKey:@"GROUP_SESSION_ID"];
                [dic setObject:[self getValue:[rs stringForColumn:@"TYPE"]] forKey:@"TYPE"];
                [dic setObject:[self getValue:[rs stringForColumn:@"NAME"]] forKey:@"NAME"];
                [dic setObject:[self getValue:[rs stringForColumn:@"DESCRIPTION"]] forKey:@"DESCRIPTION"];
                [dic setObject:[self getValue:[rs stringForColumn:@"VALUE_TYPE"]] forKey:@"VALUE_TYPE"];
                [dic setObject:[self getValue:[rs stringForColumn:@"VALUE"]] forKey:@"VALUE"];
                [dic setObject:[self getValue:[rs stringForColumn:@"FILE_NAME"]] forKey:@"FILE_NAME"];
                [dic setObject:[self getValue:[rs stringForColumn:@"THUMBNAIL_FILE_NAME"]] forKey:@"THUMBNAIL_FILE_NAME"];
                [dic setObject:[self getValue:[rs stringForColumn:@"ORIGIN_FILE_NAME"]] forKey:@"ORIGIN_FILE_NAME"];
                [dic setObject:[self getValue:[rs stringForColumn:@"FILE_TYPE"]] forKey:@"FILE_TYPE"];
                [dic setObject:[self getValue:[rs stringForColumn:@"FILE_SIZE"]] forKey:@"FILE_SIZE"];
                [dic setObject:[self getValue:[rs stringForColumn:@"FILE_DURATION"]] forKey:@"FILE_DURATION"];
                [dic setObject:[self getValue:[rs stringForColumn:@"ORDER_NO"]] forKey:@"ORDER_NO"];
                //
                [ary addObject:dic];
            }
            [rs close];
        }
    }
    @catch (NSException *exception) {
        [[CommUtilHelper sharedInstance] setErrorMsg:[@"getSessionDetailBySid error:" stringByAppendingString:[exception description]]];
        NSLog(@"getSessionDetailBySid error:%@",exception);
    }
    @finally {
        return ary;
    }
}
//
-(NSMutableDictionary *)getWelcomeSession:(NSString *)groupId
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    @try {
        NSString *sql = [NSString stringWithFormat:@"Select gs.*,(select sam_account_name  from CHAT_AD_USER where user_principal_name =gs.user_principal_name) as USER_NICK_NAME ,(select HEAD_PHOTO  from CHAT_AD_USER where user_principal_name =gs.user_principal_name) as HEAD_PHOTO From  CHAT_GROUP_SESSION as gs  WHERE chat_group_id = %@  And Sub_Type='WELCOME'", groupId];
        if ([dataBase open]) {
            FMResultSet *rs = [dataBase executeQuery:sql];
            [rs next];
            [dic setObject:[self getValue:[rs stringForColumn:@"ID"]] forKey:@"ID"];
            [dic setObject:[self getValue:[rs stringForColumn:@"GROUP_SESSION_ID"]] forKey:@"GROUP_SESSION_ID"];
            [dic setObject:[self getValue:[rs stringForColumn:@"SESSION_ID"]] forKey:@"SESSION_ID"];
            [dic setObject:[self getValue:[rs stringForColumn:@"USER_NICK_NAME"]] forKey:@"USER_NICK_NAME"];
            [dic setObject:[self getValue:[rs stringForColumn:@"HEAD_PHOTO"]] forKey:@"HEAD_PHOTO"];
            [dic setObject:[self getValue:[rs stringForColumn:@"LAST_SYNC_TIME"]] forKey:@"LAST_SYNC_TIME"];
            [dic setObject:[self getValue:[rs stringForColumn:@"CHAT_CONTENT"]] forKey:@"CHAT_CONTENT"];
            [dic setObject:[self getValue:[rs stringForColumn:@"CHAT_SMALLPIC"]] forKey:@"CHAT_SMALLPIC"];
            [dic setObject:[self getValue:[rs stringForColumn:@"FILE_PATH"]] forKey:@"FILE_PATH"];
            [dic setObject:[self getValue:[rs stringForColumn:@"CREATE_DATE"]] forKey:@"CREATE_DATE"];
            [dic setObject:[self getValue:[rs stringForColumn:@"USER_PRINCIPAL_NAME"]] forKey:@"USER_PRINCIPAL_NAME"];
            [dic setObject:[self getValue:[rs stringForColumn:@"TYPE"]] forKey:@"TYPE"];
            [dic setObject:[self getValue:[rs stringForColumn:@"SUB_TYPE"]] forKey:@"SUB_TYPE"];
            [dic setObject:[self getValue:[rs stringForColumn:@"DETAIL_DESC"]] forKey:@"DETAIL_DESC"];
            [dic setObject:[self getValue:[rs stringForColumn:@"THUMBNAIL_FILE_NAME"]] forKey:@"THUMBNAIL_FILE_NAME"];
            [dic setObject:[self getValue:[rs stringForColumn:@"ORIGIN_FILE_NAME"]] forKey:@"ORIGIN_FILE_NAME"];
            [dic setObject:[self getValue:[rs stringForColumn:@"FILE_TYPE"]] forKey:@"FILE_TYPE"];
            [dic setObject:[self getValue:[rs stringForColumn:@"FILE_SIZE"]] forKey:@"FILE_SIZE"];
            [dic setObject:[self getValue:[rs stringForColumn:@"FILE_DURATION"]] forKey:@"FILE_DURATION"];
            //
            [dic setObject:[self getSessionDetailBySid:[self getValue:[rs stringForColumn:@"SESSION_ID"]]] forKey:@"sessionDetail"];
            [rs close];
        }
    }
    @catch (NSException *exception) {
        [[CommUtilHelper sharedInstance] setErrorMsg:[@"getWelcomeSession error:" stringByAppendingString:[exception description]]];
        NSLog(@"getWelcomeSession error:%@",exception);
    }
    @finally {
        return dic;
    }
}
//
-(BOOL)updateGroupStatus:(NSString *)status GroupId:(NSString *)groupId
{
    BOOL result = NO;
    @try {
        if ([dataBase open]) {
            NSString *sql = [NSString stringWithFormat:@"Update CHAT_GROUP Set Status='%@' Where CHAT_GROUP_ID='%@'",status,groupId];
            result = [dataBase executeUpdate:sql];
        }
    }
    @catch (NSException *exception) {
        [[CommUtilHelper sharedInstance] setErrorMsg:[@"updateGroupStatus error:" stringByAppendingString:[exception description]]];
        NSLog(@"updateGroupStatus error:%@",exception);
    }
    @finally {
        return result;
    }
}
@end
