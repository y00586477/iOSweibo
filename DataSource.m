//
//  DataSource.m
//  Test
//
//  Created by bytedance on 2021/7/30.
//

#import "DataSource.h"

@implementation DataSource

-(instancetype)initWithData:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.imgArray = [NSMutableArray array];
        self.iLikedNum = [[dic objectForKey:@"attitudes_count"] intValue];
        self.iRepostNum = [[dic objectForKey:@"reposts_count"] intValue];
        self.iCommentNum = [[dic objectForKey:@"comments_count"] intValue];
        self.content = [dic objectForKey:@"text"];
        NSDictionary *user = [dic objectForKey:@"user"];
        self.name = [user objectForKey:@"name"];
        self.time = [dic objectForKey:@"created_at"];
        self.avatar = [user objectForKey:@"avatar_hd"];
        self.bVip = [[user objectForKey:@"verified"] boolValue];
//        int iPicNum = [[dic objectForKey:@"pic_num"] intValue];
        NSArray *picArray = [dic objectForKey:@"pic_urls"];
        for(NSDictionary *picDic in picArray) {
            NSString *pic = [picDic objectForKey:@"thumbnail_pic"];
            [self.imgArray addObject:pic];
        }
    }
    return self;
}

-(void)parseData:(NSDictionary *)dic{
    NSArray *userArray = [dic objectForKey:@"statuses"];
    for(NSDictionary *subDic in userArray) {
        PostData data;
        data.imgArray = [NSMutableArray array];
        data.iLikedNum = [[subDic objectForKey:@"attitudes_count"] intValue];
        data.iRepost = [[subDic objectForKey:@"reposts_count"] intValue];
        data.iCommentNum = [[subDic objectForKey:@"comments_count"] intValue];
        data.time = [subDic objectForKey:@"created_at"];
        data.content = [subDic objectForKey:@"text"];
        NSDictionary *user = [subDic objectForKey:@"user"];
        data.name = [user objectForKey:@"name"];
        data.img = [user objectForKey:@"avatar_hd"];
        data.bVip = [[user objectForKey:@"verified"] boolValue];
//        int iPicNum = [[subDic objectForKey:@"pic_num"] intValue];
        NSArray *picArray = [subDic objectForKey:@"pic_urls"];
        for(NSDictionary *picDic in picArray) {
            NSString *pic = [picDic objectForKey:@"thumbnail_pic"];
            [data.imgArray addObject:pic];
        }
        // [_postArray addObject:&data];
    }
}

@end
