//
//  SPSynchronizedOperation.m
//  Lock
//
//  Created by WangJie on 2017/12/7.
//  Copyright © 2017年 WangJie. All rights reserved.
//

#import "SPSynchronizedOperation.h"

@implementation SPSynchronizedOperation

- (void)fetchImageName {
    NSString *imageName;
    
    @synchronized(self) {
        while (1) {
            if (imgNameArray.count > 0) {
                imageName = imgNameArray.firstObject;
                [imgNameArray removeObjectAtIndex:0];
            }else {
                now = CFAbsoluteTimeGetCurrent();
                [resultArray addObject:[NSNumber numberWithDouble:now-then]];
                printf("%s_lock -> %f sec\n", [NSStringFromClass([self class]) UTF8String], now-then);
                return;
            }
        }
    }
}

@end
