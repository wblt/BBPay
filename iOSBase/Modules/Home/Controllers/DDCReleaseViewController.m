//
//  DDCReleaseViewController.m
//  iOSBase
//
//  Created by 冷婷 on 2018/10/22.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "DDCReleaseViewController.h"

@interface DDCReleaseViewController ()
@property (weak, nonatomic) IBOutlet UILabel *money;
@property (weak, nonatomic) IBOutlet UILabel *score;
@property (weak, nonatomic) IBOutlet UITextField *priceText;
@property (weak, nonatomic) IBOutlet UITextField *numText;
@end

@implementation DDCReleaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (_isPostSale) {
        self.title = @"发布出售订单";
    }else {
        self.title = @"发布购买订单";
    }
    self.score.text = [NSString stringWithFormat:@"%@",[SPUtil objectForKey:k_app_INTEGRAL]];
    self.money.text = [NSString stringWithFormat:@"%@",[SPUtil objectForKey:k_app_BALANCE]];
}
- (IBAction)cebtainAction:(UIButton *)sender {
    
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
