//
//  XHFileAttribute.h
//  XHImageViewer
//
//  Created by ivan on 14-2-18.
//  Copyright hwpl hwpl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XHFileAttribute : NSObject

@property (nonatomic, strong) NSString *filePath;
@property (nonatomic, strong) NSDictionary *fileAttributes;
@property (nonatomic, readonly) NSDate *fileModificationDate;
- (id)initWithPath:(NSString *)filePath attributes:(NSDictionary *)attributes;

@end
