//
//  TurnOutViewController.m
//  iOSBase
//
//  Created by 冷婷 on 2018/8/21.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "TurnOutViewController.h"
#import "ConvertibilityViewController.h"
#import "TurnOutRecordListViewController.h"
@interface TurnOutViewController ()

@end

@implementation TurnOutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"转出";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"转出记录" style:UIBarButtonItemStylePlain target:self action:@selector(toTurnOutRecord)];
    
}

- (void)toTurnOutRecord {
    TurnOutRecordListViewController *turnOutVC = [[TurnOutRecordListViewController alloc] init];
    [self.navigationController pushViewController:turnOutVC animated:YES];
}

- (IBAction)toTurnOutAction:(UIButton *)sender {
    
    ConvertibilityViewController *turnOutVC = [[ConvertibilityViewController alloc] init];
    [self.navigationController pushViewController:turnOutVC animated:YES];
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
