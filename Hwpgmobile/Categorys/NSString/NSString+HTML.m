//
//  NSString+HTML.m
//  HwpgMobile
//
//  Created by test on 12/24/14.
//  Copyright (c) 2014 hwpl hwpl. All rights reserved.
//

#import "NSString+HTML.h"

@implementation NSString(HTML)
-(NSString *)htmlDecode:(NSString *) string
{
    string = [string stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
    string = [string stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
    string = [string stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
    string = [string stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
    string = [string stringByReplacingOccurrencesOfString:@"&ensp;" withString:@" "];
    string = [string stringByReplacingOccurrencesOfString:@"&emsp;" withString:@" "];
    string = [string stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
    string = [string stringByReplacingOccurrencesOfString:@"&apos;" withString:@"'"];
    //string = [string stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return string;
}

@end
