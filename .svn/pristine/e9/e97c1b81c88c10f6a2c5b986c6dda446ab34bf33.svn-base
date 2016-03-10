//
//  CiclrImageTableViewCell.m
//  HPGApp
//
//  Created by hwpl on 15/12/3.
//  Copyright © 2015年 hwpl hwpl. All rights reserved.
//

#import "CiclrImageTableViewCell.h"

@implementation CiclrImageTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self= [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        CGFloat cornerRaius =[self bounds].size.height/2;
        self.imageView.layer.cornerRadius=cornerRaius;
        self.imageView.layer.masksToBounds = YES;
        //self.imageView.image = [UIImage imageNamed:@"rain.jpg"];
    }
    return self;
}

@end
