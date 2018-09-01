//
//  PurchaseOrderDetailViewController.m
//  iOSBase
//
//  Created by 冷婷 on 2018/8/31.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "PurchaseOrderDetailViewController.h"

@interface PurchaseOrderDetailViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    NSArray *detailArr;
    NSMutableArray *otherArr;
    UITableView *tableView;
}
@end

@implementation PurchaseOrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    detailArr = @[];
    tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.rowHeight = 44;
    tableView.backgroundColor = mainBackgroudColor;
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    tableView.separatorColor = mainBackgroudColor;
    [self.view addSubview:tableView];
    [self requestData];
}

- (void)requestData {
    otherArr = [NSMutableArray array];
    RequestParams *parms = [[RequestParams alloc] initWithParams:API_ORDERDETAIL];
    [parms addParameter:@"ID" value:_ID];
    [[NetworkSingleton shareInstace] httpPost:parms withTitle:@"订单详情" successBlock:^(id data) {
        detailArr = @[@"订单ID",@"交易数量",@"卖家姓名",@"持卡人名",@"银行卡号",@"开户银行",@"开户支行",@"订单时间",@"订单类型",@"订单状态",@"打款凭证"];
        NSDictionary *dic = data[@"pd"];
        [otherArr addObject:dic[@"ID"] == nil ? dic[@"ID"] : @""];
        [otherArr addObject:dic[@"BUSINESS_COUNT"] == nil ? dic[@"BUSINESS_COUNT"] : @""];
        [otherArr addObject:dic[@"NICK_NAME_B"] == nil ? dic[@"NICK_NAME_B"] : @""];
        [otherArr addObject:dic[@"BANK_USERNAME"] == nil ? dic[@"BANK_USERNAME"] : @""];
        [otherArr addObject:dic[@"BANK_NO"] == nil ? dic[@"BANK_NO"] : @""];
        [otherArr addObject:dic[@"BANK_NAME"] == nil ? dic[@"BANK_NAME"] : @""];
        [otherArr addObject:dic[@"BANK_ADDR"] == nil ? dic[@"BANK_ADDR"] : @""];
        [otherArr addObject:dic[@"CREATE_TIME"] == nil ? dic[@"CREATE_TIME"] : @""];
        [otherArr addObject:[dic[@"TYPE"] isEqualToString:@"1"] ? @"买单" : @"卖出"];
        [otherArr addObject:dic[@"STATUS"] == nil ? dic[@"STATUS"] : @""];
        [otherArr addObject:dic[@"IMAGE_NOTE"] == nil ? dic[@"IMAGE_NOTE"] : @""];
        [tableView reloadData];
    } failureBlock:^(NSError *error) {
        
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return detailArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"PurchaseOrderDetailCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.backgroundColor = mainItemsBackgroudColor;
        cell.tintColor = mainColor;
    }
    // 对cell 进行简单地数据配置
    cell.textLabel.text = detailArr[indexPath.row];
    cell.textLabel.textColor = mainColor;
    cell.detailTextLabel.text = otherArr[indexPath.row];
    cell.detailTextLabel.textColor = mainColor;
    return cell;
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
