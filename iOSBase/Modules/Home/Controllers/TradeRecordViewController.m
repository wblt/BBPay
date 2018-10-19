//
//  TradeRecordViewController.m
//  iOSBase
//
//  Created by 冷婷 on 2018/10/19.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "TradeRecordViewController.h"
#import "TradeRecordCell.h"
#import "TradeRecordModel.h"
@interface TradeRecordViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    NSMutableArray *tradeRecordArr;
    UIButton *selcetedBtn;
}
@property (nonatomic, strong) NSString *lastId;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *btn1;
@property (weak, nonatomic) IBOutlet UIButton *btn2;

@end

@implementation TradeRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"交易记录";
    selcetedBtn = _btn1;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 41;
    self.tableView.backgroundColor = mainBackgroudColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"TradeRecordCell" bundle:nil] forCellReuseIdentifier:@"TradeRecordCell"];
    
    [self requestData:@"1"];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self requestData:@"1"];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self requestData:@"2"];
    }];
    
}

- (void)requestData:(NSString *)type {
    
    RequestParams *parms = [[RequestParams alloc] initWithParams:[selcetedBtn.titleLabel.text isEqualToString:@"购买"] ? API_DDC_BUYLOGS : API_DDC_SELLLOGS];
    [parms addParameter:@"USER_NAME" value:[SPUtil objectForKey:k_app_USER_NAME]];
    [parms addParameter:@"QUERY_ID" value:[type isEqualToString:@"1"] ? @"0" : _lastId];
    [parms addParameter:@"TYPE" value:type];
    [[NetworkSingleton shareInstace] httpPost:parms withTitle:@"交易记录" successBlock:^(id data) {
        NSMutableArray *arr = [NSMutableArray array];
        for (NSDictionary *dic in data[@"pd"]) {
            TradeRecordModel *model = [TradeRecordModel mj_objectWithKeyValues:dic];
            [arr addObject:model];
        }
        if([type isEqualToString:@"1"]){
            self->tradeRecordArr = arr;
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer resetNoMoreData];
        }else{
            [self->tradeRecordArr addObjectsFromArray:arr];
            [self.tableView.mj_footer endRefreshing];
        }
        if (self->tradeRecordArr.count > 0) {
            TradeRecordModel *lastModel = self->tradeRecordArr[self->tradeRecordArr.count-1];
            self.lastId = lastModel.ID;
        }
        if(arr.count == 0){
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        [self.tableView reloadData];
    } failureBlock:^(NSError *error) {
        
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return tradeRecordArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TradeRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TradeRecordCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    TradeRecordModel *model = tradeRecordArr[indexPath.row];
    cell.name.text = model.USER_NAME_B;
    cell.price.text = model.BUSINESS_PRICE;
    cell.num.text = model.BUSINESS_COUNT;
    cell.time.text = [Util timestampToString:[NSString stringWithFormat:@"%ld",[model.CREATE_TIME integerValue]/1000] formatterString:@"yyyy-MM-dd HH:mm:ss"];
    return cell;
}

- (IBAction)selectedTypeAction:(UIButton *)sender {
    selcetedBtn.selected = NO;
    sender.selected = YES;
    selcetedBtn = sender;
    tradeRecordArr = [NSMutableArray array];
    [self requestData:@"1"];
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
