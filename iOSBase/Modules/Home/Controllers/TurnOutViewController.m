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
#import "TurnOutNextViewController.h"
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
    if (_phoneText.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入对方手机号/UID"];
        return;
    }
    
    RequestParams *parms = [[RequestParams alloc] initWithParams:API_USER];
    [parms addParameter:@"USER_NAME" value:self.phoneText.text];
    [[NetworkSingleton shareInstace] httpPost:parms withTitle:@"转出下一步" successBlock:^(id data) {
        TurnOutNextViewController *turnOutNextVC = [[TurnOutNextViewController alloc] init];
        turnOutNextVC.toTel = self.phoneText.text;
        turnOutNextVC.userDic = data;
        [self.navigationController pushViewController:turnOutNextVC animated:YES];
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
