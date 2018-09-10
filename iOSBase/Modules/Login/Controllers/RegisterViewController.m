//
//  RegisterViewController.m
//  iOSBase
//
//  Created by 冷婷 on 2018/8/11.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "RegisterViewController.h"
#import "HomeViewController.h"
#import "MQVerCodeImageView.h"
@interface RegisterViewController () {
    NSString *_imageCodeStr;
}
@property (weak, nonatomic) IBOutlet UITextField *phoneText;
@property (weak, nonatomic) IBOutlet UITextField *passwordText;
@property (weak, nonatomic) IBOutlet UITextField *codeText;
@property (weak, nonatomic) IBOutlet MQVerCodeImageView *verCodeImgView;
@property (weak, nonatomic) IBOutlet UITextField *centainText;
@property (weak, nonatomic) IBOutlet UITextField *inviteText;
@property (weak, nonatomic) IBOutlet UITextField *nickName;
@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"注册账号";
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
    if (_inviteText.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入邀请码"];
        return;
    }
    
    if (_nickName.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入用户昵称"];
        return;
    }
    
    if (![Util valiMobile:_phoneText.text]) {
        [SVProgressHUD showErrorWithStatus:@"请输入正确的手机号"];
        return;
    }
    
    if (![self.codeText.text isEqualToString:_imageCodeStr] || self.codeText.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入正确的图片验证码"];
        return;
    }
    
    if (![Util valiPassword:_passwordText.text]) {
        [SVProgressHUD showErrorWithStatus:@"请输入6-32位数字+字母密码"];
        return;
    }
    
    if (self.centainText.text.length != 6) {
        [SVProgressHUD showErrorWithStatus:@"请输入六位支付密码"];
        return;
    }
    
    RequestParams *parms = [[RequestParams alloc] initWithParams:API_SYREG];
    [parms addParameter:@"USER_NAME" value:self.nickName.text];
    [parms addParameter:@"ACCOUNT" value:self.phoneText.text];
    [parms addParameter:@"PASSWORD" value:self.passwordText.text];
    [parms addParameter:@"YQ_CODE" value:self.inviteText.text];
    [parms addParameter:@"PASSW" value:self.centainText.text];
    
    [[NetworkSingleton shareInstace] httpPost:parms withTitle:@"注册" successBlock:^(id data) {
        [SVProgressHUD showSuccessWithStatus:@"注册成功"];
        [SPUtil setBool:YES forKey:k_app_login];
        [SPUtil setObject:data[@"pd"][@"USER_NAME"] forKey:k_app_USER_NAME];
        [SPUtil setObject:_phoneText.text forKey:k_app_TEL];
        [SPUtil setObject:_passwordText.text forKey:k_app_PASSWORD];
        HomeViewController *homeVC = [[HomeViewController alloc] init];
        BaseNavViewController *homeNav = [[BaseNavViewController alloc] initWithRootViewController:homeVC];
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        appDelegate.window.rootViewController = homeNav;
    } failureBlock:^(NSError *error) {
        [_verCodeImgView freshVerCode];
    }];
    
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
