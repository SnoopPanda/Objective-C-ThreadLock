//
//  SPPOSIXOperation.m
//  Lock
//
//  Created by WangJie on 2017/12/8.
//  Copyright © 2017年 WangJie. All rights reserved.
//

#import "SPPOSIXOperation.h"
#import <pthread.h>

@implementation SPPOSIXOperation {
    pthread_mutex_t mutex;
}

- (void)dealloc {
    pthread_mutex_destroy(&mutex);
}

- (instancetype)init {
    self = [super init];
    if (self) {
        pthread_mutex_init(&mutex, NULL);
    }
    return self;
}

- (void)fetchImageName {
    NSString *imageName;
    while (1) {
        pthread_mutex_lock(&mutex);
        if (imgNameArray.count > 0) {
            imageName = imgNameArray.firstObject;
            [imgNameArray removeObjectAtIndex:0];
            pthread_mutex_unlock(&mutex);
        } else {
            now = CFAbsoluteTimeGetCurrent();
            printf("%s_lock -> %f sec\n", [NSStringFromClass([self class]) UTF8String], now-then);
            pthread_mutex_unlock(&mutex);
            return;
        }
    }
}

@end
