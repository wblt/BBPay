//
//  AddBankViewController.m
//  iOSBase
//
//  Created by 冷婷 on 2018/8/19.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "AddBankViewController.h"
#import "AnotherSearchViewController.h"
@interface AddBankViewController ()
@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *bankNum;
@property (weak, nonatomic) IBOutlet UILabel *bankName;
@property (weak, nonatomic) IBOutlet UITextField *bankSubName;

@end

@implementation AddBankViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"添加银行卡";
}

- (IBAction)selectedDefaultAction:(UIButton *)sender {
    sender.selected = !sender.selected;
}

- (IBAction)toSelectBankName:(UIButton *)sender {
    AnotherSearchViewController *search = [[AnotherSearchViewController alloc] init];
    search.title = @"选择银行";
    //返回选中搜索的结果
    [search didSelectedItem:^(NSString *item) {
        _bankName.text = item;
    }];
    [self.navigationController pushViewController:search animated:YES];
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
