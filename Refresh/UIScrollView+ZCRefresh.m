//
//  UIScrollView+ZCRefresh.m
//  RefreshAndLoad
//
//  Created by bytedance on 2021/7/20.
//

#import "UIScrollView+ZCRefresh.h"
#import "ZCHeaderRefreshView.h"
#import "FooterRefreshView.h"
#import <objc/runtime.h>

static const void *headerRefresh_key = @"headerRefresh_key";
static const void *footerRefresh_key = @"footerRefresh_key";

@implementation UIScrollView (ZCRefresh)

- (void)setHeaderRefreshView:(ZCHeaderRefreshView *)headerRefreshView{
    if (headerRefreshView != self.headerRefreshView) {
        [self.headerRefreshView removeFromSuperview];
        [self insertSubview:headerRefreshView atIndex:0];
        
        objc_setAssociatedObject(self, headerRefresh_key, headerRefreshView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

- (ZCHeaderRefreshView *)headerRefreshView{
    return objc_getAssociatedObject(self, headerRefresh_key);
}

- (void)setFooterRefreshView:(FooterRefreshView *)footerRefreshView{
    if (footerRefreshView != self.footerRefreshView) {
        [self.footerRefreshView removeFromSuperview];
        [self insertSubview:footerRefreshView atIndex:0];
        
        objc_setAssociatedObject(self, footerRefresh_key, footerRefreshView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}
- (FooterRefreshView *)footerRefreshView{
    return objc_getAssociatedObject(self, footerRefresh_key);
}

@end
