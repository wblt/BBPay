//
//  AddBankViewController.m
//  iOSBase
//
//  Created by 冷婷 on 2018/8/19.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "AddBankViewController.h"
#import "AnotherSearchViewController.h"
@interface AddBankViewController ()
@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *bankNum;
@property (weak, nonatomic) IBOutlet UILabel *bankName;
@property (weak, nonatomic) IBOutlet UITextField *bankSubName;
@property (weak, nonatomic) IBOutlet UIButton *defaultBtn;

@end

@implementation AddBankViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"添加银行卡";
}

- (IBAction)selectedDefaultAction:(UIButton *)sender {
    sender.selected = !sender.selected;
}

- (IBAction)toSelectBankName:(UIButton *)sender {
    AnotherSearchViewController *search = [[AnotherSearchViewController alloc] init];
    search.title = @"选择银行";
    //返回选中搜索的结果
    [search didSelectedItem:^(NSString *item) {
        _bankName.text = item;
    }];
    [self.navigationController pushViewController:search animated:YES];
}

- (IBAction)addBankAction:(UIButton *)sender {
    if (_name.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入持卡人姓名"];
        return;
    }
    if (_bankNum.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入银行卡号"];
        return;
    }
    if ([_bankName.text isEqualToString:@"开户行"]) {
        [SVProgressHUD showErrorWithStatus:@"请选择开户行"];
        return;
    }
    if (_bankSubName.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入开户行支行"];
        return;
    }
    RequestParams *parms = [[RequestParams alloc] initWithParams:API_ADDPAYMES];
    [parms addParameter:@"BANK_NAME" value:_bankName.text];
    [parms addParameter:@"BANK_NO" value:_bankNum.text];
    [parms addParameter:@"BANK_USERNAME" value:_name.text];
    [parms addParameter:@"BANK_ADDR" value:_bankSubName.text];
    [parms addParameter:@"IFDEFAULT" value:[NSString stringWithFormat:@"%d",_defaultBtn.selected]];
    [parms addParameter:@"USER_NAME" value:[SPUtil objectForKey:k_app_USER_NAME]];
    [[NetworkSingleton shareInstace] httpPost:parms withTitle:@"添加银行卡" successBlock:^(id data) {
        [SVProgressHUD showSuccessWithStatus:@"添加成功"];
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
