//
//  LoginViewController.m
//  iOSBase
//
//  Created by 冷婷 on 2018/8/10.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "ForgetPwdController.h"
#import "HomeViewController.h"
@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"登录";
}

- (IBAction)toHomeVC:(id)sender {
    HomeViewController *homeVC = [[HomeViewController alloc] init];
    BaseNavViewController *homeNav = [[BaseNavViewController alloc] initWithRootViewController:homeVC];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.window.rootViewController = homeNav;
    
}


- (IBAction)toRegisterVC:(id)sender {
    RegisterViewController *registerVC = [[RegisterViewController alloc] init];
    [self.navigationController pushViewController:registerVC animated:YES];
}

- (IBAction)toForgetPwdVC:(id)sender {
    ForgetPwdController *forgetVC = [[ForgetPwdController alloc] init];
    [self.navigationController pushViewController:forgetVC animated:YES];
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
