//
//  ShareCodeViewController.m
//  iOSBase
//
//  Created by 冷婷 on 2018/8/20.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "ShareCodeViewController.h"
#import "HMScannerController.h"
@interface ShareCodeViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;


@end

@implementation ShareCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *cardName = [SPUtil objectForKey:k_app_W_ADDRESS];
    
    [HMScannerController cardImageWithCardName:cardName avatar:nil scale:0.2 completion:^(UIImage *image) {
        self.imageView.image = image;
    }];
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
