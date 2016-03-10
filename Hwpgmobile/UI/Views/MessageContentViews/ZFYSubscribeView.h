//
//  ZFYSubscribeView.h
//  HPGApp
//
//  Created by hwpl on 15/11/12.
//  Copyright © 2015年 hwpl hwpl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XHMessageModel.h"
#import "NSString+Size.h"



@protocol SubsribeImageClick <NSObject>

-(void)SubsribeImageClick:(NSString *)imageUrl ;

@end

@interface ZFYSubscribeView : UIView



+(CGFloat)getViewHeight:(id <XHMessageModel> )message;

-(void)setMessage:(id <XHMessageModel> )message;
-(void)clearAll;
@property(nonatomic,weak) id<SubsribeImageClick> imageDelegate;
@end

@interface CIImageView : UIImageView
@property(nonatomic,strong) NSString *linkUrl;
@end
