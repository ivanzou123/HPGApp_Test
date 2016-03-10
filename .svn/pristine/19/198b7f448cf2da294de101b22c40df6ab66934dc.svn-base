//
//  DatabaseHandle.m
//  FMDBDEMO
//
//  Created by ruiduan ma on 12-2-14.
//  Copyright (c) 2012年 ivan. All rights reserved.
//

#import "DatabaseHandle.h"

#define DB_NAME @"MyDatabase.db"

@implementation DatabaseHandle
/*
 创建一个新的数据库
 */
+(FMDatabase *)creatDataBase
{
    FMDatabase *db = [FMDatabase databaseWithPath:@"/tmp/tmp.db"];
    NSLog(@"Is SQLite compiled with it's thread safe options turned on? %@!", [FMDatabase isThreadSafe] ? @"Yes" : @"No");
    {
		if ([db executeQuery:@"select * from table"] == nil) 
            NSLog(@"Failed");
		NSLog(@"%d: %@", [db lastErrorCode], [db lastErrorMessage]);
	}
    return db;
}

/*
 初始化一个新的数据库
 */
- (BOOL)initDatabase
{
	BOOL success;
	NSError *error;
	NSFileManager *fm = [NSFileManager defaultManager];
	NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:DB_NAME];
	
	success = [fm fileExistsAtPath:writableDBPath];
	
	if(!success){
		NSString *defaultDBPath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:DB_NAME];
		NSLog(@"defaultDBPath%@--",defaultDBPath);
		success = [fm copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
		if(!success){
			NSLog(@"error initDatabase: %@", [error localizedDescription]);
		}
		success = YES;
	}
	
    NSLog(@"db-path: %@",writableDBPath);
    
	if(success){
		dataBase = [[FMDatabase databaseWithPath:writableDBPath] retain];
		if ([dataBase open]) {
			[dataBase setShouldCacheStatements:YES];
		}else{
			NSLog(@"Failed to open database.");
			success = NO;
		}
	}
	
	return success;
}
- (FMDatabase *)getDatabase
{
	if ([self initDatabase]){
		return dataBase;
	}	
	return nil;
}

/*
 删除数据库
 */
+(void)removeOldDataBase
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:@"/Document/MyDatabase.db" error:nil];
}

/*
 关闭数据库
 */
- (void)closeDatabase
{
	[dataBase close];
}

- (id)init{
	if((self = [super init]))
	{
		dataBase = [[[DatabaseHandle alloc] getDatabase] retain];
	}
	
	return self;
}
- (void)dealloc
{
	[self closeDatabase];
	[dataBase release];
	[super dealloc];
}

-(NSString *)SQL:(NSString *)sql inTable:(NSString *)table {
	return [NSString stringWithFormat:sql, table];
}

@end
