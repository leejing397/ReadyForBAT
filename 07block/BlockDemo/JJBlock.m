//
//  JJBlock.m
//  BlockDemo
//
//  Created by Iris on 2018/12/28.
//  Copyright © 2018年 国信司南（北京）地理信息技术有限公司. All rights reserved.
//

#import "JJBlock.h"

@implementation JJBlock
- (instancetype)init {
    if (self = [super init]) {
    }
    return self;
}
- (void)setBlock {
    int multiplier = 6;
    int (^JJBlock)(int) = ^int(int num){
        return num * multiplier;
    };
    multiplier = 4;
    NSLog(@"%d",JJBlock(2));
}
@end
