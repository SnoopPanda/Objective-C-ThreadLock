//
//  SPDispatchSemaphoreOperation.m
//  Lock
//
//  Created by WangJie on 2017/12/7.
//  Copyright © 2017年 WangJie. All rights reserved.
//

#import "SPDispatchSemaphoreOperation.h"

@implementation SPDispatchSemaphoreOperation {
    dispatch_semaphore_t semaphore;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        semaphore = dispatch_semaphore_create(1);
    }
    return self;
}

- (void)fetchImageName {
    NSString *imageName;
    while (1) {
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        if (imgNameArray.count > 0) {
            imageName = imgNameArray.firstObject;
            [imgNameArray removeObjectAtIndex:0];
            dispatch_semaphore_signal(semaphore);
        }else {
            now = CFAbsoluteTimeGetCurrent();
            printf("%s_lock -> %f sec\n", [NSStringFromClass([self class]) UTF8String], now-then);
            dispatch_semaphore_signal(semaphore);
            return;
        }
    }
}

@end
