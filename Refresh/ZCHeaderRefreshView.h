//
//  ZCHeaderRefreshView.h
//  RefreshAndLoad
//
//  Created by bytedance on 2021/7/20.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZCHeaderRefreshView : UIView

+(instancetype)addHeaderRefreshViewWithTarget:(id)target action:(SEL)action;

-(void)beginHeaderRefresh;

-(void)endHeaderRefresh;

-(void)setHeaderNormalImageWithName:(NSString *)imageName;

-(void)setHeaderPullImageWithName:(NSString *)imageName;

-(void)setAnimantionImages:(NSArray *)images;

@end

NS_ASSUME_NONNULL_END
