//
//  DDCOrderViewController.m
//  iOSBase
//
//  Created by 冷婷 on 2018/10/22.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "DDCOrderViewController.h"
#import "DDCOrderCell.h"
#import "DDCOrderModel.h"
@interface DDCOrderViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *mairu_order_label;
@property (weak, nonatomic) IBOutlet UILabel *maichu_order_label;
@property (weak, nonatomic) IBOutlet UIImageView *mairu_order_img;
@property (weak, nonatomic) IBOutlet UIImageView *maichu_order_img;
@property (weak, nonatomic) IBOutlet UIButton *unfinish_button;
@property (weak, nonatomic) IBOutlet UIButton *precess_button;
@property (weak, nonatomic) IBOutlet UIButton *finish_button;
@property (nonatomic,copy) NSString *select_type;
@property (nonatomic,copy) NSString *STATUS;
@property (nonatomic,copy) NSString *queryId;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (weak, nonatomic) IBOutlet UILabel *action_name;

@end

@implementation DDCOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"查看订单";
    [self.unfinish_button setTitleColor:UIColorFromHex(0x48A9E6) forState:UIControlStateNormal];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 41;
    self.tableView.backgroundColor = mainBackgroudColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"DDCOrderCell" bundle:nil] forCellReuseIdentifier:@"DDCOrderCell"];
    self.select_type = @"1";
    self.STATUS = @"0";
    self.queryId = @"0";
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.queryId = @"0";
        if ([self.select_type isEqualToString:@"1"]) {
            [self ddc_buyOrderList:@"1"];
        } else {
            [self ddc_sellOrderList:@"1"];
        }
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        if ([self.select_type isEqualToString:@"1"]) {
            [self ddc_buyOrderList:@"2"];
        } else {
            [self ddc_sellOrderList:@"2"];
        }
    }];
}


