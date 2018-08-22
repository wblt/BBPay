//
//  MineCell.h
//  iOSBase
//
//  Created by 冷婷 on 2018/8/19.
//  Copyright © 2018年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MineCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *img;
@property (weak, nonatomic) IBOutlet UILabel *titleText;
@property (weak, nonatomic) IBOutlet UILabel *detailTitle;

@end
