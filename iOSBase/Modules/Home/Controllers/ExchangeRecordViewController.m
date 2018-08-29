//
//  ExchangeRecordViewController.m
//  iOSBase
//
//  Created by 冷婷 on 2018/8/29.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "ExchangeRecordViewController.h"
#import "ExchangeRecordCell.h"
#import "ExchangeModel.h"
@interface ExchangeRecordViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    NSMutableArray *exchangeArr;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation ExchangeRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"兑换记录";
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 60;
    self.tableView.backgroundColor = mainBackgroudColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"ExchangeRecordCell" bundle:nil] forCellReuseIdentifier:@"ExchangeRecordCell"];
    [self requestData];
}

- (void)requestData {
    exchangeArr = [NSMutableArray array];
    RequestParams *parms = [[RequestParams alloc] initWithParams:API_CGDETAIL];
    [parms addParameter:@"USER_NAME" value:[SPUtil objectForKey:k_app_USER_NAME]];
    [parms addParameter:@"QUERY_ID" value:@"0"];
    [parms addParameter:@"TYPE" value:@"1"];
    [[NetworkSingleton shareInstace] httpPost:parms withTitle:@"转出记录" successBlock:^(id data) {
        for (NSDictionary *dic in data[@"pd"]) {
            ExchangeModel *model = [ExchangeModel mj_objectWithKeyValues:dic];
            [exchangeArr addObject:model];
        }
        [self.tableView reloadData];
    } failureBlock:^(NSError *error) {
        
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return exchangeArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ExchangeRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ExchangeRecordCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    ExchangeModel *model = exchangeArr[indexPath.row];
    cell.score.text = [NSString stringWithFormat:@"积分:%@",model.INTEGRAL];
    cell.money.text = [NSString stringWithFormat:@"余额:%@",model.BALANCE];
    cell.time.text = model.CREATE_TIME;
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
