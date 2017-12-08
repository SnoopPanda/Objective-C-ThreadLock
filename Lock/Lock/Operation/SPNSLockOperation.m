//
//  SPNSLockOperation.m
//  Lock
//
//  Created by WangJie on 2017/12/7.
//  Copyright © 2017年 WangJie. All rights reserved.
//

#import "SPNSLockOperation.h"

@implementation SPNSLockOperation {
    NSLock *_lock;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _lock = [[NSLock alloc] init];
    }
    return self;
}

- (void)fetchImageName {
    NSString *imageName;
    while (1) {
        [_lock lock];
        if (imgNameArray.count > 0) {
            imageName = imgNameArray.firstObject;
            [imgNameArray removeObjectAtIndex:0];
            [_lock unlock];
        }else {
            now = CFAbsoluteTimeGetCurrent();
            printf("%s_lock -> %f sec\n", [NSStringFromClass([self class]) UTF8String], now-then);
            [_lock unlock];
            return;
        }
    }
}

@end
