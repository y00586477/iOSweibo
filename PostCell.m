//
//  PostCell.m
//  Test
//
//  Created by bytedance on 2021/8/2.
//

#import "PostCell.h"
#import "PostImage.h"
#import <Masonry/Masonry.h>

@implementation PostCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _image = [[UIImageView alloc] init];
        _image.backgroundColor = UIColor.greenColor;
        NSURL *url = [NSURL URLWithString:_dataSouce.avatar];
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
        _image.image = image;
        _image.layer.cornerRadius = 60 / 2;
        _image.layer.masksToBounds = YES;
        [self.contentView addSubview:_image];
        
        _lableVip = [[UILabel alloc] init];
        _lableVip.text = @"V";
        _lableVip.textColor = UIColor.yellowColor;
        _lableVip.textAlignment = NSTextAlignmentCenter;
        _lableVip.font = [UIFont systemFontOfSize:11];
        _lableVip.backgroundColor = UIColor.redColor;
        _lableVip.layer.cornerRadius = 7.5;
        _lableVip.layer.masksToBounds = YES;
        [self.contentView addSubview:_lableVip];
        
        _btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_btn setTitle:@"+关注" forState:UIControlStateNormal];
        [_btn setTitleColor:UIColor.blueColor forState:UIControlStateNormal];
        _btn.layer.masksToBounds = YES;
        _btn.layer.cornerRadius = 15;
        _btn.layer.borderColor = UIColor.redColor.CGColor;
        _btn.layer.borderWidth = 1;
        [_btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_btn];
        
        _lableName = [[UILabel alloc] init];
        _lableName.textColor = UIColor.redColor;
        _lableName.text = @"ttttt";
        [self.contentView addSubview:_lableName];
        
        _lableTime = [[UILabel alloc] init];
        _lableTime.text = @"ssssss";
        _lableTime.font = [UIFont fontWithName:@"Arial" size:12];
        [self.contentView addSubview:_lableTime];
        
        _lableContent = [[UILabel alloc] init];
        _lableContent.font = [UIFont systemFontOfSize:15];
        _lableContent.numberOfLines = 0;
        _lableContent.text = @"fas";
        [self.lableContent sizeToFit];
        [self.contentView addSubview:_lableContent];
        
        _postImage = [[PostImage alloc] initWithImages:_dataSouce.imgArray];
        _postImage.backgroundColor = UIColor.redColor;
        _postImage.imgArray = _dataSouce.imgArray;
        [_postImage sizeToFit];
        [self.contentView addSubview:_postImage];
        
        _btnMessage = [[UIButton alloc] init];
        [_btnMessage setTitle:[self getNum:0] forState:UIControlStateNormal];
        _btnMessage.titleLabel.font = [UIFont systemFontOfSize:10];
        [_btnMessage setTitleColor:UIColor.redColor forState:UIControlStateNormal];
        if (@available(iOS 13.0, *)) {
            [_btnMessage setImage:[UIImage systemImageNamed:@"message"] forState:0];
        } else {
            // Fallback on earlier versions
        }
        [self.contentView addSubview:_btnMessage];
        
        
        _btnCall = [[UIButton alloc] init];
        [_btnCall setTitle:[self getNum:0] forState:UIControlStateNormal];
        _btnCall.titleLabel.font = [UIFont systemFontOfSize:10];
        [_btnCall setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        if (@available(iOS 13.0, *)) {
            [_btnCall setImage:[UIImage systemImageNamed:@"heart"] forState:UIControlStateNormal];
        } else {
            // Fallback on earlier versions
        }
        [_btnCall addTarget:self action:@selector(doCall:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_btnCall];
        
        [_image mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).with.offset(10);
            make.top.equalTo(self.contentView.mas_top);
            make.width.height.mas_equalTo(60);
        }];
        
        [_lableVip mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.mas_equalTo(60 - 15);
            make.width.height.mas_equalTo(15);
        }];
        
        [_btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_right).with.offset(-80);
            make.centerY.equalTo(self.contentView.mas_top).with.offset(30);
            make.width.mas_equalTo(60);
            make.height.mas_offset(30);
        }];
        
        [_lableName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_image.mas_right).with.offset(5);
            make.top.equalTo(self.contentView.mas_top);
            make.right.equalTo(_btn.mas_left).with.offset(-5);
            make.height.mas_equalTo(20);
        }];
        
        [_lableTime mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_image.mas_right).with.offset(5);
            make.top.equalTo(self.contentView.mas_top).with.offset(40);
            make.right.equalTo(_btn.mas_left).with.offset(-5);
            make.height.mas_equalTo(20);
        }];
        
        [_lableContent mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.image.mas_bottom).with.offset(5);
            make.left.equalTo(self.contentView.mas_left).with.offset(10);
            make.right.equalTo(self.contentView.mas_right).with.offset(-10);
        }];
        
        [_postImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).with.offset(10);
            make.top.equalTo(_lableContent.mas_bottom).with.offset(5);
            make.right.equalTo(self.contentView.mas_right).with.offset(-10);
        }];
        
        [_btnMessage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).with.offset(30);
            make.top.equalTo(_postImage.mas_bottom).with.offset(10);
            make.width.mas_equalTo(60);
            make.height.mas_equalTo(20);
            make.bottom.equalTo(self.contentView.mas_bottom).with.offset(-10);
        }];
        
        [_btnCall mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView.mas_right).with.offset(-30);
            make.centerY.equalTo(_btnMessage.mas_centerY);
            make.width.equalTo(_btnMessage.mas_width);
            make.height.equalTo(_btnMessage.mas_height);
        }];
    }
    
    _highColor = UIColor.blueColor;
    _ruleArray = [[NSMutableArray alloc] init];
    [self.ruleArray addObject:@"@[\\w]+[:\\s]"];
    
    return self;
}

