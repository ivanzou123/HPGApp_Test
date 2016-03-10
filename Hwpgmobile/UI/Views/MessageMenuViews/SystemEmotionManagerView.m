//
//  SystemEmotionManagerView.m
//  Chat
//
//  Created by hwpl hwpl on 14-11-4.
//  Copyright (c) 2014年 hwpl hwpl. All rights reserved.
//

#import "SystemEmotionManagerView.h"
#import "FacialView.h"
@implementation SystemEmotionManagerView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(UIScrollView *)initWithEmotionScrollView:(CGRect)rect
{
    //创建表情键盘
    if (scrollView==nil) {
        scrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, rect.size.height, rect.size.width, keyboardHeight)];
        [scrollView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"facesBack"]]];
        for (int i=0; i<9; i++) {
            FacialView *fview=[[FacialView alloc] initWithFrame:CGRectMake(12+320*i, 15, facialViewWidth, facialViewHeight)];
            [fview setBackgroundColor:[UIColor clearColor]];
            [fview loadFacialView:i size:CGSizeMake(33, 43)];
            fview.delegate=self;
            [scrollView addSubview:fview];
            
        }
    }
    [scrollView setShowsVerticalScrollIndicator:NO];
    [scrollView setShowsHorizontalScrollIndicator:NO];
    scrollView.contentSize=CGSizeMake(320*9, keyboardHeight);
    scrollView.pagingEnabled=YES;
    scrollView.delegate=self;
    return scrollView;
//    pageControl=[[UIPageControl alloc]initWithFrame:CGRectMake(98, rect.size.height-120, 150, 30)];
//    [pageControl setCurrentPage:0];
//    pageControl.pageIndicatorTintColor=RGBACOLOR(195, 179, 163, 1);
//    pageControl.currentPageIndicatorTintColor=RGBACOLOR(132, 104, 77, 1);
//    pageControl.numberOfPages = 9;//指定页面个数
//    [pageControl setBackgroundColor:[UIColor clearColor]];
//    pageControl.hidden=YES;
//    [pageControl addTarget:self action:@selector(changePage:)forControlEvents:UIControlEventValueChanged];
//    [superView addSubview:pageControl];

}
@end
