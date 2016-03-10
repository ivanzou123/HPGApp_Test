//
//  XHRefreshActivityIndicatorContainerView.m
//  XHRefreshControlExample
//
//  Created by 曾 宪华 on 14-6-16.
//  Copyright (c) 2014年 曾宪华 QQ群: (142557668) QQ:543413507  Gmail:xhzengAIB@gmail.com. All rights reserved.
//

#import "XHRefreshActivityIndicatorContainerView.h"

@interface XHRefreshActivityIndicatorContainerView ()

@end

@implementation XHRefreshActivityIndicatorContainerView

#pragma mark - Propertys

- (void)setRefreshViewLayerType:(XHRefreshViewLayerType)refreshViewLayerType {
    _refreshViewLayerType = refreshViewLayerType;
    
    CGRect activityIndicatorViewFrame;
    switch (refreshViewLayerType) {
        case XHRefreshViewLayerTypeOnSuperView:
            activityIndicatorViewFrame = CGRectMake(CGRectGetWidth(self.bounds) / 2.0, CGRectGetHeight(self.bounds) * 0.4, 0, 0);
            break;
        case XHRefreshViewLayerTypeOnScrollViews:
            activityIndicatorViewFrame = CGRectMake(CGRectGetWidth(self.bounds) / 2.0, CGRectGetHeight(self.bounds) * 0.6, 0, 0);
            break;
        default:
            break;
    }
    self.activityIndicatorView.frame = activityIndicatorViewFrame;
}

- (XHActivityCircleIndicatorView *)activityIndicatorView {
    if (!_activityIndicatorView) {
        _activityIndicatorView = [[XHActivityCircleIndicatorView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.bounds) / 2.0, CGRectGetHeight(self.bounds) * 0.6, 0, 0)];
        _activityIndicatorView.refreshViewLayerType = self.refreshViewLayerType;
        
    }
    return _activityIndicatorView;
}

- (void)setHasStatusLabelShowed:(BOOL)hasStatusLabelShowed {
    _hasStatusLabelShowed = hasStatusLabelShowed;
    
    if (hasStatusLabelShowed) {
        self.activityIndicatorView.frame = CGRectMake((CGRectGetWidth(self.bounds) - kXHRefreshIndicatorViewHeight) / 2 - 40, (CGRectGetHeight(self.bounds) - kXHRefreshIndicatorViewHeight) / 2 - 5, kXHRefreshIndicatorViewHeight, kXHRefreshIndicatorViewHeight);
    } else {
        self.activityIndicatorView.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    }
    self.stateLabel.hidden = !hasStatusLabelShowed;
    self.timeLabel.hidden = !hasStatusLabelShowed;
    //self.stateLabel.hidden = NO;
    //self.timeLabel.hidden = NO;
}

- (UILabel *)stateLabel {
    if (!_stateLabel) {
        _stateLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.activityIndicatorView.frame), 4, 160, 14)];
        _stateLabel.backgroundColor = [UIColor clearColor];
        _stateLabel.font = [UIFont systemFontOfSize:14.f];
        _stateLabel.textColor = [UIColor blackColor];
    }
    return _stateLabel;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        CGRect timeLabelFrame = self.stateLabel.frame;
        timeLabelFrame.origin.y += CGRectGetHeight(timeLabelFrame) + 6;
        _timeLabel = [[UILabel alloc] initWithFrame:timeLabelFrame];
        _timeLabel.backgroundColor = [UIColor clearColor];
        _timeLabel.font = [UIFont systemFontOfSize:11.f];
        _timeLabel.textColor = [UIColor colorWithWhite:0.659 alpha:1.000];
    }
    return _timeLabel;
}

#pragma mark - Life Cycle

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code

        self.backgroundColor = [UIColor redColor];
        [self addSubview:self.stateLabel];
        [self addSubview:self.timeLabel];
}
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    if (newSuperview) {
        [self addSubview:self.activityIndicatorView];
    }
}

- (void)dealloc {
    _activityIndicatorView = nil;
}

@end
