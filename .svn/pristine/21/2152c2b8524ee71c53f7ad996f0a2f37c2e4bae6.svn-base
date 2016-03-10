//
//  DatabaseHandle.h
//  FMDBDEMO
//
//  Created by ruiduan ma on 12-2-14.
//  Copyright (c) 2014年 ivan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"

@interface DatabaseHandle : NSObject{
    FMDatabase *dataBase;
}
+ (FMDatabase *)creatDataBase;
+ (void)removeOldDataBase;
- (FMDatabase *)getDatabase;
-(NSString *)SQL:(NSString *)sql inTable:(NSString *)table;

@end
