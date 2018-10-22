//
//  DDCReleaseViewController.m
//  iOSBase
//
//  Created by 冷婷 on 2018/10/22.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "DDCReleaseViewController.h"

@interface DDCReleaseViewController ()
@property (weak, nonatomic) IBOutlet UILabel *money;
@property (weak, nonatomic) IBOutlet UILabel *score;
@property (weak, nonatomic) IBOutlet UITextField *priceText;
@property (weak, nonatomic) IBOutlet UITextField *numText;
@end

@implementation DDCReleaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (_isPostSale) {
        self.title = @"发布出售订单";
    }else {
        self.title = @"发布购买订单";
    }
    self.score.text = [NSString stringWithFormat:@"%@",[SPUtil objectForKey:k_app_INTEGRAL]];
    self.money.text = [NSString stringWithFormat:@"%@",[SPUtil objectForKey:k_app_BALANCE]];
}
- (IBAction)cebtainAction:(UIButton *)sender {
    if ([_priceText.text integerValue] <= 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入价格"];
        return;
    }
    if ([_numText.text integerValue] <= 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入数量"];
        return;
    }
    YQPayKeyWordVC *yqVC = [[YQPayKeyWordVC alloc] init];
    [yqVC showInViewController:self money:[NSString stringWithFormat:@"%ld", [_priceText.text integerValue]*[_numText.text integerValue]]];
    yqVC.block = ^(NSString *pass) {
        RequestParams *parms = [[RequestParams alloc] initWithParams:API_DDC_SELL];
        [parms addParameter:@"USER_NAME" value:[SPUtil objectForKey:k_app_USER_NAME]];
        [parms addParameter:@"BUSINESS_COUNT" value:self.numText.text];
        [parms addParameter:@"BUSINESS_PRICE" value:self.priceText.text];
        [parms addParameter:@"PASSW" value:pass];
        [[NetworkSingleton shareInstace] httpPost:parms withTitle:@"DDC下单" successBlock:^(id data) {
            [SVProgressHUD showSuccessWithStatus:@"挂单成功"];
            
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
