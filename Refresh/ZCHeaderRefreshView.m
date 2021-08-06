//
//  ZCHeaderRefreshView.m
//  RefreshAndLoad
//
//  Created by bytedance on 2021/7/20.
//

#import "ZCHeaderRefreshView.h"
#import <objc/message.h>

#define ZCContentOffset @"contentOffset"
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
static const int headerRefreshHeight = 60;

typedef enum{
    ZCStateNormal = 0,
    ZCStatePull,
    ZCStateRefresh
}  state;
@interface ZCHeaderRefreshView ()

@property (nonatomic,weak)UIImageView *imageView;

@property (nonatomic,weak)UILabel *label;

@property (nonatomic,weak)UIActivityIndicatorView *activityView;

@property (nonatomic, assign)int currentState;

@property (nonatomic,weak)UIScrollView *superview;

@property (nonatomic,assign)CGFloat contentOffSetY;

@property(nonatomic,weak)id target;

@property(nonatomic,assign)SEL action;

@property(nonatomic,strong)UIImage *headerNormoalImage;

@property(nonatomic,strong)UIImage *headerPullingImage;

@property(nonatomic,strong)NSArray *animationImages;

@end

@implementation ZCHeaderRefreshView

+ (instancetype)addHeaderRefreshViewWithTarget:(id)target action:(SEL)action {
    NSLog(@"add headerrefreshview");
    ZCHeaderRefreshView *refreash = [[self alloc] init];
    refreash.frame = CGRectMake(0, -headerRefreshHeight, ScreenWidth, headerRefreshHeight);
//    refreash.hidden = YES;
    refreash.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.0];
    refreash.currentState = ZCStateNormal;
    if (target != nil && action != nil) {
        refreash.target = target;
        refreash.action = action;
    }else {
        NSLog(@"请设置刷新时调用的方法！！！");
    }
    return refreash;
}

#pragma mark子控件布局
- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat imagViewWH = 40;
    CGFloat imagViewX = ScreenWidth * 0.3;
    self.imageView.frame = CGRectMake(imagViewX, (self.frame.size.height - imagViewWH) / 2, imagViewWH, imagViewWH);
    
    CGFloat labelX = CGRectGetMaxX(self.imageView.frame);
    self.label.frame = CGRectMake(labelX, (self.frame.size.height - imagViewWH) / 2, 100, imagViewWH);
    
    self.activityView.frame = CGRectMake(imagViewX, (self.frame.size.height - imagViewWH) / 2, imagViewWH, imagViewWH);
}

#pragma 加到父控件时会调用该方法
- (void)willMoveToSuperview:(UIView *)newSuperview {
    //是可以滚动的SCroolView才可以监听滚动事件
    if ([newSuperview isKindOfClass:[UIScrollView class]]) {
        //刷新控件添加的到的父控件
        self.superview = (UIScrollView *)newSuperview;
        //为父控件添加观察者，观察父控件的contentOffset.y值的变化。
        [newSuperview addObserver:self forKeyPath:ZCContentOffset options:NSKeyValueObservingOptionNew context:nil];
    }
}

#pragma 监听函数
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:ZCContentOffset]) {
        [self adjustRefreshView];
    }
}

#pragma 当正在操作下拉刷新控件时调用该方法
- (void)adjustRefreshView {
    //主要用来区别控制器有无导航栏
    if (self.superview.contentInset.top == 64.000000) {
        static dispatch_once_t one;
        dispatch_once(&one, ^{
            self.contentOffSetY = self.superview.contentInset.top;
        });
    }
    CGFloat y = self.superview.contentOffset.y;
    if (self.superview.isDragging) { //正在拖动
        if (y < -self.contentOffSetY && y > -self.contentOffSetY - headerRefreshHeight && self.currentState == ZCStatePull) { //正常状态->下拉
            self.currentState = ZCStateNormal;
        }else if (y <= -self.contentOffSetY - headerRefreshHeight && self.currentState == ZCStateNormal)//下拉->正常
        {
            self.currentState = ZCStatePull;
        }
    }else if(self.currentState == ZCStatePull && y <= -self.contentOffSetY - headerRefreshHeight) { //手释放
        self.currentState = ZCStateRefresh;
    }else if(self.currentState == ZCStateRefresh) {
        //不能直接调用objec.msgSend()
//        void (*action)(id, SEL) = (void (*)(id, SEL)) objc_msgSend;
//        action(self.target,self.action);
    }
}

