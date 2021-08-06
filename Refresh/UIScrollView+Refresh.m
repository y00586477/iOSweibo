//
//  UIScrollView+Refresh.m
//  Test
//
//  Created by bytedance on 2021/8/3.
//

#import "UIScrollView+Refresh.h"
#import "HeaderRefreshView.h"
#import <objc/runtime.h>

static const void *headerRefresh_key = @"headerRefresh_key";

@implementation UIScrollView (Refresh)

-(void)setHeaderRefreshView:(HeaderRefreshView *)headerRefreshView{
    if (headerRefreshView != self.headerRefreshView) {
        [self.headerRefreshView removeFromSuperview];
        [self insertSubview:headerRefreshView atIndex:0];
    }
    
    objc_setAssociatedObject(self, headerRefresh_key, headerRefreshView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (HeaderRefreshView *)headerRefreshView{
    return objc_getAssociatedObject(self, headerRefresh_key);
}

@end
