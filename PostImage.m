//
//  PostImage.m
//  Test
//
//  Created by bytedance on 2021/7/27.
//

#import "PostImage.h"
#import <Masonry/Masonry.h>

static CGRect oldframe;

@interface PostImage()

-(void)DrawImages:(NSArray *)imageArray;
-(void)DrawImagesRow:(NSArray *)imageArray;
-(void)DrawImage:(NSString *)imgUrl;

@end
@implementation PostImage

-(instancetype)initWithImages:(NSArray *)imageArray
{
    self = [super init];
    _height = 0.0;
    {
        [self DrawImages:imageArray];
    }
    return self;
}

- (void)DrawImages:(NSArray *)imageArray{
    _height = 0;
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    if (imageArray.count < 1) {
        return;
    }else if (imageArray.count == 1) {
        [self DrawImage:imageArray[0]];
    } else if (imageArray.count <= 3) {
        [self DrawImagesRow:imageArray];
    } else if (imageArray.count == 4) {
        [self DrawImagesRow:[imageArray subarrayWithRange:NSMakeRange(0, 2)]];
        [self DrawImagesRow:[imageArray subarrayWithRange:NSMakeRange(2, 2)]];
    } else {
        [self DrawImagesRow:[imageArray subarrayWithRange:NSMakeRange(0, 3)]];
        [self DrawImagesRow:[imageArray subarrayWithRange:NSMakeRange(3, imageArray.count - 3)]];
    }
}

-(void)DrawImage:(NSString *)imgUrl{
    CGFloat fX =  [UIScreen mainScreen].bounds.size.width - 20;
    CGFloat width = 0;
    CGFloat height = 0;
    NSURL *url = [NSURL URLWithString:[imgUrl stringByReplacingOccurrencesOfString:@"thumbnail" withString:@"bmiddle"]];
    NSData *data = [NSData dataWithContentsOfURL:url];
    UIImage *image = [UIImage imageWithData:data];
    CGSize size = image.size;
    width = MIN(size.width, fX);
    height = MIN(fX, size.height * fX / size.width);
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    imgView.image = image;
    imgView.contentMode = UIViewContentModeScaleAspectFill;
    imgView.clipsToBounds = YES;
    [self addSubview:imgView];
    [_imgViewArray addObject:imgView];
    _height += height;
    if (size.height > height * 1.4) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(width - 40, height - 20, 40, 20)];
        label.text = @"长图";
        label.textColor = UIColor.whiteColor;
        label.backgroundColor = UIColor.grayColor;
        [self addSubview:label];
    }
    
    imgView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapG = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickImage:)];
    [imgView addGestureRecognizer:tapG];

}

-(void)DrawImagesRow:(NSArray *)imageArray{
    NSUInteger iNum = imageArray.count;
    CGFloat fX =  ([UIScreen mainScreen].bounds.size.width - 20) / iNum;
    CGFloat width = 0;
    for (NSString *img in imageArray) {
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(width, _height, fX, fX)];
        NSURL *url = [NSURL URLWithString:[img stringByReplacingOccurrencesOfString:@"thumbnail" withString:@"bmiddle"]];
        NSData *data = [NSData dataWithContentsOfURL:url];
        UIImage *image = [UIImage imageWithData:data];
        imgView.image = image;
        imgView.contentMode = UIViewContentModeScaleAspectFill;
        imgView.clipsToBounds = YES;
        [self addSubview:imgView];
        [_imgViewArray addObject:imgView];
        width += fX;
        
        imgView.userInteractionEnabled = YES;
//        UILongPressGestureRecognizer *longP = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
//        [imgView addGestureRecognizer:longP];
        
        imgView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapG = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickImage:)];
        [imgView addGestureRecognizer:tapG];
    }
    _height += fX;
}

- (void)setImgArray:(NSArray *)imgArray{
    _imgArray = imgArray;
    [self DrawImages:_imgArray];
}

-(void)clickImage:(UITapGestureRecognizer *)tap{
//    NSLog(@"tag------------------------------------");
    UIImageView *clickedImageView = (UIImageView *)tap.view;
    [self scanBigImageWithImageView:clickedImageView];
}

-(void)longPress:(UILongPressGestureRecognizer *)longP{
    if (longP.state == UIGestureRecognizerStateBegan) {
        NSLog(@"开始长按时调用");
    } else if (longP.state == UIGestureRecognizerStateChanged){
        NSLog(@"当长按拖动时调用");
    } else if(longP.state == UIGestureRecognizerStateEnded) {
        NSLog(@"当长摁手指松开时调用");
        UIImageView *curView = (UIImageView *)longP.view;
        NSInteger index = [self.imgViewArray indexOfObject:curView];
        [self.imgArray removeObjectAtIndex:index];
    }
}

-(void)scanBigImageWithImageView:(UIImageView *)currentImageview{
    UIImage *image = currentImageview.image;
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    
    //当前imageview的原始尺寸->将像素currentImageview.bounds由currentImageview.bounds所在视图转换到目标视图window中，返回在目标视图window中的像素值
//    oldframe = [currentImageview convertRect:currentImageview.bounds toView:window];
    
    backgroundView.backgroundColor = UIColor.grayColor;
    [backgroundView setAlpha:0];
 
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:oldframe];
    [imageView setImage:image];
    [imageView setTag:0];
    [backgroundView addSubview:imageView];
    [window addSubview:backgroundView];

    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideImageView:)];
    [backgroundView addGestureRecognizer:tapGestureRecognizer];

    //动画放大所展示的ImageView

    [UIView animateWithDuration:0.4 animations:^{
        CGFloat y,width,height;
        // 上下居中
        y = ([UIScreen mainScreen].bounds.size.height - image.size.height * [UIScreen mainScreen].bounds.size.width / image.size.width) * 0.5;
        //宽度为屏幕宽度
        width = [UIScreen mainScreen].bounds.size.width;
        //高度 根据图片宽高比设置
        height = image.size.height * [UIScreen mainScreen].bounds.size.width / image.size.width;
        [imageView setFrame:CGRectMake(0, y, width, height)];
        //重要！ 将视图显示出来
        [backgroundView setAlpha:1];
    } completion:nil];
}

-(void)hideImageView:(UITapGestureRecognizer *)tap{
    UIView *backgroundView = tap.view;
//    UIImageView *imageView = [tap.view viewWithTag:0];
    //恢复
    [UIView animateWithDuration:0.4 animations:^{
//        [imageView setFrame:oldframe];
        [backgroundView setAlpha:0];
    } completion:^(BOOL finished) {
       //完成后将背景视图删掉
        [backgroundView removeFromSuperview];
    }];
}

@end

