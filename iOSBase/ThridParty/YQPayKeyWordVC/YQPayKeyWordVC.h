//
//  YQPayKeyWordVC.h
//  Youqun
//
//  Created by 王崇磊 on 16/6/1.
//  Copyright © 2016年 W_C__L. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YQPayKeyWordVC : UIViewController
typedef void(^Block)(NSString *pass);
@property (nonatomic, copy) Block block;
- (void)showInViewController:(UIViewController *)vc money:(NSString *)moneyNum;

@end
