//
//  SZZhuanchuModel.h
//  iOSBase
//
//  Created by wb on 2018/11/21.
//  Copyright © 2018年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SZZhuanchuModel : NSObject
/*
 "CREATE_TIME" = "2018-11-21 15:31:28";
 "DDC_B" = 1;
 "HEAD_URL" = "http://211.149.191.75:8080/apidoc/ddc.png";
 ID = 255;
 "NICK_NAME" = gagagag;
 */
@property(nonatomic,copy)NSString *CREATE_TIME;
@property(nonatomic,copy)NSString *DDC_B;
@property(nonatomic,copy)NSString *HEAD_URL;
@property(nonatomic,copy)NSString *ID;
@property(nonatomic,copy)NSString *NICK_NAME;

@end
