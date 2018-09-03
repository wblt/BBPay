//
//  PurchaseRecordViewController.m
//  iOSBase
//
//  Created by 冷婷 on 2018/8/31.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "PurchaseRecordViewController.h"
#import "TurnOutRecordListCell.h"
#import "PurchaseOrderModel.h"
@interface PurchaseRecordViewController () <UITableViewDataSource, UITableViewDelegate>
{
    NSMutableArray *turnOutArr;
}
@property (nonatomic, strong) NSString *lastId;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation PurchaseRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 70;
    self.tableView.backgroundColor = mainBackgroudColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"TurnOutRecordListCell" bundle:nil] forCellReuseIdentifier:@"TurnOutRecordListCell"];
    turnOutArr = [NSMutableArray array];
    [self requestData:@"1"];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self requestData:@"1"];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self requestData:@"2"];
    }];
}

- (void)requestData:(NSString *)type {
    
    RequestParams *parms = [[RequestParams alloc] initWithParams:([self.title isEqualToString:@"买入记录"] ? API_BUYLOGS : API_SELLLOGS)];
    [parms addParameter:@"USER_NAME" value:[SPUtil objectForKey:k_app_USER_NAME]];
    [parms addParameter:@"QUERY_ID" value:[type isEqualToString:@"1"] ? @"0" : _lastId];
    [parms addParameter:@"TYPE" value:type];
    [[NetworkSingleton shareInstace] httpPost:parms withTitle:@"买入记录" successBlock:^(id data) {
        NSMutableArray *arr = [NSMutableArray array];
        for (NSDictionary *dic in data[@"pd"]) {
            PurchaseOrderModel *model = [PurchaseOrderModel mj_objectWithKeyValues:dic];
            [arr addObject:model];
        }
        
        if([type isEqualToString:@"1"]){
            turnOutArr = arr;
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer resetNoMoreData];
        }else{
            [turnOutArr addObjectsFromArray:arr];
            [self.tableView.mj_footer endRefreshing];
        }
        if (turnOutArr.count > 0) {
            PurchaseOrderModel *lastModel = turnOutArr[turnOutArr.count-1];
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
    return turnOutArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TurnOutRecordListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TurnOutRecordListCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    PurchaseOrderModel *model = turnOutArr[indexPath.row];
    cell.title.text = model.NICK_NAME;
    cell.detail.text = @"";
    cell.money.text = model.BUSINESS_COUNT;
    cell.time.text = [Util timestampToString:[NSString stringWithFormat:@"%ld",[model.CREATE_TIME integerValue]/1000] formatterString:@"yyyy-MM-dd HH:mm:ss"];;
    [cell.img sd_setImageWithURL:[NSURL URLWithString:model.HEAD_URL] placeholderImage:[UIImage imageNamed:@"head"]];
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
