//
//  SPAutomicOperation.m
//  Lock
//
//  Created by WangJie on 2017/12/8.
//  Copyright © 2017年 WangJie. All rights reserved.
//

#import "SPAtomicOperation.h"

@interface SPAtomicOperation()
@property (atomic, strong) NSMutableArray *imageNames;
@property (nonatomic, strong) NSString *string;
@end

@implementation SPAtomicOperation

/* 测试atomic原子锁的作用
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self multiOperation];
    }
    printf("string === %s \n", [self.string UTF8String]);
    return self;
}

- (void)multiOperation {

    for (int i=0; i<10; i++) {
        NSString *queue = [NSString stringWithFormat:@"queue-%d", i];
        dispatch_queue_t q = dispatch_queue_create([queue UTF8String], NULL);
        dispatch_async(q, ^{
            self.string = queue;
        });
    }
}
*/

- (instancetype)init {
    self = [super init];
    if (self) {
        self.imageNames = [NSMutableArray array];
        int count = 1024*8;
        for (int i=0; i<count; i++) {
            [self.imageNames addObject:[NSString stringWithFormat:@"image - %d", count]];
        }
        printf("ImageName Array Initialize - imageCount = %ld\n", self.imageNames.count);
    }
    return self;
}

- (void)fetchImageName {
    
    NSString *imageName;
    while (1) {
        if (self.imageNames.count > 0) {
            imageName = self.imageNames.firstObject;
            [self.imageNames removeObjectAtIndex:0];
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
        });
    }
    
}
@end
