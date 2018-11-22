//
//  UITableView+Extension.h
//  OCTools
//
//  Created by 周 on 2018/11/21.
//  Copyright © 2018年 周. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITableView (Extension)
/**是否可以折叠*/
@property (nonatomic, assign)BOOL ww_foldable;
/**该分区是否折叠*/
- (BOOL)ww_isSectionFolded:(NSInteger)section;
/**将该分区折叠/展开*/
- (void)ww_foldSection:(NSInteger)section fold:(BOOL)fold;
@end

NS_ASSUME_NONNULL_END
