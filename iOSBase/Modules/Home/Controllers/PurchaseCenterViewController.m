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

@property (weak, nonatomic) IBOutlet UIImageView *head_img;

@property (weak, nonatomic) IBOutlet UILabel *b_label;

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
    self.b_label.text = [NSString stringWithFormat:@"DDC资产:%@",[SPUtil objectForKey:k_app_ddc_d]];
    [self.head_img sd_setImageWithURL:[NSURL URLWithString:[SPUtil objectForKey:k_app_HEAD_URL]] placeholderImage:[UIImage imageNamed:@"head"]];
}

- (void)requestData:(NSString *)type {
    RequestParams *parms = [[RequestParams alloc] initWithParams:([self.title isEqualToString:@"买入中心"] ? API_BUYLIST : API_SELLLIST)];
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
    cell.score.text = model.BUSINESS_BALANCE;
    cell.time.text = [Util timestampToString:[NSString stringWithFormat:@"%ld",[model.CREATE_TIME integerValue]/1000] formatterString:@"yyyy-MM-dd HH:mm:ss"];
    [cell.img sd_setImageWithURL:[NSURL URLWithString:model.HEAD_URL] placeholderImage:[UIImage imageNamed:@"head"]];
    cell.cancleBtn.hidden = YES;
    [cell.status setTitle:([self.title isEqualToString:@"买入中心"] ? @"卖出" : @"购买") forState:0];
    [cell.status setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    if (indexPath.row == 0) {
        [cell.status setBackgroundColor: [UIColor redColor]];
        [cell.status addTapBlock:^(UIButton *btn) {
            UIAlertController *alt = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"" preferredStyle:UIAlertControllerStyleAlert];
            [alt addTextFieldWithConfigurationHandler:^(UITextField *textField){
                textField.placeholder = @"请输入委托数量(大于1且为整数)";
                textField.keyboardType = UIKeyboardTypeNumberPad;
            }];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                UITextField *inputInfo = alt.textFields.firstObject;
                if ([inputInfo.text integerValue] <= 0) {
                    [SVProgressHUD showErrorWithStatus:@"请输入委托数量"];
                    return;
                }
                YQPayKeyWordVC *yqVC = [[YQPayKeyWordVC alloc] init];
                [yqVC showInViewController:self money:inputInfo.text];
                yqVC.block = ^(NSString *pass) {
                    RequestParams *parms = [[RequestParams alloc] initWithParams:API_TOMARKET];
                    [parms addParameter:@"USER_NAME" value:[SPUtil objectForKey:k_app_USER_NAME]];
                    [parms addParameter:@"ID" value:model.ID];
                    [parms addParameter:@"BUSINESS_COUNT" value:inputInfo.text];
                    [parms addParameter:@"PASSW" value:pass];
                    [[NetworkSingleton shareInstace] httpPost:parms withTitle:@"从买单里面下卖单" successBlock:^(id data) {
                        [SVProgressHUD showSuccessWithStatus:([self.title isEqualToString:@"买入中心"] ? @"卖出成功" : @"购买成功")];
                        self->orderArr = [NSMutableArray array];
                        [self requestData:@"1"];
                    } failureBlock:^(NSError *error) {
                        
                    }];
                };
            }];
            [alt addAction:cancelAction];
            [alt addAction:okAction];
            [self presentViewController:alt animated:YES completion:^{
            }];
        }];
    }else {
        [cell.status setBackgroundColor: [UIColor lightGrayColor]];
    }
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
