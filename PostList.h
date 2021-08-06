//
//  ViewController.h
//  Test
//
//  Created by ECom-iOS on 2021/3/15.
//

#import <UIKit/UIKit.h>

@interface PostList : UIViewController

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context;
@end

