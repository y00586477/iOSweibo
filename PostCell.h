//
//  PostCell.h
//  Test
//
//  Created by bytedance on 2021/8/2.
//

#import <UIKit/UIKit.h>
#import "DataSource.h"
#import "PostImage.h"

NS_ASSUME_NONNULL_BEGIN

@interface PostCell : UITableViewCell

@property (nonatomic, strong) DataSource *dataSouce;
@property(nonatomic) UIImageView *image;
@property(nonatomic) UILabel *lableName;
@property(nonatomic) UILabel *lableTime;
@property(nonatomic) UIButton *btn;
@property(nonatomic) UILabel *lableVip;
@property(nonatomic) UILabel *lableContent;
@property(nonatomic) PostImage *postImage;
@property(nonatomic) UIButton *btnMessage;
@property(nonatomic) UIButton *btnCall;

@property(nonatomic, strong) UIColor *highColor;
@property(nonatomic, strong) NSMutableArray<NSString *> *ruleArray;

-(void)config:(DataSource *)datasource;

@end

NS_ASSUME_NONNULL_END
