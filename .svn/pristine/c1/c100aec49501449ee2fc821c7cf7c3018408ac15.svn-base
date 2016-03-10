//
//  XHContactTableViewCell.h
//  MessageDisplayExample
//
//  Created by ivan on 14-10-28.
//  Copyright (c) 2014年 hwpl hwpl. All rights reserved.

@protocol ContactTableViewImageDelegate <NSObject>

@optional

-(void)ImageViewTapGesture:(NSInteger )index;
-(void)advriteFriend:(NSInteger )index;
@end

#import <UIKit/UIKit.h>

#import "XHContact.h"

typedef NS_ENUM(NSInteger, XHContactType) {
    XHContactTypeNormal = 0,
    XHContactTypeFilter,
};

@interface XHContactTableViewCell : UITableViewCell

@property (nonatomic, strong) XHContact *currentContact;

- (void)configureContact:(XHContact *)contact inContactType:(XHContactType)contactType searchBarText:(NSString *)searchBarText;
@property(nonatomic,assign) id<ContactTableViewImageDelegate> delegate;

@property(nonatomic,retain) UIButton *btnSendEmail;
@property(nonatomic,retain) NSIndexPath *indexPath;
@end
