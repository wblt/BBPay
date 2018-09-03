//
//  GetIntoViewController.m
//  iOSBase
//
//  Created by 冷婷 on 2018/8/29.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "GetIntoViewController.h"
#import "HMScannerController.h"
#import "TurnOutRecordListViewController.h"
@interface GetIntoViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;


@end

@implementation GetIntoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"转入";
    NSString *cardName = [SPUtil objectForKey:k_app_TEL];
    
    [HMScannerController cardImageWithCardName:cardName avatar:nil scale:0.2 completion:^(UIImage *image) {
        self.imageView.image = image;
    }];
}

- (IBAction)getIntoRecordListAction:(UIButton *)sender {
    TurnOutRecordListViewController *turnOutVC = [[TurnOutRecordListViewController alloc] init];
    turnOutVC.url = API_RECEIVEDEAIL;
    turnOutVC.title = @"转入记录";
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
