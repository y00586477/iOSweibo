//
//  Home.m
//  Test
//
//  Created by bytedance on 2021/7/29.
//

#import "Home.h"
#import "PostList.h"
#import "DataSource.h"

#import <Masonry/Masonry.h>
#import <AFNetworking/AFNetworking.h>

NSString * const accessToken = @"2.00LeSZFH8TX72C1f61f74666wMXSDB";
NSString * const urlLatest = @"https://api.weibo.com/2/statuses/home_timeline.json";

@interface Home ()

@property (nonatomic) UIButton *btn;
@property(nonatomic) PostList *postList;
@property(nonatomic) NSString *sign;

-(void)changeSign:(NSString *)sign;

@end

@implementation Home

- (instancetype)init
{
    self = [super init];
    if (self) {
        _sign = @"ttt";
        _postList = [[PostList alloc] init];
        [self addObserver:_postList forKeyPath:@"sign" options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title = @"主页";
    self.view.backgroundColor = UIColor.whiteColor;
    self.btn = [UIButton buttonWithType:UIButtonTypeSystem];
    self.btn.backgroundColor = UIColor.redColor;
    [self.btn setTitle:@"Timeline" forState:UIControlStateNormal];
    [self.btn addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.btn];
    
    [self.btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_top).with.offset(200);
            make.centerX.equalTo(self.view.mas_centerX);
            make.width.mas_equalTo(100);
            make.height.mas_equalTo(40);
    }];
}

-(void)click{
    self.hidesBottomBarWhenPushed = YES;
    [self changeSign:@"dddd"];
    [self.navigationController pushViewController:_postList animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

-(void)changeSign:(NSString *)sign{
    self.sign = sign;
}

@end
