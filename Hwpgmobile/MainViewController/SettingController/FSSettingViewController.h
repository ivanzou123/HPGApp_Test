//
//  FSSettingViewController.h
//  HPGApp
//
//  Created by hwpl on 15/10/26.
//  Copyright © 2015年 hwpl hwpl. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface FSsettingCell : UITableViewCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
@property(nonatomic,retain) UISwitch *slider;
@property(nonatomic,retain) NSDictionary *dic;
@property(nonatomic,retain) NSMutableArray *infoArr;
@property(nonatomic,copy) NSString *source;
@property(nonatomic,retain) NSIndexPath *indexPath;
@end

@interface FSSettingViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,copy) NSString *source;
@end
