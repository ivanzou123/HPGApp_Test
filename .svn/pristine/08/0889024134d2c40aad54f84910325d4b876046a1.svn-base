//
//  XHPhotographyHelper.h
//  MessageDisplayExample
//
//  Created by hwpl hwpl on 14-12-2.
//  Copyright (c) 2014年 hwpl hwpl. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^DidFinishTakeMediaCompledBlock)(UIImage *image, NSDictionary *editingInfo);

@interface XHPhotographyHelper : NSObject
@property(nonatomic,retain) UIImagePickerController *imagePickerController;
- (void)showOnPickerViewControllerSourceType:(UIImagePickerControllerSourceType)sourceType onViewController:(UIViewController *)viewController compled:(DidFinishTakeMediaCompledBlock)compled;

- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;
@end
