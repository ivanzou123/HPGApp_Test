//
//  ErrorModel.m
//  MFS
//
//  Created by hwpl hwpl on 14-9-4.
//  Copyright (c) 2014年 hwpl hwpl. All rights reserved.
//

#import "ErrorModel.h"

@implementation ErrorModel

@synthesize errorMsg;
-(id)initWithErrorCode:(NSString *)errorCode
{
    if(self=[super init])
    {
        if([errorCode isEqualToString:@"OPR_00501"])
        {
            errorMsg=@"用户名";
        }
    }
    return self;
}

-(id)initWithHttpError:(NSString *)httpErrorCode
{
    if(self=[super init])
    {
//        if (<#condition#>) {
//            <#statements#>
//        }
    }
    return self;
}
-(id)initWithHttpWithError:(NSError *)error
{
    if(self=[super init])
    {
                if (error.code == 1 ) {
                    errorMsg = @"can not connect server!";
                }else
                {
                    errorMsg= [error.userInfo objectForKey:@"NSLocalizedDescription"];
                }
    }
    return self;
}
@end
