//
//  UserCenter.m
//  06多线程
//
//  Created by Iris on 2018/12/14.
//  Copyright © 2018年 陈花花. All rights reserved.
//

#import "UserCenter.h"

@interface UserCenter()
{
    dispatch_queue_t concurrent_queue;
    NSMutableDictionary *userCenterDict;
}
@end

@implementation UserCenter
- (instancetype)init {
    if (self = [super init]) {
        concurrent_queue = dispatch_queue_create("UserCenter", DISPATCH_QUEUE_CONCURRENT);
        userCenterDict = [NSMutableDictionary dictionaryWithCapacity:3];
        
    }
    return self;
}

@end