- (IBAction)mairu_action:(id)sender {
    self.select_type = @"1";
    self.mairu_order_img.image = [UIImage imageNamed:@"zhuanru_jilu_hui"];
    self.maichu_order_img.image = [UIImage imageNamed:@"zhuanru_jilu_hui"];
    self.mairu_order_label.textColor = [UIColor whiteColor];
    self.maichu_order_label.textColor = [UIColor groupTableViewBackgroundColor];
    
    self.STATUS = @"0";
    [self.unfinish_button setTitleColor:UIColorFromHex(0x48A9E6) forState:UIControlStateNormal];
    [self.precess_button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.finish_button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    self.queryId = @"0";
    [self ddc_buyOrderList:@"1"];
}


- (IBAction)maichu_action:(id)sender {
    self.select_type = @"2";
    self.mairu_order_img.image = [UIImage imageNamed:@"zhuanru_jilu_hui"];
    self.maichu_order_img.image = [UIImage imageNamed:@"zhuanru_jilu_hui"];
    self.maichu_order_label.textColor = [UIColor whiteColor];
    self.mairu_order_label.textColor = [UIColor groupTableViewBackgroundColor];
    
    self.STATUS = @"0";
    [self.unfinish_button setTitleColor:UIColorFromHex(0x48A9E6) forState:UIControlStateNormal];
    [self.precess_button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.finish_button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    self.queryId = @"0";
    [self ddc_sellOrderList:@"1"];
}

- (IBAction)unfinish:(id)sender {
    self.action_name.text = @"操作";
    self.STATUS = @"0";
    [self.unfinish_button setTitleColor:UIColorFromHex(0x48A9E6) forState:UIControlStateNormal];
    [self.precess_button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.finish_button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.queryId = @"0";
    if ([self.select_type isEqualToString:@"1"]) {
        [self ddc_buyOrderList:@"1"];
    } else {
        [self ddc_sellOrderList:@"1"];
    }
}


- (IBAction)precess:(id)sender {
    self.action_name.text = @"状态";
    self.STATUS = @"-1";
    [self.unfinish_button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.precess_button setTitleColor:UIColorFromHex(0x48A9E6) forState:UIControlStateNormal];
    [self.finish_button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.queryId = @"0";
    if ([self.select_type isEqualToString:@"1"]) {
        [self ddc_buyOrderList:@"1"];
    } else {
        [self ddc_sellOrderList:@"1"];
    }
}


- (IBAction)finish:(id)sender {
    self.action_name.text = @"状态";
    self.STATUS = @"1";
    [self.unfinish_button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.precess_button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.finish_button setTitleColor:UIColorFromHex(0x48A9E6) forState:UIControlStateNormal];
    self.queryId = @"0";
    if ([self.select_type isEqualToString:@"1"]) {
        [self ddc_buyOrderList:@"1"];
    } else {
        [self ddc_sellOrderList:@"1"];
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DDCOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DDCOrderCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.dataArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DDCOrderModel *model = self.dataArray[indexPath.row];
    if ([model.STATUS isEqualToString:@"0"]) {
        [UIAlertController showAlertViewWithTitle:@"温馨提示" Message:@"您确定要取消订单？" BtnTitles:@[@"取消",@"确定"] ClickBtn:^(NSInteger index) {
            if (index == 1) {
                [self ddc_orderCancle:model.ID];
            }
        }];
    }
}

- (void)ddc_buyOrderList:(NSString *)type {
    RequestParams *parms = [[RequestParams alloc] initWithParams:API_ddc_buyOrderList];
    [parms addParameter:@"USER_NAME" value:[SPUtil objectForKey:k_app_USER_NAME]];
    [parms addParameter:@"QUERY_ID" value:self.queryId];
    [parms addParameter:@"STATUS" value:self.STATUS];
    [parms addParameter:@"TYPE" value:type];
    [[NetworkSingleton shareInstace] httpPost:parms withTitle:@"积分记录" successBlock:^(id data) {
        NSLog(@"dd");
        NSMutableArray *array = [DDCOrderModel mj_objectArrayWithKeyValuesArray:data[@"pd"]];
        if([type isEqualToString:@"1"]){
            self.dataArray = array;
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer resetNoMoreData];
        }else{
            [self.dataArray addObjectsFromArray:array];
            [self.tableView.mj_footer endRefreshing];
        }
        if (self.dataArray.count > 0) {
            DDCOrderModel *lastModel = self.dataArray[self.dataArray.count-1];
            self.queryId = lastModel.ID;
        }
        if(array.count == 0){
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        [self.tableView reloadData];
    } failureBlock:^(NSError *error) {
        
    }];
}

- (void)ddc_sellOrderList:(NSString *)type {
    RequestParams *parms = [[RequestParams alloc] initWithParams:API_ddc_sellOrderList];
    [parms addParameter:@"USER_NAME" value:[SPUtil objectForKey:k_app_USER_NAME]];
    [parms addParameter:@"QUERY_ID" value:self.queryId];
    [parms addParameter:@"STATUS" value:self.STATUS];
    [parms addParameter:@"TYPE" value:type];
    [[NetworkSingleton shareInstace] httpPost:parms withTitle:@"积分记录" successBlock:^(id data) {
        NSLog(@"dd");
        NSMutableArray *array = [DDCOrderModel mj_objectArrayWithKeyValuesArray:data[@"pd"]];
        if([type isEqualToString:@"1"]){
            self.dataArray = array;
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer resetNoMoreData];
        }else{
            [self.dataArray addObjectsFromArray:array];
            [self.tableView.mj_footer endRefreshing];
        }
        if (self.dataArray.count > 0) {
            DDCOrderModel *lastModel = self.dataArray[self.dataArray.count-1];
            self.queryId = lastModel.ID;
        }
        if(array.count == 0){
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        [self.tableView reloadData];
    } failureBlock:^(NSError *error) {
        
    }];
}

- (void)ddc_orderCancle:(NSString *)ID {
    RequestParams *parms = [[RequestParams alloc] initWithParams:API_ddc_orderCancle];
    [parms addParameter:@"ID" value:ID];
    [[NetworkSingleton shareInstace] httpPost:parms withTitle:@"积分记录" successBlock:^(id data) {
        NSLog(@"dd");
        self.queryId = @"0";
        if ([self.select_type isEqualToString:@"1"]) {
            [self ddc_buyOrderList:@"1"];
        } else {
            [self ddc_sellOrderList:@"1"];
        }
    } failureBlock:^(NSError *error) {
        
    }];
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
