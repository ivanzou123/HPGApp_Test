//
//  NSURLRequest(ForSSL).m
//  HwpgMobile
//
//  Created by hwpl on 15/4/27.
//  Copyright (c) 2015年 hwpl hwpl. All rights reserved.
//

#import "NSURLRequest+ForSSL.h"

@implementation NSMutableURLRequest(ForSSL)
+(BOOL)allowsAnyHTTPSCertificateForHost:(NSString*)host
{
    return YES;
}

+(void)setAllowsAnyHTTPSCertificate:(BOOL)allow forHost:(NSString*)host
{
    
}
@end
