//
//  XHMessageTableViewCell.m
//  MessageDisplayExample
//
//  Created by qtone-1 on 14-4-24.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import "XHMessageTableViewCell.h"
#import "TransPondViewController.h"
#import "CommUtilHelper.h"
#import "MessageUtilHelper.h"
static const CGFloat kXHLabelPadding = 0;
static const CGFloat kXHTimeStampLabelHeight = 12.0f;

static const CGFloat kXHAvatorPaddingX = 8.0;
static const CGFloat kXHAvatorPaddingY = 15;
static const CGFloat kXHBubbleMessageViewPadding = 15;
@interface XHMessageTableViewCell () {
    
}

@property (nonatomic, weak, readwrite) XHMessageBubbleView *messageBubbleView;

@property (nonatomic, weak, readwrite) UIButton *avatorButton;

@property (nonatomic, weak, readwrite) UIButton *repeatSendButton;

@property (nonatomic, weak, readwrite) UILabel *userNameLabel;

@property (nonatomic, weak, readwrite) LKBadgeView *timestampLabel;


/**
 *  是否显示时间轴Label
 */
@property (nonatomic, assign) BOOL displayTimestamp;

/**
 *  1、是否显示Time Line的label
 *
 *  @param message 需要配置的目标消息Model
 */
- (void)configureTimestamp:(BOOL)displayTimestamp atMessage:(id <XHMessageModel>)message;

/**
 *  2、配置头像
 *
 *  @param message 需要配置的目标消息Model
 */
- (void)configAvatorWithMessage:(id <XHMessageModel>)message;

/**
 *  3、配置需要显示什么消息内容，比如语音、文字、视频、图片
 *
 *  @param message 需要配置的目标消息Model
 */
- (void)configureMessageBubbleViewWithMessage:(id <XHMessageModel>)message;

/**
 *  头像按钮，点击事件
 *
 *  @param sender 头像按钮对象
 */
- (void)avatorButtonClicked:(UIButton *)sender;

/**
 *  统一一个方法隐藏MenuController，多处需要调用
 */
- (void)setupNormalMenuController;

/**
 *  点击Cell的手势处理方法，用于隐藏MenuController的
 *
 *  @param tapGestureRecognizer 点击手势对象
 */
- (void)tapGestureRecognizerHandle:(UITapGestureRecognizer *)tapGestureRecognizer;

/**
 *  长按Cell的手势处理方法，用于显示MenuController的
 *
 *  @param longPressGestureRecognizer 长按手势对象
 */
- (void)longPressGestureRecognizerHandle:(UILongPressGestureRecognizer *)longPressGestureRecognizer;

/**
 *  单击手势处理方法，用于点击多媒体消息触发方法，比如点击语音需要播放的回调、点击图片需要查看大图的回调
 *
 *  @param tapGestureRecognizer 点击手势对象
 */
- (void)sigleTapGestureRecognizerHandle:(UITapGestureRecognizer *)tapGestureRecognizer;

/**
 *  双击手势处理方法，用于双击文本消息，进行放大文本的回调
 *
 *  @param tapGestureRecognizer 双击手势对象
 */
- (void)doubleTapGestureRecognizerHandle:(UITapGestureRecognizer *)tapGestureRecognizer;
/**
 *  长按头像
 *
 *  @param tapGestureRecognizer
 */
-(void)longHeadPressGestureRecognizerHandle:(UILongPressGestureRecognizer *)longPressGestureRecognizer;
@end

@implementation XHMessageTableViewCell

- (void)avatorButtonClicked:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(didSelectedAvatorOnMessage:atIndexPath:)]) {
        [self.delegate didSelectedAvatorOnMessage:self.messageBubbleView.message atIndexPath:self.indexPath];
    }
}

#pragma mark - Copying Method

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (BOOL)becomeFirstResponder {
    return [super becomeFirstResponder];
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    return (action == @selector(copyed:) || action == @selector(transpond:) || action == @selector(favorites:) || action == @selector(more:));
}

#pragma mark - Menu Actions

