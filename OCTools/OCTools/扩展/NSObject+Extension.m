//
//  NSObject+Extension.m
//  OCTools
//
//  Created by 周 on 2018/11/21.
//  Copyright © 2018年 周. All rights reserved.
//

#import "NSObject+Extension.h"

@implementation NSObject (Extension)
+ (void)replaceInstanceMethod:(SEL)method withMethod:(SEL)newMethod {
    Method old = class_getInstanceMethod(self, method);
    Method new = class_getInstanceMethod(self, newMethod);
    if (old && new) {
        method_exchangeImplementations(old, new);
    }else{
        NSLog(@"实例方法交换失败:%s",sel_getName(method));
    }
}
+ (void)replaceClassMethod:(SEL)method withMethod:(SEL)newMethod {
    Method old = class_getClassMethod(self, method);
    Method new = class_getClassMethod(self, newMethod);
    if (old && new) {
        method_exchangeImplementations(old, new);
    }else{
        NSLog(@"类方法交换失败:%s",sel_getName(method));
    }
}
@end
