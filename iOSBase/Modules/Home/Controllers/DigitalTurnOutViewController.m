//
//  DigitalTurnOutViewController.m
//  iOSBase
//
//  Created by 冷婷 on 2018/8/26.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "DigitalTurnOutViewController.h"
#import "TurnOutRecordListViewController.h"
@interface DigitalTurnOutViewController ()

@end

@implementation DigitalTurnOutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"转出";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"记录" style:UIBarButtonItemStylePlain target:self action:@selector(toTurnOutRecord)];
}

- (void)toTurnOutRecord {
    TurnOutRecordListViewController *turnOutVC = [[TurnOutRecordListViewController alloc] init];
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
