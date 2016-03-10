//
//  XHDisplayMediaViewController.m
//  MessageDisplayExample
//
//  Created by qtone-1 on 14-5-6.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import "XHDisplayMediaViewController.h"
#import <MediaPlayer/MediaPlayer.h>

#import "UIView+XHRemoteImage.h"
#import "CommUtilHelper.h"
#import "UIWindow+YzdHUD.h"
@interface XHDisplayMediaViewController ()<UIScrollViewDelegate>
{
    UIView *navagationView;
    UIButton *btnCancel;
    UIButton *btnSave;
}

@property (nonatomic, strong) MPMoviePlayerController *moviePlayerController;

@property (nonatomic, strong) UIImageView *photoImageView;
@property (nonatomic,strong)UIScrollView *scrollView;

@end

@implementation XHDisplayMediaViewController

- (MPMoviePlayerController *)moviePlayerController {
    if (!_moviePlayerController) {
        _moviePlayerController = [[MPMoviePlayerController alloc] init];
        _moviePlayerController.repeatMode = MPMovieRepeatModeOne;
        _moviePlayerController.scalingMode = MPMovieScalingModeAspectFill;
        _moviePlayerController.view.frame = self.view.frame;
        [self.view addSubview:_moviePlayerController.view];
    }
    return _moviePlayerController;
}
-(instancetype)init
{
    if ([super init]) {
        CGRect rect = self.view.frame;
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0,0, screenWidth, screenHeight)];
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
        _scrollView.userInteractionEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
       
        [self.view addSubview:_scrollView];
        
        _zoomScrollView = [[MRZoomScrollView alloc] init];
        CGRect frame = self.scrollView.frame;
        _zoomScrollView.frame = frame;
  
        [self.scrollView addSubview:_zoomScrollView];
        
        navagationView = [[UIView alloc] initWithFrame:CGRectMake(0, screenHeight-44, screenWidth, 44)];
        btnCancel = [[UIButton alloc] initWithFrame:CGRectMake(10, 2, 60, 40)];
        [btnCancel setTitle:@"Close" forState:UIControlStateNormal];
        [btnCancel addTarget:self action:@selector(closeController) forControlEvents:UIControlEventTouchUpInside];
        [navagationView addSubview:btnCancel];
        
        btnSave = [[UIButton alloc] initWithFrame:CGRectMake(navagationView.frame.size.width-70, 2, 60, 40)];
        [btnSave setTitle:@"Save" forState:UIControlStateNormal];
        [btnSave addTarget:self action:@selector(savePic) forControlEvents:UIControlEventTouchUpInside];
        [navagationView addSubview:btnSave];
        [navagationView setBackgroundColor:[UIColor lightGrayColor]];
        [self.view addSubview:navagationView];

    }
    return self;
}



- (UIImageView *)photoImageView {
    if (!_photoImageView) {
        
       // UIImageView *photoImageView = [[UIImageView alloc] initWithFrame:self.view.frame];
//        //UITapGestureRecognizer *tap  = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(magnifyImage)];
//        
//        //[photoImageView addGestureRecognizer:tap];
//        
//        //3 设置UIScrollView 属性
//        
//        //3.2 设置UIScrollView内容的尺寸，滚动范围
//        self.scrollView.contentSize=CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
//        
//        //3.2 设置UIScrollView的4周增加额外的滚动区域
//        CGFloat distance = 100.0f;
//        self.scrollView.contentInset = UIEdgeInsetsMake(distance, distance, distance, distance);
//        
//        //3.3 设置弹簧效果
//        self.scrollView.bounces = YES;
//        
//        //3.4 设置滚动不显示
//        self.scrollView.showsHorizontalScrollIndicator=NO;
//        self.scrollView.showsVerticalScrollIndicator=NO;
//        
//        
//        
//        
//        //4 UIImageView 添加到 UIScrollView 中
//        [self.scrollView addSubview:photoImageView];
//        
//        //5 UIScrollView
//        [self.view addSubview:self.scrollView];
//        
//        
//        //6 设置代理
//        self.scrollView.delegate = self;
//        
//        
//        //7 缩放
//        self.scrollView.minimumZoomScale=0.2f;
//        self.scrollView.maximumZoomScale=2.0f;

        //[self.view addSubview:photoImageView];
        //_photoImageView = photoImageView;
        
    }
    return _photoImageView;
}


