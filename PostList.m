//
//  PostList.m
//  Test
//
//  Created by ECom-iOS on 2021/3/15.
//

#import "PostList.h"
#import "Post.h"
#import "PostImage.h"
#import "Navigation.h"
#import "Detials.h"
#import "PostCell.h"
#import "UIScrollView+ZCRefresh.h"
#import "ZCHeaderRefreshView.h"
#import "FooterRefreshView.h"

#import <Masonry/Masonry.h>
#import <AFNetworking/AFNetworking.h>
#import "LoadingAnimationView.h"

#define NumberOfCells 6
#define NumberOfLoad 4
#define ScreenWidth [UIScreen mainScreen].bounds.size.width

@interface PostList () <UITableViewDelegate, UITableViewDataSource, UISceneDelegate>
{
    UIRefreshControl *refreshControl;
    LoadingAnimationView *loadView;
}
@property(nonatomic, strong) NSMutableArray *data;
@property (nonatomic, strong) NSMutableArray *dataSouce;
@property (nonatomic, strong) NSMutableArray *dataSouceRecomment;
@property(nonatomic) UITableView *tableViewAttention;
@property(nonatomic) UITableView *tableViewRecomment;
@property(nonatomic) UIScrollView *scrollView;

-(PostData)getPost:(NSDictionary *)dic;

@end

@implementation PostList

- (instancetype)init
{
    self = [super init];
    if (self) {
        _dataSouce = [[NSMutableArray alloc] init];
        _data = [[NSMutableArray alloc] init];
//        [self getLatestNews];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Timeline";
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.view.backgroundColor = UIColor.blueColor;
    
    _scrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
    _scrollView.delegate = self;
    _scrollView.contentSize = CGSizeMake(self.view.frame.size.width * 2, self.view.frame.size.height);
    _scrollView.pagingEnabled = YES;
    _scrollView.directionalLockEnabled = YES;
    _scrollView.bounces = NO;
    _scrollView.showsHorizontalScrollIndicator= NO;

    _tableViewAttention = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    _tableViewAttention.delegate = self;
    _tableViewAttention.dataSource = self;
    [self.scrollView addSubview:_tableViewAttention];
    _tableViewAttention.showsVerticalScrollIndicator = NO;

    _tableViewRecomment = [[UITableView alloc] initWithFrame:CGRectMake(self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    _tableViewRecomment.delegate = self;
    _tableViewRecomment.dataSource = self;
    [self.scrollView addSubview:_tableViewRecomment];

    [self.view addSubview:_scrollView];

    self.tableViewAttention.estimatedRowHeight = 60;
    self.tableViewAttention.rowHeight= UITableViewAutomaticDimension;

    self.tableViewRecomment.estimatedRowHeight = 60;
    self.tableViewRecomment.rowHeight= UITableViewAutomaticDimension;
    
    ZCHeaderRefreshView *headerRefreshView = [ZCHeaderRefreshView addHeaderRefreshViewWithTarget:self action:@selector(refresh)];
    _tableViewAttention.headerRefreshView = headerRefreshView;
    
    FooterRefreshView *footerRefreshView = [FooterRefreshView addFooterRefreshViewWithTarget:self action:@selector(load)];
    _tableViewAttention.footerRefreshView = footerRefreshView;
    
    loadView = [[LoadingAnimationView alloc] init];
    [loadView showInView:self.view];
}

-(void)viewDidAppear:(BOOL)animated{
    [self.tableViewAttention reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataSouce.count;
//    if ([tableView isEqual:_tableViewAttention]) {
//        return _dataSouce.count;
//    } else{
//        return _dataSouceRecomment.count;
//    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellId = @"cellPost";
    PostCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[PostCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    [cell config:self.dataSouce[indexPath.row]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Detials *details = [[Detials alloc] init];
    [details config:self.dataSouce[indexPath.row]];
    [self.navigationController pushViewController:details animated:NO];
}

- (PostData)getPost:(NSDictionary *)dic{
    PostData data;
    data.img = [dic objectForKey:@"avatar"];
    data.bVip = [[dic objectForKey:@"vip"] boolValue];
    data.name = [dic objectForKey:@"name"];
    data.time = [dic objectForKey:@"date"];
    data.content = [dic objectForKey:@"text"];
    data.imgArray = [dic objectForKey:@"images"];
    data.bLiked = [[dic objectForKey:@"isLiked"] boolValue];
    data.iCommentNum = [[dic objectForKey:@"commentCount"] intValue];
    data.iLikedNum = [[dic objectForKey:@"likeCount"] intValue];
    return data;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        sleep(1);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self getLatestNews];
            [self.tableViewAttention reloadData];
            [loadView dismiss];
        });
    });
}

- (void)refresh{
    [self getLatestNews];
    [self.tableViewAttention reloadData];
    [self.tableViewAttention.headerRefreshView endHeaderRefresh];
}

- (void)load{
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSUInteger length = self.dataSouce.count;
        for (NSUInteger i = length; i < length + NumberOfLoad && i < self.data.count; i++) {
            [self.dataSouce addObject:self.data[i]];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableViewAttention reloadData];
            [self.tableViewAttention.footerRefreshView endFooterRefresh];
        });
    });
}
-(void)getLatestNews{
    [self.dataSouce removeAllObjects];
    [self.data removeAllObjects];
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    NSString *url = urlLatest;
//    NSDictionary *para = @{@"access_token":accessToken};
//    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//    [manager GET:url parameters:para headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSArray *userArray = [responseObject objectForKey:@"statuses"];
//        for(NSDictionary *subDic in userArray){
//            DataSource *data = [[DataSource alloc] initWithData:subDic];
//            [self.dataArray addObject:data];
//        }
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSLog(@"%@", error);
//    }];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"response.json" ofType:nil];
    NSData *data = [[NSData alloc] initWithContentsOfFile:path];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    NSArray *userArray = [dic objectForKey:@"statuses"];
    int i = 0;
    for(NSDictionary *subDic in userArray){
        DataSource *data = [[DataSource alloc] initWithData:subDic];
        [self.data addObject:data];
        if (i < NumberOfCells) {
            [self.dataSouce addObject:data];
        }
        i++;
    }
    return;
}

@end
