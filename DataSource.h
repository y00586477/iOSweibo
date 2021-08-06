//
//  DataSource.h
//  Test
//
//  Created by bytedance on 2021/7/30.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef struct{
    NSString *name;
    NSString *time;
    NSString *img;
    BOOL bVip;
    BOOL bLiked;
    NSString *content;
    NSMutableArray *imgArray;
    int iCommentNum;
    int iRepost;
    int iLikedNum;
}PostData;

@interface DataSource : NSObject

@property(nonatomic) NSString *name;
@property(nonatomic) NSString *time;
@property(nonatomic) NSString *avatar;
@property(nonatomic) BOOL bVip;
@property(nonatomic) BOOL bLiked;
@property(nonatomic) NSString *content;
@property(nonatomic) NSMutableArray *imgArray;
@property(nonatomic) int iCommentNum;
@property(nonatomic) int iRepostNum;
@property(nonatomic) int iLikedNum;

@property(nonatomic) NSMutableArray *postArray;

-(instancetype)initWithData:(NSDictionary *)dic;

-(void)parseData:(NSDictionary *)dic;

@end

NS_ASSUME_NONNULL_END
