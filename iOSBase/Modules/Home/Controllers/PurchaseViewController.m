//
//  PurchaseViewController.m
//  iOSBase
//
//  Created by 冷婷 on 2018/8/21.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "PurchaseViewController.h"
#import "XDMenuView.h"
#import "MyBankViewController.h"
#import "YQPayKeyWordVC.h"
#import "PurchaseOrderViewController.h"
#import "PurchaseCenterViewController.h"
#import "PurchaseRecordViewController.h"
#import "AddBankViewController.h"
@interface PurchaseViewController ()
{
    NSArray *btnArr;
    UIButton *selectedBtn;
}
@property (weak, nonatomic) IBOutlet UIButton *btn1;
@property (weak, nonatomic) IBOutlet UIButton *btn2;
@property (weak, nonatomic) IBOutlet UIButton *btn3;
@property (weak, nonatomic) IBOutlet UIButton *btn4;
@property (weak, nonatomic) IBOutlet UIButton *btn5;
@property (weak, nonatomic) IBOutlet UIButton *btn6;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *bankName;
@property (weak, nonatomic) IBOutlet UILabel *bankNum;
@property (weak, nonatomic) IBOutlet UITextField *orther_number;
@property (nonatomic,copy) NSString *select_type;
@property (nonatomic,copy) NSString *bzj;
@property (nonatomic,copy) NSString *sxf;
@end

@implementation PurchaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    btnArr = @[_btn1,_btn2,_btn3,_btn4,_btn5,_btn6];
    selectedBtn = _btn1;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"more_icon"] style:UIBarButtonItemStylePlain target:self action:@selector(toMoreAction:)];
    self.select_type = @"1";
    if ([self.title isEqualToString:@"卖出"]) {
        self.orther_number.placeholder = @"请输入其他的数量(500的整数倍)";
    } else {
        self.orther_number.placeholder = @"请输入其他的数量(1的整数倍)";
    }
    [self s_bzj];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self requestData];
}

- (IBAction)editing_changed:(id)sender {
    for (UIButton *btn in btnArr) {
        btn.selected = NO;
    }
    self.select_type = @"2";
}

- (IBAction)editing_end:(UITextField *)sender {
    if (sender.text.length == 0) {
        UIButton *btn = [btnArr firstObject];
        btn.selected = YES;
        self.select_type = @"1";
    }
}




- (void)requestData {
    RequestParams *parms = [[RequestParams alloc] initWithParams:API_PAYMES];
    [parms addParameter:@"USER_NAME" value:[SPUtil objectForKey:k_app_USER_NAME]];
    [[NetworkSingleton shareInstace] httpPost:parms withTitle:@"我的银行卡" successBlock:^(id data) {
        NSArray *arr = data[@"pd"];
        if (arr.count > 0) {
            _bankModel = [MyBankModel mj_objectWithKeyValues:arr[0]];
            _name.text = _bankModel.BANK_USERNAME;
            _bankName.text = _bankModel.BANK_NAME;
            _bankNum.text = _bankModel.BANK_NO;
        }
       
    } failureBlock:^(NSError *error) {
        
    }];
}

