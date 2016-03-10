//
//  XHContactTableViewCell.m
//  MessageDisplayExample
//
//  Created by ivan on 14-10-28.
//  Copyright (c) 2014年 hwpl hwpl. All rights reserved.

#import "XHContactTableViewCell.h"

@implementation XHContactTableViewCell

- (void)configureContact:(XHContact *)contact inContactType:(XHContactType)contactType searchBarText:(NSString *)searchBarText {
    self.currentContact = contact;
    
    switch (contactType) {
        case XHContactTypeNormal: {
            self.textLabel.text = contact.contactName;
            self.imageView.image = contact.headImage;
            break;
        }
        case XHContactTypeFilter: {
            NSMutableAttributedString *attributedTitle = [[NSMutableAttributedString alloc] initWithString:contact.contactName attributes:@{NSForegroundColorAttributeName: [UIColor colorWithWhite:0.785 alpha:1.000], NSFontAttributeName:[UIFont preferredFontForTextStyle:UIFontTextStyleBody]}];
            [attributedTitle addAttribute:NSForegroundColorAttributeName
                                    value:[UIColor colorWithRed:0.122 green:0.475 blue:0.992 alpha:1.000]
                                    range:[attributedTitle.string.lowercaseString rangeOfString:searchBarText]];
            
            self.textLabel.attributedText = attributedTitle;
            self.imageView.image = contact.headImage;

            break;
        }
        default:
            break;
    }
}

#pragma mark - Life Cycle

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.imageView setFrame:CGRectMake(0, 0, 40, 40)];
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handHeadTap:)];
        gesture.numberOfTapsRequired=1;
        gesture.delegate=self;
        self.imageView.userInteractionEnabled=YES;
        [self.imageView addGestureRecognizer:gesture];
        UIButton *sendEmail = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width-100, 12, 60, 30)];
        [sendEmail setTitle:@"Invite" forState:UIControlStateNormal];
        [sendEmail setTitleColor:kGetColor(4, 118, 246) forState:UIControlStateNormal];
        [sendEmail.layer setBorderColor:kGetColor(4, 118, 246).CGColor];
        [sendEmail.layer setCornerRadius:3];
        [sendEmail.layer setBorderWidth:1];
        [sendEmail.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [sendEmail addTarget:self action:@selector(sendEmail:) forControlEvents:UIControlEventTouchUpInside];
        _btnSendEmail = sendEmail;
        _btnSendEmail.hidden=YES;
        [self addSubview:_btnSendEmail];
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)handHeadTap:(UITapGestureRecognizer *)getsture
{
    if ([_delegate respondsToSelector:@selector(ImageViewTapGesture:)]) {
        [_delegate ImageViewTapGesture:_indexPath.section];
    }
}
-(void)sendEmail:(UIButton *)btn
{
    if ([_delegate respondsToSelector:@selector(advriteFriend:)]) {
        [_delegate advriteFriend:_indexPath.section];
    }
}
@end
