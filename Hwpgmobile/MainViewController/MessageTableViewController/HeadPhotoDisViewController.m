//
//  HeadPhotoDisViewController.m
//  HwpgMobile
//
//  Created by hwpl on 15/4/24.
//  Copyright (c) 2015年 hwpl hwpl. All rights reserved.
//

#import "HeadPhotoDisViewController.h"
#import "CharViewNetServiceUtil.h"
#import "ResponseModel.h"
#import "UIWindow+YzdHUD.h"
#import "CommUtilHelper.h"
#import "MRZoomScrollView.h"
@interface HeadPhotoDisViewController ()<UIScrollViewDelegate>
{
    UIImageView *imageView;
    UIActivityIndicatorView *loadingView;
    MRZoomScrollView  *zoomScrollView;
    
   
}
@property (nonatomic,strong)UIScrollView *scrollView;
@end

@implementation HeadPhotoDisViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor lightGrayColor]];
   
    
    
    
    //imageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
    //[self.view addSubview:imageView];
    
    //CGRect rect = self.view.frame;
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0,0, screenWidth, screenHeight)];
    self.scrollView.delegate = self;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.userInteractionEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.contentMode = UIViewContentModeScaleAspectFill;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.scrollView];
    
    zoomScrollView = [[MRZoomScrollView alloc] init];
    CGRect frame = self.scrollView.frame;
    zoomScrollView.frame = frame;
    
    [self.scrollView addSubview:zoomScrollView];
   
    
    loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [loadingView setFrame:CGRectMake(screenWidth/2-15, screenHeight/2-15, 30, 30)];
    loadingView.center = self.view.center;
    [self.view addSubview:loadingView];
    
    // Do any additional setup after loading the view.
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)loadHeadPohtoImageFromUser:(NSString *)user groupId:(NSString *)groupId
{
    
    //NSString *url = [NSString stringWithFormat:@"%@/setting/getBigHeadPhoto?from=%@",charUrl,user];
    if (groupId == nil) {
       groupId=@"0";
    }
   NSString *  url =[NSString stringWithFormat:@"%@/setting/getBigHeadPhoto?from=%@&groupid=%@",charUrl,user,groupId];
    [self.view bringSubviewToFront:loadingView];
   [loadingView startAnimating];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        
    
        ResponseModel *rs = [CharViewNetServiceUtil getHeadPhotoByUrl:url];
        dispatch_async(dispatch_get_main_queue(), ^{
            [loadingView stopAnimating];
            if (rs.error !=nil) {
                return ;
            }
            if (rs.resultInfo ==nil) {
                return;
            }
            if ([@""  isEqualToString: rs.resultInfo]) {
                [self.view.window showHUDWithText:@"No Data" Type:ShowPhotoNo Enabled:YES];
                return;
            }
            NSString *s= rs.resultInfo;
            UIImage *image = [[CommUtilHelper sharedInstance] base64ToImage:s];
            
            CGSize imageSize = image.size;
            CGSize photoSize = [[CommUtilHelper sharedInstance] scaleToSize:imageSize MaxWidth:screenWidth MaxHeight:screenHeight];
            //居中对齐
            float x = 0;
            if(photoSize.width < screenWidth){
                x = (screenWidth-photoSize.width)/2;
                
            }
            float y = 0;
            
            if(photoSize.height < screenHeight){
                y = (screenHeight-photoSize.height)/2;
            }
            
            [zoomScrollView.imageView setFrame:CGRectMake(x, y, photoSize.width, photoSize.height)];
            zoomScrollView.imageView.image = image;
        });
    });
}





/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
