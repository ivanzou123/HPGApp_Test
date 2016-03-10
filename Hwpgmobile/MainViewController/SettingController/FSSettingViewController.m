//
//  FSSettingViewController.m
//  HPGApp
//
//  Created by hwpl on 15/10/26.
//  Copyright © 2015年 hwpl hwpl. All rights reserved.
//
#import "FSWebServiceUtil.h"
#import "FSSettingViewController.h"
#import "CommUtilHelper.h"
#import "ResponseModel.h"
#import "CustomLoadingView.h"
#import "JSON.h"
#import "ResponseModel.h"
@interface FSsettingCell()
{
    NSDictionary *tempDic;
}
@end
@implementation FSsettingCell
@synthesize slider;
@synthesize dic;
@synthesize source;
@synthesize indexPath;
@synthesize infoArr;
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self= [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        slider = [[UISwitch alloc] initWithFrame:CGRectMake(self.frame.size.width-60, 5,60, 30)];
        [slider addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
       [self addSubview:slider];
    }
    return self;
}
-(void)switchAction:(UISwitch *)s
{
    @try {
        
       tempDic = [infoArr objectAtIndex:indexPath.section];
    //NSString *a= [tempDic description];
    
    if (tempDic !=nil) {
        
        NSMutableArray *rsArr = [tempDic objectForKey:@"subOptions"];
        
        NSMutableDictionary *rsDic =[rsArr objectAtIndex:indexPath.row];
        
        //[rsArr removeAllObjects];
        //[rsArr addObject:rsDic];
        
      
        
        if (slider.on) {
            
            [rsDic setObject:@"0" forKey:@"optionType"];
            
        }else
        {
            [rsDic setObject:@"1" forKey:@"optionType"];
        }
       // NSMutableArray *rsArr2 = [tempDic objectForKey:@"subOptions"];
        //NSString *dataInfo = [NSString stringWithFormat:@"%@_%@_%@_%@",projectId,staffId,msgTypeId,sendType];
       
        NSString *dataInfo = [dic JSONFragment];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
          ResponseModel *model =  [[FSWebServiceUtil sharedInstance] updateSendType:dataInfo withSource:source];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (model.error !=nil) {
                    
                }
            });
        });
    }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }

}

@end

@interface FSSettingViewController ()
{
    NSMutableArray *infoArr;
    UITableView *fsTableView;
    NSInteger count;
    NSInteger row;
    NSMutableArray *sectionArr;
     NSMutableArray *titleArr;
}
@end

@implementation FSSettingViewController
@synthesize source;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Setting";
    [self.view setBackgroundColor:[UIColor whiteColor]];
    fsTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight) style:UITableViewStyleGrouped];
    fsTableView.delegate=self;
    fsTableView.dataSource = self;
    [self.view addSubview:fsTableView];
    sectionArr = [[NSMutableArray alloc] init];
    titleArr = [[NSMutableArray alloc] init];
    count = 0;
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    UIView *loadingview = [[CustomLoadingView alloc] getLoaidngViewByText:@"loading..." Frame:CGRectMake(screenWidth/2-25, screenHeight/2-25, 50, 50)];
    
    [self.view addSubview:loadingview];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        ResponseModel *response = [[FSWebServiceUtil sharedInstance] getMsgCatalogList:[[CommUtilHelper sharedInstance] getUser] withSource:source];
        NSDictionary *userDic = response.resultInfo;
        
        if (userDic !=nil) {
           infoArr =  [userDic objectForKey:@"RESULT"];
            
        }
       NSString *error =  [userDic objectForKey:@"ERROR"];
       
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [loadingview removeFromSuperview];
            
            if ([error isKindOfClass:[NSNull class]]) {
                return ;
            }
            
            if(error !=nil && ![@"" isEqualToString:error]) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Prompt" message:error delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [alertView show];
                return;
            }
            for (int i=0; i<[infoArr count]; i++){
                NSDictionary *infoDic = [infoArr objectAtIndex:i];
                NSString *optionName = [infoDic objectForKey:@"optionName"];
                NSMutableArray *subOptionArr = [infoDic objectForKey:@"subOptions"];
                if (subOptionArr !=nil) {
                    [sectionArr addObject:[NSString stringWithFormat:@"%li",[subOptionArr count]]];
                }
                [titleArr addObject:optionName];

            }
            [fsTableView reloadData];
        });
    });
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

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FSsettingCell *cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"fscell_%li_%li",indexPath.section,indexPath.row]];
    if (cell == nil) {
        cell = [[FSsettingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[NSString stringWithFormat:@"fscell_%li_%li",indexPath.section,indexPath.row]];
    }
    NSDictionary *rsDic = [infoArr objectAtIndex:indexPath.section];
    NSMutableArray *arr = [rsDic objectForKey:@"subOptions"];
    NSDictionary *infoDic = [arr objectAtIndex:indexPath.row];
    //NSString *projectId = [infoDic objectForKey:@"PROJECTID"];
    cell.textLabel.text=[infoDic objectForKey:@"optionName"];
    [cell.textLabel setFont:[UIFont systemFontOfSize:14]];
    cell.dic = rsDic;
    cell.infoArr=infoArr;
    cell.source=source;
    cell.indexPath=indexPath;
    NSString *type = [[infoDic objectForKey:@"optionType"] stringValue];
    if ([@"0" isEqualToString:type]) {
        cell.slider.on=YES;
    }else
    {
        cell.slider.on = NO;
    }
   // cell.textLabel.text=[infoDic objectForKey:@"STAFFID"];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

//-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    return  [titleArr objectAtIndex:section];
//}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 20)];
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 250, 20)];
    lable.text =[titleArr objectAtIndex:section];
    [lable  setFont:[UIFont systemFontOfSize:12]];
    [lable  setTextColor:[UIColor grayColor]];
    [view addSubview:lable];
    
//    UISwitch *slider = [[UISwitch alloc] initWithFrame:CGRectMake(screenWidth-60, 5, 50, 28)];
//    [slider addTarget:self action:@selector(controlAllSwitch:) forControlEvents:UIControlEventValueChanged];
//    slider.tag = 100+section;
//    [view addSubview:slider];
    return view;
}
-(void)controlAllSwitch:(UISwitch *)slider
{
    NSInteger section = slider.tag-100;
    if ([infoArr count]>0) {
        NSMutableDictionary *rsDic = [infoArr objectAtIndex:section];
        NSMutableArray *rsArr = [rsDic objectForKey:@"subOptions"];
       // NSMutableDictionary *rsDic =[rsArr objectAtIndex:section];
        for (int i=0; i<[rsArr count]; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:section];
            FSsettingCell *cell = [fsTableView cellForRowAtIndexPath:indexPath];
            cell.slider.on=slider.on;
        }
        for (int i=0; i<[rsArr count]; i++) {
            NSMutableDictionary *rsDic =[rsArr objectAtIndex:i];
            if (slider.on) {
                
                [rsDic setObject:@"0" forKey:@"optionType"];
                
            }else
            {
                [rsDic setObject:@"1" forKey:@"optionType"];
            }

        }
        NSString *dataInfo = [rsDic JSONFragment];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            ResponseModel *model =  [[FSWebServiceUtil sharedInstance] updateSendType:dataInfo withSource:source];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (model.error !=nil) {
                    
                }
            });
        });
        
       
    }
    
}
//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(screenWidth/2-100, 5, 200, 25)];
//    l.text = [titleArr objectAtIndex:section-1];
//    return l;
//}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [sectionArr count];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *rows =  [sectionArr objectAtIndex:section];
    return  [rows integerValue];
}
@end
