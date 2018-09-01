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

@end

@implementation PurchaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    btnArr = @[_btn1,_btn2,_btn3,_btn4,_btn5,_btn6];
    selectedBtn = _btn1;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"more_icon"] style:UIBarButtonItemStylePlain target:self action:@selector(toMoreAction:)];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self requestData];
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
    if (_bankModel == nil) {
        AddBankViewController *addBankVC = [[AddBankViewController alloc] init];
        addBankVC.isFrist = YES;
        [self.navigationController pushViewController:addBankVC animated:YES];
        
    }else {
        YQPayKeyWordVC *yqVC = [[YQPayKeyWordVC alloc] init];
        [yqVC showInViewController:self money:selectedBtn.titleLabel.text];
        yqVC.block = ^(NSString *pass) {
            RequestParams *parms = [[RequestParams alloc] initWithParams:([self.title isEqualToString:@"买入"] ? API_BUY : API_SELL)];
            [parms addParameter:@"USER_NAME" value:[SPUtil objectForKey:k_app_USER_NAME]];
            [parms addParameter:@"BUSINESS_COUNT" value:selectedBtn.titleLabel.text];
            [parms addParameter:@"BANK_NO" value:_bankModel.BANK_NO];
            [parms addParameter:@"BANK_USERNAME" value:_bankModel.BANK_USERNAME];
            [parms addParameter:@"BANK_NAME" value:_bankModel.BANK_NAME];
            [parms addParameter:@"BANK_ADDR" value:_bankModel.BANK_ADDR];
            [parms addParameter:@"PASSW" value:pass];
            [[NetworkSingleton shareInstace] httpPost:parms withTitle:@"买入创建订单" successBlock:^(id data) {
                [SVProgressHUD showSuccessWithStatus:@"创建订单成功"];
            } failureBlock:^(NSError *error) {
                
            }];
        };
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
