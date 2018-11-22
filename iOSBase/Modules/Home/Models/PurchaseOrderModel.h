//
//  PurchaseOrderModel.h
//  iOSBase
//
//  Created by 冷婷 on 2018/8/31.
//  Copyright © 2018年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PurchaseOrderModel : NSObject
/*
 "BUSINESS_BALANCE" = 500;
 "CREATE_TIME" = 1542856736000;
 ID = 164;
 "NICK_NAME" = gagagag;
 SJ = 0;
 "USER_ID" = 25994;
 "USER_NAME" = gagagag;
 */
@property (nonatomic, strong) NSString *USER_NAME;
@property (nonatomic, strong) NSString *ID;
@property (nonatomic, strong) NSString *USER_NAME_B;
@property (nonatomic, strong) NSString *NICK_NAME;
@property (nonatomic, strong) NSString *NICK_NAME_B;
@property (nonatomic, strong) NSString *HEAD_URL;
@property (nonatomic, strong) NSString *HEAD_URL_B;
@property (nonatomic, strong) NSString *STATUS;
@property (nonatomic, strong) NSString *BUSINESS_COUNT;
@property (nonatomic, strong) NSString *CREATE_TIME;
@property (nonatomic, strong) NSString *BUSINESS_BALANCE;


@end
