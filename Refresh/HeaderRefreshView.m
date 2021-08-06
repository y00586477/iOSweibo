//
//  HeaderRefreshView.m
//  Test
//
//  Created by bytedance on 2021/8/3.
//

#import "HeaderRefreshView.h"
#import <objc/message.h>

#define ContentOffset @"contentOffset"
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
static const int headerRefreshHeight = 60;

typedef enum{
    StateNormal = 0,
    StatePull,
    StateRefresh
} state;

@interface HeaderRefreshView()

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

@implementation HeaderRefreshView

+ (instancetype)addHeaderRefreshViewWithTarget:(id)target action:(SEL)action{
    HeaderRefreshView *headerRefresh = [[self alloc] init];
    headerRefresh.frame = CGRectMake(0, -headerRefreshHeight, ScreenWidth, headerRefreshHeight);
    headerRefresh.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.0];
    headerRefresh.currentState = StateNormal;
    if (target != nil && action != nil) {
        headerRefresh.target = target;
        headerRefresh.action = action;
    }else {
        NSLog(@"请设置刷新时调用的方法！！！");
    }
    return headerRefresh;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat imgViewWH = 40;
    CGFloat imgViewX = ScreenWidth * 0.3;
    self.imageView.frame = CGRectMake(imgViewX, (self.frame.size.height - imgViewWH) / 2, imgViewWH, imgViewWH);
    
    CGFloat labelX = CGRectGetMaxX(self.imageView.frame);
    self.label.frame = CGRectMake(labelX, (self.frame.size.height - imgViewWH) / 2, 100, imgViewWH);
    
    self.activityView.frame = CGRectMake(imgViewX, (self.frame.size.height - imgViewWH) / 2, imgViewWH, imgViewWH);
}

- (void)willMoveToSuperview:(UIView *)newSuperview{
    if ([newSuperview isKindOfClass:[UIScrollView class]]) {
        self.superview = (UIScrollView *)newSuperview;
        [newSuperview addObserver:self forKeyPath:ContentOffset options:NSKeyValueObservingOptionNew context:nil];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:ContentOffset]) {
        [self adjustRefreshView];
    }
}

-(void)adjustRefreshView {
    if (self.superview.contentInset.top == 64.0) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            self.contentOffSetY = self.superview.contentInset.top;
        });
    }
    CGFloat y =self.superview.contentOffset.y;
    if (self.superview.isDragging) {
        if (y < -self.contentOffSetY && y > -self.contentOffSetY - headerRefreshHeight && self.currentState == StatePull) {
            self.currentState = StateNormal;
        } else if (y <= self.contentOffSetY - headerRefreshHeight && self.currentState == StateNormal) {
            self.currentState = StatePull;
        }
    } else if (self.currentState == StatePull && y <= -self.contentOffSetY - headerRefreshHeight) {
        self.currentState = StateRefresh;
    } else if (self.currentState == StateRefresh) {
        void (*action)(id, SEL) = (void (*)(id, SEL)) objc_msgSend;
        action(self.target, self.action);
    }
}

- (void)setCurrentState:(int)currentState{
    if (currentState == _currentState) {
        return;
    }
    _currentState = currentState;
    if (_currentState == StateNormal) {
        self.imageView.hidden = NO;
        [self.activityView stopAnimating];
        self.activityView.hidden = YES;
        [UIView animateWithDuration:0.5 animations:^{
                    [self.imageView stopAnimating];
                    self.label.text = @"下拉刷新";
        }];
    } else if (_currentState == StatePull) {
        self.label.text = @"正在刷新...";
        self.activityView.hidden = NO;
        self.imageView.hidden = YES;
        [self.activityView startAnimating];
        [UIView animateWithDuration:0.25 animations:^{
            self.superview.contentInset = UIEdgeInsetsMake(self.superview.contentInset.top + headerRefreshHeight, self.superview.contentInset.left, self.superview.contentInset.bottom, self.superview.contentInset.right);
        }];
    }
}
- (void)beginHeaderRefresh{
    self.currentState = StateRefresh;
}

- (void)endHeaderRefresh{
    if (self.currentState == StateRefresh) {
        self.currentState = StateNormal;
        [UIView animateWithDuration:0.25 animations:^{
            self.superview.contentInset = UIEdgeInsetsMake(self.superview.contentInset.top - headerRefreshHeight, self.superview.contentInset.left, self.superview.contentInset.bottom, self.superview.contentInset.right);
        }];
    }
}
- (void)dealloc
{
    [self.superview removeObserver:self forKeyPath:ContentOffset];
}

- (UIImageView *)imageView {
    if (_imageView == nil) {
        UIImageView *imageView = [[UIImageView alloc] init];
        if (self.animationImages == nil)
        {
            if (self.headerNormoalImage == nil) {
                imageView.image = [UIImage imageNamed:@"down"];
            }
            else {
                imageView.image = self.headerNormoalImage;
            }
        }else {
            imageView.image = self.animationImages[0];
        }
        imageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        [self addSubview: imageView];
        _imageView = imageView;
    }
    return _imageView;
}

- (UILabel *)label {
    if (_label == nil) {
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