- (void)toMoreAction:(UIBarButtonItem *)sender {
    XDMenuView * menu = [XDMenuView menuViewWithSender:sender];
    menu.backColor = mainBackgroudColor;
    NSArray *menuTitleArr = @[];
    if ([self.title isEqualToString:@"买入"]) {
        menuTitleArr = @[@"买入订单",@"买入记录",@"买入中心"];
    }else {
        menuTitleArr = @[@"卖出订单",@"卖出记录",@"卖出中心"];
    }
    
    XDMenuItem * item1 = [XDMenuItem item:menuTitleArr[0] icon:@"1-index-pop-searchguide" clickBlock:^(XDMenuItem *item, XDMenuView *menu) {
        PurchaseOrderViewController * vc = [[PurchaseOrderViewController alloc] init];
        vc.title = menuTitleArr[0];
        [self.navigationController pushViewController:vc animated:YES];
        
    }];
    XDMenuItem * item2 = [XDMenuItem item:menuTitleArr[1] icon:@"1-index-pop-searchguide" clickBlock:^(XDMenuItem *item, XDMenuView *menu) {
        PurchaseRecordViewController * vc = [[PurchaseRecordViewController alloc] init];
        vc.title = menuTitleArr[1];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    XDMenuItem * item3 = [XDMenuItem item:menuTitleArr[2] icon:@"1-index-pop-myorder" clickBlock:^(XDMenuItem *item, XDMenuView *menu) {
        PurchaseCenterViewController * vc = [[PurchaseCenterViewController alloc] init];
        vc.title = menuTitleArr[2];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
    [menu addItem:item1];
    [menu addItem:item2];
    [menu addItem:item3];
    
    //弹出
    [self presentViewController:menu animated:YES completion:nil];
}

- (IBAction)selectBtnAction:(UIButton *)sender {
    for (UIButton *btn in btnArr) {
        btn.selected = NO;
    }
    sender.selected = YES;
    selectedBtn = sender;
    self.select_type = @"1";
}

- (IBAction)toSelectBankInfoAction:(UITapGestureRecognizer *)sender {
    MyBankViewController *myBankVC = [[MyBankViewController alloc] init];
//    myBankVC.isSelectedBank = YES;
//    myBankVC.bankBlock = ^(MyBankModel *model) {
//        _name.text = model.BANK_USERNAME;
//        _bankName.text = model.BANK_NAME;
//        _bankNum.text = model.BANK_NO;
//        _bankModel = model;
//    };
    [self.navigationController pushViewController:myBankVC animated:YES];
}

- (IBAction)createOrderAction:(UIButton *)sender {
    NSString *title_msg = [NSString stringWithFormat:@"确认是否您账号百分之%@的DDC币作为保证金,同时消耗卖出数量的百分之%@的DDC币。",self.bzj,self.sxf];
    [UIAlertController showAlertViewWithTitle:@"温馨提示" Message:title_msg BtnTitles:@[@"取消",@"确定"] ClickBtn:^(NSInteger index) {
        if (index == 1) {
            if (self->_bankModel == nil) {
                AddBankViewController *addBankVC = [[AddBankViewController alloc] init];
                addBankVC.isFrist = YES;
                [self.navigationController pushViewController:addBankVC animated:YES];
            }else {
                YQPayKeyWordVC *yqVC = [[YQPayKeyWordVC alloc] init];
                if ([self.select_type isEqualToString:@"2"]) {
                    if ([self.title isEqualToString:@"卖出"]) {
                        NSInteger number = [self.orther_number.text integerValue];
                        if (number == 0 || number % 500 != 0) {
                            [SVProgressHUD showSuccessWithStatus:@"请输入数量并且为500的整数倍"];
                            return;
                        }
                    } else {
                        NSInteger number = [self.orther_number.text integerValue];
                        if (number == 0 || number < 1) {
                            [SVProgressHUD showSuccessWithStatus:@"请输入数量并且大于或等于1的整数倍"];
                            return;
                        }
                    }
                    [yqVC showInViewController:self money:self.orther_number.text];
                } else {
                    [yqVC showInViewController:self money:self->selectedBtn.titleLabel.text];
                }
                yqVC.block = ^(NSString *pass) {
                    RequestParams *parms = [[RequestParams alloc] initWithParams:([self.title isEqualToString:@"买入"] ? API_BUY : API_SELL)];
                    [parms addParameter:@"USER_NAME" value:[SPUtil objectForKey:k_app_USER_NAME]];
                    if ([self.select_type isEqualToString:@"2"]) {
                        [parms addParameter:@"BUSINESS_COUNT" value:self.orther_number.text];
                    } else {
                        [parms addParameter:@"BUSINESS_COUNT" value:self->selectedBtn.titleLabel.text];
                    }
                    [parms addParameter:@"BANK_NO" value:self->_bankModel.BANK_NO];
                    [parms addParameter:@"BANK_USERNAME" value:self->_bankModel.BANK_USERNAME];
                    [parms addParameter:@"BANK_NAME" value:self->_bankModel.BANK_NAME];
                    [parms addParameter:@"BANK_ADDR" value:self->_bankModel.BANK_ADDR];
                    [parms addParameter:@"PASSW" value:pass];
                    [[NetworkSingleton shareInstace] httpPost:parms withTitle:@"买入创建订单" successBlock:^(id data) {
                        [SVProgressHUD showSuccessWithStatus:@"创建订单成功"];
                        PurchaseOrderViewController * vc = [[PurchaseOrderViewController alloc] init];
                        vc.title = [self.title isEqualToString:@"买入"] ? @"买入订单" : @"卖出订单";
                        [self.navigationController pushViewController:vc animated:YES];
                    } failureBlock:^(NSError *error) {
                        
                    }];
                };
            }
        }
    }];
}

- (void)s_bzj{
    RequestParams *parms = [[RequestParams alloc] initWithParams:API_bzj];
    [[NetworkSingleton shareInstace] httpPost:parms withTitle:@"转出记录" successBlock:^(id data) {
        self.bzj = data[@"pd"][@"BZJ"];
        self.sxf = data[@"pd"][@"SXF"];
        NSLog(@"dd");
    } failureBlock:^(NSError *error) {
        
    }];
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
