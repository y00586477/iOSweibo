//
//  HeaderRefreshView.h
//  Test
//
//  Created by bytedance on 2021/8/3.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HeaderRefreshView : UIView

+(instancetype)addHeaderRefreshViewWithTarget:(id)target action:(SEL)action;

-(void)beginHeaderRefresh;

-(void)endHeaderRefresh;

@end

NS_ASSUME_NONNULL_END
