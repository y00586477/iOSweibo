//
//  FooterRefreshView.h
//  Test
//
//  Created by bytedance on 2021/8/3.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FooterRefreshView : UIView

+(instancetype)addFooterRefreshViewWithTarget:(id)target action:(SEL)action;

-(void)beginFooterRefresh;

-(void)endFooterRefresh;

@end

NS_ASSUME_NONNULL_END
