//
//  DDCTurnOutRecordViewController.m
//  iOSBase
//
//  Created by 冷婷 on 2018/11/20.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "DDCTurnOutRecordViewController.h"
#import "ExchangeListCell.h"
#import "SZZhuanchuModel.h"

@interface DDCTurnOutRecordViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIButton *zhuanchu_button;
@property (weak, nonatomic) IBOutlet UIButton *zhuanru_button;
@property (nonatomic,copy) NSString *queryId;
@property (nonatomic,copy) NSString *select_type;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArray;
@end

@implementation DDCTurnOutRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.zhuanchu_button setTitleColor:UIColorFromHex(0x48A9E6) forState:UIControlStateNormal];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 44;
    self.tableView.backgroundColor = mainBackgroudColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"ExchangeListCell" bundle:nil] forCellReuseIdentifier:@"ExchangeListCell"];
    self.queryId = @"0";
    self.select_type = @"1";
    [self sendDDCBDetail:@"1"];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.queryId = @"0";
        if ([self.select_type isEqualToString:@"1"]) {
            [self sendDDCBDetail:@"1"];
        } else {
            [self receiveDDCBDetail:@"1"];
        }
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        if ([self.select_type isEqualToString:@"1"]) {
            [self sendDDCBDetail:@"2"];
        } else {
            [self receiveDDCBDetail:@"2"];
        }
    }];
}

- (IBAction)zhuanchu_action:(id)sender {
    self.select_type = @"1";
    [self.zhuanchu_button setTitleColor:UIColorFromHex(0x48A9E6) forState:UIControlStateNormal];
    [self.zhuanru_button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.queryId = @"0";
    [self sendDDCBDetail:@"1"];
}

- (IBAction)zhuanru_action:(id)sender {
    self.select_type = @"2";
    [self.zhuanchu_button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.zhuanru_button setTitleColor:UIColorFromHex(0x48A9E6) forState:UIControlStateNormal];
    self.queryId = @"0";
    [self receiveDDCBDetail:@"1"];
}

- (void)sendDDCBDetail:(NSString *)type {
    RequestParams *parms = [[RequestParams alloc] initWithParams:API_sendDDCBDetail];
    [parms addParameter:@"USER_NAME" value:[SPUtil objectForKey:k_app_USER_NAME]];
    [parms addParameter:@"QUERY_ID" value:self.queryId];
    [parms addParameter:@"TYPE" value:type];
    [[NetworkSingleton shareInstace] httpPost:parms withTitle:@"积分记录" successBlock:^(id data) {
        NSLog(@"dd");
        NSMutableArray *arr = [SZZhuanchuModel mj_objectArrayWithKeyValuesArray:data[@"pd"]];
        if([type isEqualToString:@"1"]){
            self.dataArray = arr;
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer resetNoMoreData];
        }else{
            [self.dataArray addObjectsFromArray:arr];
            [self.tableView.mj_footer endRefreshing];
        }
        if (self.dataArray.count > 0) {
            SZZhuanchuModel *lastModel = self.dataArray[self.dataArray.count-1];
            self.queryId = lastModel.ID;
        }
        if(arr.count == 0){
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        [self.tableView reloadData];
    } failureBlock:^(NSError *error) {
        
    }];
}

- (void)receiveDDCBDetail:(NSString *)type {
    RequestParams *parms = [[RequestParams alloc] initWithParams:API_receiveDDCBDetail];
    [parms addParameter:@"USER_NAME" value:[SPUtil objectForKey:k_app_USER_NAME]];
    [parms addParameter:@"QUERY_ID" value:self.queryId];
    [parms addParameter:@"TYPE" value:type];
    [[NetworkSingleton shareInstace] httpPost:parms withTitle:@"积分记录" successBlock:^(id data) {
        NSLog(@"dd");
        NSMutableArray *arr = [SZZhuanchuModel mj_objectArrayWithKeyValuesArray:data[@"pd"]];
        if([type isEqualToString:@"1"]){
            self.dataArray = arr;
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer resetNoMoreData];
        }else{
            [self.dataArray addObjectsFromArray:arr];
            [self.tableView.mj_footer endRefreshing];
        }
        if (self.dataArray.count > 0) {
            SZZhuanchuModel *lastModel = self.dataArray[self.dataArray.count-1];
            self.queryId = lastModel.ID;
        }
        if(arr.count == 0){
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        [self.tableView reloadData];
    } failureBlock:^(NSError *error) {
        
    }];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ExchangeListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ExchangeListCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    SZZhuanchuModel *szModel = self.dataArray[indexPath.row];
    cell.lbl1.text = [NSString stringWithFormat:@"昵称:%@",szModel.NICK_NAME];
    cell.lbl2.text = [NSString stringWithFormat:@"数量:%@",szModel.DDC_B];
    cell.lbl3.text = [NSString stringWithFormat:@"%@",szModel.CREATE_TIME];
    return cell;
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