- (void)copyed:(id)sender {
    [[UIPasteboard generalPasteboard] setString:self.messageBubbleView.displayTextView.text];
    [self resignFirstResponder];
    DLog(@"Cell was copy");
}

- (void)transpond:(id)sender {
    DLog(@"Cell was transpond");
   id<XHMessageModel> message = self.messageBubbleView.message;
    
    if ([self.delegate respondsToSelector:@selector(transPondMessage:)]) {
        [self.delegate transPondMessage:message];
    }
}

- (void)favorites:(id)sender {
    DLog(@"Cell was favorites");
}

- (void)more:(id)sender {
    DLog(@"Cell was more");
}
-(void)repeatSendAction:(UIButton *)button
{
    if ([self.delegate respondsToSelector:@selector(repeatSendButton:)]) {
        [self.delegate repeatSendButton:button];
    }
}
#pragma mark - Setters

- (void)configureCellWithMessage:(id <XHMessageModel>)message
               displaysTimestamp:(BOOL)displayTimestamp {
    // 1、是否显示Time Line的label
    [self configureTimestamp:displayTimestamp atMessage:message];
    if(message.subType == nil)
    {
    // 2、配置头像
    [self configAvatorWithMessage:message];
    
    // 3、配置用户名
    [self configUserNameWithMessage:message];
        
    }else
    {
      self.avatorButton.hidden = YES;
      self.userNameLabel.hidden = YES;
        
    }
    
    // 4、配置需要显示什么消息内容，比如语音、文字、视频、图片
    [self configureMessageBubbleViewWithMessage:message];
    
    //5配置是否重发标志
    [self repeatSendMsgButton:message];
}
-(void)repeatSendMsgButton:(id <XHMessageModel>)message
{
    NSMutableDictionary *handleDic = message.handleDic;
    
    if (message.isSending) {
        if (handleDic !=nil && [@"notime" isEqualToString: [handleDic objectForKey:@"syncTime"]]) {
            [_sendLoadView stopAnimating];
            [self.repeatSendButton setHidden:NO];
            NSString *sessionid = [handleDic objectForKey:@"sessionId"];
            if (sessionid && ![@"" isEqualToString:sessionid]){
                self.repeatSendButton.tag = [sessionid intValue];
            }
        
        }else
        {
      
        [_sendLoadView startAnimating];
        [_sendLoadView setHidden:NO];
        [self.repeatSendButton setHidden:YES];

      }
    }else
    {
     if (handleDic ){
     NSString *syncTime = [handleDic objectForKey:@"syncTime"];
     NSString *sessionid = [handleDic objectForKey:@"sessionId"];
     NSString *user = [handleDic objectForKey:@"user"];
        
         if ([[[MessageUtilHelper sharedInstance] getUnSendMessage] containsObject:sessionid]) {
             [_sendLoadView startAnimating];
             [_sendLoadView setHidden:NO];
             [self.repeatSendButton setHidden:YES];
         }else if ((!syncTime || [@"" isEqualToString:syncTime]) && [[[CommUtilHelper sharedInstance] getUser] isEqualToString:user] ) {
         if (sessionid && ![@"" isEqualToString:sessionid]){
         self.repeatSendButton.tag = [sessionid intValue];
         }
         [self.repeatSendButton setHidden:NO];
         [_sendLoadView setHidden:YES];
          
         [_sendLoadView stopAnimating];
       }else
       {
           [self.repeatSendButton setHidden:YES];
           [_sendLoadView setHidden:YES];
           
           [_sendLoadView stopAnimating];
       }
     }
    }
    [self reDrawRepeatDisplay];

}

