//
//  XHContactView.m
//  MessageDisplayExample
//
//  Created by ivan on 14-10-28.
//  Copyright (c) 2014年 hwpl hwpl. All rights reserved.

#import "XHContactView.h"

@interface XHContactView ()

@property (nonatomic, strong) UIImageView *avatorImageView;

@property (nonatomic, strong) UILabel *userNameLabel;

@property (nonatomic, strong) UIImageView *userSexImageView;

@property (nonatomic, strong) UILabel *weChatNumberLabel;

@end

@implementation XHContactView

#pragma mark - Propertys

- (void)setDisplayContact:(XHContact *)displayContact {
    _displayContact = displayContact;
    
    self.userNameLabel.text = displayContact.contactName;
    self.weChatNumberLabel.text = displayContact.contactUserId;
    self.avatorImageView.image = displayContact.headImage;
}

- (UIImageView *)avatorImageView {
    if (!_avatorImageView) {
        _avatorImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kXHAlbumAvatorSpacing, kXHAlbumAvatorSpacing, kXHContactAvatorSize, kXHContactAvatorSize)];
        _avatorImageView.image = [UIImage imageNamed:@"MeIcon"];
        [_avatorImageView.layer setCornerRadius:CGRectGetHeight(_avatorImageView.frame)/2];
        _avatorImageView.layer.masksToBounds = YES;
        _avatorImageView.layer.borderColor = [[UIColor whiteColor] CGColor];
        _avatorImageView.backgroundColor = [UIColor whiteColor];
        //_avatorImageView.layer.shadowColor = [UIColor grayColor].CGColor;
        //_avatorImageView.layer.shadowOffset = CGSizeMake(4, 4);
        //_avatorImageView.layer.shadowOpacity = 0.5;
        //_avatorImageView.layer.shadowRadius = 2.0;
        //_avatorImageView.layer.borderWidth = 2.0f;
    }
    return _avatorImageView;
}

- (UILabel *)userNameLabel {
    if (!_userNameLabel) {
        CGFloat userNameLabelX = CGRectGetMaxX(self.avatorImageView.frame) + kXHAlbumAvatorSpacing;
        _userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(userNameLabelX, CGRectGetMinY(self.avatorImageView.frame), CGRectGetWidth(self.bounds) - userNameLabelX - kXHAlbumAvatorSpacing, kXHContactNameLabelHeight)];
        _userNameLabel.backgroundColor = [UIColor clearColor];
        _userNameLabel.textColor = [UIColor blackColor];
        _userNameLabel.font = [UIFont boldSystemFontOfSize:17];
        
    }
    return _userNameLabel;
}

- (UIImageView *)userSexImageView {
    if (!_userSexImageView) {
        _userSexImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.userNameLabel.frame), CGRectGetMinY(self.userNameLabel.frame), 15, 15)];
    }
    return _userSexImageView;
}

- (UILabel *)weChatNumberLabel {
    if (!_weChatNumberLabel) {
        CGRect weChatNumberLabelFrame = self.userNameLabel.frame;
        weChatNumberLabelFrame.origin.y += CGRectGetHeight(weChatNumberLabelFrame);
        _weChatNumberLabel = [[UILabel alloc] initWithFrame:weChatNumberLabelFrame];
        _weChatNumberLabel.backgroundColor = [UIColor clearColor];
        _weChatNumberLabel.textColor = [UIColor grayColor];
        _weChatNumberLabel.font = [UIFont systemFontOfSize:12];
    }
    return _weChatNumberLabel;
}

#pragma mark - Life Cycle

- (void)setup {
    self.backgroundColor = [UIColor clearColor];
    
    [self addSubview:self.avatorImageView];
    [self addSubview:self.userNameLabel];
    [self addSubview:self.userSexImageView];
    [self addSubview:self.weChatNumberLabel];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setup];
    }
    return self;
}

@end
