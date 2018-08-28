//
//  SPUtil.h
//  Keepcaring
//
//  Created by wb on 2017/12/13.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

#define k_app_login @"app_login"      // 判断是否登录
#define k_app_PASSWORD @"app_PASSWORD"
#define k_app_TEL @"app_TEL"
#define k_app_USER_NAME @"app_USER_NAME"
#define k_app_NICK_NAME @"app_NICK_NAME"
#define k_app_USER_ID @"app_USER_ID"
#define k_app_HEAD_URL @"app_HEAD_URL"
#define k_app_INTEGRAL @"app_INTEGRAL"
#define k_app_BALANCE @"app_BALANCE"
#define k_app_CREDIT @"app_CREDIT"
#define k_app_VIP @"app_VIP"
#define k_app_W_ADDRESS @"app_W_ADDRESS"
#define k_app_IFPAS @"app_IFPAS"
@interface SPUtil : NSObject

// 设置
+ (void)setInteger:(NSInteger)value forKey:(NSString *_Nullable)defaultName;

+ (void)setFloat:(float)value forKey:(NSString *_Nullable)defaultName;

+ (void)setDouble:(double)value forKey:(NSString *_Nullable)defaultName;

+ (void)setBool:(BOOL)value forKey:(NSString *_Nullable)defaultName;

+ (void)setURL:(nullable NSURL *)url forKey:(NSString *_Nullable)defaultName;

+ (void)setObject:(nullable id)value forKey:(NSString *_Nullable)defaultName;

// 获取
+ (NSInteger)integerForKey:(NSString *_Nullable)defaultName;

+ (float)floatForKey:(NSString *_Nullable)defaultName;

+ (double)doubleForKey:(NSString *_Nullable)defaultName;

+ (BOOL)boolForKey:(NSString *_Nullable)defaultName;

+ (nullable NSURL *)URLForKey:(NSString *_Nullable)defaultName;

+ (id _Nullable )objectForKey:(NSString *_Nullable)defaultName;

+ (void)clear;

@end
