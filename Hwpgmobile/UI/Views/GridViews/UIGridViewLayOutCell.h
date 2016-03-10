//
//  Cell.h
//  naivegrid
//
//  Created by Apirom Na Nakorn on 3/6/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIGridViewCell.h"

@interface UIGridViewLayOutCell : UIGridViewCell {

}

@property (nonatomic, retain)  UIImageView *thumbnail;
@property (nonatomic, retain)  UILabel *label;
@property (nonatomic, retain)  UIButton *deleteButton;

@end

