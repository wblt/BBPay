//
//  TurnOutViewController.m
//  iOSBase
//
//  Created by 冷婷 on 2018/8/21.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "TurnOutViewController.h"
#import "ConvertibilityViewController.h"
#import "TurnOutRecordListViewController.h"
#import "YQPayKeyWordVC.h"
@interface TurnOutViewController ()
@property (weak, nonatomic) IBOutlet UITextField *phoneText;
@property (weak, nonatomic) IBOutlet UITextField *moneyNum;

@end

@implementation TurnOutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"转出";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"转出记录" style:UIBarButtonItemStylePlain target:self action:@selector(toTurnOutRecord)];
    self.phoneText.text = _mobile;
}

- (void)toTurnOutRecord {
    TurnOutRecordListViewController *turnOutVC = [[TurnOutRecordListViewController alloc] init];
    turnOutVC.url = API_SENDDEAIL;
    turnOutVC.title = @"转出记录";
    [self.navigationController pushViewController:turnOutVC animated:YES];
}

- (IBAction)toTurnOutAction:(UIButton *)sender {
    
    ConvertibilityViewController *turnOutVC = [[ConvertibilityViewController alloc] init];
    [self.navigationController pushViewController:turnOutVC animated:YES];
}

- (IBAction)toCentainAction:(UIButton *)sender {
    if (![Util valiMobile:_phoneText.text]) {
        [SVProgressHUD showErrorWithStatus:@"请输入对方账户"];
        return;
    }
    if ([_moneyNum.text floatValue] == 0.0) {
        [SVProgressHUD showErrorWithStatus:@"请输入转账金额"];
        return;
    }
    
    YQPayKeyWordVC *yqVC = [[YQPayKeyWordVC alloc] init];
    [yqVC showInViewController:self money:_moneyNum.text];
    yqVC.block = ^(NSString *pass) {
        RequestParams *parms = [[RequestParams alloc] initWithParams:API_SEND];
        [parms addParameter:@"USER_NAME" value:[SPUtil objectForKey:k_app_USER_NAME]];
        [parms addParameter:@"TEL" value:self.phoneText.text];
        [parms addParameter:@"S_MONEY" value:self.moneyNum.text];
        [parms addParameter:@"PASSW" value:pass];
        [[NetworkSingleton shareInstace] httpPost:parms withTitle:@"转出" successBlock:^(id data) {
            [SVProgressHUD showSuccessWithStatus:@"转出成功"];
            [self toTurnOutRecord];
        } failureBlock:^(NSError *error) {
            
        }];
    };
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
