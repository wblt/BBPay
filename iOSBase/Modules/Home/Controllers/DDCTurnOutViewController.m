//
//  DDCTurnOutViewController.m
//  iOSBase
//
//  Created by 冷婷 on 2018/11/20.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "DDCTurnOutViewController.h"
#import "DDCTurnOutRecordViewController.h"
#import "YQPayKeyWordVC.h"
@interface DDCTurnOutViewController ()

@property (weak, nonatomic) IBOutlet UITextField *number;

@property (weak, nonatomic) IBOutlet UITextField *address;

@end

@implementation DDCTurnOutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"转出";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"记录" style:UIBarButtonItemStylePlain target:self action:@selector(toTurnOutRecord)];
    
}

- (void)toTurnOutRecord {
    DDCTurnOutRecordViewController *turnOutVC = [[DDCTurnOutRecordViewController alloc] init];
    turnOutVC.title = @"记录";
    [self.navigationController pushViewController:turnOutVC animated:YES];
}

- (IBAction)yes_action:(id)sender {
    if (self.number.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入转出数量"];
        return;
    }
    if (self.address.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入转出地址"];
        return;
    }
    YQPayKeyWordVC *yqVC = [[YQPayKeyWordVC alloc] init];
    [yqVC showInViewController:self money:self.number.text];
    yqVC.block = ^(NSString *pass) {
        RequestParams *parms = [[RequestParams alloc] initWithParams:API_sendDDCB];
        [parms addParameter:@"USER_NAME" value:[SPUtil objectForKey:k_app_USER_NAME]];
        [parms addParameter:@"S_MONEY" value:self.number.text];
        [parms addParameter:@"PASSW" value:pass];
        [parms addParameter:@"TEL" value:self.address.text];
        [[NetworkSingleton shareInstace] httpPost:parms withTitle:@"买入记录" successBlock:^(id data) {
            [SVProgressHUD showInfoWithStatus:@"转出成功"];
            [self.navigationController popViewControllerAnimated:YES];
        } failureBlock:^(NSError *error) {
            
        }];
    };
    
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
