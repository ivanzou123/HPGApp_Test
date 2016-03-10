//
//  PreDisImageViewController.m
//  HwpgMobile
//
//  Created by hwpl on 15/3/18.
//  Copyright (c) 2015年 hwpl hwpl. All rights reserved.
//

#import "PreDisImageViewController.h"
#import "CommUtilHelper.h"
@interface PreDisImageViewController ()

@property(nonatomic,retain) XHMessageTableViewController *_temCon;
@property(nonatomic,strong) UIImageView  *disImageView;

@end

@implementation PreDisImageViewController
@synthesize _temCon;
@synthesize disImageView;
- (void)viewDidLoad {
    self.automaticallyAdjustsScrollViewInsets=NO;
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(PreDisImageViewController *)initWithImageView:(UIImage *)image SendController:(XHMessageTableViewController *)controller
{
    _temCon = controller;
    disImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
    disImageView.image = image;
    [self.view addSubview:disImageView];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"Send" style:UIBarButtonItemStyleDone target:self action:@selector(SendImageAction)];
    [self.view setBackgroundColor:[UIColor blackColor]];

    [self layoutImageView:image];
    return self;
    
}

-(void)layoutImageView:(UIImage *)image
{
    
    CGSize photoSize = [[CommUtilHelper sharedInstance] scaleToSize:image.size MaxWidth:screenWidth MaxHeight:screenHeight];
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
    
    [disImageView setFrame:CGRectMake(x, y-44, photoSize.width,photoSize.height)];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dissMiss
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)SendImageAction
{
    if (_temCon && disImageView.image) {
        [_temCon didSendPhoto:disImageView.image fromSender:[[CommUtilHelper sharedInstance] getUser] onDate:[NSDate date]];
    }
    [self dissMiss];
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
