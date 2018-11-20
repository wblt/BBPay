//
//  DDCTurnOutViewController.m
//  iOSBase
//
//  Created by 冷婷 on 2018/11/20.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "DDCTurnOutViewController.h"
#import "DDCTurnOutRecordViewController.h"
@interface DDCTurnOutViewController ()

@end

@implementation DDCTurnOutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"转出";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"记录" style:UIBarButtonItemStylePlain target:self action:@selector(toTurnOutRecord)];
}

- (void)toTurnOutRecord {
    DDCTurnOutRecordViewController *turnOutVC = [[DDCTurnOutRecordViewController alloc] init];
    turnOutVC.title = @"记录";
    [self.navigationController pushViewController:turnOutVC animated:YES];
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
