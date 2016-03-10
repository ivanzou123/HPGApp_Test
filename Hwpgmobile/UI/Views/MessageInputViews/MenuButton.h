//
//  MenuButton.h
//  HPGApp
//
//  Created by hwpl on 15/11/25.
//  Copyright © 2015年 hwpl hwpl. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol menuButtonDeletegate <NSObject>

-(void)meneButtonClicked:(NSString *)url;

@end

@interface MenuButton : UIButton

@property(nonatomic,copy) NSString *url;
@property(nonatomic,weak)id<menuButtonDeletegate> delegate;
@end
