//
//  AppDelegate.m
//  Test
//
//  Created by ECom-iOS on 2021/3/15.
//

#import "AppDelegate.h"
#import "Home.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    __auto_type window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window = window;
    
    // __auto_type viewController = [[ViewController alloc] init];
    // __auto_type nav = [[UINavigationController alloc] initWithRootViewController:viewController];
    __auto_type home = [[Home alloc] init];
    __auto_type nav = [[UINavigationController alloc] initWithRootViewController:home];
    window.rootViewController = nav;
    [window makeKeyAndVisible];
    
    return YES;
}


@end
