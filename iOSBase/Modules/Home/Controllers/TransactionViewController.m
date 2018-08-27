//
//  TransactionViewController.m
//  iOSBase
//
//  Created by 冷婷 on 2018/8/26.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "TransactionViewController.h"
#import "TurnOutRecordListCell.h"
#import "XDMenuView.h"
@interface TransactionViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation TransactionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"交易";
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 70;
    self.tableView.backgroundColor = mainBackgroudColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"TurnOutRecordListCell" bundle:nil] forCellReuseIdentifier:@"TurnOutRecordListCell"];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"DDC" style:UIBarButtonItemStylePlain target:self action:@selector(toMoreAction:)];
}

- (void)toMoreAction:(UIBarButtonItem *)sender {
    XDMenuView * menu = [XDMenuView menuViewWithSender:sender];
    menu.backColor = mainBackgroudColor;
    XDMenuItem * item1 = [XDMenuItem item:@"DDC" icon:@"1-index-pop-searchguide" clickBlock:^(XDMenuItem *item, XDMenuView *menu) {
        UIViewController * vc = [[UIViewController alloc]init];
        vc.title = @"全部项目";
        [self.navigationController pushViewController:vc animated:YES];
        
    }];
    XDMenuItem * item2 = [XDMenuItem item:@"比特币" icon:@"1-index-pop-searchguide" clickBlock:^(XDMenuItem *item, XDMenuView *menu) {
        UIViewController * vc = [[UIViewController alloc]init];
        vc.title = @"偏好设置";
        [self.navigationController pushViewController:vc animated:YES];
    }];
    XDMenuItem * item3 = [XDMenuItem item:@"莱特币" icon:@"1-index-pop-myorder" clickBlock:^(XDMenuItem *item, XDMenuView *menu) {
        UIViewController * vc = [[UIViewController alloc]init];
        vc.title = @"我的收藏";
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
    XDMenuItem * item4 = [XDMenuItem item:@"以太坊" icon:@"1-index-pop-myorder" clickBlock:^(XDMenuItem *item, XDMenuView *menu) {
        UIViewController * vc = [[UIViewController alloc]init];
        vc.title = @"我的收藏";
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
    XDMenuItem * item5 = [XDMenuItem item:@"狗狗币" icon:@"1-index-pop-myorder" clickBlock:^(XDMenuItem *item, XDMenuView *menu) {
        UIViewController * vc = [[UIViewController alloc]init];
        vc.title = @"我的收藏";
        [self.navigationController pushViewController:vc animated:YES];
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
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TurnOutRecordListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TurnOutRecordListCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (IBAction)toPostSaleOrder:(UIButton *)sender {
}

- (IBAction)toPostBuyOrder:(UIButton *)sender {
}

- (IBAction)toOrderListAction:(UIButton *)sender {
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
