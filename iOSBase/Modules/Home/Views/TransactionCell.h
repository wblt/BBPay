//
//  TransactionCell.h
//  iOSBase
//
//  Created by 冷婷 on 2018/10/19.
//  Copyright © 2018年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TransactionCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImg;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *num;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UIButton *btn;

@end

NS_ASSUME_NONNULL_END
