//
//  UtilDAO.h
//  MFS
//
//  Created by hwpl hwpl on 14-9-4.
//  Copyright (c) 2014年 hwpl hwpl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CrmNetServiceUtil : NSObject
+(CrmNetServiceUtil *)sharedInstance;
+(id)startRecommandlistByPage:(int) pageIndex Message:(NSString *)message ;
+(id)startRecommandlistByPagePost:(int) pageIndex Message:(NSMutableDictionary *)message ;
@end
