//
//  DDCOrderCell.m
//  iOSBase
//
//  Created by wb on 2018/10/28.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "DDCOrderCell.h"

@implementation DDCOrderCell

- (void)setModel:(DDCOrderModel *)model {
    _model = model;
    self.nike.text = model.NICK_NAME;
    self.jiage.text = model.BUSINESS_PRICE;
    if ([model.STATUS isEqualToString:@"0"]) {
        self.shuliang.text = model.BUSINESS_BALANCE;
        self.stauts.text = @"取消";
    } else if([model.STATUS isEqualToString:@"3"]) {
        self.shuliang.text = model.BUSINESS_BALANCE;
        self.stauts.text = @"部分成交";
    } else if([model.STATUS isEqualToString:@"1"]) {
        self.shuliang.text = model.BUSINESS_COUNT;
        self.stauts.text = @"已成交";
    } else {
        self.shuliang.text = model.BUSINESS_BALANCE;
        self.stauts.text = @"已取消";
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
