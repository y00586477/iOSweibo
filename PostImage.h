//
//  PostImage.h
//  Test
//
//  Created by bytedance on 2021/7/27.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PostImage : UIView

@property(nonatomic) NSMutableArray *imgArray;
@property(nonatomic) CGFloat height;
@property(nonatomic) NSMutableArray *imgViewArray;

-(instancetype)initWithImages:(NSArray *)imageArray;

@end

NS_ASSUME_NONNULL_END
