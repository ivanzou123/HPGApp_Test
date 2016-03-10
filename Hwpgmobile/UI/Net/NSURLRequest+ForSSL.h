//
//  NSURLRequest(ForSSL).h
//  HwpgMobile
//
//  Created by hwpl on 15/4/27.
//  Copyright (c) 2015年 hwpl hwpl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURLRequest(ForSSL)
+(BOOL)allowsAnyHTTPSCertificateForHost:(NSString*)host;

+(void)setAllowsAnyHTTPSCertificate:(BOOL)allow forHost:(NSString*)host;
@end
