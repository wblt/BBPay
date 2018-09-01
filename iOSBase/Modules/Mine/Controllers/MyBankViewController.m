//
//  MyBankViewController.m
//  iOSBase
//
//  Created by 冷婷 on 2018/8/19.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "MyBankViewController.h"
#import "MyBankCell.h"
#import "AddBankViewController.h"
#import "MyBankModel.h"
@interface MyBankViewController () <UITableViewDataSource, UITableViewDelegate>
{
    NSMutableArray *myBankArr;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation MyBankViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的银行卡";
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 90;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"MyBankCell" bundle:nil] forCellReuseIdentifier:@"MyBankCell"];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self requestData];
}

- (void)requestData {
    myBankArr = [NSMutableArray array];
    RequestParams *parms = [[RequestParams alloc] initWithParams:API_PAYMES];
    [parms addParameter:@"USER_NAME" value:[SPUtil objectForKey:k_app_USER_NAME]];
    [[NetworkSingleton shareInstace] httpPost:parms withTitle:@"我的银行卡" successBlock:^(id data) {
        for (NSDictionary *dic in data[@"pd"]) {
            MyBankModel *model = [MyBankModel mj_objectWithKeyValues:dic];
            [myBankArr addObject:model];
        }
        [self.tableView reloadData];
    } failureBlock:^(NSError *error) {
        
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return myBankArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyBankCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyBankCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    MyBankModel *model = myBankArr[indexPath.row];
    cell.bankName.text = model.BANK_NAME;
    cell.bankNum.text = model.BANK_NO;
    if ([model.IFDEFAULT isEqualToString:@"1"]) {
        cell.morenStatus.hidden = NO;
    }else {
        cell.morenStatus.hidden = YES;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 50;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    return nil;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 50)];
    footV.backgroundColor = [UIColor clearColor];
    UIButton *addBankBtn = [[UIButton alloc] initWithFrame:CGRectMake(6, 10, 110, 30)];
    addBankBtn.backgroundColor = [UIColor clearColor];
    addBankBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [addBankBtn setTitle:@"添加银行卡" forState:UIControlStateNormal];
    [addBankBtn setTitleColor:mainColor forState:UIControlStateNormal];
    [addBankBtn setImage:[UIImage imageNamed:@"jiahao"] forState:UIControlStateNormal];
    [addBankBtn addTapBlock:^(UIButton *btn) {
        AddBankViewController *addBankVC = [[AddBankViewController alloc] init];
        addBankVC.isFrist = (myBankArr.count == 0);
        [self.navigationController pushViewController:addBankVC animated:YES];
    }];
    [footV addSubview:addBankBtn];
    return footV;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MyBankModel *model = myBankArr[indexPath.row];
//    if (self.isSelectedBank) {
//        self.bankBlock(model);
//        [self.navigationController popViewControllerAnimated:YES];
//
//    }else {
        if ([model.IFDEFAULT isEqualToString:@"1"]) {
            return;
        }
        [UIAlertController showActionSheetWithTitle:@"银行卡操作" Message:nil cancelBtnTitle:@"取消" OtherBtnTitles:@[@"设置默认",@"删除银行卡"] ClickBtn:^(NSInteger index) {
            if (index == 1) {
                RequestParams *parms = [[RequestParams alloc] initWithParams:API_MODPAYMES];
                [parms addParameter:@"ID" value:model.ID];
                [parms addParameter:@"USER_NAME" value:[SPUtil objectForKey:k_app_USER_NAME]];
                [[NetworkSingleton shareInstace] httpPost:parms withTitle:@"修改默认" successBlock:^(id data) {
                    [SVProgressHUD showSuccessWithStatus:@"修改成功"];
                    [self requestData];
                } failureBlock:^(NSError *error) {
                    
                }];
            }else if (index == 2) {
                RequestParams *parms = [[RequestParams alloc] initWithParams:API_DELPAYMES];
                [parms addParameter:@"ID" value:model.ID];
                [[NetworkSingleton shareInstace] httpPost:parms withTitle:@"删除银行卡" successBlock:^(id data) {
                    [SVProgressHUD showSuccessWithStatus:@"删除成功"];
                    [self requestData];
                } failureBlock:^(NSError *error) {
                    
                }];
            }
        }];
//    }
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
