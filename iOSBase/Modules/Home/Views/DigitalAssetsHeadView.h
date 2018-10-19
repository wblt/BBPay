//
//  DigitalAssetsHeadView.h
//  iOSBase
//
//  Created by 冷婷 on 2018/8/22.
//  Copyright © 2018年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DigitalAssetsHeadView : UIView
@property (weak, nonatomic) IBOutlet UILabel *currentPrice;
@property (weak, nonatomic) IBOutlet UIImageView *headImg;
@property (weak, nonatomic) IBOutlet UIButton *turnOutBtn;
@property (weak, nonatomic) IBOutlet UIButton *transactionBtn;
@property (weak, nonatomic) IBOutlet UILabel *DDC_assets;
@property (weak, nonatomic) IBOutlet UILabel *packageAddress;
@property (weak, nonatomic) IBOutlet UIButton *btnCopy;


@end
