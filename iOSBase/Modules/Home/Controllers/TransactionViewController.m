//
//  TransactionViewController.m
//  iOSBase
//
//  Created by 冷婷 on 2018/8/26.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "TransactionViewController.h"
#import "TransactionCell.h"
#import "XDMenuView.h"
#import "TradeRecordModel.h"
@interface TransactionViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    UIButton *selcetedBtn;
    NSMutableArray *transactionArr;
}
@property (nonatomic, strong) NSString *lastId;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *btn1;
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UILabel *label3;
@property (weak, nonatomic) IBOutlet UILabel *label4;
@property (weak, nonatomic) IBOutlet UILabel *label5;
@property (weak, nonatomic) IBOutlet UILabel *label6;

@end

@implementation TransactionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"交易";
    selcetedBtn = _btn1;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 70;
    self.tableView.backgroundColor = mainBackgroudColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"TransactionCell" bundle:nil] forCellReuseIdentifier:@"TransactionCell"];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"DDC" style:UIBarButtonItemStylePlain target:self action:@selector(toMoreAction:)];
    [self changeTypeAction];
    
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if (self.type == 0) {
            [self requestData:@"1"];
        }
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        if (self.type == 0) {
            [self requestData:@"2"];
        }
    }];
    
}

- (void)changeTypeAction {
    transactionArr = [NSMutableArray array];
    [_tableView reloadData];
    if (_type == 0) {
        [self.navigationItem.rightBarButtonItem setTitle:@"DDC"];
        self.label1.text = [NSString stringWithFormat:@"%@",self.transactionDic[@"DDC_B"]];
        self.label2.text = [NSString stringWithFormat:@"%@",self.transactionDic[@"BALANCE"]];
        self.label3.text = @"DDC";
        self.label4.text = [NSString stringWithFormat:@"当前价格：%@",self.transactionDic[@"BUSINESS_PRICE"]];
        self.label5.text = [NSString stringWithFormat:@"高：%@",self.transactionDic[@"BUSINESS_PRICE"]];
        self.label6.text = [NSString stringWithFormat:@"低：%@",self.transactionDic[@"BUSINESS_PRICE"]];
        [self requestData:@"1"];
    }else if (_type == 1) {
        [self.navigationItem.rightBarButtonItem setTitle:@"比特币"];
        self.label1.text = @"0.0000";
        self.label2.text = @"0.00";
        self.label3.text = @"比特币";
        self.label4.text = [NSString stringWithFormat:@"当前价格：%@",self.transactionDic[@"BTC_PRICE"]];
        self.label5.text = [NSString stringWithFormat:@"高：%@",self.transactionDic[@"BTC_PRICE"]];
        self.label6.text = [NSString stringWithFormat:@"低：%@",self.transactionDic[@"BTC_PRICE"]];
    }else if (_type == 2) {
        [self.navigationItem.rightBarButtonItem setTitle:@"莱特币"];
        self.label1.text = @"0.0000";
        self.label2.text = @"0.00";
        self.label3.text = @"莱特币";
        self.label4.text = [NSString stringWithFormat:@"当前价格：%@",self.transactionDic[@"LTC_PRICE"]];
        self.label5.text = [NSString stringWithFormat:@"高：%@",self.transactionDic[@"LTC_PRICE"]];
        self.label6.text = [NSString stringWithFormat:@"低：%@",self.transactionDic[@"LTC_PRICE"]];
    }else if (_type == 3) {
        [self.navigationItem.rightBarButtonItem setTitle:@"以太坊"];
        self.label1.text = @"0.0000";
        self.label2.text = @"0.00";
        self.label3.text = @"以太坊";
        self.label4.text = [NSString stringWithFormat:@"当前价格：%@",self.transactionDic[@"ETH_PRICE"]];
        self.label5.text = [NSString stringWithFormat:@"高：%@",self.transactionDic[@"ETH_PRICE"]];
        self.label6.text = [NSString stringWithFormat:@"低：%@",self.transactionDic[@"ETH_PRICE"]];
    }else if (_type == 4) {
        [self.navigationItem.rightBarButtonItem setTitle:@"狗狗币"];
        self.label1.text = @"0.0000";
        self.label2.text = @"0.00";
        self.label3.text = @"狗狗币";
        self.label4.text = [NSString stringWithFormat:@"当前价格：%@",self.transactionDic[@"DOG_PRICE"]];
        self.label5.text = [NSString stringWithFormat:@"高：%@",self.transactionDic[@"DOG_PRICE"]];
        self.label6.text = [NSString stringWithFormat:@"低：%@",self.transactionDic[@"DOG_PRICE"]];
    }
}

