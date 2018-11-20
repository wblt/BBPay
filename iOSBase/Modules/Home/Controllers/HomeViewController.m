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
#import "ScoreRecordViewController.h"
#import "ConvertibilityViewController.h"
@interface HomeViewController ()
{
    SDCycleScrollView *bannerView;
    NSString *PROFIT_BALANCE;
    NSString *PROFIT_INTEGRAL;
}
@property (weak, nonatomic) IBOutlet UILabel *score;
@property (weak, nonatomic) IBOutlet UILabel *money;
@property (weak, nonatomic) IBOutlet UIImageView *headImg;
@property (weak, nonatomic) IBOutlet UILabel *uidLbl;
@property (weak, nonatomic) IBOutlet UIScrollView *scorllView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scorllW;
@property (weak, nonatomic) IBOutlet UIImageView *vipImg;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"首页";
    _scorllW.constant = KScreenWidth;
    if ([[SPUtil objectForKey:k_app_sj] isEqualToString:@"1"]) {
        NSString *text = [NSString stringWithFormat:@"UID:S%@",[SPUtil objectForKey:k_app_USER_ID]];
        NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc]initWithString:text];
        [attributeStr addAttribute:NSForegroundColorAttributeName value:UIColorFromHex(0x52d869) range:NSMakeRange(4, 1)];
        self.uidLbl.attributedText = attributeStr;
    } else {
        NSString *text = [NSString stringWithFormat:@"UID:%@",[SPUtil objectForKey:k_app_USER_ID]];
        self.uidLbl.text = text;
    }
    self.score.text = [NSString stringWithFormat:@"%@",[SPUtil objectForKey:k_app_INTEGRAL]];
    self.money.text = [NSString stringWithFormat:@"%@",[SPUtil objectForKey:k_app_BALANCE]];
    [self.headImg sd_setImageWithURL:[NSURL URLWithString:[SPUtil objectForKey:k_app_HEAD_URL]] placeholderImage:[UIImage imageNamed:@"head"]];
    bannerView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 307, KScreenWidth, 100) imageNamesGroup:@[@"banner1",@"banner2",@"banner3"]];
    [_scorllView addSubview:bannerView];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    [self requestData]; 
}

- (void)requestData {
    RequestParams *parms = [[RequestParams alloc] initWithParams:API_HOMEPAGE];
    [parms addParameter:@"USER_NAME" value:[SPUtil objectForKey:k_app_USER_NAME]];
    [[NetworkSingleton shareInstace] httpPost:parms withTitle:@"首页" successBlock:^(id data) {
        self.score.text = [NSString stringWithFormat:@"%@",data[@"pd"][@"INTEGRAL"]];
        self.money.text = [NSString stringWithFormat:@"%@",data[@"pd"][@"BALANCE"]];
        [self.headImg sd_setImageWithURL:[NSURL URLWithString:data[@"pd"][@"HEAD_URL"]] placeholderImage:[UIImage imageNamed:@"head"]];
        if ([data[@"pd"][@"SPECIAL"] isEqualToString:@"0"]) {
            self.headImg.layer.borderColor = [UIColor colorWithWhite:0.6 alpha:0.6].CGColor;
            self.headImg.layer.borderWidth = 40;
        }
        if ([data[@"pd"][@"VIP"] isEqualToString:@"1"]) {
            self->_vipImg.hidden = false;
        }
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
        [SPUtil setObject:data[@"pd"][@"SJ"] forKey:k_app_sj];
        [SPUtil setObject:data[@"pd"][@"DDC_D"] forKey:k_app_ddc_d];
        [SPUtil setObject:data[@"pd"][@"DDC_B"] forKey:k_app_ddc_b];
        self->PROFIT_BALANCE = data[@"pd"][@"PROFIT_BALANCE"];
        self->PROFIT_INTEGRAL = data[@"pd"][@"PROFIT_INTEGRAL"];
        if ([data[@"pd"][@"IFJL"] integerValue] == 0) {
            UIView *redPackgeView = [[NSBundle mainBundle] loadNibNamed:@"RedPackgeView" owner:nil options:nil].lastObject;
            redPackgeView.frame = self.view.bounds;
            UILabel *money = [redPackgeView viewWithTag:101];
            money.text = [NSString stringWithFormat:@"%.2f",[data[@"pd"][@"PROFIT_BALANCE"] floatValue]];
            UIButton *receiveBtn = [redPackgeView viewWithTag:102];
            [receiveBtn addTapBlock:^(UIButton *btn) {
                [redPackgeView removeFromSuperview];
                [self toReceiveRedpackageRequest];
            }];
            [self.view addSubview:redPackgeView];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toRemoveRedPackgeView:)];
            [redPackgeView addGestureRecognizer:tap];
        }
        if ([[SPUtil objectForKey:k_app_sj] isEqualToString:@"1"]) {
            NSString *text = [NSString stringWithFormat:@"UID:S%@",data[@"pd"][@"USER_ID"]];
            NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc]initWithString:text];
            [attributeStr addAttribute:NSForegroundColorAttributeName value:UIColorFromHex(0x52d869) range:NSMakeRange(4, 1)];
            self.uidLbl.attributedText = attributeStr;
        } else {
            NSString *text = [NSString stringWithFormat:@"UID:%@",data[@"pd"][@"USER_ID"]];
            self.uidLbl.text = text;
        }
    } failureBlock:^(NSError *error) {
        
    }];
}

