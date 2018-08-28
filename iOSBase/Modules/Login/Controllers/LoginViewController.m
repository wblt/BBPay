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
#import "MQVerCodeImageView.h"
@interface LoginViewController () {
    NSString *_imageCodeStr;
}
@property (weak, nonatomic) IBOutlet UITextField *phoneText;
@property (weak, nonatomic) IBOutlet UITextField *passwordText;
@property (weak, nonatomic) IBOutlet UITextField *codeText;
@property (weak, nonatomic) IBOutlet MQVerCodeImageView *verCodeImgView;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"登录";
    _imageCodeStr = @"";
    _verCodeImgView.bolck = ^(NSString *imageCodeStr){//看情况是否需要
        _imageCodeStr = imageCodeStr;
        NSLog(@"imageCodeStr = %@",imageCodeStr);
    };
    _verCodeImgView.isRotation = NO;
    [_verCodeImgView freshVerCode];
    
    //点击刷新
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
    [_verCodeImgView addGestureRecognizer:tap];
}

- (void)tapClick:(UITapGestureRecognizer*)tap
{
    [_verCodeImgView freshVerCode];
}

- (IBAction)toHomeVC:(id)sender {
    
//    if (![Util valiMobile:_phoneText.text]) {
//        [SVProgressHUD showErrorWithStatus:@"请输入正确的手机号"];
//        return;
//    }
    if (_phoneText.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入手机号/用户名"];
        return;
    }
    
    if (_passwordText.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入密码"];
        return;
    }
    
    if (![self.codeText.text isEqualToString:_imageCodeStr] || self.codeText.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入正确的图片验证码"];
        return;
    }
    RequestParams *parms = [[RequestParams alloc] initWithParams:API_LOGIN];
    [parms addParameter:@"USER_NAME" value:self.phoneText.text];
    [parms addParameter:@"PASSWORD" value:self.passwordText.text];
    [[NetworkSingleton shareInstace] httpPost:parms withTitle:@"登录" successBlock:^(id data) {
        [SVProgressHUD showSuccessWithStatus:@"登录成功"];
        [SPUtil setBool:YES forKey:k_app_login];
        [SPUtil setObject:_phoneText.text forKey:k_app_USER_NAME];
        [SPUtil setObject:_passwordText.text forKey:k_app_PASSWORD];
        HomeViewController *homeVC = [[HomeViewController alloc] init];
        BaseNavViewController *homeNav = [[BaseNavViewController alloc] initWithRootViewController:homeVC];
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        appDelegate.window.rootViewController = homeNav;
    } failureBlock:^(NSError *error) {
        [_verCodeImgView freshVerCode];
    }];
    
}


- (IBAction)toRegisterVC:(id)sender {
    RegisterViewController *registerVC = [[RegisterViewController alloc] init];
    [self.navigationController pushViewController:registerVC animated:YES];
}

- (IBAction)toForgetPwdVC:(id)sender {
    ForgetPwdController *forgetVC = [[ForgetPwdController alloc] init];
    [self.navigationController pushViewController:forgetVC animated:YES];
}

- (void)test {
    
    
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
