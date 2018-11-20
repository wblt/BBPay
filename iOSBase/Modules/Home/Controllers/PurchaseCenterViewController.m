//
//  PurchaseCenterViewController.m
//  iOSBase
//
//  Created by 冷婷 on 2018/8/31.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "PurchaseCenterViewController.h"
#import "PurchaseOrderCell.h"
#import "PurchaseOrderModel.h"
#import "UploadPic.h"
@interface PurchaseCenterViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    NSMutableArray *orderArr;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSString *lastId;
@end

@implementation PurchaseCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 70;
    self.tableView.backgroundColor = mainBackgroudColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"PurchaseOrderCell" bundle:nil] forCellReuseIdentifier:@"PurchaseOrderCell"];
    orderArr = [NSMutableArray array];
    [self requestData:@"1"];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self requestData:@"1"];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self requestData:@"2"];
    }];
}

- (void)requestData:(NSString *)type {
    
    RequestParams *parms = [[RequestParams alloc] initWithParams:([self.title isEqualToString:@"买入中心"] ? API_BUYLIST : API_SELLLIST)];
//    [parms addParameter:@"BUSINESS_COUNT" value:selectedBtn.titleLabel.text];
    [parms addParameter:@"QUERY_ID" value:[type isEqualToString:@"1"] ? @"0" : _lastId];
    [parms addParameter:@"TYPE" value:type];
    [[NetworkSingleton shareInstace] httpPost:parms withTitle:@"买单列表" successBlock:^(id data) {
        NSMutableArray *arr = [NSMutableArray array];
        for (NSDictionary *dic in data[@"pd"]) {
            PurchaseOrderModel *model = [PurchaseOrderModel mj_objectWithKeyValues:dic];
            [arr addObject:model];
        }
        
        if([type isEqualToString:@"1"]){
            orderArr = arr;
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer resetNoMoreData];
        }else{
            [orderArr addObjectsFromArray:arr];
            [self.tableView.mj_footer endRefreshing];
        }
        if (orderArr.count > 0) {
            PurchaseOrderModel *lastModel = orderArr[orderArr.count-1];
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
    return orderArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PurchaseOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PurchaseOrderCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    PurchaseOrderModel *model = orderArr[indexPath.row];
    cell.name.text = model.NICK_NAME;
    cell.score.text = model.BUSINESS_COUNT;
    cell.time.text = [Util timestampToString:[NSString stringWithFormat:@"%ld",[model.CREATE_TIME integerValue]/1000] formatterString:@"yyyy-MM-dd HH:mm:ss"];
    [cell.img sd_setImageWithURL:[NSURL URLWithString:model.HEAD_URL] placeholderImage:[UIImage imageNamed:@"head"]];
    cell.cancleBtn.hidden = YES;
    [cell.status setTitle:([self.title isEqualToString:@"买入中心"] ? @"卖出" : @"购买") forState:0];
    [cell.status addTapBlock:^(UIButton *btn) {
        YQPayKeyWordVC *yqVC = [[YQPayKeyWordVC alloc] init];
//        [yqVC showInViewController:self money:selectedBtn.titleLabel.text];
        yqVC.block = ^(NSString *pass) {
            RequestParams *parms = [[RequestParams alloc] initWithParams:API_TOMARKET];
            [parms addParameter:@"USER_NAME" value:[SPUtil objectForKey:k_app_USER_NAME]];
            [parms addParameter:@"ID" value:model.ID];
            [parms addParameter:@"PASSW" value:pass];
            [[NetworkSingleton shareInstace] httpPost:parms withTitle:@"从买单里面下卖单" successBlock:^(id data) {
                [SVProgressHUD showSuccessWithStatus:([self.title isEqualToString:@"买入中心"] ? @"卖出成功" : @"购买成功")];
                orderArr = [NSMutableArray array];
                [self requestData:@"1"];
            } failureBlock:^(NSError *error) {
                
            }];
        };
    }];
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
