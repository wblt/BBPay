//
//  MyBankViewController.m
//  iOSBase
//
//  Created by 冷婷 on 2018/8/19.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "MyBankViewController.h"
#import "MyBankCell.h"
#import "AddBankViewController.h"
@interface MyBankViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation MyBankViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的银行卡";
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 90;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"MyBankCell" bundle:nil] forCellReuseIdentifier:@"MyBankCell"];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyBankCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyBankCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 50;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    return nil;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 50)];
    footV.backgroundColor = [UIColor clearColor];
    UIButton *addBankBtn = [[UIButton alloc] initWithFrame:CGRectMake(6, 10, 110, 30)];
    addBankBtn.backgroundColor = [UIColor clearColor];
    addBankBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [addBankBtn setTitle:@"添加银行卡" forState:UIControlStateNormal];
    [addBankBtn setTitleColor:mainColor forState:UIControlStateNormal];
    [addBankBtn setImage:[UIImage imageNamed:@"jiahao"] forState:UIControlStateNormal];
    [addBankBtn addTapBlock:^(UIButton *btn) {
        AddBankViewController *addBankVC = [[AddBankViewController alloc] init];
        [self.navigationController pushViewController:addBankVC animated:YES];
    }];
    [footV addSubview:addBankBtn];
    return footV;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
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
