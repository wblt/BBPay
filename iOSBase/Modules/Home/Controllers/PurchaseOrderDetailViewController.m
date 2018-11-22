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
    self.title = @"订单详情";
    detailArr = @[];
    tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.rowHeight = 44;
    tableView.backgroundColor = mainBackgroudColor;
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    tableView.separatorColor = [UIColor groupTableViewBackgroundColor];
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
        [otherArr addObject:self.ID];
        [otherArr addObject:dic[@"BUSINESS_COUNT"]];
        NSString *NICK_NAME_B = dic[@"NICK_NAME_B"];
        if (NICK_NAME_B == nil) {
            [otherArr addObject:@""];
        } else {
            [otherArr addObject:NICK_NAME_B];
        }
        [otherArr addObject:dic[@"BANK_USERNAME"]];
        [otherArr addObject:dic[@"BANK_NO"]];
        [otherArr addObject:dic[@"BANK_NAME"]];
        [otherArr addObject:dic[@"BANK_ADDR"]];
        [otherArr addObject:[Util timestampToString:[NSString stringWithFormat:@"%ld",[dic[@"CREATE_TIME"] integerValue]/1000] formatterString:@"yyyy-MM-dd HH:mm:ss"]];
        [otherArr addObject:[dic[@"TYPE"] integerValue] == 1 ? @"买单" : @"卖出"];
        [otherArr addObject:dic[@"STATUS"]];
        [otherArr addObject:dic[@"IMAGE_NOTE"]];
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
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.backgroundColor = mainItemsBackgroudColor;
        cell.tintColor = mainColor;
    }
    // 对cell 进行简单地数据配置
    cell.textLabel.text = detailArr[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:13];
    cell.textLabel.textColor = mainColor;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",otherArr[indexPath.row]];
    cell.detailTextLabel.textColor = mainColor;
    cell.detailTextLabel.font = [UIFont systemFontOfSize:13];
    if (indexPath.row == detailArr.count - 1) {
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(KScreenWidth-90, 5, 50, 50)];
        [img sd_setImageWithURL:[NSURL URLWithString:otherArr[indexPath.row]] placeholderImage:[UIImage imageNamed:@"logo"]];
        [cell addSubview:img];
        cell.detailTextLabel.text = @"";
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == detailArr.count - 1) {
        return 60;
    }
    return 44;
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
