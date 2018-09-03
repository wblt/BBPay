//
//  ScoreRecordViewController.m
//  iOSBase
//
//  Created by 冷婷 on 2018/9/1.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "ScoreRecordViewController.h"
#import "ExchangeRecordCell.h"
#import "ScoreRecordModel.h"
@interface ScoreRecordViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    NSMutableArray *exchangeArr;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation ScoreRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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
    RequestParams *parms = [[RequestParams alloc] initWithParams:[self.title isEqualToString:@"积分记录"] ? API_INTEGREALLOG : API_BALANCELOG];
    [parms addParameter:@"USER_ID" value:[SPUtil objectForKey:k_app_USER_ID]];
    [[NetworkSingleton shareInstace] httpPost:parms withTitle:@"积分记录" successBlock:^(id data) {
        for (NSDictionary *dic in data[@"pd"]) {
            ScoreRecordModel *model = [ScoreRecordModel mj_objectWithKeyValues:dic];
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
    ScoreRecordModel *model = exchangeArr[indexPath.row];
    cell.score.text = model.YE_TYPE;
    cell.money.text = [self.title isEqualToString:@"积分记录"] ? model.INTEGRAL : model.BALANCE;
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
