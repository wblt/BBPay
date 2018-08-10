//
//  RegisterViewController.m
//  iOSBase
//
//  Created by 冷婷 on 2018/8/11.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "RegisterViewController.h"
#import "HomeViewController.h"
@interface RegisterViewController ()

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"注册账号";
}

- (IBAction)toHomeVC:(id)sender {
    HomeViewController *homeVC = [[HomeViewController alloc] init];
    BaseNavViewController *homeNav = [[BaseNavViewController alloc] initWithRootViewController:homeVC];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.window.rootViewController = homeNav;
}

- (IBAction)toLoginVC:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
