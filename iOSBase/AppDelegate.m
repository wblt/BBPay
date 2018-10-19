//
//  AppDelegate.m
//  iOSBase
//
//  Created by mac on 2018/1/9.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "AppDelegate.h"
#import <Bugly/Bugly.h>
#import <IQKeyboardManager/IQKeyboardManager.h>
#import "LoginViewController.h"
#import "HomeViewController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // 创建窗口
    self.window = [[UIWindow alloc] init];
    self.window.frame = [UIScreen mainScreen].bounds;
    
//    // 设置窗口的根控制器
//    if ([SPUtil boolForKey:k_app_login]) {
//        if ([[Util timeToTurnTheTimestamp] integerValue]-[[SPUtil objectForKey:@"time"] integerValue] > 10*60) {
//            [SPUtil setBool:NO forKey:k_app_login];
//            LoginViewController *loginVC = [[LoginViewController alloc] init];
//            BaseNavViewController *loginNav = [[BaseNavViewController alloc] initWithRootViewController:loginVC];
//            self.window.rootViewController = loginNav;
//        }else {
            HomeViewController *homeVC = [[HomeViewController alloc] init];
            BaseNavViewController *homeNav = [[BaseNavViewController alloc] initWithRootViewController:homeVC];
            self.window.rootViewController = homeNav;
//        }
//    }else {
//        LoginViewController *loginVC = [[LoginViewController alloc] init];
//        BaseNavViewController *loginNav = [[BaseNavViewController alloc] initWithRootViewController:loginVC];
//        self.window.rootViewController = loginNav;
//    }

    // 显示窗口
    [self.window makeKeyAndVisible];
    // 启动腾讯bugly
    [Bugly startWithAppId:@"cebf1e905f"];
    
    // 设置最大消失时间为1s
    [SVProgressHUD setMaximumDismissTimeInterval:1];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [self keyboardManager];
    return YES;
    
}

- (void)keyboardManager {
    IQKeyboardManager *keyboardManager = [IQKeyboardManager sharedManager]; // 获取类库的单例变量
    
    keyboardManager.enable = YES; // 控制整个功能是否启用
    
    keyboardManager.shouldResignOnTouchOutside = YES; // 控制点击背景是否收起键盘
    
    keyboardManager.shouldToolbarUsesTextFieldTintColor = YES; // 控制键盘上的工具条文字颜色是否用户自定义
    
    keyboardManager.toolbarManageBehaviour = IQAutoToolbarBySubviews; // 有多个输入框时，可以通过点击Toolbar 上的“前一个”“后一个”按钮来实现移动到不同的输入框
    
    keyboardManager.enableAutoToolbar = YES; // 控制是否显示键盘上的工具条
    
    keyboardManager.shouldShowToolbarPlaceholder = YES;
    
    keyboardManager.placeholderFont = [UIFont boldSystemFontOfSize:14]; // 设置占位文字的字体
    
    keyboardManager.keyboardDistanceFromTextField = 10.0f; // 输入框距离键盘的距离
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    if ([SPUtil boolForKey:k_app_login]) {
        [SPUtil setObject:[Util timeToTurnTheTimestamp] forKey:@"time"];
    }
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    if ([SPUtil boolForKey:k_app_login]) {
        if ([[Util timeToTurnTheTimestamp] integerValue]-[[SPUtil objectForKey:@"time"] integerValue] > 10*60) {
            [SPUtil setBool:NO forKey:k_app_login];
            LoginViewController *loginVC = [[LoginViewController alloc] init];
            BaseNavViewController *loginNav = [[BaseNavViewController alloc] initWithRootViewController:loginVC];
            self.window.rootViewController = loginNav;
        }
    }
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
//
//    if ([SPUtil boolForKey:k_app_login]) {
//        if ([[Util timeToTurnTheTimestamp] integerValue]-[[SPUtil objectForKey:@"time"] integerValue] > 1) {
//            [SPUtil setBool:NO forKey:k_app_login];
//            LoginViewController *loginVC = [[LoginViewController alloc] init];
//            BaseNavViewController *loginNav = [[BaseNavViewController alloc] initWithRootViewController:loginVC];
//            self.window.rootViewController = loginNav;
//        }
//    }
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
