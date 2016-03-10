//
//  CustomLoadingView.h
//  HwpgMobile
//
//  Created by hwpl hwpl on 14-11-24.
//  Copyright (c) 2014年 hwpl hwpl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomLoadingView : UIView
{
    UIView *custView;
    UILabel *lblName;
    UILabel *lblSite;
    UIActivityIndicatorView *actView;
}
@property(nonatomic,retain) UIView *disView;
-(UIView *)getLoaidngViewByText:(NSString *)text Frame:(CGRect)frame;
@end
