//
//  TurnOutNextViewController.m
//  iOSBase
//
//  Created by 冷婷 on 2018/9/12.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "TurnOutNextViewController.h"
#import "YQPayKeyWordVC.h"
#import "TurnOutRecordListViewController.h"
@interface TurnOutNextViewController ()
@property (weak, nonatomic) IBOutlet UITextField *phoneText;
@property (weak, nonatomic) IBOutlet UITextField *moneyNum;
@property (weak, nonatomic) IBOutlet UIImageView *headImg;
@property (weak, nonatomic) IBOutlet UILabel *uidLbl;
@property (weak, nonatomic) IBOutlet UIImageView *vipImg;
@end

@implementation TurnOutNextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"转出";
    self.uidLbl.text = [NSString stringWithFormat:@"%@(%@)",_userDic[@"pd"][@"USER_NAME"],_userDic[@"pd"][@"USER_ID"]];
    [self.headImg sd_setImageWithURL:[NSURL URLWithString:_userDic[@"pd"][@"HEAD_URL"]] placeholderImage:[UIImage imageNamed:@"head"]];
    if ([_userDic[@"pd"][@"SPECIAL"] isEqualToString:@"0"]) {
        self.headImg.layer.borderColor = [UIColor colorWithWhite:0.6 alpha:0.6].CGColor;
        self.headImg.layer.borderWidth = 40;
    }
    if ([_userDic[@"pd"][@"VIP"] isEqualToString:@"1"]) {
        _vipImg.hidden = false;
    }
}

- (IBAction)toTurnOutAction:(UIButton *)sender {
    if ([_moneyNum.text floatValue] == 0.0) {
        [SVProgressHUD showErrorWithStatus:@"请输入转账金额"];
        return;
    }
    
    if (![_phoneText.text isEqualToString:[_toTel substringFromIndex:7]]) {
        [SVProgressHUD showErrorWithStatus:@"请输入正确的手机号末四位"];
        return;
    }
    
    YQPayKeyWordVC *yqVC = [[YQPayKeyWordVC alloc] init];
    [yqVC showInViewController:self money:_moneyNum.text];
    yqVC.block = ^(NSString *pass) {
        RequestParams *parms = [[RequestParams alloc] initWithParams:API_SEND];
        [parms addParameter:@"USER_NAME" value:[SPUtil objectForKey:k_app_USER_NAME]];
        [parms addParameter:@"TEL" value:_toTel];
        [parms addParameter:@"S_MONEY" value:self.moneyNum.text];
        [parms addParameter:@"PASSW" value:pass];
        [[NetworkSingleton shareInstace] httpPost:parms withTitle:@"转出" successBlock:^(id data) {
            [SVProgressHUD showSuccessWithStatus:@"转出成功"];
            [self toTurnOutRecord];
        } failureBlock:^(NSError *error) {
            
        }];
    };

}

- (void)toTurnOutRecord {
    TurnOutRecordListViewController *turnOutVC = [[TurnOutRecordListViewController alloc] init];
    turnOutVC.url = API_SENDDEAIL;
    turnOutVC.title = @"转出记录";
    [self.navigationController pushViewController:turnOutVC animated:YES];
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
