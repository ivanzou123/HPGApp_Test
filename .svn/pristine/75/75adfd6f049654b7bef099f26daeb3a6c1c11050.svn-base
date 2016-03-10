//
//  XHDisplayMediaViewController.h
//  MessageDisplayExample
//
//  Created by hwpl hwpl on 14-12-2.
//  Copyright (c) 2014年 hwpl hwpl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XHBaseViewController.h"
#import "XHMessageModel.h"
#import "MRZoomScrollView.h"
@interface XHDisplayMediaViewController : XHBaseViewController<UIGestureRecognizerDelegate>
{
CGFloat lastScale;
BOOL tapValue;
}

@property (nonatomic, strong) id <XHMessageModel> message;
@property (nonatomic, retain) MRZoomScrollView  *zoomScrollView;


@property(nonatomic,strong)UIImage *ploderImage;

-(void)setLinkUrl:(NSString *)linkUrl;
@end
