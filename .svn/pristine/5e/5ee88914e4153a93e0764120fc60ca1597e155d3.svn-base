//
//  UIGridViewView.m
//  foodling2
//
//  Created by Tanin Na Nakorn on 3/6/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "UIGridView.h"
#import "UIGridViewDelegate.h"
#import "UIGridViewCell.h"
#import "UIGridViewRow.h"

@implementation UIGridView


@synthesize uiGridViewDelegate;


-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        [self setUp];
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        
    }
    return self;
}
- (id) initWithCoder:(NSCoder *)aDecoder
{
	
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setUp];
        
		self.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return self;
}


- (void) setUp
{
	self.delegate = self;
	self.dataSource = self;
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code.
}
*/

- (void)dealloc {
	self.delegate = nil;
	self.dataSource = nil;
	self.uiGridViewDelegate = nil;
    
}

- (UIGridViewCell *) dequeueReusableCell
{
	UIGridViewCell* temp = tempCell;
    //UIGridViewCell* temp = [[UIGridViewCell alloc] init];
	tempCell = nil;
	return temp;
}


// UITableViewController specifics


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [uiGridViewDelegate numberOfSection:tableView];
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
        
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
    }else
    {
        [uiGridViewDelegate tableView:tableView didSelectIndexPath:indexPath];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        int residue =  (int)([uiGridViewDelegate numberOfCellsOfGridView:self] % [uiGridViewDelegate numberOfColumnsOfGridView:self]);
        
        if (residue > 0) residue = 1;
        return ([uiGridViewDelegate numberOfCellsOfGridView:self] / [uiGridViewDelegate numberOfColumnsOfGridView:self]) + residue;
    }else
    {
        //分2ge section
        return [uiGridViewDelegate numberOfRwosInSection:tableView];
    }
	
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    }
    return 4;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view  = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 4)];
    [view setBackgroundColor:[UIColor clearColor]];
    return view;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view  = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 4)];
    [view setBackgroundColor:[UIColor clearColor]];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [uiGridViewDelegate gridView:self heightForRowAt:indexPath];
}


-(void)deleteRowsAtColms:(UIGridViewCell *)cell withRowAnimation:(UITableViewRowAnimation *)animation
{
    
    [cell removeFromSuperview];
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // NSString *CellIdentifier = [NSString stringWithFormat:@"UIGridViewRow",(int)indexPath.row] ;
    NSString *CellIdentifier = @"gridCell";
    if (indexPath.section == 0) {
       UIGridViewRow *row = (UIGridViewRow *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (row == nil) {
            row = [[UIGridViewRow alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
        }
        
        int numCols = (int)[uiGridViewDelegate numberOfColumnsOfGridView:self];
        int count = (int)[uiGridViewDelegate numberOfCellsOfGridView:self];
        
        CGFloat x = 0.0;
        CGFloat height = [uiGridViewDelegate gridView:self heightForRowAt:indexPath];
       
        for (int i=0;i<numCols;i++) {
            
            if ((i + indexPath.row * numCols) >= count) {
                
                if ([row.contentView.subviews count] > i) {
                    ((UIGridViewCell *)[row.contentView.subviews objectAtIndex:i]).hidden = YES;
                }
                
                continue;
            }
//            
            if ([row.contentView.subviews count] > i) {
                
                tempCell = [row.contentView.subviews objectAtIndex:i];
                
            } else {
                tempCell = nil;
            }
            
            UIGridViewCell *cell = [uiGridViewDelegate gridView:self
                                                   cellForRowAt:indexPath.row
                                                    AndColumnAt:i IndexPath:indexPath];
            
            
            if (cell.superview != row.contentView) {
                
                [cell removeFromSuperview];
                [row.contentView addSubview:cell];
                [cell addTarget:self action:@selector(cellPressed:) forControlEvents:UIControlEventTouchUpInside];
            }
            
            cell.hidden = NO;
            cell.rowIndex = (int)indexPath.row;
            cell.colIndex = i;
            
            CGFloat thisWidth = [uiGridViewDelegate gridView:self widthForColumnAt:indexPath ];
            if (screenWidth >320 && cell.colIndex == 0) {
                x=30;
            }
            cell.frame = CGRectMake(x, 6, thisWidth, height);
            x += thisWidth;
        }
        
        row.frame = CGRectMake(row.frame.origin.x,
                               row.frame.origin.y,
                               x,
                               height);
        return row;
    }else
    {
        UITableViewCell *cell=[uiGridViewDelegate gridView:self otherIndexPath:indexPath Identifer:@"cell"];
        
                    return cell;
    }
    
    
}


- (void) cellPressed:(id) sender
{
	UIGridViewCell *cell = (UIGridViewCell *) sender;
	[uiGridViewDelegate gridView:self didSelectRowAt:cell.rowIndex AndColumnAt:cell.colIndex Cell:cell];
}
-(void)deleteRowsAtIndexPaths:(NSArray *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation
{
}

@end
