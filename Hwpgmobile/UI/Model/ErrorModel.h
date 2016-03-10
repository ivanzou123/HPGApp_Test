//
//  ErrorModel.h
//  MFS
//
//  Created by hwpl hwpl on 14-9-4.
//  Copyright (c) 2014年 hwpl hwpl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ErrorModel : NSObject
@property(nonatomic,retain)NSString *errorMsg;


-(id)initWithErrorCode:(NSString *)errorCode;
-(id)initWithHttpWithError:(NSError *)error;
-(id)initWithHttpError:(NSString *)httpErrorCode;
@end