-(void)setLinkUrl:(NSString *)linkUrl
{
    if(linkUrl !=nil)
    {
        // CGSize pSize = .size;
        //float pHeight =(screenWidth/pSize.width)*pSize.height;
        //[_zoomScrollView.imageView setFrame:CGRectMake( 0, (screenHeight-pHeight)/2, screenWidth,(screenWidth/pSize.width)*pSize.height)];
        [ _zoomScrollView.imageView setImageWithURL:[NSURL URLWithString:linkUrl] placeholer:nil];
        [_zoomScrollView.imageView setContentMode:UIViewContentModeScaleAspectFit];
        [_zoomScrollView.imageView setFrame:CGRectMake( 0, 0, screenWidth,screenHeight)];
    }
}



- (void)setMessage:(id<XHMessageModel>)message {
    _message = message;
    if ([message messageMediaType] == XHBubbleMessageMediaTypeVideo) {
        self.title = NSLocalizedStringFromTable(@"Video", @"MessageDisplayKitString", @"详细视频");
        self.moviePlayerController.contentURL = [NSURL fileURLWithPath:[message videoPath]];
        [self.moviePlayerController play];
    } else if ([message messageMediaType] ==XHBubbleMessageMediaTypePhoto) {
        self.title = NSLocalizedStringFromTable(@"Photo", @"MessageDisplayKitString", @"详细照片");
       // self.photoImageView.image = message.photo;
        //self.photoImageView.contentMode = UIViewContentModeScaleAspectFit;
        if (message.photo == nil) {
            return;
        }
        _zoomScrollView.imageView.image =message.photo;
        _zoomScrollView.contentMode = UIViewContentModeScaleAspectFill;
        if (message.nativePhoto) {
            CGSize photoSize = [[CommUtilHelper sharedInstance] scaleToSize:message.photo.size MaxWidth:screenWidth MaxHeight:screenHeight];
            //居中对齐
            float x = 0;
            if(photoSize.width < screenWidth){
                x = (screenWidth-photoSize.width)/2;
            }
            float y = 0;
            if(photoSize.height < screenHeight){
                y = (screenHeight-photoSize.height)/2;
            }
            //[self.photoImageView setImageWithURL:nil placeholer:message.nativePhoto showActivityIndicatorView:NO];
            //[self.photoImageView setFrame:CGRectMake(x, y, photoSize.width,photoSize.height)];
            [_zoomScrollView.imageView setImageWithURL:nil placeholer:message.nativePhoto showActivityIndicatorView:NO];
            [_zoomScrollView.imageView setFrame:CGRectMake(x, y, photoSize.width,photoSize.height)];
        }else{
            //先检查本地是否存在，存在则直接显示，不存在则显示网络图片
            if (message.imageNativePath) {
                NSMutableArray *imgArr =[[NSMutableArray alloc] initWithArray: [message.imageNativePath  componentsSeparatedByString:@"/"]];
                NSString *fileName = nil;
                if ([imgArr count]) {
                    fileName =  [imgArr objectAtIndex:imgArr.count-1];
                }else{
                    fileName = message.imageNativePath;
                }
                NSString *filePath = [[CommUtilHelper sharedInstance] dataImagePath:fileName];
                if([[NSFileManager defaultManager] fileExistsAtPath:filePath]){
                    NSData *imgData = [[NSData alloc] initWithContentsOfFile:filePath];
                  
                    //self.photoImageView.image = [[UIImage alloc] initWithData:imgData];
                    //_zoomScrollView.imageView.image = [[UIImage alloc] initWithData:imgData];
                    
                    CGSize photoSize = [[CommUtilHelper sharedInstance] scaleToSize:[[UIImage alloc] initWithData:imgData].size MaxWidth:screenWidth MaxHeight:screenHeight];
                    //居中对齐
                    float x = 0;
                    if(photoSize.width < screenWidth){
                        x = (screenWidth-photoSize.width)/2;
                    }
                    float y = 0;
                    if(photoSize.height < screenHeight){
                        y = (screenHeight-photoSize.height)/2;
                    }
                    //[self.photoImageView setImageWithURL:nil placeholer:message.nativePhoto showActivityIndicatorView:NO];
                    //[self.photoImageView setFrame:CGRectMake(x, y, photoSize.width,photoSize.height)];
                    [_zoomScrollView.imageView setImageWithURL:nil placeholer:[[UIImage alloc] initWithData:imgData] showActivityIndicatorView:NO];
                    [_zoomScrollView.imageView setFrame:CGRectMake(x, y, photoSize.width,photoSize.height)];
                    
                }else{
                    if(message.originPhotoUrl){
                        //[self.photoImageView setImageWithURL:[NSURL URLWithString:[message originPhotoUrl]] placeholer:message.photo];
                         CGSize pSize = message.photo.size;
                         float pHeight =(screenWidth/pSize.width)*pSize.height;
                         [_zoomScrollView.imageView setFrame:CGRectMake( 0, (screenHeight-pHeight)/2, screenWidth,(screenWidth/pSize.width)*pSize.height)];
                         [ _zoomScrollView.imageView setImageWithURL:[NSURL URLWithString:[message originPhotoUrl]] placeholer:message.photo];
                        
                    }
                }
            }
        }
    }
}

