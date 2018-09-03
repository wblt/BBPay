//
//  ShareCodeViewController.m
//  iOSBase
//
//  Created by 冷婷 on 2018/8/20.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "ShareCodeViewController.h"
#import "HMScannerController.h"
#import "ShareRecordViewController.h"
@interface ShareCodeViewController ()
{
    NSString *v_addr;
}
@property (weak, nonatomic) IBOutlet UIImageView *imageView;


@end

@implementation ShareCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"邀请好友";
    [self requestData];
}

- (void)requestData {
    RequestParams *parms = [[RequestParams alloc] initWithParams:API_INVITATION];
    [parms addParameter:@"USER_NAME" value:[SPUtil objectForKey:k_app_USER_NAME]];
    [parms addParameter:@"TERMINAL" value:@"1"];
    [[NetworkSingleton shareInstace] httpPost:parms withTitle:@"邀请好友" successBlock:^(id data) {
        v_addr = data[@"pd"][@"V_ADDR"];
        [HMScannerController cardImageWithCardName:v_addr avatar:nil scale:0.2 completion:^(UIImage *image) {
            self.imageView.image = image;
        }];

    } failureBlock:^(NSError *error) {
        
    }];
}

- (IBAction)copyAction:(UIButton *)sender {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = v_addr;
    [SVProgressHUD showSuccessWithStatus:@"复制成功"];
}

- (IBAction)toShareRecordVCAction:(UIButton *)sender {
    ShareRecordViewController *editVC = [[ShareRecordViewController alloc] init];
    [self.navigationController pushViewController:editVC animated:YES];
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
