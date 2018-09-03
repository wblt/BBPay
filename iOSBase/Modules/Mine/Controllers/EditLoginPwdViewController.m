//
//  EditLoginPwdViewController.m
//  iOSBase
//
//  Created by 冷婷 on 2018/8/20.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "EditLoginPwdViewController.h"

@interface EditLoginPwdViewController ()
@property (weak, nonatomic) IBOutlet UITextField *oldText;
@property (weak, nonatomic) IBOutlet UITextField *passwardNew;

@end

@implementation EditLoginPwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修改密码";
    
}

- (IBAction)toEditCentainAction:(UIButton *)sender {
    if (_oldText.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入原密码"];
        return;
    }
    
    if (self.isPayPwd) {
        if (_passwardNew.text.length != 6) {
            [SVProgressHUD showErrorWithStatus:@"请输入新的六位支付密码"];
            return;
        }
        
        RequestParams *parms = [[RequestParams alloc] initWithParams:API_AQPASSW];
        [parms addParameter:@"USER_NAME" value:[SPUtil objectForKey:k_app_USER_NAME]];
        [parms addParameter:@"OLD_PAS" value:self.oldText.text];
        [parms addParameter:@"NEW_PAS" value:self.passwardNew.text];
        [[NetworkSingleton shareInstace] httpPost:parms withTitle:@"修改支付密码" successBlock:^(id data) {
            
            [SVProgressHUD showSuccessWithStatus:@"修改成功"];

            [self.navigationController popViewControllerAnimated:YES];
        } failureBlock:^(NSError *error) {
            
        }];
    }else {
        if (![Util valiPassword:_passwardNew.text]) {
            [SVProgressHUD showErrorWithStatus:@"请输入6-32位数字+字母密码"];
            return;
        }
        
        RequestParams *parms = [[RequestParams alloc] initWithParams:API_CHANGEPWD];
        [parms addParameter:@"USER_NAME" value:[SPUtil objectForKey:k_app_USER_NAME]];
        [parms addParameter:@"OLD_PAS" value:self.oldText.text];
        [parms addParameter:@"NEW_PAS" value:self.passwardNew.text];
        [[NetworkSingleton shareInstace] httpPost:parms withTitle:@"修改登录密码" successBlock:^(id data) {
            [SVProgressHUD showSuccessWithStatus:@"修改成功"];
            [SPUtil setObject:_passwardNew.text forKey:k_app_PASSWORD];
            [self.navigationController popViewControllerAnimated:YES];
        } failureBlock:^(NSError *error) {
            
        }];
    }
    
    
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
