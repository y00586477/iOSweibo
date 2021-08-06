//
//  Post.m
//  Test
//
//  Created by bytedance on 2021/7/23.
//

#import "Post.h"
#import "PostImage.h"
#import <Masonry/Masonry.h>

float const fHeight = 60;

@interface Post()

@property(nonatomic) UIImageView *image;
@property(nonatomic) UILabel *lableName;
@property(nonatomic) UILabel *lableTime;
@property(nonatomic) UIButton *btn;
@property(nonatomic) UILabel *lableVip;
@property(nonatomic) UILabel *lableContent;
@property(nonatomic) PostImage *postImage;
@property(nonatomic) UIButton *btnMessage;
@property(nonatomic) UIButton *btnCall;

-(NSString *)getNum:(int) iNum;

@end

@implementation Post

- (instancetype)initWithObject:(DataSource *)dataSource{
    self = [super init];
    _dataSouce = dataSource;
    if (self) {
        _image = [[UIImageView alloc] init];
        _image.backgroundColor = UIColor.greenColor;
        NSURL *url = [NSURL URLWithString:_dataSouce.avatar];
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
        _image.image = image;
        _image.layer.cornerRadius = fHeight / 2;
        _image.layer.masksToBounds = YES;
        [self addSubview:_image];

        _lableVip = [[UILabel alloc] init];
        _lableVip.text = @"V";
        _lableVip.textColor = UIColor.yellowColor;
        _lableVip.textAlignment = NSTextAlignmentCenter;
        _lableVip.font = [UIFont systemFontOfSize:11];
        _lableVip.backgroundColor = UIColor.redColor;
        _lableVip.layer.cornerRadius = 7.5;
        _lableVip.layer.masksToBounds = YES;
        [self addSubview:_lableVip];
        if (_dataSouce.bVip) {
            _lableVip.hidden = NO;
        } else {
            _lableVip.hidden = YES;
        }

        _lableName = [[UILabel alloc] init];
        _lableName.textColor = UIColor.redColor;
        _lableName.text = _dataSouce.name;
        [self addSubview:_lableName];

        _lableTime = [[UILabel alloc] init];
        _lableTime.text = _dataSouce.time;
        _lableTime.font = [UIFont fontWithName:@"Arial" size:12];
        [self addSubview:_lableTime];

        _btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_btn setTitle:@"+关注" forState:UIControlStateNormal];
        [_btn setTitleColor:UIColor.blueColor forState:UIControlStateNormal];
        _btn.layer.masksToBounds = YES;
        _btn.layer.cornerRadius = 15;
        _btn.layer.borderColor = UIColor.redColor.CGColor;
        _btn.layer.borderWidth = 1;
        [_btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_btn];
        
        _lableContent = [[UILabel alloc] init];
        _lableContent.font = [UIFont systemFontOfSize:15];
        _lableContent.numberOfLines = 0;
        _lableContent.text = _dataSouce.content;
        CGSize size = [_lableContent sizeThatFits:CGSizeMake([UIScreen mainScreen].bounds.size.width, MAXFLOAT)];
        [self addSubview:_lableContent];
        
        _postImage = [[PostImage alloc] initWithImages:_dataSouce.imgArray];
        _postImage.backgroundColor = UIColor.redColor;
        _postImage.imgArray = _dataSouce.imgArray;
        [self addSubview:_postImage];
        
        _btnMessage = [[UIButton alloc] init];
//        _btnMessage.backgroundColor = UIColor.redColor;
        [_btnMessage setTitle:[self getNum:_dataSouce.iCommentNum] forState:UIControlStateNormal];
        _btnMessage.titleLabel.font = [UIFont systemFontOfSize:10];
        [_btnMessage setTitleColor:UIColor.redColor forState:UIControlStateNormal];
        if (@available(iOS 13.0, *)) {
            [_btnMessage setImage:[UIImage systemImageNamed:@"message"] forState:0];
        } else {
            // Fallback on earlier versions
        }
        [self addSubview:_btnMessage];
        
        _btnCall = [[UIButton alloc] init];
//        _btnCall.backgroundColor = UIColor.redColor;
        [_btnCall setTitle:[self getNum:_dataSouce.iLikedNum] forState:UIControlStateNormal];
        _btnCall.titleLabel.font = [UIFont systemFontOfSize:10];
        [_btnCall setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [_btnCall setImage:[UIImage systemImageNamed:_dataSouce.bLiked ? @"heart.fill" : @"heart"] forState:UIControlStateNormal];
        [_btnCall addTarget:self action:@selector(doCall:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_btnCall];
        
        [_btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.mas_right).with.offset(-80);
                make.centerY.equalTo(self.mas_top).with.offset(30);
                make.width.mas_equalTo(60);
                make.height.mas_offset(30);
        }];

        [_image mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.mas_left);
                make.top.equalTo(self.mas_top);
                make.width.height.mas_equalTo(fHeight);
        }];

        [_lableName mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.mas_left).with.offset(fHeight);
                make.top.equalTo(self.mas_top);
                make.right.equalTo(_btn.mas_left).with.offset(-5);
                make.height.mas_equalTo(20);
        }];

        [_lableTime mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.mas_left).with.offset(fHeight);
                make.top.equalTo(self.mas_top).with.offset(40);
                make.right.equalTo(_btn.mas_left).with.offset(-5);
                make.height.mas_equalTo(20);
        }];

        [_lableVip mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.top.mas_equalTo(fHeight - 15);
                make.width.height.mas_equalTo(15);
        }];

        [_lableContent mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(_image.mas_bottom).with.offset(5);
            make.left.equalTo(self.mas_left);
            make.right.equalTo(self.mas_right);
            make.height.mas_equalTo(size.height);
        }];
        [_postImage mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.mas_left);
                make.top.equalTo(_lableContent.mas_bottom).with.offset(5);
                make.width.equalTo(self.mas_width).with.offset(20);
        }];
        
        [_btnMessage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).with.offset(30);
            make.top.equalTo(_postImage.mas_bottom).with.offset(10);
            make.width.mas_equalTo(60);
            make.height.mas_equalTo(20);
            make.bottom.equalTo(self.mas_bottom).with.offset(-10);
        }];
        
        [_btnCall mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).with.offset(-30);
            make.centerY.equalTo(_btnMessage.mas_centerY);
            make.width.equalTo(_btnMessage.mas_width);
            make.height.equalTo(_btnMessage.mas_height);
        }];
    }
    return self;
}

