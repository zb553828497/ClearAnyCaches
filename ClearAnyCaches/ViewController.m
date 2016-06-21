//
//  ViewController.m
//  ClearAnyCaches
//
//  Created by zhangbin on 16/6/21.
//  Copyright © 2016年 zhangbin. All rights reserved.
//

#import "ViewController.h"
#import "NSString+ZBClearAnyCaches.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 1.文件管理者
    NSFileManager *mgr = [NSFileManager defaultManager];
    // 2.只需要指定缓存的路径，就可以计算这个路径中缓存的大小，并且可以删除这些缓存。
    NSString *caches = @"/Users/zhangbin/Desktop/zhangsi";
    NSLog(@"%ld", [caches fileSize]);
    // 3.执行删除caches路径下的数据
    [mgr removeItemAtPath:caches error:nil];



}

@end