-(void)reDrawRepeatDisplay
{
    //重写重复旋转标志
    
    //CGRect rect =[self getBubuleViewFrame];
    CGRect imageRect = self.messageBubbleView.bubblePhotoImageView.frame;
    //CGSize imageSize = self.messageBubbleView.bubblePhotoImageView.messagePhoto.size;
    switch ( self.messageBubbleView.message.messageMediaType) {
        case XHBubbleMessageMediaTypeText:
        {
           
            CGRect  rect = self.messageBubbleView.bubbleImageView.frame;
            [self.repeatSendButton setFrame:CGRectMake(rect.origin.x-30,self.repeatSendButton.frame.origin.y, 20, 20)];
            [_sendLoadView setFrame:CGRectMake(rect.origin.x-30, _sendLoadView.frame.origin.y, 20, 20)];
            break;
        }
        case XHBubbleMessageMediaTypePhoto:
        {
            [self.contentView bringSubviewToFront:self.repeatSendButton];
            //if (rect.origin.x==0) {
                [self.repeatSendButton setFrame:CGRectMake(imageRect.origin.x-30,self.repeatSendButton.frame.origin.y, 20, 20)];
                [_sendLoadView setFrame:CGRectMake(imageRect.origin.x-30, _sendLoadView.frame.origin.y, 20, 20)];
            //}
            //else
            //{
              //  [self.repeatSendButton setFrame:CGRectMake(rect.origin.x-25, self.repeatSendButton.frame.origin.y, 20, 20)];
                //[_sendLoadView setFrame:CGRectMake(rect.origin.x-30,  _sendLoadView.frame.origin.y, 20, 20)];
            //}
            break;
        }
        case XHBubbleMessageMediaTypeVoice:
        {
            CGRect  rect = self.messageBubbleView.bubbleImageView.frame;
            [self.repeatSendButton setFrame:CGRectMake(rect.origin.x-30,self.repeatSendButton.frame.origin.y, 20, 20)];
            [_sendLoadView setFrame:CGRectMake(rect.origin.x-30, _sendLoadView.frame.origin.y, 20, 20)];
            //rect = self.messageBubbleView.bubbleImageView.frame;
            break;
        }
        default:
            break;
    }

    //[self.contentView addSubview:_sendLoadView];
   // [self.contentView addSubview:self.repeatSendButton];
}

- (void)configureTimestamp:(BOOL)displayTimestamp atMessage:(id <XHMessageModel>)message {
    //self.displayTimestamp = displayTimestamp;
    self.displayTimestamp = YES;
    self.timestampLabel.hidden = !self.displayTimestamp;
    if (YES) {
        NSDateFormatter *formate = [[NSDateFormatter alloc] init];
        [formate setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
        [formate setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *strDate = [formate stringFromDate:message.timestamp];

        //self.timestampLabel.text = [NSDateFormatter localizedStringFromDate:message.timestamp
                                                                //  dateStyle:NSDateFormatterMediumStyle
                                                               //   timeStyle:NSDateFormatterShortStyle];
        self.timestampLabel.text = strDate;
    }
}

- (void)configAvatorWithMessage:(id <XHMessageModel>)message {
    //如果是系统用户，则不显示头像
    if([CommUtilHelper isSystemUser:message.sender]){
        self.avatorButton.hidden = YES;
        return;
    }else{
        self.avatorButton.hidden = NO;
    }
    //
    if (message.avator) {
        [self.avatorButton setImage:message.avator forState:UIControlStateNormal];
        if (message.avatorUrl) {
            self.avatorButton.messageAvatorType = XHMessageAvatorTypeSquare;
            [self.avatorButton setImageWithURL:[NSURL URLWithString:message.avatorUrl] placeholer:[UIImage imageNamed:@"avator"]];
        }
    } else {
        [self.avatorButton setImage:[XHMessageAvatorFactory avatarImageNamed:[UIImage imageNamed:@"avator"] messageAvatorType:XHMessageAvatorTypeSquare] forState:UIControlStateNormal];
    }
}

- (void)configUserNameWithMessage:(id <XHMessageModel>)message {
    //如果是系统用户，则不显示名称
    if([CommUtilHelper isSystemUser:message.sender]){
        self.userNameLabel.hidden = YES;
    }else{
        self.userNameLabel.hidden = NO;
    }
    self.userNameLabel.text = [message sender];
}

- (void)configureMessageBubbleViewWithMessage:(id <XHMessageModel>)message {
    XHBubbleMessageMediaType currentMediaType = message.messageMediaType;
    for (UIGestureRecognizer *gesTureRecognizer in self.messageBubbleView.bubbleImageView.gestureRecognizers) {
        [self.messageBubbleView.bubbleImageView removeGestureRecognizer:gesTureRecognizer];
    }
    for (UIGestureRecognizer *gesTureRecognizer in self.messageBubbleView.bubblePhotoImageView.gestureRecognizers) {
        [self.messageBubbleView.bubblePhotoImageView removeGestureRecognizer:gesTureRecognizer];
    }
    switch (currentMediaType) {
        case XHBubbleMessageMediaTypePhoto:
        case XHBubbleMessageMediaTypeVideo:
        case XHBubbleMessageMediaTypeLocalPosition: {
            UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sigleTapGestureRecognizerHandle:)];
            [self.messageBubbleView.bubblePhotoImageView addGestureRecognizer:tapGestureRecognizer];
            break;
        }
        case XHBubbleMessageMediaTypeText:
      
        case XHBubbleMessageMediaTypeVoice: {
            self.messageBubbleView.voiceDurationLabel.text = [NSString stringWithFormat:@"%@\'\'", message.voiceDuration];
//            break;
        }
        case XHBubbleMessageMediaTypeEmotion: {
            UITapGestureRecognizer *tapGestureRecognizer;
            if (currentMediaType == XHBubbleMessageMediaTypeText) {
                tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapGestureRecognizerHandle:)];
            } else {
                tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sigleTapGestureRecognizerHandle:)];
            }
            tapGestureRecognizer.numberOfTapsRequired = (currentMediaType == XHBubbleMessageMediaTypeText ? 2 : 1);
            [self.messageBubbleView.bubbleImageView addGestureRecognizer:tapGestureRecognizer];
            break;
        }
        default:
            break;
    }
    [self.messageBubbleView configureCellWithMessage:message];
}

