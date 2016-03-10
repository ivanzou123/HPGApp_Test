//
//  NativeCacheHandle.h
//  HwpgMobile
//
//  Created by hwpl hwpl on 14-11-13.
//  Copyright (c) 2014年 hwpl hwpl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"
@interface NativeCacheHandle : NSObject
{
 FMDatabase *dataBase;
}

+ (FMDatabase *)creatDataBase;
+ (void)removeOldDataBase;
- (FMDatabase *)getDatabase;
-(NSString *)SQL:(NSString *)sql inTable:(NSString *)table;
- (void)closeDatabase;
@end
