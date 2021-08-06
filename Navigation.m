//
//  Navigation.m
//  Test
//
//  Created by bytedance on 2021/7/28.
//

#import "Navigation.h"

@implementation Navigation

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 84);
        self.backgroundColor = UIColor.redColor;
//        self.barTintColor = [UIColor colorWithRed:101/255.0 green:215/255.0 blue:237/255.0 alpha:1.0];
//        
//        UILabel *leftTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 40)];
//        leftTitle.text = @"test";
//        leftTitle.textColor = UIColor.redColor;
//        leftTitle.font = [UIFont systemFontOfSize:18];
//        
//        UINavigationItem *item = [[UINavigationItem alloc] init];
//        item.titleView = leftTitle;
//        
//        UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"left" style:UIBarButtonItemStylePlain target:self action:@selector(leftButtonClick)];
//        leftButton.tintColor = UIColor.purpleColor;
//        
//        UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"right" style:UIBarButtonItemStylePlain target:self action:@selector(rightButtonClick)];
//        rightButton.tintColor = UIColor.redColor;
//        
//        [item setLeftBarButtonItem:leftButton animated:false];
//        [item setRightBarButtonItem:rightButton animated:false];
//        
//        [self pushNavigationItem:item animated:false];
    }
    return self;
}

@end
