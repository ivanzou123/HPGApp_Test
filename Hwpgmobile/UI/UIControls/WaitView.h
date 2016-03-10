//
//  WaitView.h
//  FS
//
//  Created by hwpl hwpl on 14-10-20.
//  Copyright (c) 2014年 hwpl hwpl. All rights reserved.
//
#import <Foundation/Foundation.h>

@protocol WaitViewDelegate <NSObject>
//委托方法
-(void)waitViewTap:(NSString *)url;//用于点击重新加载视图

@end

#import <UIKit/UIKit.h>
@interface WaitView : UIView
{
    UILabel *lblName;
    UILabel *lblSite;
    UIActivityIndicatorView *actView;
    BOOL isDownLoadFailed;//加载成功或者失败
    
}
@property(nonatomic,retain) UIView *disView;
@property(nonatomic,retain) UIButton *reloadButton;
@property(nonatomic,assign) id<WaitViewDelegate> delegate;
@property(nonatomic,retain) NSString *url;//请求的url

-(void)setDisplayText:(NSString *)text url:(NSString *) _url;
-(void)setDisplayText:(NSString *) text;
-(void)setErrorView;
-(void)restart;
-(void)setLoadingViewStart;

-(void)setLoadingViewEnd;

@end