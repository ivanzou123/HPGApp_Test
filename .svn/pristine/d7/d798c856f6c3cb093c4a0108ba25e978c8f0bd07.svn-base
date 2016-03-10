//
//  SettingViewController.m
//  Chart
//
//  Created by hwpl hwpl on 14-10-28.
//  Copyright (c) 2014年 hwpl hwpl. All rights reserved.
//

#define biggerFont @"21"
#define normalFont @"16"
#define bigFont @"19"

#import "SettingViewController.h"
#import "ContactViewController.h"
#import "eChatDAO.h"
#import "ImageCropper.h"
#import "CommUtilHelper.h"
#import "XHPhotographyHelper.h"
#import "PushNotificationUtil.h"
#import "UIWindow+YzdHUD.h"
#import "FixViewController.h"
@interface SettingViewController ()<UIPickerViewDataSource,UIPickerViewDelegate,UIActionSheetDelegate>{
    UITableView *view;
    NSString *headImagePath;
    NSString *userTitle;
    NSString *userLocation;
    NSString *userEmail;
    NSString *userPhoneNumber;
    ImageCropper *imageCropper;
    //pickView;
    NSArray *fontPickArr;
    UIPickerView *fontPickerView;
    UIView *fontView;
    
    UIButton *sbt_text;
    UIButton *lbt_text;
    UIButton *mbt_text;
}
@end

@implementation SettingViewController

- (void)viewDidLoad {
   
    self.navigationItem.title=@"Me";
    [self.view setBackgroundColor:[UIColor clearColor]];
    //self.navigationController.navigationBar.barTintColor=[CommUtilHelper getDefaultBackgroupColor];
    //self.navigationController.navigationBar.translucent=YES;
    //self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    [super viewDidLoad];
    //[self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
   self.navigationController.navigationBar.barTintColor=kGetColor(248, 248, 248);
    view = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight) style:UITableViewStylePlain];
    view.delegate=self;
    view.dataSource=self;
    [view setBackgroundColor:[UIColor colorWithRed:245/255.0 green: 245/255.0 blue: 245/255.0 alpha:0.9]];
    [self.view addSubview:view];
    [self setExtraCellLineHidden:view];
    
    [self.view setBackgroundColor:[UIColor grayColor]];
    // Do any additional setup after loading the view.
    //从本地数据库取得头像文件路径
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSMutableArray *userArr = [[eChatDAO sharedChatDao] getUserInfo:[ud objectForKey:@"user"]];
    if(userArr && userArr.count >0) {
        headImagePath =[userArr[0] objectForKey:@"HEAD_PHOTO"];
        userTitle =[userArr[0] objectForKey:@"TITLE"];
        userLocation =[userArr[0] objectForKey:@"LOCATION"];
        userEmail =[userArr[0] objectForKey:@"EMAIL"];
        userPhoneNumber =[userArr[0] objectForKey:@"PHONE"];
    }
    //
    imageCropper = [ImageCropper sharedImageCropper:self CanTap:YES GroupId:@"-1"];
    
    //font 数字初始化
    fontPickArr = [[NSArray alloc] initWithObjects:normalFont,bigFont,biggerFont, nil];
    //[self initPikerViewActionSheet];
    
}

