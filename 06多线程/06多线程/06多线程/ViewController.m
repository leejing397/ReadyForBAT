//
//  ViewController.m
//  06多线程
//
//  Created by Iris on 2018/12/14.
//  Copyright © 2018年 陈花花. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    [self test5];
}
- (void)test6 {
    dispatch_barrier_async(dispatch_get_main_queue(), ^{
        
    });
}
#pragma mark 同步串行1
- (void)test1 {
    dispatch_sync(dispatch_get_main_queue(), ^{
        NSLog(@"hello world");
    });
}
#pragma mark 同步串行2
- (void)test2 {
    dispatch_queue_t queue = dispatch_queue_create("tk.bourne.testQueue", NULL);
    dispatch_sync(queue, ^{
         NSLog(@"hello world");
    });
}

#pragma mark 同步并发
- (void)test3 {
    NSLog(@"1");
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSLog(@"2");
        dispatch_sync(dispatch_get_global_queue(0, 0), ^{
            NSLog(@"3");
        });
        NSLog(@"4");
    });
    NSLog(@"5");
}

#pragma mark 异步串行
- (void)test4 {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"1");
    });
}

#pragma mark 异步并发
- (void)test5 {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSLog(@"1");
//        [self performSelectorOnMainThread:@selector(printLog) withObject:nil waitUntilDone:YES];
        [self performSelector:@selector(printLog) withObject:nil afterDelay:0];
        NSLog(@"3");
    });
}

- (void)printLog {
    NSLog(@"2");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
