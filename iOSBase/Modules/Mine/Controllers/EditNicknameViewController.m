//
//  EditNicknameViewController.m
//  iOSBase
//
//  Created by 冷婷 on 2018/8/19.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "EditNicknameViewController.h"

@interface EditNicknameViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nickNameText;

@end

@implementation EditNicknameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修改昵称";
}

- (IBAction)editNickNameAction:(UIButton *)sender {

    if (_nickNameText.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入要修改的昵称"];
        return;
    }
    
    RequestParams *parms = [[RequestParams alloc] initWithParams:API_PERSONMES];
    [parms addParameter:@"USER_NAME" value:[SPUtil objectForKey:k_app_USER_NAME]];
    [parms addParameter:@"HEAD_URL" value:[SPUtil objectForKey:k_app_HEAD_URL]];
    [parms addParameter:@"NICK_NAME" value:_nickNameText.text];
    [[NetworkSingleton shareInstace] httpPost:parms withTitle:@"修改昵称" successBlock:^(id data) {
        [SVProgressHUD showSuccessWithStatus:@"修改成功"];
        
        [SPUtil setObject:_nickNameText.text forKey:k_app_NICK_NAME];
        [self.navigationController popViewControllerAnimated:YES];
    } failureBlock:^(NSError *error) {
        
    }];
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
