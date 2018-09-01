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
    NSArray *btnArr;
    UIButton *selectedBtn;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *btn1;
@property (weak, nonatomic) IBOutlet UIButton *btn2;
@property (weak, nonatomic) IBOutlet UIButton *btn3;
@property (weak, nonatomic) IBOutlet UIButton *btn4;
@property (weak, nonatomic) IBOutlet UIButton *btn5;
@property (weak, nonatomic) IBOutlet UIButton *btn6;

@end

@implementation PurchaseCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    btnArr = @[_btn1,_btn2,_btn3,_btn4,_btn5,_btn6];
    selectedBtn = _btn1;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 70;
    self.tableView.backgroundColor = mainBackgroudColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"PurchaseOrderCell" bundle:nil] forCellReuseIdentifier:@"PurchaseOrderCell"];
    [self requestData];
}

- (void)requestData {
    orderArr = [NSMutableArray array];
    RequestParams *parms = [[RequestParams alloc] initWithParams:([self.title isEqualToString:@"买入中心"] ? API_BUYLIST : API_SELLLIST)];
    [parms addParameter:@"BUSINESS_COUNT" value:selectedBtn.titleLabel.text];
    [parms addParameter:@"QUERY_ID" value:@"0"];
    [parms addParameter:@"TYPE" value:@"1"];
    [[NetworkSingleton shareInstace] httpPost:parms withTitle:@"买单列表" successBlock:^(id data) {
        for (NSDictionary *dic in data[@"pd"]) {
            PurchaseOrderModel *model = [PurchaseOrderModel mj_objectWithKeyValues:dic];
            [orderArr addObject:model];
        }
        [self.tableView reloadData];
    } failureBlock:^(NSError *error) {
        
    }];
}

- (IBAction)selectedTypeStatusAction:(UIButton *)sender {
    for (UIButton *btn in btnArr) {
        btn.selected = NO;
    }
    sender.selected = YES;
    selectedBtn = sender;
    [self requestData];
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
        [yqVC showInViewController:self money:selectedBtn.titleLabel.text];
        yqVC.block = ^(NSString *pass) {
            RequestParams *parms = [[RequestParams alloc] initWithParams:API_TOMARKET];
            [parms addParameter:@"USER_NAME" value:[SPUtil objectForKey:k_app_USER_NAME]];
            [parms addParameter:@"ID" value:model.ID];
            [parms addParameter:@"PASSW" value:pass];
            [[NetworkSingleton shareInstace] httpPost:parms withTitle:@"从买单里面下卖单" successBlock:^(id data) {
                [SVProgressHUD showSuccessWithStatus:([self.title isEqualToString:@"买入中心"] ? @"卖出成功" : @"购买成功")];
                [self requestData];
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
