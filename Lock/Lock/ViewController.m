//
//  ViewController.m
//  Lock
//
//  Created by WangJie on 2017/12/7.
//  Copyright © 2017年 WangJie. All rights reserved.
//

#import "ViewController.h"
#import "SPNSLockOperation.h"
#import "SPSynchronizedOperation.h"
#import "SPDispatchSemaphoreOperation.h"

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
            self.operation = [SPNSLockOperation new];
            break;
        case 1:
            self.operation = [SPSynchronizedOperation new];
            break;
        case 2:
            self.operation = [SPDispatchSemaphoreOperation new];
            break;
        default:
            break;
    }
    [self.operation operationWithMultiThread];
}

@end
