//
//  XHContact.m
//  MessageDisplayExample
//
//  Created by 曾 宪华 on 14-5-22.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import "XHContact.h"

@implementation XHContact
@synthesize ContactTitile;
@synthesize contactEmail;
@synthesize contactPhone;
- (NSArray *)contactMyAlbums {
    if (!_contactMyAlbums) {
        _contactMyAlbums = [[NSArray alloc] initWithObjects:[UIImage imageNamed:@"bottleButtonFish"], [UIImage imageNamed:@"avator"], [UIImage imageNamed:@"MeIcon"], nil];
    }
    return _contactMyAlbums;
}

- (NSString *)contactIntroduction {
    if (!_contactIntroduction) {
        _contactIntroduction = @"我是ivan";
    }
    return _contactIntroduction;
}

- (NSString *)contactUserId {
    if (!_contactUserId) {
        _contactUserId = @"";
    }
    return _contactUserId;
}

- (NSString *)contactRegion {
    if (!_contactRegion) {
        _contactRegion = @"深圳市";
    }
    return _contactRegion;
}

- (NSString *)description {
    return self.contactName;
}

-(UIImage *)headImage
{
    if (!_headImage) {
        _headImage = [UIImage imageNamed:@"default2x@2x.png"];
    }
    return _headImage;
}
@end
