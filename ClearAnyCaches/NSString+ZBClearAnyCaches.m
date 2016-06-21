//
//  NSString+ZBClearAnyCaches.m
//  ClearAnyCaches
//
//  Created by zhangbin on 16/6/21.
//  Copyright © 2016年 zhangbin. All rights reserved.
//

#import "NSString+ZBClearAnyCaches.h"

@implementation NSString (ZBClearAnyCaches)


// 外界的(文件/文件夹)路径调用fileSize方法
- (NSInteger)fileSize
{   // 创建文件管理者对象mgr
    NSFileManager *mgr = [NSFileManager defaultManager];
    // 判断是否为文件,先令dir为NO
    BOOL dir = NO;
    // dir为NO/YES由self决定，上面dir设置为NO，只是赋一个初始值.如果传过来的self路径是文件夹(框架底层自动判断)，那么dir就变为了YES(表示self是一个文件夹)，那么exist为YES(表示文件夹存在)
    BOOL exists = [mgr fileExistsAtPath:self isDirectory:&dir];
    // 文件\文件夹不存在
    if (exists == NO) return 0;
    
    // dir为YES,即self(外界的路径)是一个文件夹
    if (dir) {
        // 假设self(外界的路径)是沙盒中的Caches文件夹。
        // 0.对于这句代码:NSArray *subpaths = [mgr subpathsAtPath:self];有以下4点必须知道:
        // 1.遍历Caches路径下的所有内容(直接内容+间接内容),即使Caches路径下有文件夹,文件夹中又有内容,也能遍历出来，最终遍历出来的结果是:Caches直接路径下的文件+直接路径下的文件夹+间接路径下的文件.只要在Caches路径内部，都能遍历出来.
        // 2.注意:必须用subpathsAtPath方法+for in来实现遍历,缺一不可
        // 3.subpathsAtPath方法的作用:拿到Caches路径下的所有内容(包括子路径/间接路径)放到数组中存储
        // 4.for in的作用:取出数组中的每一个字符串对象,每取出一个对象，就拼接这个对象的全路径，再判断这个对象如果是文件，就累加文件的大小，如果不是文件就不累加大小，所以最终得到的是Caches路径下(包括子路径)所有文件的大小
        // 拓展:如果将0处的代码替换成 NSArray *contents = [mgr contentsOfDirectoryAtPath:self error:nil];那么我们只能遍历出Caches里面的直接内容.如果Caches路径中又有目录，那么目录里面的东西遍历不出来
        NSArray *subpaths = [mgr subpathsAtPath:self];
        // totalByteSize用于累加每个文件的大小
        NSInteger totalByteSize = 0;
        for (NSString *subpath in subpaths) {
            //获得全路径:Caches路径+subpath文件/文件夹，最后得到的路径用fullSubPath表示
            NSString *fullSubPath = [self stringByAppendingPathComponent:subpath];
            // dir用于判断是否为文件.
            BOOL dir = NO;
            // 判断fullSubPath路径是否存在，以及dir(也就是subpath)是否为文件夹(目录)
            [mgr fileExistsAtPath:fullSubPath isDirectory:&dir];
            if (dir == NO) { // dir(也就是subpath)不是文件夹(目录)，而是文件,就执行{},计算并累加文件的大小
                // 计算每一个文件的大小
                NSUInteger byteSize = [[mgr attributesOfItemAtPath:fullSubPath error:nil][NSFileSize] integerValue];
                // 累加每一个文件的大小
                totalByteSize += byteSize;
            }
        }
        // 返回累加值后的文件大小给外界
        return totalByteSize;
    } else { //  dir为NO,即self(外界的路径)是一个文件
        // 直接计算这个文件的尺寸，然后返回给外界
        return [[mgr attributesOfItemAtPath:self error:nil][NSFileSize] integerValue];
    }
}

@end
