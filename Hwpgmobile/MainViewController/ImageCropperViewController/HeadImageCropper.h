//
//  ImageCropperViewController.h
//  HwpgMobile
//
//  Created by test on 12/5/14.
//  Copyright (c) 2014 hwpl hwpl. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HeadImageCropper;

@interface HeadImageCropper  : NSObject

+(HeadImageCropper *)sharedImageCropper:(UIViewController *) fromViewController CanTap:(BOOL) canTap GroupId:(NSString *) groupId;

@property(nonatomic,strong) UIViewController *fromViewController;
@property(nonatomic,assign) BOOL canTap;
@property(nonatomic,assign) NSString *groupId;
- (void)setImageView:(UIImageView *) imageView;

@end