-(instancetype)initWithData:(PostData)postData
{
    self = [super init];
    _data = postData;
    if (self) {
        _image = [[UIImageView alloc] init];
        _image.backgroundColor = UIColor.greenColor;
        _image.image = [UIImage imageNamed:_data.img];
        _image.layer.cornerRadius = fHeight / 2;
        _image.layer.masksToBounds = YES;
        [self addSubview:_image];

        _lableVip = [[UILabel alloc] init];
        _lableVip.text = @"V";
        _lableVip.textColor = UIColor.yellowColor;
        _lableVip.textAlignment = NSTextAlignmentCenter;
        _lableVip.font = [UIFont systemFontOfSize:11];
        _lableVip.backgroundColor = UIColor.redColor;
        _lableVip.layer.cornerRadius = 7.5;
        _lableVip.layer.masksToBounds = YES;
        [self addSubview:_lableVip];
        if (_data.bVip) {
            _lableVip.hidden = NO;
        } else {
            _lableVip.hidden = YES;
        }

        _lableName = [[UILabel alloc] init];
        _lableName.textColor = UIColor.redColor;
        _lableName.text = _data.name;
        [self addSubview:_lableName];

        _lableTime = [[UILabel alloc] init];
        _lableTime.text = _data.time;
        _lableTime.font = [UIFont fontWithName:@"Arial" size:12];
        [self addSubview:_lableTime];

        _btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_btn setTitle:@"+关注" forState:UIControlStateNormal];
        [_btn setTitleColor:UIColor.blueColor forState:UIControlStateNormal];
        _btn.layer.masksToBounds = YES;
        _btn.layer.cornerRadius = 15;
        _btn.layer.borderColor = UIColor.redColor.CGColor;
        _btn.layer.borderWidth = 1;
        [_btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_btn];
        
        _lableContent = [[UILabel alloc] init];
        _lableContent.font = [UIFont systemFontOfSize:15];
        _lableContent.numberOfLines = 0;
        _lableContent.text = _data.content;
        CGSize size = [_lableContent sizeThatFits:CGSizeMake([UIScreen mainScreen].bounds.size.width, MAXFLOAT)];
        [self addSubview:_lableContent];
        
        _postImage = [[PostImage alloc] initWithImages:_data.imgArray];
        _postImage.backgroundColor = UIColor.redColor;
        _postImage.imgArray = _data.imgArray;
        [self addSubview:_postImage];
        
        _btnMessage = [[UIButton alloc] init];
//        _btnMessage.backgroundColor = UIColor.redColor;
        [_btnMessage setTitle:[self getNum:postData.iCommentNum] forState:UIControlStateNormal];
        _btnMessage.titleLabel.font = [UIFont systemFontOfSize:10];
        [_btnMessage setTitleColor:UIColor.redColor forState:UIControlStateNormal];
        if (@available(iOS 13.0, *)) {
            [_btnMessage setImage:[UIImage systemImageNamed:@"message"] forState:0];
        } else {
            // Fallback on earlier versions
        }
        [self addSubview:_btnMessage];
        
        _btnCall = [[UIButton alloc] init];
//        _btnCall.backgroundColor = UIColor.redColor;
        [_btnCall setTitle:[self getNum:postData.iLikedNum] forState:UIControlStateNormal];
        _btnCall.titleLabel.font = [UIFont systemFontOfSize:10];
        [_btnCall setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [_btnCall setImage:[UIImage systemImageNamed:postData.bLiked ? @"heart.fill" : @"heart"] forState:UIControlStateNormal];
        [_btnCall addTarget:self action:@selector(doCall:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_btnCall];
        
        [_btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.mas_right).with.offset(-80);
                make.centerY.equalTo(self.mas_top).with.offset(30);
                make.width.mas_equalTo(60);
                make.height.mas_offset(30);
        }];

        [_image mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.mas_left);
                make.top.equalTo(self.mas_top);
                make.width.height.mas_equalTo(fHeight);
        }];

        [_lableName mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.mas_left).with.offset(fHeight);
                make.top.equalTo(self.mas_top);
                make.right.equalTo(_btn.mas_left).with.offset(-5);
                make.height.mas_equalTo(20);
        }];

        [_lableTime mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.mas_left).with.offset(fHeight);
                make.top.equalTo(self.mas_top).with.offset(40);
                make.right.equalTo(_btn.mas_left).with.offset(-5);
                make.height.mas_equalTo(20);
        }];

        [_lableVip mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.top.mas_equalTo(fHeight - 15);
                make.width.height.mas_equalTo(15);
        }];

        [_lableContent mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(_image.mas_bottom).with.offset(5);
            make.left.equalTo(self.mas_left);
            make.right.equalTo(self.mas_right);
            make.height.mas_equalTo(size.height);
        }];
        [_postImage mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.mas_left);
                make.top.equalTo(_lableContent.mas_bottom).with.offset(5);
                make.width.equalTo(self.mas_width).with.offset(20);
        }];
        
        [_btnMessage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).with.offset(30);
            make.top.equalTo(_postImage.mas_bottom).with.offset(10);
            make.width.mas_equalTo(60);
            make.height.mas_equalTo(20);
            make.bottom.equalTo(self.mas_bottom).with.offset(-10);
        }];
        
        [_btnCall mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).with.offset(-30);
            make.centerY.equalTo(_btnMessage.mas_centerY);
            make.width.equalTo(_btnMessage.mas_width);
            make.height.equalTo(_btnMessage.mas_height);
        }];
    }
    return self;
}

