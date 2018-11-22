//
//  NSObject+Extension.h
//  OCTools
//
//  Created by 周 on 2018/11/21.
//  Copyright © 2018年 周. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
NS_ASSUME_NONNULL_BEGIN
@interface NSObject (Extension)
/**交换实例方法*/
+ (void)replaceInstanceMethod:(SEL)method withMethod:(SEL)newMethod;
/**交换类方法*/
+ (void)replaceClassMethod:(SEL)method withMethod:(SEL)newMethod;
@end

NS_ASSUME_NONNULL_END
