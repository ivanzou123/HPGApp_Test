//
//  PreDisImageViewController.h
//  HwpgMobile
//
//  Created by hwpl on 15/3/18.
//  Copyright (c) 2015年 hwpl hwpl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "XHMessageTableViewController.h"
@interface PreDisImageViewController : UIViewController
-(PreDisImageViewController *)initWithImageView:(UIImage *) image SendController:(XHMessageTableViewController *)controller;
@end