#pragma 重写setState方法
- (void)setCurrentState:(int)currentState{
    if (_currentState == currentState) { //相等直接返回
        return;
    }
    _currentState = currentState;
    if (_currentState == ZCStateNormal) {//默认状态
        self.imageView.hidden = NO;
        [self.activityView stopAnimating];
        self.activityView.hidden = YES;
        [UIView animateWithDuration:0.5 animations:^{
            [self.imageView stopAnimating];
            self.label.text = @"下拉刷新";
            //如果没有设置动画图片
            if (self.animationImages == nil)  {
                if (self.headerNormoalImage == nil) {//没有设置正常图片，则采用默认的
                    self.imageView.image = [UIImage imageNamed:@"down"];
                }   else {//采用设置的图片
                    self.imageView.image = self.headerNormoalImage;
                }
            } else {//   如果设置了动画，则采用第一张做正常时的图片
                self.imageView.image = self.animationImages[0];
            }
        }];
    }else if (_currentState ==ZCStatePull){//下拉状态
        self.imageView.hidden = NO;
        [self.activityView stopAnimating];
        self.activityView.hidden = YES;
        [UIView animateWithDuration:0.5 animations:^{
            [self.imageView stopAnimating];
            self.label.text= @"释放立即刷新";
            //如果没有设置动画图片
            if (self.animationImages == nil)  {
                if (self.headerPullingImage == nil) {//没有设置下拉图片，则采用默认的
                    self.imageView.image = [UIImage imageNamed:@"up"];
                } else {//采用设置的图片
                    self.imageView.image = self.headerPullingImage;
                }
            } else {
                //   如果设置了动画，则采用第一张做下拉时的图片
                self.imageView.image = self.animationImages[0];
            }
        }];
    } else if (_currentState == ZCStateRefresh){ //释放刷新
        self.label.text = @"正在刷新...";
        //没有动画图片，默认采用菊花控件
        if (self.animationImages == nil) {
            self.activityView.hidden = NO;
            self.imageView.hidden = YES;
            [self.activityView startAnimating];
        } else {
            self.imageView.hidden = NO;
            self.activityView.hidden = YES;
            self.imageView.animationDuration = 0.1 * self.animationImages.count;
            [self.imageView startAnimating];
        }
        //放手之后不能立即返回
        [UIView animateWithDuration:0.25 animations:^{
            self.superview.contentInset = UIEdgeInsetsMake(self.superview.contentInset.top + headerRefreshHeight, self.superview.contentInset.left, self.superview.contentInset.bottom, self.superview.contentInset.right);
        } completion:^(BOOL finished) {
            void (*action)(id, SEL) = (void (*)(id, SEL)) objc_msgSend;
            action(self.target,self.action);
        }];
    }
}

#pragma 开始刷新
- (void)beginHeaderRefresh{
    self.currentState = ZCStateRefresh;
}
#pragma 结束下拉刷新
- (void)endHeaderRefresh {
    if (self.currentState == ZCStateRefresh) {
        self.currentState = ZCStateNormal;
        [UIView animateWithDuration:0.25 animations:^{
            self.superview.contentInset = UIEdgeInsetsMake(self.superview.contentInset.top - headerRefreshHeight, self.superview.contentInset.left, self.superview.contentInset.bottom, self.superview.contentInset.right);
        }];
    }
}
#pragma mark 一定要记得移除观察者，不然会崩
- (void)dealloc  {
    [self.superview removeObserver:self forKeyPath:ZCContentOffset];
}
#pragma mark 设置图片相关方法
- (void)setHeaderNormalImageWithName:(NSString *)imageName{
    self.headerNormoalImage = [UIImage imageNamed:imageName];
}
- (void)setHeaderPullImageWithName:(NSString *)imageName {
    self.headerPullingImage = [UIImage imageNamed:imageName];
}
- (void)setAnimantionImages:(NSArray *)images{
    self.animationImages = images;
    self.imageView.animationImages = self.animationImages;
}
#pragma mark懒加载子控件,放到最后这样不影响主逻辑
// 1 图片控件
- (UIImageView *)imageView {
    if (_imageView == nil) {
        UIImageView *imageView = [[UIImageView alloc] init];
        //如果没有设置动画图片
        if (self.animationImages == nil)
        {
            if (self.headerNormoalImage == nil) {//没有设置正常图片，则采用默认的
                imageView.image = [UIImage imageNamed:@"down"];
            }
            else {//采用设置的图片
                imageView.image = self.headerNormoalImage;
            }
        }else {//   如果设置了动画，则采用第一张做正常时的图片
            imageView.image = self.animationImages[0];
        }
        imageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        [self addSubview: imageView];
        _imageView = imageView;
    }
    return _imageView;
}
//2 文本控件
- (UILabel *)label {
    if (_label == nil) {
        //2 文本控件
        UILabel *label = [[UILabel alloc] init];
        label.textColor = [UIColor darkGrayColor];
        label.font = [UIFont systemFontOfSize:13];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"下拉刷新";
        [label sizeToFit];
        [self addSubview:label];
        _label = label;
    }
    return _label;
}
//菊花控件
- (UIActivityIndicatorView *)activityView {
    if (_activityView == nil) {
        UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] init];
        self.activityView = activityView;
        activityView.bounds = self.imageView.bounds;
        activityView.autoresizingMask = self.imageView.autoresizingMask;
        [self addSubview: activityView];
    }
    return _activityView;
}
@end