#pragma mark - Life cycle

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden=NO;
    if ([self.message messageMediaType] == XHBubbleMessageMediaTypeVideo) {
        [self.moviePlayerController stop];
    }
}

-(void)closeController
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden=YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
   // self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStyleDone  target:self action:@selector(savePic)];
    tapValue = true;
    self.automaticallyAdjustsScrollViewInsets = NO;
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor blackColor];
    
//    UIPinchGestureRecognizer *pinchRecognizer = [[UIPinchGestureRecognizer alloc]
//                                                 initWithTarget:self action:@selector(scale:)];
//    [pinchRecognizer setDelegate:self];
//    [self.view addGestureRecognizer:pinchRecognizer];
//    
    UITapGestureRecognizer *tapRecongnizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ShowOrHideTopHeader:)];
    tapRecongnizer.delegate = self;
    [self.view addGestureRecognizer:tapRecongnizer];
   
    
}
-(void)savePic
{
    UIImage *image = self.zoomScrollView.imageView.image;
    if (image) {
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    }
}
// 指定回调方法
- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo
{
    NSString *msg = nil ;
    if(error != NULL){
        msg = @"Failure" ;
         [self.view.window showHUDWithText:msg Type:ShowPhotoNo Enabled:YES];
    }else{
        msg = @"Success" ;
         [self.view.window showHUDWithText:msg Type:ShowPhotoYes Enabled:YES];
    }
   
}
-(void)ShowOrHideTopHeader:(UIGestureRecognizer *)gesture
{
    if ([gesture state] == UIGestureRecognizerStateEnded) {
        if (tapValue) {
            //self.navigationController.navigationBar.hidden=YES;
            navagationView.hidden=YES;
            tapValue = false;
        }else
        {
        //self.navigationController.navigationBar.hidden=NO;
            navagationView.hidden=NO;
            tapValue = true;
        }
        
    }
}
-(void)scale:(id)sender {
    [self.view bringSubviewToFront:[(UIPinchGestureRecognizer*)sender view]];
    //当手指离开屏幕时,将lastscale设置为1.0
    if([(UIPinchGestureRecognizer*)sender state] == UIGestureRecognizerStateEnded) {
        lastScale = 1.0;
        return;
    }
    CGFloat scale = 1.0 - (lastScale - [(UIPinchGestureRecognizer*)sender scale]);
    CGAffineTransform currentTransform = [(UIPinchGestureRecognizer*)sender view].transform;
    CGAffineTransform newTransform = CGAffineTransformScale(currentTransform, scale, scale);
    [[(UIPinchGestureRecognizer*)sender view] setTransform:newTransform];
    lastScale = [(UIPinchGestureRecognizer*)sender scale];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return ![gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]];
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

- (void)dealloc {
    [_moviePlayerController stop];
    _moviePlayerController = nil;
    
    _photoImageView = nil;
}

#pragma mark 代理方法







#pragma mark 属性get方法

- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
    }
    return _scrollView;
}





@end
