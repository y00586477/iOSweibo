//
//  Post.h
//  Test
//
//  Created by bytedance on 2021/7/23.
//

#import <UIKit/UIKit.h>
#include "DataSource.h"
#import "PostImage.h"

NS_ASSUME_NONNULL_BEGIN

//typedef struct{
//    NSString *name;
//    NSString *time;
//    NSString *img;
//    BOOL bVip;
//    BOOL bLiked;
//    NSString *content;
//    NSArray *imgArray;
//    int iCommentNum;
//    int iLikedNum;
//}PostData;

@interface Post : UIView

@property (nonatomic) PostData data;
@property (nonatomic, strong) DataSource *dataSouce;

-(instancetype)initWithData:(PostData)postData;

-(instancetype)initWithObject:(DataSource *)dataSource;

@end

NS_ASSUME_NONNULL_END
