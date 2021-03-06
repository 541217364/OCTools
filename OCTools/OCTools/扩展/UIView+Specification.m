//
//  UIView+Specification.m
//  OCTools
//
//  Created by 周 on 2018/10/29.
//  Copyright © 2018年 周. All rights reserved.
//

#import "UIView+Specification.h"

@implementation UIView (Specification)
-(CGFloat)x{
    return self.frame.origin.x;
}
- (void)setX:(CGFloat)x{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}
-(CGFloat)y{
    return self.frame.origin.y;
}
-(void)setY:(CGFloat)y{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}
-(CGFloat)width{
    return self.frame.size.width;
}
- (void)setWidth:(CGFloat)width{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}
-(CGFloat)height{
    return self.frame.size.height;
}
-(void)setHeight:(CGFloat)height{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}
- (CGFloat)maxX {
    return self.x + self.width;
}
- (CGFloat)maxY {
    return self.y + self.height;
}
@end