#pragma mark - Gestures

- (void)setupNormalMenuController {
    UIMenuController *menu = [UIMenuController sharedMenuController];
    if (menu.isMenuVisible) {
        [menu setMenuVisible:NO animated:YES];
    }
}

- (void)tapGestureRecognizerHandle:(UITapGestureRecognizer *)tapGestureRecognizer {
    [self updateMenuControllerVisiable];
}

- (void)updateMenuControllerVisiable {
    [self setupNormalMenuController];
}

- (void)longPressGestureRecognizerHandle:(UILongPressGestureRecognizer *)longPressGestureRecognizer {
    if (longPressGestureRecognizer.state != UIGestureRecognizerStateBegan || ![self becomeFirstResponder])
        return;
    
    UIMenuItem *copy = [[UIMenuItem alloc] initWithTitle:NSLocalizedStringFromTable(@"copy", @"MessageDisplayKitString", @"复制文本消息") action:@selector(copyed:)];
    UIMenuItem *transpond = [[UIMenuItem alloc] initWithTitle:NSLocalizedStringFromTable(@"Forward", @"MessageDisplayKitString", @"Forward") action:@selector(transpond:)];
   // UIMenuItem *favorites = [[UIMenuItem alloc] initWithTitle:NSLocalizedStringFromTable(@"favorites", @"MessageDisplayKitString", @"收藏") action:@selector(favorites:)];
   // UIMenuItem *more = [[UIMenuItem alloc] initWithTitle:NSLocalizedStringFromTable(@"more", @"MessageDisplayKitString", @"更多") action:@selector(more:)];
    
    UIMenuController *menu = [UIMenuController sharedMenuController];
    if(self.messageBubbleView.message.messageMediaType==XHBubbleMessageMediaTypeText)
    {
    [menu setMenuItems:[NSArray arrayWithObjects: transpond,copy, nil]];
    }else
    {
      //[menu setMenuItems:[NSArray arrayWithObjects: transpond, nil]];
    }
    
    CGRect targetRect = [self convertRect:[self.messageBubbleView bubbleFrame]
                                 fromView:self.messageBubbleView];
    
    [menu setTargetRect:CGRectInset(targetRect, 0.0f, 4.0f) inView:self];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleMenuWillShowNotification:)
                                                 name:UIMenuControllerWillShowMenuNotification
                                               object:nil];
    [menu setMenuVisible:YES animated:YES];
}

