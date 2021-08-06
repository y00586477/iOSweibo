//
//  Detials.h
//  Test
//
//  Created by bytedance on 2021/7/29.
//

#import <UIKit/UIKit.h>
#import "DataSource.h"
#import "PostImage.h"

NS_ASSUME_NONNULL_BEGIN

@interface Detials : UIViewController

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

@property (strong, nonatomic) UIAlertAction *okAction;
@property (strong, nonatomic) UIAlertAction *cancelAction;

-(void)config:(DataSource *)datasource;
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context;

@end

NS_ASSUME_NONNULL_END
