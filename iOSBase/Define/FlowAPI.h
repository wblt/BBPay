//
//  FlowAPI.h
//  Keepcaring
//
//  Created by mac on 2017/12/11.
//  Copyright © 2017年 mac. All rights reserved.
//

#ifndef FlowAPI_h
#define FlowAPI_h

/**<转换16进制颜色*/
#define UIColorFromHex(HexValue) ([UIColor colorWithHex:HexValue])

/**<RGB颜色设置*/
#define UI_ColorWithRGBA(r,g,b,a) [UIColor colorWithRed:r/255. green:g/255. blue:b/255. alpha:a]

/**<本地的文件目录路径*/
#define kLocalFilePath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"LocalFileDirectory"]

/**<本地的文件目录*/
#define LocalFileDirectory [Util createFileDirectory:kLocalFilePath]

/**<用户的文件目录*/
#define UserModelPath [LocalFileDirectory stringByAppendingPathComponent:@"userModel.archive"]

/**<设备信息的文件目录*/
#define DeviceDataPath [LocalFileDirectory stringByAppendingPathComponent:@"DeviceData.archive"]

/**<下载的文件目录*/
#define DownloadFilePath [LocalFileDirectory stringByAppendingPathComponent:@"downloadFileDirectory"]

//DEBUG  模式下打印日志,当前行
#ifdef DEBUG
#define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define DLog(...)
#endif

//获取屏幕宽高
#define KScreenWidth ([[UIScreen mainScreen] bounds].size.width)
#define KScreenHeight [[UIScreen mainScreen] bounds].size.height

#define navHeight ((KScreenWidth == 1125.0 && KScreenHeight == 2436.0) ? 88.0 : 64.0)
//金色
#define mainColor UIColorFromHex(0xCBAE86)
//底色
#define mainBackgroudColor UIColorFromHex(0x303030)
//控件底色
#define mainItemsBackgroudColor UIColorFromHex(0x424242)
//灰色字体
#define mainGrayColor UIColorFromHex(0x848484)

#define weakify(...) \
rac_keywordify \
metamacro_foreach_cxt(rac_weakify_,, __weak, __VA_ARGS__)

#define strongify(...) \
rac_keywordify \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wshadow\"") \
metamacro_foreach(rac_strongify_,, __VA_ARGS__) \
_Pragma("clang diagnostic pop")

// 主服务器地址
#define SERVER_IP         @"http://139.196.225.206:8082"

// 登录
#define API_LOGIN       SERVER_IP@"/app/user/login"
// 注册
#define API_SYREG       SERVER_IP@"/app/user/syreg"
// 首页
#define API_HOMEPAGE       SERVER_IP@"/app/index/homePage"
//
#define API_CHANGEPWD       SERVER_IP@"/app/tool/changePassw"
//
#define API_AQPASSW       SERVER_IP@"/app/tool/aqPassw"
//
#define API_NOTICE       SERVER_IP@"/app/index/notice"
//
#define API_SIGNCREATE       SERVER_IP@"/upload/signCreate"
//
#define API_PERSONMES       SERVER_IP@"/app/tool/cgPersonMes"
//
#define API_PAYMES       SERVER_IP@"/app/tool/payMes"
//
#define API_MODPAYMES       SERVER_IP@"/app/tool/modPayMes"
//
#define API_DELPAYMES       SERVER_IP@"/app/tool/delPayMes"
//
#define API_ADDPAYMES       SERVER_IP@"/app/tool/addPayMes"
//
#define API_INVITATION       SERVER_IP@"/app/index/invitation"
//
#define API_FRIENDS       SERVER_IP@"/app/index/friends"
//
#define API_SEND       SERVER_IP@"/app/my/send"
//
#define API_SENDDEAIL       SERVER_IP@"/app/my/sendDetail"
//
#define API_RECEIVEDEAIL       SERVER_IP@"/app/my/receiveDetail"
//
#define API_CHANGEINTEGRAL       SERVER_IP@"/app/my/changeIntegral"
//
#define API_CGDETAIL       SERVER_IP@"/app/my/cgDetail"

#endif /* FlowAPI_h */