-(void)initPikerViewActionSheet
{

    fontView = [[UIView alloc] initWithFrame:CGRectMake(0, screenHeight, screenWidth, 200)];
    [fontView setBackgroundColor:kGetColor(135, 206 ,250)];
    fontPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 40, fontView.frame.size.width, fontView.frame.size.height-40)];
    
    fontPickerView.delegate=self;
    fontPickerView.dataSource=self;
    [fontPickerView setShowsSelectionIndicator:YES];
    [fontPickerView selectedRowInComponent:0];
    
    [fontPickerView setBackgroundColor:kGetColor(255 ,250 ,240)];
    
    //
    
    UIButton *saveButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [saveButton setBackgroundColor:[UIColor whiteColor]];
    [saveButton setFrame:CGRectMake(fontView.frame.size.width-80, 5, 60, 30)];
    [saveButton setTitle:@"Done" forState:UIControlStateNormal];
    [saveButton addTarget:self action:@selector(saveFont) forControlEvents:UIControlEventTouchUpInside];
  
    [saveButton.layer setCornerRadius:4];
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [cancelButton setBackgroundColor:[UIColor whiteColor]];
    [cancelButton setFrame:CGRectMake(10, 5, 60, 30)];
    [cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cacelSaveFont) forControlEvents:UIControlEventTouchUpInside];
    [cancelButton.layer setCornerRadius:4];
    
    [fontView addSubview:cancelButton];
    [fontView addSubview:saveButton];
    [fontView addSubview:fontPickerView];
    [self.view addSubview:fontView];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tabBarController.tabBar setHidden:NO];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        [cell.textLabel setTextColor:kGetColorAl(0, 0, 0, 0.87)];
        [cell.detailTextLabel setTextColor:kGetColorAl(0, 0, 0, 0.53)];
        
        [cell.textLabel setFont:[UIFont systemFontOfSize:14]];
        [cell.detailTextLabel setFont:[UIFont systemFontOfSize:12]];
        
    }
    //
    int section = (int)indexPath.section;
    int row = (int)indexPath.row;
    switch (section) {
        case 0:
        {
            cell.textLabel.text =[[CommUtilHelper sharedInstance] getCommonName];
            NSString *_filePath = [[CommUtilHelper sharedInstance] dataImagePath:headImagePath ];
            NSFileManager *fileManager = [NSFileManager defaultManager];
            UIImage *img= nil;
            if ([fileManager fileExistsAtPath:_filePath]) {
                NSData *d = [[NSData alloc] initWithContentsOfFile:_filePath];
                UIImage *im = [[UIImage alloc] initWithData:d];
                if (im) {
                    //img =[[[XHPhotographyHelper alloc] init] imageWithImage:im scaledToSize:CGSizeMake(60, 60)];
                    img=im;
                }
                else
                {
                    img = [UIImage imageNamed:@"default2x@2x.jpg"];
                }
            }else
            {
                img = [UIImage imageNamed:@"default2x@2x.jpg"];
            }
            cell.imageView.image=img;
            [imageCropper setImageView:cell.imageView];
            break;
        }
        case 1:
        {
            cell.textLabel.text = @"Title";
            cell.detailTextLabel.text = userTitle==nil?@"":userTitle;
            cell.detailTextLabel.lineBreakMode = NSLineBreakByCharWrapping;
            cell.detailTextLabel.numberOfLines = 0;
        }
            break;
        case 2:
        {
            if(row == 0)
            {
                cell.textLabel.text = @"City";
                cell.detailTextLabel.text = userLocation==nil?@"":userLocation;
                cell.detailTextLabel.lineBreakMode = NSLineBreakByCharWrapping;
                cell.detailTextLabel.numberOfLines = 0;
            }else if(row == 1)
            {
                cell.textLabel.text = @"Email";
                cell.detailTextLabel.text = userEmail==nil?@"":userEmail;
                cell.detailTextLabel.lineBreakMode = NSLineBreakByCharWrapping;
                cell.detailTextLabel.numberOfLines = 0;
            }else if(row == 2)
            {
                cell.textLabel.text = @"Phone";
                cell.detailTextLabel.text = userPhoneNumber==nil?@"":userPhoneNumber;
                cell.detailTextLabel.lineBreakMode = NSLineBreakByCharWrapping;
                cell.detailTextLabel.numberOfLines = 0;
            }else if(row == 3)
            {
                cell.textLabel.text = @"Version";
                cell.detailTextLabel.text = versionNo;
                cell.detailTextLabel.lineBreakMode = NSLineBreakByCharWrapping;
                cell.detailTextLabel.numberOfLines = 0;
            }else if(row == 4)
            {
                 cell.textLabel.text = @"PushNotifiaction";
                 NSUserDefaults *d = [NSUserDefaults standardUserDefaults];
                cell.detailTextLabel.text = [d objectForKey:@"pushNotification"];
                cell.detailTextLabel.lineBreakMode = NSLineBreakByCharWrapping;
                cell.detailTextLabel.numberOfLines = 0;
            }
        }
            break;
        case 3:
        {
            if(row==0)
            {
            cell.textLabel.text=@"Font";
            NSUserDefaults *df = [NSUserDefaults standardUserDefaults];
            NSString *font = [df objectForKey:fontIdentier];
           
            sbt_text = [[UIButton alloc] initWithFrame:CGRectMake(80, 9, 32, 32)];
            [sbt_text setBackgroundImage:[UIImage imageNamed:@"s_text01.png"] forState:UIControlStateNormal];
            [sbt_text addTarget:self action:@selector(selectFont:) forControlEvents:UIControlEventTouchUpInside];
            sbt_text.tag = [normalFont integerValue];
            
            mbt_text = [[UIButton alloc] initWithFrame:CGRectMake(120, 9, 32, 32)];
            [mbt_text setBackgroundImage:[UIImage imageNamed:@"m_text01.png"] forState:UIControlStateNormal];
            [mbt_text addTarget:self action:@selector(selectFont:) forControlEvents:UIControlEventTouchUpInside];
            mbt_text.tag = [bigFont integerValue];
            
            lbt_text = [[UIButton alloc] initWithFrame:CGRectMake(160, 9, 32, 32)];
            [lbt_text setBackgroundImage:[UIImage imageNamed:@"l_text01.png"] forState:UIControlStateNormal];
            [lbt_text addTarget:self action:@selector(selectFont:) forControlEvents:UIControlEventTouchUpInside];
            lbt_text.tag = [biggerFont integerValue];
            
            if ([font isEqualToString:bigFont]){
                [mbt_text setBackgroundImage:[UIImage imageNamed:@"m_text02.png"] forState:UIControlStateNormal];
            }else if([font isEqualToString:biggerFont])
            {
             [lbt_text setBackgroundImage:[UIImage imageNamed:@"l_text02.png"] forState:UIControlStateNormal];
            }else
            {
             [sbt_text setBackgroundImage:[UIImage imageNamed:@"s_text02.png"] forState:UIControlStateNormal];
            }
            [cell.contentView addSubview:sbt_text];
            [cell.contentView addSubview:mbt_text];
            [cell.contentView addSubview:lbt_text];
            }
//            else if(row == 1)
//            {
//            cell.textLabel.text=@"Fix";
//                cell.accessoryType =UITableViewCellAccessoryDisclosureIndicator;
//            }
        }
        default:
            break;
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 40;
    }else if(indexPath.section == 1){
        return 50;
    }else
    {
        return 50;
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 2) {
        return 5;
    }else if(section==3)
    {
        return 1;
    }
    {
        return 1;
    }
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

