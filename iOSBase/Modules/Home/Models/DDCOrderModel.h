//
//  DDCOrderModel.h
//  iOSBase
//
//  Created by wb on 2018/11/20.
//  Copyright © 2018年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DDCOrderModel : NSObject
/*
 "BUSINESS_BALANCE" = 1;
 "BUSINESS_COUNT" = 1;
 "BUSINESS_PRICE" = 1;
 "CREATE_TIME" = 1542700746000;
 ID = 3;
 "NICK_NAME" = gagagag;
 STATUS = 0;
 "USER_NAME" = gagagag;
 */
@property(nonatomic,copy)NSString *BUSINESS_BALANCE;
@property(nonatomic,copy)NSString *BUSINESS_COUNT;
@property(nonatomic,copy)NSString *BUSINESS_PRICE;
@property(nonatomic,copy)NSString *CREATE_TIME;
@property(nonatomic,copy)NSString *ID;
@property(nonatomic,copy)NSString *NICK_NAME;
@property(nonatomic,copy)NSString *STATUS;
@property(nonatomic,copy)NSString *USER_NAME;
@end
