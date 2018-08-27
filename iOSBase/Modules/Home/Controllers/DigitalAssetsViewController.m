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
@interface DigitalAssetsViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation DigitalAssetsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 80;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"DigitalAssetsCell" bundle:nil] forCellReuseIdentifier:@"DigitalAssetsCell"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DigitalAssetsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DigitalAssetsCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
    [headV.backBtn addTapBlock:^(UIButton *btn) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [headV.turnOutBtn addTapBlock:^(UIButton *btn) {
        self.navigationController.navigationBarHidden = NO;
        DigitalTurnOutViewController *turnOutVC = [[DigitalTurnOutViewController alloc] init];
        [self.navigationController pushViewController:turnOutVC animated:YES];
    }];
    [headV.transactionBtn addTapBlock:^(UIButton *btn) {
        self.navigationController.navigationBarHidden = NO;
        TransactionViewController *turnOutVC = [[TransactionViewController alloc] init];
        [self.navigationController pushViewController:turnOutVC animated:YES];
    }];
    return headV;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.navigationController.navigationBarHidden = NO;
    
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
