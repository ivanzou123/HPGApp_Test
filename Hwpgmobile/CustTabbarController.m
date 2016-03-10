//
//  CustTabbarControllerViewController.m
//  HwpgMobile
//
//  Created by hwpl on 15/4/23.
//  Copyright (c) 2015年 hwpl hwpl. All rights reserved.
//
#define workHtmlViewTag 2
#import "CustTabbarController.h"
#import "WorkWebViewController.h"
#import "WorkViewController.h"
@interface CustTabbarController ()

@end

@implementation CustTabbarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    NSInteger xx= item.tag;
    if (xx == workHtmlViewTag) {
        UINavigationController *nav = (UINavigationController *)[self.viewControllers objectAtIndex:2];
        
      WorkViewController *wwv = (WorkViewController *) [nav.viewControllers objectAtIndex:0];
        if (wwv !=nil) {
            //[wwv ]
            [wwv loadData];
        }
        
    }
}

@end
