//
//  NSString+Size.h
//  XFCircle
//
//  Created by hwpl on 15/5/21.
//  Copyright (c) 2015年 hwpl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Size)

- (CGSize)textSizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size lineBreakMode:(NSLineBreakMode)lineBreakMode;

@end
