//
//  FSWebServiceUtil.h
//  HPGApp
//
//  Created by hwpl on 15/10/26.
//  Copyright © 2015年 hwpl hwpl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FSWebServiceUtil : NSObject
+(FSWebServiceUtil *)sharedInstance;

-(id)getSearchMessageByParam:(NSString *)txtConnmods user:(NSString *)user;

-(id)getMsgCatalogList:(NSString *) user withSource:(NSString *)source;


-(id)updateSendType:(NSString *)dataInfo withSource:(NSString *)source;

@end
