//
//  XHContactPhotosView.h
//  MessageDisplayExample
//
//  Created by ivan on 14-10-28.
//  Copyright (c) 2014年 hwpl hwpl. All rights reserved.
#import <UIKit/UIKit.h>

//#import "XHAlbum.h"

@interface XHContactPhotosView : UIView

@property (nonatomic, strong) NSArray *photos;

- (void)reloadData;

@end
