//
//  ImageCropperViewController.m
//  HwpgMobile
//
//  Created by test on 12/5/14.
//  Copyright (c) 2014 hwpl hwpl. All rights reserved.
//

#import "ImageCropper.h"
#import "VPImageCropperViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "CommUtilHelper.h"
#import "eChatDAO.h"
#import "SocketIO.h"
#import "SocketIOConnect.h"
#import "ChatViewController.h"

static const float MAX_HEAD_PHOTO_WIDTH = 40.0f;
static const float MAX_HEAD_PHOTO_HEIGHT = 40.0f;

@interface ImageCropper()<UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate, VPImageCropperDelegate,SocketIODelegate>{
    UIImageView *theImageView;
}

@end

static ImageCropper *instance = nil;

@implementation ImageCropper
//初始化单例
+(ImageCropper *)sharedImageCropper:(UIViewController *) fromViewController CanTap:(BOOL) canTap GroupId:(NSString *) groupId
{
    @synchronized(self)
    {
        if (instance==nil) {
            instance = [[ImageCropper alloc] init];
        }
        instance.fromViewController = fromViewController;
        instance.canTap = canTap;
        instance.groupId = groupId;
    }
    return instance;
}
#pragma mark getImageView getter
//设置圆形头像视图
- (void)setImageView:(UIImageView *) imageView {
    //如果为空，则设置为默认头像
    if(imageView.image == nil){
        imageView.image = [UIImage imageNamed:@"default-60.jpg"];
    }
    CGRect rect = CGRectMake(0.0f, 0.0f, MAX_HEAD_PHOTO_WIDTH, MAX_HEAD_PHOTO_HEIGHT);
    [imageView setFrame:rect];
    [imageView.layer setCornerRadius:(imageView.frame.size.height/2)];
    [imageView.layer setMasksToBounds:YES];
    [imageView setContentMode:UIViewContentModeScaleAspectFill];
    [imageView setClipsToBounds:YES];
    imageView.layer.borderColor = [[UIColor whiteColor] CGColor];
    imageView.backgroundColor = [UIColor whiteColor];
    //imageView.layer.shadowColor = [UIColor grayColor].CGColor;
    //imageView.layer.shadowOffset = CGSizeMake(4, 4);
    //imageView.layer.shadowOpacity = 0.5;
    //imageView.layer.shadowRadius = 2.0;
    //imageView.layer.borderWidth = 2.0f;
    if(self.canTap){
        imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showSelectPhotoMenu:)];
        [imageView addGestureRecognizer:tapGesture];
    }
    theImageView = imageView;
}
//弹出菜单
- (void)showSelectPhotoMenu:(UITapGestureRecognizer *) fromGesture  {
    UIActionSheet *choiceSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Camera", @"Album", nil];
    [choiceSheet showInView:fromGesture.view];
}

#pragma mark VPImageCropperDelegate
//截图完成时调用的方法
- (void)imageCropper:(VPImageCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage {
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
        //如果没有设置imageView，则直接返回
        if(!theImageView) return;
        //
        theImageView.image = editedImage;
        //save image
        NSString *photoName =[[[CommUtilHelper sharedInstance] createUUID] stringByAppendingString:@".png"];
        NSString *savedImagePath=[[CommUtilHelper sharedInstance] dataImagePath:photoName];
        NSData *imageData =UIImageJPEGRepresentation(editedImage, 1.0);
        [imageData writeToFile:savedImagePath atomically:YES];
        //得到当前用户
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        NSString *user =  [ud objectForKey:@"user"];
        //保存到本地数据库
        BOOL isSaved= false;
        if(self.groupId && [self.groupId integerValue] > 0){
            //保存群头像
            isSaved = [[eChatDAO sharedChatDao] updateGroupHeadPhoto:[NSString stringWithFormat:@"%@",self.groupId] ImagePath:photoName];
        }else{
            //保存个人头像
            isSaved = [[eChatDAO sharedChatDao] updateHeadPhoto:user ImagePath:photoName];
        }
        if(isSaved){
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            NSString *_encodeBase64 = [imageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
            //
            [dict setObject:user forKey:@"from"];
            [dict setObject:self.groupId forKey:@"groupid"];
            [dict setObject:@"image/png" forKey:@"imgType"];
            [dict setObject:_encodeBase64 forKey:@"imgData"];
            [dict setObject:[CommUtilHelper getDeviceId] forKey:@"deviceId"];
            [[ChatViewController sharedInstance] sendMsg:dict Event:@"setHeadPhoto"];
        }
    }];
}

- (void)imageCropperDidCancel:(VPImageCropperViewController *)cropperViewController {
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
    }];
}

#pragma mark UIActionSheetDelegate

