//
//  SPOSSpinLockOperation.m
//  Lock
//
//  Created by WangJie on 2017/12/8.
//  Copyright © 2017年 WangJie. All rights reserved.
//

#import "SPOSSpinLockOperation.h"
#import <libkern/OSAtomic.h>

@implementation SPOSSpinLockOperation {
    OSSpinLock spinLock;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        spinLock = OS_SPINLOCK_INIT;
    }
    return self;
}

- (void)fetchImageName {
    NSString *imageName;
    while (1) {
        OSSpinLockLock(&spinLock);
        if (imgNameArray.count > 0) {
            imageName = imgNameArray.firstObject;
            [imgNameArray removeObjectAtIndex:0];
            OSSpinLockUnlock(&spinLock);
        }else {
            now = CFAbsoluteTimeGetCurrent();
            [resultArray addObject:[NSNumber numberWithDouble:now-then]];
            printf("%s_lock -> %f sec\n", [NSStringFromClass([self class]) UTF8String], now-then);
            OSSpinLockUnlock(&spinLock);
            return;
        }
    }
}

@end
