//
//  UIGridViewDelegate.h
//  foodling2
//
//  Created by Tanin Na Nakorn on 3/6/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIGridView.h"
@protocol UIGridViewDelegate


@optional
- (void) gridView:(UIGridView *)grid didSelectRowAt:(int)rowIndex AndColumnAt:(int)columnIndex Cell:(UIGridViewCell *)cell;

- (void) tableView:(UITableView *)tableView didSelectIndexPath:(NSIndexPath *)indexPath;
-(void) reloadSections:(NSIndexSet *) indexSet;
@required

- (CGFloat) gridView:(UIGridView *)grid widthForColumnAt:(NSIndexPath *)indexPath;
- (CGFloat) gridView:(UIGridView *)grid heightForRowAt:(NSIndexPath *)indexPath;

- (NSInteger) numberOfColumnsOfGridView:(UIGridView *) grid;
- (NSInteger) numberOfCellsOfGridView:(UIGridView *) grid;

-(NSInteger) numberOfSection:(UITableView *)tableView;
-(NSInteger) numberOfRwosInSection:(UITableView *)tableView;
- (UIGridViewCell *) gridView:(UIGridView *)grid cellForRowAt:(int)rowIndex AndColumnAt:(int)columnIndex IndexPath:(NSIndexPath *)indexPath;

- (UITableViewCell *) gridView:(UITableView *)tableview  otherIndexPath:(NSIndexPath *)indexPath Identifer:(NSString *)identifer;

@end

