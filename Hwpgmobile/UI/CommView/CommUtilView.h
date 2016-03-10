//
//  CommUtilView.h
//  Chart
//
//  Created by hwpl hwpl on 14-10-29.
//  Copyright (c) 2014年 hwpl hwpl. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface CommUtilView : UIView

+(UILabel *)initUIlable:(NSString *)title withFontSize:(NSInteger) fontSize withFrame:(CGRect) frame;
+(UIButton *)initUIButton:(NSString *)title withFontSize:(NSInteger) fontSize Frame:(CGRect) frame Image:(NSString *)imageName;
+(UIView *)initUIView:(CGRect) frame;
@end