- (void)toRemoveRedPackgeView:(UITapGestureRecognizer *)tap {
    [tap.view removeFromSuperview];
}

- (void)toReceiveRedpackageRequest {
    RequestParams *parms = [[RequestParams alloc] initWithParams:API_REWARD];
    [parms addParameter:@"USER_NAME" value:[SPUtil objectForKey:k_app_USER_NAME]];
    [parms addParameter:@"USER_ID" value:[SPUtil objectForKey:k_app_USER_ID]];
    [parms addParameter:@"INTEGRAL" value:PROFIT_INTEGRAL];
    [parms addParameter:@"BALANCE" value:PROFIT_BALANCE];
    [[NetworkSingleton shareInstace] httpPost:parms withTitle:@"领取奖励" successBlock:^(id data) {
        [SVProgressHUD showSuccessWithStatus:@"领取成功"];
        [self requestData];
    } failureBlock:^(NSError *error) {
        
    }];
}

- (IBAction)toMineVC:(UIButton *)sender {
    self.navigationController.navigationBarHidden = NO;
    MineViewController *mineVC = [[MineViewController alloc] init];
    [self.navigationController pushViewController:mineVC animated:YES];
}

- (IBAction)QRCodeScannerAction:(UIButton *)sender {
    
    HMScannerController *scanner = [HMScannerController scannerWithCardName:nil avatar:nil completion:^(NSString *stringValue) {
        
        self.navigationController.navigationBarHidden = NO;
        TurnOutViewController *turnOutVC = [[TurnOutViewController alloc] init];
        turnOutVC.mobile = stringValue;
        [self.navigationController pushViewController:turnOutVC animated:YES];
    }];
    
    [scanner setTitleColor:[UIColor whiteColor] tintColor:[UIColor whiteColor]];
    
    [self showDetailViewController:scanner sender:nil];
}

- (IBAction)homeBtnAction:(UIButton *)sender {
    self.navigationController.navigationBarHidden = NO;
    
    if (sender.tag == 101) { // 余额转出
        TurnOutViewController *turnOutVC = [[TurnOutViewController alloc] init];
        [self.navigationController pushViewController:turnOutVC animated:YES];
    }else if (sender.tag == 102) { // 余额转入
        GetIntoViewController *vc = [[GetIntoViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (sender.tag == 103) { // 兑换积分
        ConvertibilityViewController *turnOutVC = [[ConvertibilityViewController alloc] init];
        turnOutVC.s_title = @"兑换积分";
        [self.navigationController pushViewController:turnOutVC animated:YES];
    }else if (sender.tag == 104) { // DDC豆买入
        PurchaseViewController *vc = [[PurchaseViewController alloc] init];
        vc.title = @"买入";
        [self.navigationController pushViewController:vc animated:YES];
    }else if (sender.tag == 105) { // DDC豆卖出
        PurchaseViewController *vc = [[PurchaseViewController alloc] init];
        vc.title = @"卖出";
        [self.navigationController pushViewController:vc animated:YES];
    }else if (sender.tag == 106) { // DDC豆兑换
        ConvertibilityViewController *turnOutVC = [[ConvertibilityViewController alloc] init];
        turnOutVC.s_title = @"兑换DDC豆";
        [self.navigationController pushViewController:turnOutVC animated:YES];
    }else if (sender.tag == 107) { // DDC商城
        self.navigationController.navigationBarHidden = YES;
        [SVProgressHUD showInfoWithStatus:@"DDC商城暂未开放，即将呈现敬请期待！"];
    }else if (sender.tag == 108) { // 数字资产
        DigitalAssetsViewController *vc = [[DigitalAssetsViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (sender.tag == 109) { // 订火车票
        self.navigationController.navigationBarHidden = YES;
        [SVProgressHUD showInfoWithStatus:@"订火车票暂未开放，即将呈现敬请期待！"];
    }
}

- (IBAction)headImgTapAction:(UITapGestureRecognizer *)sender {
    self.navigationController.navigationBarHidden = NO;
    MineViewController *mineVC = [[MineViewController alloc] init];
    [self.navigationController pushViewController:mineVC animated:YES];
}

- (IBAction)toScoreRecordAction:(id)sender {
    self.navigationController.navigationBarHidden = NO;
    ScoreRecordViewController *VC = [[ScoreRecordViewController alloc] init];
    VC.title = @"积分记录";
    [self.navigationController pushViewController:VC animated:YES];
}

- (IBAction)toMoneyRecordAction:(id)sender {
    self.navigationController.navigationBarHidden = NO;
    ScoreRecordViewController *VC = [[ScoreRecordViewController alloc] init];
    VC.title = @"余额记录";
    [self.navigationController pushViewController:VC animated:YES];
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