-(void)longHeadPressGestureRecognizerHandle:(UILongPressGestureRecognizer *)longPressGestureRecognizer
{
    if (longPressGestureRecognizer.state != UIGestureRecognizerStateBegan || ![self becomeFirstResponder])
        return;
    if ([self.delegate respondsToSelector:@selector(didLongPressHead:atIndexPath:)]) {
        [self.delegate didLongPressHead:self.messageBubbleView.message atIndexPath:self.indexPath];
    }
    
}

- (void)sigleTapGestureRecognizerHandle:(UITapGestureRecognizer *)tapGestureRecognizer {
    if (tapGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        [self setupNormalMenuController];
        if ([self.delegate respondsToSelector:@selector(multiMediaMessageDidSelectedOnMessage:atIndexPath:onMessageTableViewCell:)]) {
            [self.delegate multiMediaMessageDidSelectedOnMessage:self.messageBubbleView.message atIndexPath:self.indexPath onMessageTableViewCell:self];
        }
    }
}
- (void)sigleSubscribeViewTapGestureRecognizerHandle:(UITapGestureRecognizer *)tapGestureRecognizer {
    if (tapGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        [self setupNormalMenuController];
        if ([self.delegate respondsToSelector:@selector(sigleSubscribeViewTapGestureRecognizerHandle:atIndexPath:onMessageTableViewCell:)]) {
            [self.delegate sigleSubscribeViewTapGestureRecognizerHandle:self.messageBubbleView.message atIndexPath:self.indexPath onMessageTableViewCell:self];
        }
    }
}

- (void)doubleTapGestureRecognizerHandle:(UITapGestureRecognizer *)tapGestureRecognizer {
    if (tapGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        if ([self.delegate respondsToSelector:@selector(didDoubleSelectedOnTextMessage:atIndexPath:)]) {
            [self.delegate didDoubleSelectedOnTextMessage:self.messageBubbleView.message atIndexPath:self.indexPath];
        }
    }
}

#pragma mark - Notifications

- (void)handleMenuWillHideNotification:(NSNotification *)notification {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIMenuControllerWillHideMenuNotification
                                                  object:nil];
}

- (void)handleMenuWillShowNotification:(NSNotification *)notification {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIMenuControllerWillShowMenuNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleMenuWillHideNotification:)
                                                 name:UIMenuControllerWillHideMenuNotification
                                               object:nil];
}

#pragma mark - Getters

- (XHBubbleMessageType)bubbleMessageType {
    return self.messageBubbleView.message.bubbleMessageType;
}


+ (CGFloat)calculateCellHeightWithMessage:(id <XHMessageModel>)message
                        displaysTimestamp:(BOOL)displayTimestamp {
    
    CGFloat timestampHeight = displayTimestamp ? (kXHTimeStampLabelHeight + kXHLabelPadding * 2) : kXHLabelPadding;
    CGFloat avatarHeight = kXHAvatarImageSize;
    
    CGFloat userNameHeight = 20;
    
    CGFloat subviewHeights = timestampHeight + kXHBubbleMessageViewPadding * 2 + userNameHeight;
    
    CGFloat bubbleHeight = [XHMessageBubbleView calculateCellHeightWithMessage:message];
    
    return subviewHeights + MAX(avatarHeight, bubbleHeight);
}

#pragma mark - Life cycle

- (void)setup {
    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.accessoryType = UITableViewCellAccessoryNone;
    self.accessoryView = nil;
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecognizerHandle:)];
    [self.messageBubbleView addGestureRecognizer:tapGestureRecognizer];
   
}