- (void)config:(DataSource *)datasource{
    _dataSouce =datasource;
    NSURL *url = [NSURL URLWithString:_dataSouce.avatar];
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
    _image.image = image;

    if (_dataSouce.bVip) {
        _lableVip.hidden = NO;
    } else {
        _lableVip.hidden = YES;
    }

    _lableName.text = _dataSouce.name;

    _lableTime.text = _dataSouce.time;
    
    NSMutableAttributedString *coloredStr = [self getHighColorText:_dataSouce.content];
    _lableContent.attributedText = coloredStr;
    
    _postImage.imgArray = _dataSouce.imgArray;
  
    CGFloat height = _postImage.height;
    [_postImage mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(height);
        }];
    
    [self updateConstraintsIfNeeded];
    [self layoutIfNeeded];

    [_btnMessage setTitle:[self getNum:_dataSouce.iCommentNum] forState:UIControlStateNormal];
    
    [_btnCall setTitle:[self getNum:_dataSouce.iLikedNum] forState:UIControlStateNormal];
    [_btnCall setImage:[UIImage systemImageNamed:_dataSouce.bLiked ? @"heart.fill" : @"heart"] forState:UIControlStateNormal];
    [_btnCall addTarget:self action:@selector(doCall:) forControlEvents:UIControlEventTouchUpInside];
    
    return;
}

-(void)btnClick:(UIButton *)btn{
    [btn setTitle:@"已关注" forState:UIControlStateNormal];
}

-(void)doCall:(UIButton *)btn{
    _dataSouce.bLiked = !_dataSouce.bLiked;
    [btn setImage:[UIImage systemImageNamed:_dataSouce.bLiked ? @"heart.fill" : @"heart"] forState:0];
    if (-_dataSouce.bLiked) {
        _dataSouce.iLikedNum++;
    } else {
        _dataSouce.iLikedNum--;
    }
    [btn setTitle:[self getNum:_dataSouce.iLikedNum] forState:UIControlStateNormal];
}

-(NSString *)getNum:(int) iNum{
    NSString *message = [NSString stringWithFormat:@"%d", iNum];
    if (iNum > 10000) {
        message = [NSString stringWithFormat:@"%.1f万", iNum / 10000.0];
    }
    return message;
}

-(NSMutableAttributedString *) getHighColorText:(NSString *)text {
    NSMutableAttributedString *coloredString = [[NSMutableAttributedString alloc] initWithString:text];
    NSString* string = coloredString.string;
    NSRange range = NSMakeRange(0,[string length]);
    for(NSString* expression in self.ruleArray) {
        NSArray* matches = [[NSRegularExpression regularExpressionWithPattern:expression options:NSRegularExpressionDotMatchesLineSeparators error:nil] matchesInString:string options:0 range:range];
        for(NSTextCheckingResult* match in matches) {
            NSLog(@"%@", match.description);
            [coloredString addAttribute:NSForegroundColorAttributeName value:self.highColor range:match.range];
        }
    }
    return coloredString;
}

@end
