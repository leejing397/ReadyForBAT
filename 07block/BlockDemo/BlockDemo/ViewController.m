//
//  ViewController.m
//  BlockDemo
//
//  Created by Iris on 2018/12/28.
//  Copyright © 2018年 国信司南（北京）地理信息技术有限公司. All rights reserved.
//

#import "ViewController.h"

#import "JJBlock.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    JJBlock *block1 = [[JJBlock alloc]init];
    NSLog(@"%@",block1);
    [block1 setBlock];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
