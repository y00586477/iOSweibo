//
//  UIScrollView+Refresh.h
//  Test
//
//  Created by bytedance on 2021/8/3.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class HeaderRefreshView;

@interface UIScrollView (Refresh)

@property(nonatomic, strong) HeaderRefreshView *headerRefreshView;

@end

NS_ASSUME_NONNULL_END
