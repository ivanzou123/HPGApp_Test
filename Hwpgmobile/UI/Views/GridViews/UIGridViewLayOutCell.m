//
//  Cell.m
//  naivegrid
//
//  Created by Apirom Na Nakorn on 3/6/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//
#define manageImageSize 50
#define deleteButtonSize 25
#import "UIGridViewLayOutCell.h"
#import <QuartzCore/QuartzCore.h> 

@implementation UIGridViewLayOutCell


@synthesize thumbnail;
@synthesize label;
@synthesize  deleteButton;

- (id)init {
	
    if (self = [super init]) {
        self.frame = CGRectMake(0, 0, 80, 80);
        thumbnail = [[UIImageView alloc] initWithFrame:CGRectMake(15, 5, manageImageSize, manageImageSize)];
        [thumbnail setContentMode:UIViewContentModeScaleAspectFill];
        deleteButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 0,deleteButtonSize, deleteButtonSize)];
        //
        label = [[UILabel alloc] initWithFrame:CGRectMake(0, 55, 80, 20)];
        [label setFont:[UIFont systemFontOfSize:12]];
        [label setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:thumbnail];
        [self addSubview:label];
        [self addSubview: deleteButton];
		//
		self.thumbnail.layer.masksToBounds = YES;
       [thumbnail.layer setCornerRadius: CGRectGetHeight([thumbnail bounds])/2.0];
        thumbnail.layer.borderColor = [[UIColor whiteColor] CGColor];
        thumbnail.backgroundColor = [UIColor whiteColor];
        //thumbnail.layer.shadowColor = [UIColor grayColor].CGColor;
        //thumbnail.layer.shadowOffset = CGSizeMake(4, 4);
        //thumbnail.layer.shadowOpacity = 0.5;
        //thumbnail.layer.shadowRadius = 2.0;
        //thumbnail.layer.borderWidth = 2.0f;
	}
	
    return self;
	
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code.
}
*/


@end
