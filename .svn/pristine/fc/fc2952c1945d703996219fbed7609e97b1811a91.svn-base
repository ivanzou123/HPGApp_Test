//
//  XHFileAttribute.m
//  XHImageViewer
//
//  Created by ivan on 14-2-18.
//  Copyright hwpl hwpl. All rights reserved.
//

#import "XHFileAttribute.h"

@implementation XHFileAttribute

- (id)initWithPath:(NSString *)filePath attributes:(NSDictionary *)attributes {
    self = [super init];
    if(self){
        self.filePath = filePath;
        self.fileAttributes = attributes;
    }
    return self;
}

- (NSDate *)fileModificationDate {
    return [_fileAttributes fileModificationDate];
}

- (NSString *)description {
    return self.filePath;
}

@end
