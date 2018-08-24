//
//  HomeViewController.m
//  iOSBase
//
//  Created by 冷婷 on 2018/8/10.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "HomeViewController.h"
#import "MineViewController.h"
#import "HMScannerController.h"
#import "TurnOutViewController.h"
#import "ShareCodeViewController.h"
#import "PurchaseViewController.h"
#import "DigitalAssetsViewController.h"
@interface HomeViewController ()
@property (weak, nonatomic) IBOutlet UILabel *score;
@property (weak, nonatomic) IBOutlet UILabel *money;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"首页";
    [self requestData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)requestData {
    RequestParams *parms = [[RequestParams alloc] initWithParams:API_HOMEPAGE];
    [parms addParameter:@"USER_NAME" value:[SPUtil objectForKey:k_app_userNumber]];
    [[NetworkSingleton shareInstace] httpPost:parms withTitle:@"首页" successBlock:^(id data) {

        self.score.text = data[@"pd"][@"INTEGRAL"];
        self.money.text = data[@"pd"][@"BALANCE"];
        
    } failureBlock:^(NSError *error) {
        
    }];
}

- (IBAction)toMineVC:(UIButton *)sender {
    MineViewController *mineVC = [[MineViewController alloc] init];
    [self.navigationController pushViewController:mineVC animated:YES];
}

- (IBAction)QRCodeScannerAction:(UIButton *)sender {
    
    HMScannerController *scanner = [HMScannerController scannerWithCardName:nil avatar:nil completion:^(NSString *stringValue) {
        
//        self.scanResultLabel.text = stringValue;
    }];
    
    [scanner setTitleColor:mainColor tintColor:mainColor];
    
    [self showDetailViewController:scanner sender:nil];
}

- (IBAction)homeBtnAction:(UIButton *)sender {
    self.navigationController.navigationBarHidden = NO;
    if (sender.tag == 101) {
        TurnOutViewController *turnOutVC = [[TurnOutViewController alloc] init];
        [self.navigationController pushViewController:turnOutVC animated:YES];
    }else if (sender.tag == 102) {
        ShareCodeViewController *vc = [[ShareCodeViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (sender.tag == 103) {
        PurchaseViewController *vc = [[PurchaseViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (sender.tag == 104) {
        PurchaseViewController *vc = [[PurchaseViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (sender.tag == 105) {
        DigitalAssetsViewController *vc = [[DigitalAssetsViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (sender.tag == 106) {
        self.navigationController.navigationBarHidden = YES;
        [SVProgressHUD showInfoWithStatus:@"开发中"];
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