//- (void)drawRect:(CGRect)rect{
//
//
//}

- (void)setData:(PostData)data{
    _image.image = [UIImage imageNamed:data.img];
    _lableName.text = data.name;
    _lableTime.text = data.time;
    if (data.bVip) {
        _lableVip.hidden = NO;
    } else {
        _lableVip.hidden = YES;
    }
    _postImage.imgArray = data.imgArray;
}

-(void)btnClick:(UIButton *)btn{
    [btn setTitle:@"已关注" forState:UIControlStateNormal];
}

-(void)doCall:(UIButton *)btn{
    _data.bLiked = !_data.bLiked;
    [btn setImage:[UIImage systemImageNamed:_data.bLiked ? @"heart.fill" : @"heart"] forState:0];
    if (-_data.bLiked) {
        _data.iLikedNum++;
    } else {
        _data.iLikedNum--;
    }
    [btn setTitle:[self getNum:_data.iLikedNum] forState:UIControlStateNormal];
}

//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    NSLog(@"click");
//}

-(NSString *)getNum:(int) iNum{
    NSString *message = [NSString stringWithFormat:@"%d", iNum];
    if (iNum > 10000) {
        message = [NSString stringWithFormat:@"%.1f万", iNum / 10000.0];
    }
    return message;
}
@end
