//
//  ViewController.m
//  Lock
//
//  Created by WangJie on 2017/12/7.
//  Copyright © 2017年 WangJie. All rights reserved.
//

#import "ViewController.h"
#import "SPAtomicOperation.h"
#import "SPNSLockOperation.h"
#import "SPSynchronizedOperation.h"
#import "SPDispatchSemaphoreOperation.h"
#import "SPConditionOperation.h"
#import "SPConditionLockOperation.h"
#import "SPRecursiveLockOperation.h"
#import "SPPOSIXOperation.h"
#import "SPOSSpinLockOperation.h"

@interface ViewController ()

@property (nonatomic, strong) SPBaseOperation *operation;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)selectAction:(UIButton *)sender {
    
    self.typeLabel.text = [NSString stringWithFormat:@"选择锁类型：%@", sender.titleLabel.text];
    switch (sender.tag) {
        case 0:
            self.operation = [SPBaseOperation new];
            break;
        case 1:
            self.operation = [SPAtomicOperation new];
            break;
        case 2:
            self.operation = [SPNSLockOperation new];
            break;
        case 3:
            self.operation = [SPSynchronizedOperation new];
            break;
        case 4:
            self.operation = [SPDispatchSemaphoreOperation new];
            break;
        case 5:
            self.operation = [SPConditionOperation new];
            break;
        case 6:
            self.operation = [SPConditionLockOperation new];
            break;
        case 7:
            self.operation = [SPRecursiveLockOperation new];
            break;
        case 8:
            self.operation = [SPPOSIXOperation new];
            break;
        case 9:
            self.operation = [SPOSSpinLockOperation new];
            break;
        default:
            break;
    }
    [self.operation operationWithMultiThread];
}

@end
