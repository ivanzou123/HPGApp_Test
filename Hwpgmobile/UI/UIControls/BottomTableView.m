//
//  BottomTableView.m
//  ManHua
//
//  Created by test on 13-6-19.
//  Copyright (c) 2013年 test. All rights reserved.
//

#import "BottomTableView.h"
@interface CustomTabBarView()
@property(nonatomic,retain)UIImage *normalImg;
@property(nonatomic,retain)UIImage *selectedImg;
@end
@implementation CustomTabBarView
@synthesize lblTabBar,tabBarImageView;
@synthesize normalImg,selectedImg;
@synthesize delegate;
-(id)initWithText:(NSString *)text Image:(UIImage *)image SelectedImage:(UIImage *)selectedImage Count:(NSInteger )count
{
    normalImg = image ;
    selectedImg=selectedImage;
    NSLog(@"IMG:%@",normalImg);
    //CGFloat f = self.frame.size.width/count;
    
    if(self=[super initWithFrame:CGRectMake(0, 0, 106.6, 50)]){
       
        tabBarImageView=[[UIImageView alloc] initWithFrame:CGRectMake(38, 4, 30, 30)];
        [self.tabBarImageView setImage:normalImg];
        [self addSubview:tabBarImageView];
        lblTabBar=[[UILabel alloc] initWithFrame:CGRectMake(28, 32, 50, 12)];
        [lblTabBar setBackgroundColor:[UIColor clearColor] ];
        [lblTabBar setFont:[UIFont systemFontOfSize:10.0]];
        [lblTabBar setFont:[UIFont boldSystemFontOfSize:10.0]];
        [lblTabBar setTextColor:[UIColor whiteColor]];
        //[lblTabBar setTextAlignment:UITextAlignmentCenter];
        [lblTabBar setTextAlignment:NSTextAlignmentCenter];
        [self.lblTabBar setText:text];
        [self addSubview:lblTabBar];
        
    }
    return self;
}
-(void)isSelectd:(BOOL)flag
{
  if(flag)
  {
      [tabBarImageView setImage:selectedImg];
      [self setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"tab_select_indicator.png"]]];
  }else
  {
      [tabBarImageView setImage:normalImg];
      [self setBackgroundColor:[UIColor clearColor]];
  }
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
 if([delegate respondsToSelector:@selector(tabBarClick:)])
 {
     [delegate tabBarClick:self];
 }
}
@end
@interface BottomTableView ()
@property(nonatomic,retain)UIImageView *backgroundImageView;
@end
@implementation BottomTableView
@synthesize backgroundImageView;
@synthesize tabItems,backgroundImage;
@synthesize selectIndex;
@synthesize delegate;

-(id)initWithFrame:(CGRect)frame tabBarItems:(NSArray *)tabBarItems
{
    self = [super initWithFrame:frame];
    if (self) {
        // self.backgroundColor=[UIColor clearColor];
         backgroundImageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [backgroundImageView setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
         [backgroundImageView setUserInteractionEnabled:YES];
        [self addSubview:backgroundImageView];
        self.tabItems=tabBarItems;
        int itemCount = [tabItems count];
        for(int i=0;i<itemCount;i++)
        {
            CustomTabBarView *customTabBarView = [tabItems objectAtIndex:i];
            
            //CustomTabBarView.frame=CGRectMake(0, 0, self.frame.size.width/itemCount, 44);
             CGFloat offsetX=(frame.size.width-itemCount*customTabBarView.frame.size.width)/2;
            [customTabBarView setDelegate:self];
            [customTabBarView setFrame:CGRectMake(offsetX+customTabBarView.frame.size.width*i, 0, customTabBarView.frame.size.width, customTabBarView.frame.size.height)];
            [backgroundImageView addSubview:customTabBarView];
        }
        [self setSelectIndex:0];
    }
    return self;
}
-(void)setBackgroundImage:(UIImage *)_backgroundImage
{
 if(backgroundImage !=_backgroundImage)
 {
     backgroundImage = _backgroundImage;
     [backgroundImageView setImage:backgroundImage];
 }
}
-(void)setBackgroundColor:(UIColor *)backgroundColor
{
    [backgroundImageView setBackgroundColor:backgroundColor];
    [backgroundImageView setAlpha:0.8];
}
-(void)setSelectIndex:(NSUInteger)selectedIndex
{
    selectIndex =selectedIndex;
    for(int i=0;i<[tabItems count];i++)
    {
        CustomTabBarView *tab = [tabItems objectAtIndex:i];
        if(i == selectIndex)
        {
            [tab isSelectd:YES];
        }else
        {
            [tab isSelectd:NO];
        }
    }
}

-(void)hideBottomTabBar:(BOOL)flag
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.35];
    if(flag)
    {
        [backgroundImageView setFrame:CGRectMake(0-backgroundImageView.frame.size.width, backgroundImageView.frame.origin.y, backgroundImageView.frame.size.width, backgroundImageView.frame.size.height)];
    }else
    {
      [backgroundImageView setFrame:CGRectMake(0, backgroundImageView.frame.origin.y, backgroundImageView.frame.size.width, backgroundImageView.frame.size.height)];
    }
}

-(void)tabBarClick:(CustomTabBarView *)tabBar
{
    NSInteger index = [tabItems indexOfObject:tabBar];
    [self setSelectIndex:index];
    if([delegate respondsToSelector:@selector(tabBarSelected:)])
    {
        [delegate tabBarSelected:[NSNumber numberWithInt:index]];
    }
}
/*
 
 
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
