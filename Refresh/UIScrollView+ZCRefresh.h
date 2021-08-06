//
//  UIScrollView+ZCRefresh.h
//  RefreshAndLoad
//
//  Created by bytedance on 2021/7/20.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class ZCHeaderRefreshView, FooterRefreshView;

@interface UIScrollView (ZCRefresh)

@property (nonatomic, strong)ZCHeaderRefreshView *headerRefreshView;
@property(nonatomic, strong) FooterRefreshView *footerRefreshView;

@end

NS_ASSUME_NONNULL_END
