//
//  DropDown1.m
//  M_CRM
//
//  Created by leoli on 14/11/17.
//  Copyright (c) 2014年 邱健. All rights reserved.
//

#import "DropDownList.h"


@implementation DropDownList

@synthesize tv,tableArray,tField,btnbutton;

- (void)dealloc
{
    [tv release];
    [tableArray release];
    [tField release];
    [btnbutton release];
    [super dealloc];
}

-(id)initWithFrame:(CGRect)frame
{
   
    if (frame.size.height<200) {
        frameHeight = 200;
    }else{
        frameHeight = frame.size.height;
    }
    tabheight = frameHeight-30;
    
    frame.size.height = 30.0f;
    
    self=[super initWithFrame:frame];
    
    if(self){
        showList = NO; //默认不显示下拉框
        
        tv = [[UITableView alloc] initWithFrame:CGRectMake(0, 45, frame.size.width, 0)];
        tv.delegate = self;
        tv.dataSource = self;
        tv.backgroundColor = [UIColor blackColor];
       
        tv.separatorColor = [UIColor lightGrayColor];
        tv.hidden = YES;
        tv.layer.cornerRadius = 8;
        tv.layer.masksToBounds = YES;
        [self addSubview:tv];
        
        tField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 45)];
       
        tField.returnKeyType = UIReturnKeyDone;//设置回车键类型
        
        tField.borderStyle=UITextBorderStyleRoundedRect;//设置文本框的边框风格
        tField.delegate = self;
        tField.enabled = NO;
        //[tField addTarget:self action:@selector(dropdown) forControlEvents:UIControlEventAllTouchEvents];
        
        btnbutton= [[UIButton alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 45)];
        btnbutton.backgroundColor = [UIColor clearColor];
        
        [btnbutton addTarget:self action:@selector(dropdown) forControlEvents:UIControlEventTouchDown];
        
        [self addSubview:tField];
        [self addSubview:btnbutton];

        
    }
    return self;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    [tField resignFirstResponder];
    
    //[self showPickerView];// 这个方法可以实现一些picker动画显示效果
    
}
- (void)hideKeyboard:(id)sender
{
    [tField resignFirstResponder];
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [tField resignFirstResponder];
    
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [tField resignFirstResponder];
    return YES;
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{ //隐藏键盘
    [tField resignFirstResponder];
    showList = NO;
    tv.hidden = YES;
    
    CGRect sf = self.frame;
    sf.size.height = 45;
    self.frame = sf;
    CGRect frame = tv.frame;
    frame.size.height = 0;
    tv.frame = frame;
}
-(void)dropdown{
    
    if (showList) {//如果下拉框已显示，什么都不做
        [tField resignFirstResponder];
        showList = NO;
        tv.hidden = YES;
        
        CGRect sf = self.frame;
        sf.size.height = 45;
        self.frame = sf;
        CGRect frame = tv.frame;
        frame.size.height = 0;
        tv.frame = frame;

        //return;
    }else {//如果下拉框尚未显示，则进行显示
        [tField resignFirstResponder];
        CGRect sf = self.frame;
        sf.size.height = frameHeight;
        
        //把dropdownList放到前面，防止下拉框被别的控件遮住
        [self.superview bringSubviewToFront:self];
        tv.hidden = NO;
        showList = YES;//显示下拉框
        
        CGRect frame = tv.frame;
        frame.size.height = 0;
        tv.frame = frame;
        frame.size.height = 120;
        [UIView beginAnimations:@"ResizeForKeyBoard" context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveLinear];
        self.frame = sf;
        tv.frame = frame;
        [UIView commitAnimations];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [tableArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    NSString *ValueAndID = [tableArray objectAtIndex:[indexPath row]];
    NSArray *ValueAndIDArray = [ValueAndID componentsSeparatedByString:@"_"];
    NSString *ID =[ValueAndIDArray objectAtIndex:0];
    NSString *Value =[ValueAndIDArray objectAtIndex:1];

    
    cell.textLabel.text = Value;
    cell.textLabel.tag=ID;
    
    cell.textLabel.font = [UIFont systemFontOfSize:16.0f];
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.backgroundColor= [UIColor colorWithRed:221.0/255.0 green:221.0/255.0 blue:221.0/255.0 alpha:1.0];
    cell.selectedBackgroundView = [[[UIView alloc] initWithFrame:cell.frame] autorelease];
    cell.selectedBackgroundView.backgroundColor = [UIColor colorWithRed:0.0/255.0 green:153.0/255.0 blue:204.0/255.0 alpha:1.0];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 35;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *ValueAndID = [tableArray objectAtIndex:[indexPath row]];
    NSArray *ValueAndIDArray = [ValueAndID componentsSeparatedByString:@"_"];
    NSString *ID =[ValueAndIDArray objectAtIndex:0];
    NSString *Value =[ValueAndIDArray objectAtIndex:1];

    
    tField.text = Value;
    tField.tag = [ID integerValue];
    showList = NO;
    tv.hidden = YES;
    
    CGRect sf = self.frame;
    sf.size.height = 35;
    self.frame = sf;
    CGRect frame = tv.frame;
    frame.size.height = 0;
    tv.frame = frame;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end

