//
//  DDCOrderCell.h
//  iOSBase
//
//  Created by wb on 2018/10/28.
//  Copyright © 2018年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDCOrderModel.h"

@interface DDCOrderCell : UITableViewCell

@property(nonatomic,strong) DDCOrderModel *model;

@property (weak, nonatomic) IBOutlet UILabel *nike;

@property (weak, nonatomic) IBOutlet UILabel *shuliang;

@property (weak, nonatomic) IBOutlet UILabel *jiage;

@property (weak, nonatomic) IBOutlet UILabel *stauts;

@end
