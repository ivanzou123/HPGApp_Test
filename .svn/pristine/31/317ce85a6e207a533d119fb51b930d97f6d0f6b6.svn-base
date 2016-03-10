//
//  XHContactPhotosTableViewCell.m
//  MessageDisplayExample
//
//  Created by ivan on 14-10-28.
//  Copyright (c) 2014年 hwpl hwpl. All rights reserved.
// 朋友圈分享人的名称高度
#define kXHAlbumUserNameHeigth 18

// 朋友圈分享的图片以及图片之间的间隔
#define kXHAlbumPhotoSize 60
#define kXHAlbumPhotoInsets 5

// 朋友圈分享内容字体和间隔
#define kXHAlbumContentFont [UIFont systemFontOfSize:13]
#define kXHAlbumContentLineSpacing 4

// 朋友圈评论按钮大小
#define kXHAlbumCommentButtonWidth 25
#define kXHAlbumCommentButtonHeight 25
#import "XHContactPhotosTableViewCell.h"

#import "XHContactPhotosView.h"

@interface XHContactPhotosTableViewCell ()

@property (nonatomic, strong) XHContactPhotosView *contactPhotosView;

@end

@implementation XHContactPhotosTableViewCell

- (void)configureCellWithContactInfo:(id)info atIndexPath:(NSIndexPath *)indexPath {
    NSString *placeholder;
    
    self.accessoryType = UITableViewCellAccessoryNone;
    self.contactPhotosView.hidden = YES;
    switch (indexPath.row) {
        case 0:
            placeholder = @"Title";
            break;
        case 1:
            placeholder = @"City";
            break;
        case 2:
            placeholder = @"Email";
            break;
        case 3:
            placeholder = @"Phone";
            break;
       
        default:
            break;
    }
    self.textLabel.text = placeholder;
    if ([info isKindOfClass:[NSString class]]) {
        self.detailTextLabel.text = info;
    }
//    else if ([info isKindOfClass:[NSArray class]]) {
//        self.contactPhotosView.hidden = NO;
//        self.contactPhotosView.photos = info;
//        [self.contactPhotosView reloadData];
//    }
}

#pragma mark - Propertys

- (XHContactPhotosView *)contactPhotosView {
    if (!_contactPhotosView) {
        CGFloat contactPhotosViewWidht = kXHAlbumPhotoSize * 3 + kXHAlbumPhotoInsets * 2;
        _contactPhotosView = [[XHContactPhotosView alloc] initWithFrame:CGRectMake(CGRectGetWidth([[UIScreen mainScreen] bounds]) - (contactPhotosViewWidht + 40), kXHAlbumPhotoInsets, contactPhotosViewWidht, kXHAlbumPhotoSize)];
        _contactPhotosView.backgroundColor = self.contentView.backgroundColor;
        _contactPhotosView.hidden = YES;
    }
    return _contactPhotosView;
}

#pragma mark - Life Cycle

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.textLabel.font = [UIFont systemFontOfSize:16];
        self.detailTextLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        self.detailTextLabel.numberOfLines = 2;
        self.detailTextLabel.font = [UIFont systemFontOfSize:13];
        
        [self.contentView addSubview:self.contactPhotosView];
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)prepareForReuse {
    self.contactPhotosView.photos = nil;
    self.textLabel.text = nil;
    self.detailTextLabel.text = nil;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
