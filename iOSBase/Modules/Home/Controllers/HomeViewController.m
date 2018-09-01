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
#import "GetIntoViewController.h"
#import "PurchaseViewController.h"
#import "DigitalAssetsViewController.h"
#import "SDCycleScrollView.h"
@interface HomeViewController ()
{
    SDCycleScrollView *bannerView;
}
@property (weak, nonatomic) IBOutlet UILabel *score;
@property (weak, nonatomic) IBOutlet UILabel *money;
@property (weak, nonatomic) IBOutlet UIImageView *headImg;
@property (weak, nonatomic) IBOutlet UILabel *uidLbl;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"首页";
    self.uidLbl.text = [NSString stringWithFormat:@"UID:%@",[SPUtil objectForKey:k_app_USER_ID]];
    self.score.text = [NSString stringWithFormat:@"UID:%@",[SPUtil objectForKey:k_app_INTEGRAL]];
    self.money.text = [NSString stringWithFormat:@"UID:%@",[SPUtil objectForKey:k_app_BALANCE]];
    [self.headImg sd_setImageWithURL:[NSURL URLWithString:[SPUtil objectForKey:k_app_HEAD_URL]] placeholderImage:[UIImage imageNamed:@"head"]];
    bannerView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, KScreenHeight-308-navHeight, KScreenWidth, 100) imageURLStringsGroup:@[@"http://p0hct3xqb.bkt.clouddn.com/shareshop2018-06-06_5b17fd93a0445.jpg",@"http://p0hct3xqb.bkt.clouddn.com/shareshop2018-06-06_5b17fdb969459.jpg"]];
    [self.view addSubview:bannerView];
    [self requestData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)requestData {
    RequestParams *parms = [[RequestParams alloc] initWithParams:API_HOMEPAGE];
    [parms addParameter:@"USER_NAME" value:[SPUtil objectForKey:k_app_USER_NAME]];
    [[NetworkSingleton shareInstace] httpPost:parms withTitle:@"首页" successBlock:^(id data) {

        self.uidLbl.text = [NSString stringWithFormat:@"UID:%@",data[@"pd"][@"USER_ID"]];
        self.score.text = data[@"pd"][@"INTEGRAL"];
        self.money.text = data[@"pd"][@"BALANCE"];
        [self.headImg sd_setImageWithURL:[NSURL URLWithString:data[@"pd"][@"HEAD_URL"]] placeholderImage:[UIImage imageNamed:@"head"]];
        [SPUtil setObject:data[@"pd"][@"USER_NAME"] forKey:k_app_USER_NAME];
        [SPUtil setObject:data[@"pd"][@"NICK_NAME"] forKey:k_app_NICK_NAME];
        [SPUtil setObject:data[@"pd"][@"USER_ID"] forKey:k_app_USER_ID];
        [SPUtil setObject:data[@"pd"][@"TEL"] forKey:k_app_TEL];
        [SPUtil setObject:data[@"pd"][@"HEAD_URL"] forKey:k_app_HEAD_URL];
        [SPUtil setObject:data[@"pd"][@"INTEGRAL"] forKey:k_app_INTEGRAL];
        [SPUtil setObject:data[@"pd"][@"BALANCE"] forKey:k_app_BALANCE];
        [SPUtil setObject:data[@"pd"][@"CREDIT"] forKey:k_app_CREDIT];
        [SPUtil setObject:data[@"pd"][@"VIP"] forKey:k_app_VIP];
        [SPUtil setObject:data[@"pd"][@"W_ADDRESS"] forKey:k_app_W_ADDRESS];
        [SPUtil setObject:data[@"pd"][@"IFPAS"] forKey:k_app_IFPAS];
    } failureBlock:^(NSError *error) {
        
    }];
}

- (IBAction)toMineVC:(UIButton *)sender {
    MineViewController *mineVC = [[MineViewController alloc] init];
    [self.navigationController pushViewController:mineVC animated:YES];
}

- (IBAction)QRCodeScannerAction:(UIButton *)sender {
    
    HMScannerController *scanner = [HMScannerController scannerWithCardName:nil avatar:nil completion:^(NSString *stringValue) {
        if ([Util valiMobile:stringValue]) {
            self.navigationController.navigationBarHidden = NO;
            TurnOutViewController *turnOutVC = [[TurnOutViewController alloc] init];
            turnOutVC.mobile = stringValue;
            [self.navigationController pushViewController:turnOutVC animated:YES];
        }
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
        GetIntoViewController *vc = [[GetIntoViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (sender.tag == 103) {
        PurchaseViewController *vc = [[PurchaseViewController alloc] init];
        vc.title = @"买入";
        [self.navigationController pushViewController:vc animated:YES];
    }else if (sender.tag == 104) {
        PurchaseViewController *vc = [[PurchaseViewController alloc] init];
        vc.title = @"卖出";
        [self.navigationController pushViewController:vc animated:YES];
    }else if (sender.tag == 105) {
        self.navigationController.navigationBarHidden = YES;
        [SVProgressHUD showInfoWithStatus:@"开发中"];
//        DigitalAssetsViewController *vc = [[DigitalAssetsViewController alloc] init];
//        [self.navigationController pushViewController:vc animated:YES];
    }else if (sender.tag == 106) {
        self.navigationController.navigationBarHidden = YES;
        [SVProgressHUD showInfoWithStatus:@"开发中"];
    }
}

- (IBAction)headImgTapAction:(UITapGestureRecognizer *)sender {
    MineViewController *mineVC = [[MineViewController alloc] init];
    [self.navigationController pushViewController:mineVC animated:YES];
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