- (instancetype)initWithMessage:(id <XHMessageModel>)message
              displaysTimestamp:(BOOL)displayTimestamp
                reuseIdentifier:(NSString *)cellIdentifier {
    self = [self initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    if (self) {
        // 如果初始化成功，那就根据Message类型进行初始化控件，比如配置头像，配置发送和接收的样式
        
        // 1、是否显示Time Line的label
        if (!_timestampLabel) {
            LKBadgeView *timestampLabel = [[LKBadgeView alloc] initWithFrame:CGRectMake(0, kXHLabelPadding, 160, kXHTimeStampLabelHeight)];
            timestampLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin;
            //timestampLabel.badgeColor = [UIColor colorWithWhite:0.000 alpha:0.380];
            timestampLabel.badgeColor = self.backgroundColor;
            timestampLabel.textColor = [UIColor grayColor];
            timestampLabel.font = [UIFont systemFontOfSize:10.0f];
            timestampLabel.center = CGPointMake(CGRectGetWidth([[UIScreen mainScreen] bounds]) / 2.0, timestampLabel.center.y);
            [self.contentView addSubview:timestampLabel];
            [self.contentView bringSubviewToFront:timestampLabel];
            _timestampLabel = timestampLabel;
        }
        
        // 2、配置头像
        // avator
        CGRect avatorButtonFrame;
        switch (message.bubbleMessageType) {
            case XHBubbleMessageTypeReceiving:
                avatorButtonFrame = CGRectMake(kXHAvatorPaddingX, kXHAvatorPaddingY + (self.displayTimestamp ? kXHTimeStampLabelHeight : 0), kXHAvatarImageSize, kXHAvatarImageSize);
                break;
            case XHBubbleMessageTypeSending:
                avatorButtonFrame = CGRectMake(CGRectGetWidth(self.bounds) - kXHAvatarImageSize - kXHAvatorPaddingX, kXHAvatorPaddingY + (self.displayTimestamp ? kXHTimeStampLabelHeight : 0), kXHAvatarImageSize, kXHAvatarImageSize);
                break;
            default:
                break;
        }
        
        UIButton *avatorButton = [[UIButton alloc] initWithFrame:avatorButtonFrame];
        [avatorButton setImage:[XHMessageAvatorFactory avatarImageNamed:[UIImage imageNamed:@"avator"] messageAvatorType:XHMessageAvatorTypeCircle] forState:UIControlStateNormal];
        [avatorButton addTarget:self action:@selector(avatorButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        UILongPressGestureRecognizer *headPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longHeadPressGestureRecognizerHandle:)];
        headPress.minimumPressDuration=0.8;
        [avatorButton addGestureRecognizer:headPress];
        [self.contentView addSubview:avatorButton];
        self.avatorButton = avatorButton;
        
        // 3、配置用户名
        UILabel *userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.avatorButton.frame.origin.y-22, CGRectGetWidth(self.avatorButton.bounds) + 40, 22)];
        userNameLabel.textAlignment = NSTextAlignmentCenter;
        userNameLabel.backgroundColor = [UIColor clearColor];
        userNameLabel.font = [UIFont systemFontOfSize:11];
        userNameLabel.textColor = [UIColor colorWithRed:0.140 green:0.635 blue:0.969 alpha:1.000];
        [self.contentView addSubview:userNameLabel];
        self.userNameLabel = userNameLabel;
        
        // 4、配置需要显示什么消息内容，比如语音、文字、视频、图片
        if (!_messageBubbleView) {
            CGFloat bubbleX = 0.0f;
            
            CGFloat offsetX = 0.0f;
            
            if (message.bubbleMessageType == XHBubbleMessageTypeReceiving)
            {
                bubbleX = kXHAvatarImageSize + kXHAvatorPaddingX + kXHAvatorPaddingX;
                if (self.messageBubbleView.message.subType !=nil) {
                    bubbleX = [[UIScreen mainScreen] bounds].size.width*(0.05);
                }
                
            }
            else
            {
                offsetX = kXHAvatarImageSize + kXHAvatorPaddingX + kXHAvatorPaddingX;
            }
            

            
            CGRect frame = CGRectMake(bubbleX,
                                      kXHBubbleMessageViewPadding + (self.displayTimestamp ? (kXHTimeStampLabelHeight + kXHLabelPadding) : kXHLabelPadding),
                                      self.contentView.frame.size.width - bubbleX - offsetX,
                                      self.contentView.frame.size.height - (kXHBubbleMessageViewPadding + (self.displayTimestamp ? (kXHTimeStampLabelHeight + kXHLabelPadding) : kXHLabelPadding)));
            
            // bubble container
            XHMessageBubbleView *messageBubbleView = [[XHMessageBubbleView alloc] initWithFrame:frame message:message];
            messageBubbleView.autoresizingMask = (UIViewAutoresizingFlexibleWidth
                                                  | UIViewAutoresizingFlexibleHeight
                                                  | UIViewAutoresizingFlexibleBottomMargin);
            [self.contentView addSubview:messageBubbleView];
            [self.contentView sendSubviewToBack:messageBubbleView];
            self.messageBubbleView = messageBubbleView;
            if (self.messageBubbleView.zfySubscribeView) {
                self.messageBubbleView.zfySubscribeView.imageDelegate=self;
            }
            
            
            UILongPressGestureRecognizer *recognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGestureRecognizerHandle:)];
            [recognizer setMinimumPressDuration:0.4f];
            [self.messageBubbleView addGestureRecognizer:recognizer];
            
            UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sigleSubscribeViewTapGestureRecognizerHandle:)];
            
            [self.messageBubbleView addGestureRecognizer:tapGestureRecognizer];
            
            
        }
       
        if (!_repeatSendButton) {
            NSMutableDictionary *handleDic = message.handleDic;
            if (handleDic ) {
                    UIButton *sendButton = [[UIButton alloc] initWithFrame:CGRectZero];
                    [sendButton setImage:[UIImage imageNamed:@"reSendPic.png"] forState:UIControlStateNormal];
                    [sendButton addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
                    [sendButton setFrame:CGRectMake(50, 40, 20, 20)];
                    [sendButton addTarget:self action:@selector(repeatSendAction:) forControlEvents:UIControlEventTouchUpInside];
                    //[self.contentView addSubview:sendButton];
                     self.repeatSendButton = sendButton;
                    [self.repeatSendButton setHidden:NO];
                    [self.contentView addSubview:self.repeatSendButton];
            }
            
        }
        _sendLoadView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [_sendLoadView setFrame:CGRectMake(0, 0, 30, 30)];
        [self.contentView addSubview:_sendLoadView];
        [_sendLoadView setHidden:YES];
        
    }
    [self layoutSubviews];
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self setup];
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
    [self setup];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat layoutOriginY = kXHAvatorPaddingY + (self.displayTimestamp ? kXHTimeStampLabelHeight : 0);
    CGRect avatorButtonFrame = self.avatorButton.frame;
    avatorButtonFrame.origin.y = layoutOriginY;
    avatorButtonFrame.origin.x = ([self bubbleMessageType] == XHBubbleMessageTypeReceiving) ? kXHAvatorPaddingX : ((CGRectGetWidth(self.bounds) - kXHAvatorPaddingX - kXHAvatarImageSize));
    
    layoutOriginY = kXHBubbleMessageViewPadding + (self.displayTimestamp ? kXHTimeStampLabelHeight : 0);
    CGRect bubbleMessageViewFrame = self.messageBubbleView.frame;
    bubbleMessageViewFrame.origin.y = layoutOriginY;
    
    CGFloat bubbleX = 0.0f;
    if ([self bubbleMessageType] == XHBubbleMessageTypeReceiving)
    {
        bubbleX = kXHAvatarImageSize + kXHAvatorPaddingX + kXHAvatorPaddingX;
        if (self.messageBubbleView.message.subType !=nil) {
            bubbleX = 10;
        }
    }
    bubbleMessageViewFrame.origin.x = bubbleX;
    
    self.avatorButton.frame = avatorButtonFrame;
    
    [self.avatorButton.layer setCornerRadius:CGRectGetHeight([self.avatorButton bounds])/2];
    [self.avatorButton.layer setBorderWidth:1];
    self.avatorButton.layer.masksToBounds=YES;
    [self.avatorButton.layer setBorderColor:[[UIColor lightGrayColor] CGColor]];
    if (avatorButtonFrame.origin.x > screenWidth/2){
        //是右侧显示的信息,14是气泡箭头的宽度,见XHMessageBubbleView.m的kXHArrowMarginWidth
        [self.userNameLabel setFrame:CGRectMake(bubbleMessageViewFrame.origin.x + bubbleMessageViewFrame.size.width - 14 - 80, bubbleMessageViewFrame.origin.y-5, 80, 15)];
        [self.userNameLabel setTextAlignment:NSTextAlignmentRight];
        
        NSMutableDictionary *handleDic =  self.messageBubbleView.message.handleDic;
        //NSString *sender = self.messageBubbleView.message.sender;
        
        if (handleDic ){
            NSString *syncTime = [handleDic objectForKey:@"syncTime"];
            NSString *sessionid = [handleDic objectForKey:@"sessionId"];
            NSString *user = [handleDic objectForKey:@"user"];
            if ((!syncTime || [@"" isEqualToString:syncTime]) && [[[CommUtilHelper sharedInstance] getUser] isEqualToString:user] ) {
                [self reDrawRepeatDisplay];
                CGRect rect =[self getBubuleViewFrame];
                if (rect.origin.x==0) {
                
                    [self.repeatSendButton setFrame:CGRectMake(self.messageBubbleView.frame.size.width-20-rect.size.width, avatorButtonFrame.origin.y+20, 20, 20)];
                }else
                {
                    [self.repeatSendButton setFrame:CGRectMake(rect.origin.x-25, avatorButtonFrame.origin.y+20, 20, 20)];
                }
            }
        }
        CGRect rect =[self getBubuleViewFrame];
        if (rect.origin.x==0) {
            
            [_sendLoadView setFrame:CGRectMake(self.messageBubbleView.frame.size.width-20-rect.size.width, avatorButtonFrame.origin.y+20, 20, 20)];
        }else
        {
            [_sendLoadView setFrame:CGRectMake(rect.origin.x-30, avatorButtonFrame.origin.y+20, 20, 20)];
        }
        
    }else
    {
        //是左侧显示的信息,14是气泡箭头的宽度,见XHMessageBubbleView.m的kXHArrowMarginWidth
        [self.userNameLabel setFrame:CGRectMake(bubbleMessageViewFrame.origin.x + 14, bubbleMessageViewFrame.origin.y-5, 80, 15)];
        [self.userNameLabel setTextAlignment:NSTextAlignmentLeft];
    }
    //
    self.messageBubbleView.frame = bubbleMessageViewFrame;
    [self reDrawRepeatDisplay];
}

