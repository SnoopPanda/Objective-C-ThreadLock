//
//  SPOperation.m
//  Lock
//
//  Created by WangJie on 2017/12/7.
//  Copyright © 2017年 WangJie. All rights reserved.
//

#import "SPBaseOperation.h"

@implementation SPBaseOperation

- (instancetype)init {
    self = [super init];
    if (self) {
        _syncQueue = dispatch_queue_create("com.snooppanda.lock", DISPATCH_QUEUE_CONCURRENT);
        imgNameArray = [NSMutableArray new];
        resultArray = [NSMutableArray new];
        int count = 1024*8;
        for (int i=0;i<count;i++) {
            [imgNameArray addObject:[NSString stringWithFormat:@"image - %d", count]];
        }
        printf("ImageName Array Initialize - imageCount = %ld\n", imgNameArray.count);
    }
    return self;
}

- (void)fetchImageName {
    
    NSString *imageName;
    while (1) {
        if (imgNameArray.count > 0) {
            imageName = imgNameArray.firstObject;
            [imgNameArray removeObjectAtIndex:0];
        }else {
            now = CFAbsoluteTimeGetCurrent();
            printf("%s_lock -> %f sec\n", [NSStringFromClass([self class]) UTF8String], now-then);
            return;
        }
    }
}

- (void)operationWithMultiThread {
    printf("=== %s_start ===\n", [NSStringFromClass([self class]) UTF8String]);
    then = CFAbsoluteTimeGetCurrent();
    for (int i=0; i<5; i++) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self fetchImageName];
            if (resultArray.count == 5) {
                float avg = [[resultArray valueForKeyPath:@"@avg.floatValue"] floatValue];
                printf("avg -> %f\n", avg);
            }
        });
    }
}

@end
