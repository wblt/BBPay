//
//  ConvertibilityViewController.m
//  iOSBase
//
//  Created by 冷婷 on 2018/8/21.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "ConvertibilityViewController.h"
#import "YQPayKeyWordVC.h"
#import "ExchangeRecordViewController.h"
@interface ConvertibilityViewController ()
@property (weak, nonatomic) IBOutlet UITextField *scoreNum;
@property (weak, nonatomic) IBOutlet UILabel *money;
@property (weak, nonatomic) IBOutlet UILabel *score;
@property (weak, nonatomic) IBOutlet UILabel *jifen_title;

@end

@implementation ConvertibilityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.s_title;
    self.money.text = [NSString stringWithFormat:@"%@",[SPUtil objectForKey:k_app_BALANCE]];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"兑换记录" style:UIBarButtonItemStylePlain target:self action:@selector(toExchangeRecord)];
    if ([self.s_title isEqualToString:@"兑换积分"]) {
        self.jifen_title.text = @"积分";
        self.score.text = [NSString stringWithFormat:@"%@",[SPUtil objectForKey:k_app_INTEGRAL]];
    } else {
        self.jifen_title.text = @"DDC豆";
        self.score.text = [NSString stringWithFormat:@"%@",[SPUtil objectForKey:k_app_ddc_d]];
    }
}

- (void)toExchangeRecord {
    ExchangeRecordViewController *exchangeVC = [[ExchangeRecordViewController alloc] init];
    if ([self.s_title isEqualToString:@"兑换积分"]) {
        exchangeVC.s_title = @"兑换积分";
    } else {
        exchangeVC.s_title = @"兑换DDC豆";
    }
    [self.navigationController pushViewController:exchangeVC animated:YES];
}

- (IBAction)scoreExchangeAction:(UIButton *)sender {
    if ([_scoreNum.text integerValue] < 100) {
        [SVProgressHUD showErrorWithStatus:@"请输入兑换数量"];
        return;
    }
    YQPayKeyWordVC *yqVC = [[YQPayKeyWordVC alloc] init];
    [yqVC showInViewController:self money:_scoreNum.text];
    yqVC.block = ^(NSString *pass) {
        RequestParams *parms = nil;
        if ([self.s_title isEqualToString:@"兑换积分"]) {
             parms = [[RequestParams alloc] initWithParams:API_CHANGEINTEGRAL];
        } else {
             parms = [[RequestParams alloc] initWithParams:API_changeDDCD];
        }
        [parms addParameter:@"USER_NAME" value:[SPUtil objectForKey:k_app_USER_NAME]];
        [parms addParameter:@"S_NUM" value:self.scoreNum.text];
        [parms addParameter:@"PASSW" value:pass];
        [[NetworkSingleton shareInstace] httpPost:parms withTitle:@"兑换积分" successBlock:^(id data) {
            [SVProgressHUD showSuccessWithStatus:@"兑换成功"];
            [self.navigationController popViewControllerAnimated:YES];
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
