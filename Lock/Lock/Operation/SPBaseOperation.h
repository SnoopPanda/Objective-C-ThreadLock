//
//  SPOperation.h
//  Lock
//
//  Created by WangJie on 2017/12/7.
//  Copyright © 2017年 WangJie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SPBaseOperation : NSObject
{
    NSMutableArray *imgNameArray;
    __block double then, now;
}

@property (nonatomic, readonly) dispatch_queue_t syncQueue;

- (void)fetchImageName;
- (void)operationWithMultiThread;

@end
