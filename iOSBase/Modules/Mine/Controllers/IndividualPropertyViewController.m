//
//  IndividualPropertyViewController.m
//  iOSBase
//
//  Created by 冷婷 on 2018/8/20.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "IndividualPropertyViewController.h"

@interface IndividualPropertyViewController ()
@property (weak, nonatomic) IBOutlet UILabel *money;
@property (weak, nonatomic) IBOutlet UILabel *score;
@end

@implementation IndividualPropertyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的资产";
    self.view.backgroundColor = [UIColor whiteColor];
    self.score.text = [SPUtil objectForKey:k_app_INTEGRAL];
    self.money.text = [SPUtil objectForKey:k_app_BALANCE];
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