-(CGRect)getBubuleViewFrame
{
    CGRect rect ;
    switch ( self.messageBubbleView.message.messageMediaType) {
        case XHBubbleMessageMediaTypeText:
            rect = self.messageBubbleView.bubbleImageView.frame;
            break;
        case XHBubbleMessageMediaTypePhoto:
            rect = self.messageBubbleView.bubbleImageView.frame;
            break;
        case XHBubbleMessageMediaTypeVoice:
            rect = self.messageBubbleView.bubbleImageView.frame;
            break;
        default:
            break;
    }
    return rect;
}

- (void)dealloc {
    _avatorButton = nil;
    _timestampLabel = nil;
    _messageBubbleView = nil;
    _indexPath = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - TableViewCell

- (void)prepareForReuse {
    // 这里做清除工作
    [super prepareForReuse];
    self.messageBubbleView.animationVoiceImageView.image = nil;
    self.messageBubbleView.displayTextView.text = nil;
    self.messageBubbleView.displayTextView.attributedText = nil;
    self.messageBubbleView.bubblePhotoImageView.messagePhoto = nil;
    self.messageBubbleView.emotionImageView.animatedImage = nil;
    self.timestampLabel.text = nil;
    [self.messageBubbleView.zfySubscribeView  clearAll];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    
    if ([touch.view isKindOfClass:[UIButton class]]) {      //change it to your condition
        
        NSLog(@"123");
        return NO;
    }
    return YES;
}
//-(void)SubSribeClickImage:(NSString *)url
//{
//    if ([self.delegate respondsToSelector:@selector(didClickSubscirbImage:)]) {
//        [self.delegate didClickSubscirbImage:url];
//    }
//}
-(void)SubsribeImageClick:(NSString *)imageUrl
{
    if ([self.delegate respondsToSelector:@selector(didClickSubscirbImage:)]) {
        [self.delegate didClickSubscirbImage:imageUrl];
    }
}
@end
