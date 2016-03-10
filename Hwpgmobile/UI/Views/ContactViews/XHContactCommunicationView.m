//
//  XHContactCommunicationView.m
//  MessageDisplayExample
//
//  Created by ivan on 14-10-28.
//  Copyright (c) 2014年 hwpl hwpl. All rights reserved.

#import <QuartzCore/QuartzCore.h>
#import "XHContactCommunicationView.h"

#import "XHContact.h"

@implementation XHContactCommunicationView

#pragma mark - Propertys

- (UIButton *)videoCommunicationButton {
    if (!_videoCommunicationButton) {
        _videoCommunicationButton = [[UIButton alloc] initWithFrame:CGRectMake(kXHAlbumAvatorSpacing, 0, CGRectGetWidth(self.bounds) - kXHAlbumAvatorSpacing * 2, kXHContactButtonHeight)];
        _videoCommunicationButton.layer.cornerRadius = 4;
        _videoCommunicationButton.backgroundColor = [UIColor colorWithRed:0.263 green:0.717 blue:0.031 alpha:1.000];
        [_videoCommunicationButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_videoCommunicationButton setTitle:@"Send Message" forState:UIControlStateNormal];
        //[self addSubview:_videoCommunicationButton];
    }
    return _videoCommunicationButton;
}

- (UIButton *)messageCommunicationButton {
    if (!_messageCommunicationButton) {
        _messageCommunicationButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.videoCommunicationButton.frame), CGRectGetMaxY(self.videoCommunicationButton.frame) + kXHContactButtonSpacing, CGRectGetWidth(self.videoCommunicationButton.bounds), CGRectGetHeight(self.videoCommunicationButton.bounds))];
        _messageCommunicationButton.layer.cornerRadius = 4;
        //_messageCommunicationButton.backgroundColor = [UIColor colorWithRed:0.263 green:0.717 blue:0.031 alpha:1.000];
        _messageCommunicationButton.backgroundColor = [UIColor colorWithRed:102/255.0 green:168/255.0 blue:49/255.0 alpha:1];
        [_messageCommunicationButton setHighlighted:YES];
        [_messageCommunicationButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_messageCommunicationButton setTitle:@"Add  Contact" forState:UIControlStateNormal];
        [self addSubview:_messageCommunicationButton];
    }
    return _messageCommunicationButton;
}

#pragma mark - Life Cycle

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
