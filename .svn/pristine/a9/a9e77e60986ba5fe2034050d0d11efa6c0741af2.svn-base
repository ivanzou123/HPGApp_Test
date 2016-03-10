//
//  MessageTableViewCell.m
//  HwpgMobile
//
//  Created by hwpl hwpl on 14-12-11.
//  Copyright (c) 2014年 hwpl hwpl. All rights reserved.
//

#import "MessageTableViewCell.h"

@implementation MessageTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(id)initWithReuserIdentifier:(NSString *)resuerIndenifier TableViewStyle:(UITableViewCellStyle )style
{
    self=[super initWithStyle:style reuseIdentifier:resuerIndenifier];
    if (self) {
        _custTextLable = [[UILabel alloc] initWithFrame:CGRectMake(55, 10, 200, 20)];
        _custDetailTextLable = [[UILabel alloc] initWithFrame:CGRectMake(55, 28, 200, 18)];
        _tip = [[UILabel alloc] initWithFrame:CGRectMake(55, 45, 200, 15)];
        _custImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 40, 40)];
        
        [_custImageView.layer setCornerRadius:CGRectGetHeight([_custImageView bounds]) / 2];
        _custImageView.layer.masksToBounds = YES;
        _custImageView.layer.borderColor = [[UIColor whiteColor] CGColor];
        _custImageView.backgroundColor = [UIColor whiteColor];
        _custImageView.contentMode = UIViewContentModeScaleAspectFit;
        //_custImageView.layer.shadowColor = [UIColor grayColor].CGColor;
        //_custImageView.layer.shadowOffset = CGSizeMake(4, 4);
        //_custImageView.layer.shadowOpacity = 0.5;
        //_custImageView.layer.shadowRadius = 2.0;
        //_custImageView.layer.borderWidth = 2.0f;
        
        [self addSubview:_custTextLable];
        [self addSubview:_custDetailTextLable];
        [self addSubview:_tip];
        [self addSubview:_custImageView];
    }
    return self;
}
@end
