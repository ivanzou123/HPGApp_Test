//
//  XHContact.h
//  MessageDisplayExample
//
//  Created by 曾 宪华
//

#import <Foundation/Foundation.h>

#define kXHContactAvatorSize 40
#define kXHContactNameLabelHeight 30

#define kXHContactButtonHeight 44
#define kXHContactButtonSpacing 20

@interface XHContact : NSObject

@property (nonatomic, copy) NSString *contactName;

@property (nonatomic, copy) NSString *contactUserId;

@property (nonatomic, copy) NSString *contactUser;

@property (nonatomic, copy) NSString *contactRegion;

@property (nonatomic, copy) NSString *contactIntroduction;

@property (nonatomic, copy) NSArray *contactMyAlbums;

@property (nonatomic, copy) UIImage *headImage;

@property(nonatomic ,copy) NSString *contactPhone;

@property(nonatomic,copy) NSString *ContactTitile;

@property(nonatomic,copy) NSString *contactEmail;

@property(nonatomic,copy) NSString *contactLoginStatus;
@end
