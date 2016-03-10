//
//  ManageNetServiceUitl.h
//  HwpgMobile
//
//  Created by hwpl hwpl on 14-12-3.
//  Copyright (c) 2014年 hwpl hwpl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ManageNetServiceUitl : NSObject
+(ManageNetServiceUitl *)sharedInstance;
//删除并退出群
-(id)dropGroupFrunFrom:(NSString *)from GroupId:(NSString *)groupId;
@end