-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        // 拍照
        if ([self isCameraAvailable] && [self doesCameraSupportTakingPhotos]) {
            UIImagePickerController *controller = [[UIImagePickerController alloc] init];
            controller.sourceType = UIImagePickerControllerSourceTypeCamera;
            if ([self isRearCameraAvailable]) {
                controller.cameraDevice = UIImagePickerControllerCameraDeviceRear;
            }
            NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
            [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
            controller.mediaTypes = mediaTypes;
            controller.delegate = self;
            [instance.fromViewController presentViewController:controller
                                                      animated:YES
                                                    completion:^(void){
                                                        NSLog(@"Picker View Controller is presented");
                                                    }];
        }
        
    } else if (buttonIndex == 1) {
        // 从相册中选取
        if ([self isPhotoLibraryAvailable]) {
            UIImagePickerController *controller = [[UIImagePickerController alloc] init];
            controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
            [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
            controller.mediaTypes = mediaTypes;
            controller.delegate = self;
            [instance.fromViewController presentViewController:controller
                                                      animated:YES
                                                    completion:^(void){
                                                        NSLog(@"Picker View Controller is presented");
                                                    }];
        }
    }
}

//- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
//    if (buttonIndex == 0) {
//        // 拍照
//        if ([self isCameraAvailable] && [self doesCameraSupportTakingPhotos]) {
//            UIImagePickerController *controller = [[UIImagePickerController alloc] init];
//            controller.sourceType = UIImagePickerControllerSourceTypeCamera;
//            if ([self isRearCameraAvailable]) {
//                controller.cameraDevice = UIImagePickerControllerCameraDeviceRear;
//            }
//            NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
//            [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
//            controller.mediaTypes = mediaTypes;
//            controller.delegate = self;
//            [self.fromViewController presentViewController:controller
//                               animated:YES
//                             completion:^(void){
//                                 NSLog(@"Picker View Controller is presented");
//                             }];
//        }
//
//    } else if (buttonIndex == 1) {
//        // 从相册中选取
//        if ([self isPhotoLibraryAvailable]) {
//            UIImagePickerController *controller = [[UIImagePickerController alloc] init];
//            controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//            NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
//            [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
//            controller.mediaTypes = mediaTypes;
//            controller.delegate = self;
//            [self.fromViewController presentViewController:controller
//                               animated:YES
//                             completion:^(void){
//                                 NSLog(@"Picker View Controller is presented");
//                             }];
//        }
//    }
//}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:^() {
        UIImage *portraitImg = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        portraitImg = [self imageByScalingToMaxSize:portraitImg];
        // present the cropper view controller
        VPImageCropperViewController *imgCropperVC = [[VPImageCropperViewController alloc] initWithImage:portraitImg cropFrame:CGRectMake(0, 100.0f, self.fromViewController.view.frame.size.width, self.fromViewController.view.frame.size.width) limitScaleRatio:3.0];
        imgCropperVC.delegate = self;
        [self.fromViewController presentViewController:imgCropperVC animated:YES completion:^{
            // TO DO
        }];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^(){
    }];
}

#pragma mark image scale utility
- (UIImage *)imageByScalingToMaxSize:(UIImage *)sourceImage {
    if (sourceImage.size.width < screenHeight) return sourceImage;
    CGFloat btWidth = 0.0f;
    CGFloat btHeight = 0.0f;
    if (sourceImage.size.width > sourceImage.size.height) {
        btHeight = screenHeight;
        btWidth = sourceImage.size.width * (screenHeight / sourceImage.size.height);
    } else {
        btWidth = screenHeight;
        btHeight = sourceImage.size.height * (screenHeight / sourceImage.size.width);
    }
    CGSize targetSize = CGSizeMake(btWidth, btHeight);
    return [self imageByScalingAndCroppingForSourceImage:sourceImage targetSize:targetSize];
}

- (UIImage *)imageByScalingAndCroppingForSourceImage:(UIImage *)sourceImage targetSize:(CGSize)targetSize {
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else
            if (widthFactor < heightFactor)
            {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
    }
    UIGraphicsBeginImageContext(targetSize); // this will crop
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil) NSLog(@"could not scale image");
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}

#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
}

#pragma mark camera utility
- (BOOL) isCameraAvailable{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) isRearCameraAvailable{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
}

- (BOOL) isFrontCameraAvailable {
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
}

- (BOOL) doesCameraSupportTakingPhotos {
    return [self cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) isPhotoLibraryAvailable{
    return [UIImagePickerController isSourceTypeAvailable:
            UIImagePickerControllerSourceTypePhotoLibrary];
}
- (BOOL) canUserPickVideosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeMovie sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}
- (BOOL) canUserPickPhotosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (BOOL) cameraSupportsMedia:(NSString *)paramMediaType sourceType:(UIImagePickerControllerSourceType)paramSourceType{
    __block BOOL result = NO;
    if ([paramMediaType length] == 0) {
        return NO;
    }
    NSArray *availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:paramSourceType];
    [availableMediaTypes enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *mediaType = (NSString *)obj;
        if ([mediaType isEqualToString:paramMediaType]){
            result = YES;
            *stop= YES;
        }
    }];
    return result;
}


@end
