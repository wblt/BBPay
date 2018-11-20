//
//  ExchangeRecordViewController.m
//  iOSBase
//
//  Created by 冷婷 on 2018/8/29.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "ExchangeRecordViewController.h"
#import "ExchangeListCell.h"
#import "ExchangeModel.h"
@interface ExchangeRecordViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    NSMutableArray *exchangeArr;
    
}
@property (nonatomic, strong) NSString *lastId;
@property (weak, nonatomic) IBOutlet UILabel *jifen_label;


@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation ExchangeRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"兑换记录";
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 44;
    self.tableView.backgroundColor = mainBackgroudColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"ExchangeListCell" bundle:nil] forCellReuseIdentifier:@"ExchangeListCell"];
    exchangeArr = [NSMutableArray array];
    [self requestData:@"1"];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self requestData:@"1"];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self requestData:@"2"];
    }];
    if ([self.s_title isEqualToString:@"积分兑换"]) {
        self.jifen_label.text = @"兑换积分";
    } else {
        self.jifen_label.text = @"兑换DDC豆";
    }
    
}

- (void)requestData:(NSString *)type {
    RequestParams *parms = nil;
    if ([self.s_title isEqualToString:@"积分兑换"]) {
        parms = [[RequestParams alloc] initWithParams:API_CGDETAIL];
    } else {
        parms = [[RequestParams alloc] initWithParams:API_cgDDCDDetail];
    }
    [parms addParameter:@"USER_NAME" value:[SPUtil objectForKey:k_app_USER_NAME]];
    [parms addParameter:@"QUERY_ID" value:[type isEqualToString:@"1"] ? @"0" : _lastId];
    [parms addParameter:@"TYPE" value:type];
    [[NetworkSingleton shareInstace] httpPost:parms withTitle:@"兑换记录" successBlock:^(id data) {
        NSMutableArray *arr = [NSMutableArray array];
        for (NSDictionary *dic in data[@"pd"]) {
            ExchangeModel *model = [ExchangeModel mj_objectWithKeyValues:dic];
            [arr addObject:model];
        }
        if([type isEqualToString:@"1"]){
            exchangeArr = arr;
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer resetNoMoreData];
        }else{
            [exchangeArr addObjectsFromArray:arr];
            [self.tableView.mj_footer endRefreshing];
        }
        if (exchangeArr.count > 0) {
            ExchangeModel *lastModel = exchangeArr[exchangeArr.count-1];
            _lastId = lastModel.ID;
        }
        if(arr.count == 0){
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        [self.tableView reloadData];
    } failureBlock:^(NSError *error) {
        
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return exchangeArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ExchangeListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ExchangeListCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    ExchangeModel *model = exchangeArr[indexPath.row];
    if ([self.s_title isEqualToString:@"兑换积分"]) {
        cell.lbl2.text = model.INTEGRAL;
    } else {
        cell.lbl2.text = model.DDC_D;
    }
    cell.lbl1.text = [NSString stringWithFormat:@"-%@",model.BALANCE];
    cell.lbl3.text = [Util timestampToString:[NSString stringWithFormat:@"%ld",[model.CREATE_TIME integerValue]/1000] formatterString:@"yyyy-MM-dd HH:mm:ss"];
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
