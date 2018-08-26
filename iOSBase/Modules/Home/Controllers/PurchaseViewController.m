//
//  PurchaseViewController.m
//  iOSBase
//
//  Created by 冷婷 on 2018/8/21.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "PurchaseViewController.h"
#import "XDMenuView.h"
@interface PurchaseViewController ()

@end

@implementation PurchaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"买入";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"more_icon"] style:UIBarButtonItemStylePlain target:self action:@selector(toMoreAction:)];
}

- (void)toMoreAction:(UIBarButtonItem *)sender {
    XDMenuView * menu = [XDMenuView menuViewWithSender:sender];
    menu.backColor = mainBackgroudColor;
    XDMenuItem * item1 = [XDMenuItem item:@"订单" icon:@"1-index-pop-searchguide" clickBlock:^(XDMenuItem *item, XDMenuView *menu) {
        UIViewController * vc = [[UIViewController alloc]init];
        vc.title = @"全部项目";
        [self.navigationController pushViewController:vc animated:YES];
        
    }];
    XDMenuItem * item2 = [XDMenuItem item:@"买入记录" icon:@"1-index-pop-searchguide" clickBlock:^(XDMenuItem *item, XDMenuView *menu) {
        UIViewController * vc = [[UIViewController alloc]init];
        vc.title = @"偏好设置";
        [self.navigationController pushViewController:vc animated:YES];
    }];
    XDMenuItem * item3 = [XDMenuItem item:@"买入中心" icon:@"1-index-pop-myorder" clickBlock:^(XDMenuItem *item, XDMenuView *menu) {
        UIViewController * vc = [[UIViewController alloc]init];
        vc.title = @"我的收藏";
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
    [menu addItem:item1];
    [menu addItem:item2];
    [menu addItem:item3];
    
    //弹出
    [self presentViewController:menu animated:YES completion:nil];
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
