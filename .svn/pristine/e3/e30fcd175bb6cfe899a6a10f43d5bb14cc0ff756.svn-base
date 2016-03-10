//
//  BottomTableView.h
//  ManHua
//
//  Created by test on 13-6-19.
//  Copyright (c) 2013年 test. All rights reserved.
//
@class CustomTabBarView;
@protocol  TabBarDelegate <NSObject>
@optional
-(void) tabBarClick:(CustomTabBarView *)tabBar;
-(void)tabBarSelected:(NSNumber *)selectedIndex;
@end
#import <UIKit/UIKit.h>
@interface CustomTabBarView:UIView

@property(nonatomic,retain)UIImageView *tabBarImageView;
@property(nonatomic,retain)UILabel *lblTabBar;
@property(nonatomic,assign)id<TabBarDelegate>delegate;
-(id)initWithText:(NSString *)text Image:(UIImage *)image SelectedImage:(UIImage *)selectedImage Count:(NSInteger )count;
-(void)isSelectd:(BOOL)flag;
@end
#import <UIKit/UIKit.h>

@interface BottomTableView : UIView<TabBarDelegate>
@property(nonatomic,retain)UIImage *backgroundImage;
@property(nonatomic,retain)NSArray *tabItems;
@property(nonatomic,assign) NSUInteger selectIndex;
@property(nonatomic,assign)id<TabBarDelegate>delegate;
-(id)initWithFrame:(CGRect) frame tabBarItems:(NSArray *)tabBarItems;
-(void)hideBottomTabBar:(BOOL)flag;
@end