- (void)setExtraCellLineHidden: (UITableView *)tableView{
    UIView *view1 =[ [UIView alloc]init];
    [view1 setBackgroundColor:[UIColor grayColor]];
    //view1.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view1];
    [tableView setTableHeaderView:view1];
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section ==2) {
        if (indexPath.row == 4) {
            
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            if ([@"YES" isEqualToString:cell.detailTextLabel.text]) {
                return;
            }
            
            UIAlertView *tipView = [[UIAlertView alloc] initWithTitle:@"Prompt" message:@"Register PushNotification?" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"OK", nil];
            [tipView show];
        }

    }else if (indexPath.section == 3)
    {
        NSInteger row = indexPath.row;
        if(row ==0)
        {
        [fontView setFrame:CGRectMake(0, (screenHeight-200-self.tabBarController.tabBar.frame.size.height), screenWidth, 200)];
        }else
        {
            FixViewController *fvc = [[FixViewController alloc] init];
            [self.tabBarController.tabBar setHidden:YES];
            [self.navigationController pushViewController:fvc animated:YES];
        }
        
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (buttonIndex ==1 ) {
        
        [self.view.window showHUDWithText:@"please wait" Type:ShowLoading Enabled:YES];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
         //[self.view.window showHUDWithText:@"please wait" Type:ShowLoading Enabled:YES];
         BOOL isRegiser =  [PushNotificationUtil saveRegistrationInfo];
            dispatch_async(dispatch_get_main_queue(), ^{
                //[self.view.window goTimeInit];
                if (isRegiser) {
                    [self.view.window showHUDWithText:@"success" Type:ShowPhotoYes Enabled:YES];
                }else
                {
                    [self.view.window showHUDWithText:@"failure" Type:ShowPhotoYes Enabled:YES];

                }
              
                [view reloadData];
            });

        });
        
    }
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
#pragma mark pickview datasource

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [fontPickArr count];
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *font = [fontPickArr objectAtIndex:row];
    if ([font isEqualToString:biggerFont]) {
        return  @"Biggest";
    }else if([font isEqualToString:bigFont])
    {
        return @"Bigger";
    }else
    {
        return @"Normal";
    }

    
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
   
   
}

-(void)selectFont:(UIButton *)lbnText
{
    NSInteger btnTag = lbnText.tag;
    NSString *strBtn =[NSString stringWithFormat:@"%i",btnTag];
    
  
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:strBtn forKey:fontIdentier];
   
    [view reloadSections:[NSIndexSet indexSetWithIndex:3] withRowAnimation:UITableViewRowAnimationAutomatic];
}
-(void)saveFont
{
    NSString *strValue = [fontPickArr objectAtIndex:[fontPickerView selectedRowInComponent:0]];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:strValue forKey:fontIdentier];
    [fontView setFrame:CGRectMake(0, screenHeight, screenWidth, 200)];
    [view reloadSections:[NSIndexSet indexSetWithIndex:3] withRowAnimation:UITableViewRowAnimationAutomatic];
}
-(void)cacelSaveFont
{
  [fontView setFrame:CGRectMake(0, screenHeight, screenWidth, 200)];
}
@end
