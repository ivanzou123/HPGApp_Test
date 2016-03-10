//
//  FixViewController.m
//  HPGApp
//
//  Created by hwpl on 15/10/15.
//  Copyright © 2015年 hwpl hwpl. All rights reserved.
//
#import "CommUtilHelper.h"
#import "FixViewController.h"
#import "ChatViewController.h"
@interface FixViewController ()
{
    UITableView *tableView;
}
@end

@implementation FixViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, navBarHeight, screenWidth, screenHeight-navBarHeight) style:UITableViewStylePlain];
    tableView.dataSource=self;
    tableView.delegate =self;
    [[CommUtilHelper sharedInstance] setExtraCellLineHidden:tableView type:nil];
    [self.view addSubview:tableView];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier =[NSString stringWithFormat:@"fixCell_%li",(long)indexPath.row];
    UITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    NSInteger row = indexPath.row;
    if (row == 0) {
        cell.textLabel.text = @"Clear Message BageNumber";
        [cell.textLabel setFont:[UIFont systemFontOfSize:12]];
        UIButton *btnClear = [[UIButton alloc] initWithFrame:CGRectMake(screenWidth-120, 7, 60, 30)];
        [btnClear.layer setBorderColor:[UIColor blueColor].CGColor];
        [btnClear.layer setCornerRadius:3];
        [btnClear.layer setBorderWidth:1];
        [btnClear addTarget:self action:@selector(clearAllBageNumber) forControlEvents:UIControlEventTouchUpInside];
        [btnClear setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [btnClear setTitle:@"clear" forState:UIControlStateNormal];
        [cell.contentView addSubview:btnClear];
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
  
}


-(void)clearAllBageNumber
{
    NSUserDefaults *messageDefault = [NSUserDefaults standardUserDefaults];
    [messageDefault removeObjectForKey:@"messageCountArr"];
    [[ChatViewController sharedInstance] setBadageValue];
    [self.view.window showHUDWithText:@"success" Type:ShowPhotoYes Enabled:YES];
    
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
