//
//  DigitalAssetsViewController.m
//  iOSBase
//
//  Created by 冷婷 on 2018/8/22.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "DigitalAssetsViewController.h"
#import "DigitalAssetsCell.h"
#import "DigitalAssetsHeadView.h"
#import "DigitalTurnOutViewController.h"
#import "TransactionViewController.h"
#import "TradeRecordViewController.h"
@interface DigitalAssetsViewController ()<UITableViewDataSource, UITableViewDelegate> {
    NSDictionary *digitalAssets;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation DigitalAssetsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"数字资产";
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 80;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"DigitalAssetsCell" bundle:nil] forCellReuseIdentifier:@"DigitalAssetsCell"];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"交易记录" style:UIBarButtonItemStylePlain target:self action:@selector(toTradeAction)];
    digitalAssets = [NSDictionary dictionary];
    [self requestData];
}

- (void)toTradeAction {
    TradeRecordViewController *tradeRecordVC = [[TradeRecordViewController alloc] init];
    [self.navigationController pushViewController:tradeRecordVC animated:YES];
    
}

- (void)requestData {
    
    RequestParams *parms = [[RequestParams alloc] initWithParams:API_MARKET_PRICE];
    [parms addParameter:@"USER_NAME" value:[SPUtil objectForKey:k_app_USER_NAME]];
    [[NetworkSingleton shareInstace] httpPost:parms withTitle:@"指导价" successBlock:^(id data) {
        self->digitalAssets = data[@"pd"];
        [self.tableView reloadData];
    } failureBlock:^(NSError *error) {
        
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([digitalAssets isEqual: @{}]) {
        return 0;
    }else {
        return 5;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DigitalAssetsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DigitalAssetsCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row == 0) {
        cell.name.text = @"DDC";
        cell.detailName.text = @"DDC的资产";
        cell.num.text = [NSString stringWithFormat:@"%@", digitalAssets[@"DDC_B"]];
        cell.price.text = [NSString stringWithFormat:@"%@",digitalAssets[@"BUSINESS_PRICE"]];
    }else if (indexPath.row == 1) {
        cell.name.text = @"BTC";
        cell.detailName.text = @"比特币资产";
        cell.num.text = @"0.0000";
        cell.price.text = [NSString stringWithFormat:@"%@",digitalAssets[@"BTC_PRICE"]];
    }else if (indexPath.row == 2) {
        cell.name.text = @"LTC";
        cell.detailName.text = @"莱特币资产";
        cell.num.text = @"0.0000";
        cell.price.text = [NSString stringWithFormat:@"%@",digitalAssets[@"LTC_PRICE"]];
    }else if (indexPath.row == 3) {
        cell.name.text = @"ETH";
        cell.detailName.text = @"以太坊资产";
        cell.num.text = @"0.0000";
        cell.price.text = [NSString stringWithFormat:@"%@",digitalAssets[@"ETH_PRICE"]];
    }else if (indexPath.row == 4) {
        cell.name.text = @"DOG";
        cell.detailName.text = @"狗狗币资产";
        cell.num.text = @"0.0000";
        cell.price.text = [NSString stringWithFormat:@"%@",digitalAssets[@"DOG_PRICE"]];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 396;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    DigitalAssetsHeadView *headV = [[NSBundle mainBundle] loadNibNamed:@"DigitalAssetsHeadView" owner:nil options:nil].lastObject;
    if (![digitalAssets isEqual: @{}]) {
        headV.currentPrice.text = [NSString stringWithFormat:@"当前价格：%@", digitalAssets[@"BUSINESS_PRICE"]];
        headV.DDC_assets.text = [NSString stringWithFormat:@"%@",digitalAssets[@"DDC_B"]];
        headV.packageAddress.text = [NSString stringWithFormat:@"%@",digitalAssets[@"W_ADDRESS"]];
        [headV.btnCopy addTapBlock:^(UIButton *btn) {
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.string = [NSString stringWithFormat:@"%@",self->digitalAssets[@"W_ADDRESS"]];
            [SVProgressHUD showSuccessWithStatus:@"复制成功"];
        }];
    }
    [headV.turnOutBtn addTapBlock:^(UIButton *btn) {
        [SVProgressHUD showInfoWithStatus:@"暂未开放，即将呈现敬请期待！"];
    }];
    [headV.transactionBtn addTapBlock:^(UIButton *btn) {
        
        TransactionViewController *turnOutVC = [[TransactionViewController alloc] init];
        turnOutVC.transactionDic = self->digitalAssets;
        turnOutVC.type = 0;
        [self.navigationController pushViewController:turnOutVC animated:YES];
    }];
    return headV;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.navigationController.navigationBarHidden = NO;
    TransactionViewController *turnOutVC = [[TransactionViewController alloc] init];
    turnOutVC.transactionDic = digitalAssets;
    turnOutVC.type = indexPath.row;
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