- (void)requestData:(NSString *)type {
    
    RequestParams *parms = [[RequestParams alloc] initWithParams:[selcetedBtn.titleLabel.text isEqualToString:@"购买"] ? API_DDC_SELLLIST : API_DDC_BUYLIST];
    [parms addParameter:@"QUERY_ID" value:[type isEqualToString:@"1"] ? @"0" : _lastId];
    [parms addParameter:@"TYPE" value:type];
    [[NetworkSingleton shareInstace] httpPost:parms withTitle:@"交易记录" successBlock:^(id data) {
        NSMutableArray *arr = [NSMutableArray array];
        for (NSDictionary *dic in data[@"pd"]) {
            TradeRecordModel *model = [TradeRecordModel mj_objectWithKeyValues:dic];
            [arr addObject:model];
        }
        if([type isEqualToString:@"1"]){
            self->transactionArr = arr;
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer resetNoMoreData];
        }else{
            [self->transactionArr addObjectsFromArray:arr];
            [self.tableView.mj_footer endRefreshing];
        }
        if (self->transactionArr.count > 0) {
            TradeRecordModel *lastModel = self->transactionArr[self->transactionArr.count-1];
            self.lastId = lastModel.ID;
        }
        if(arr.count == 0){
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        [self.tableView reloadData];
    } failureBlock:^(NSError *error) {
        
    }];
}

- (void)toMoreAction:(UIBarButtonItem *)sender {
    XDMenuView * menu = [XDMenuView menuViewWithSender:sender];
    menu.backColor = mainBackgroudColor;
    XDMenuItem * item1 = [XDMenuItem item:@"DDC" icon:@"1-index-pop-searchguide" clickBlock:^(XDMenuItem *item, XDMenuView *menu) {
        self.type = 0;
        [self changeTypeAction];
    }];
    XDMenuItem * item2 = [XDMenuItem item:@"比特币" icon:@"1-index-pop-searchguide" clickBlock:^(XDMenuItem *item, XDMenuView *menu) {
        self.type = 1;
        [self changeTypeAction];
    }];
    XDMenuItem * item3 = [XDMenuItem item:@"莱特币" icon:@"1-index-pop-myorder" clickBlock:^(XDMenuItem *item, XDMenuView *menu) {
        self.type = 2;
        [self changeTypeAction];
    }];
    
    XDMenuItem * item4 = [XDMenuItem item:@"以太坊" icon:@"1-index-pop-myorder" clickBlock:^(XDMenuItem *item, XDMenuView *menu) {
        self.type = 3;
        [self changeTypeAction];
    }];
    
    XDMenuItem * item5 = [XDMenuItem item:@"狗狗币" icon:@"1-index-pop-myorder" clickBlock:^(XDMenuItem *item, XDMenuView *menu) {
        self.type = 4;
        [self changeTypeAction];
    }];
    
    [menu addItem:item1];
    [menu addItem:item2];
    [menu addItem:item3];
    [menu addItem:item4];
    [menu addItem:item5];
    
    //弹出
    [self presentViewController:menu animated:YES completion:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return transactionArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TransactionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TransactionCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    TradeRecordModel *model = transactionArr[indexPath.row];
    cell.name.text = [NSString stringWithFormat:@"昵称：%@",model.NICK_NAME];
    cell.price.text = model.BUSINESS_PRICE;
    cell.num.text = [NSString stringWithFormat:@"数量：%@",model.BUSINESS_BALANCE];
    [cell.headImg sd_setImageWithURL:[NSURL URLWithString:model.HEAD_URL] placeholderImage:[UIImage imageNamed:@"head"]];
    if ([selcetedBtn.titleLabel.text isEqualToString:@"购买"]) {
        [cell.btn setTitle:@"购买" forState:UIControlStateNormal];
    }else {
        [cell.btn setTitle:@"出售" forState:UIControlStateNormal];
    }
    if (indexPath.row == 0) {
        cell.btn.backgroundColor = mainRedColor;
        [cell.btn addTapBlock:^(UIButton *btn) {
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
                    RequestParams *parms = [[RequestParams alloc] initWithParams:API_DDC_TOMARKET];
                    [parms addParameter:@"USER_NAME" value:[SPUtil objectForKey:k_app_USER_NAME]];
                    [parms addParameter:@"BUSINESS_COUNT" value:inputInfo.text];
                    [parms addParameter:@"ID" value:model.ID];
                    [parms addParameter:@"PASSW" value:pass];
                    [[NetworkSingleton shareInstace] httpPost:parms withTitle:@"DDC下单" successBlock:^(id data) {
                        [SVProgressHUD showSuccessWithStatus:@"操作成功"];
                        self->selcetedBtn = self.btn1;
                        self->transactionArr = [NSMutableArray array];
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
        cell.btn.backgroundColor = [UIColor grayColor];
    }
    return cell;
}

- (IBAction)toPostSaleOrder:(UIButton *)sender {
    if (_type == 0) {
        
    }else {
        [SVProgressHUD showInfoWithStatus:@"暂未开放，即将呈现敬请期待！"];
    }
}

- (IBAction)toPostBuyOrder:(UIButton *)sender {
    if (_type == 0) {
        
    }else {
        [SVProgressHUD showInfoWithStatus:@"暂未开放，即将呈现敬请期待！"];
    }
}

- (IBAction)toOrderListAction:(UIButton *)sender {
    if (_type == 0) {
        
    }else {
        [SVProgressHUD showInfoWithStatus:@"暂未开放，即将呈现敬请期待！"];
    }
}

- (IBAction)selectedTypeAction:(UIButton *)sender {
    selcetedBtn.selected = NO;
    sender.selected = YES;
    selcetedBtn = sender;
    transactionArr = [NSMutableArray array];
    if (_type == 0) {
        [self requestData:@"1"];
    }
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
