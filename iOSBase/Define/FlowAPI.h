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
#define mainColor UIColorFromHex(0x000000)
//底色
#define mainBackgroudColor UIColorFromHex(0xF4F4F4)
//控件底色
#define mainItemsBackgroudColor UIColorFromHex(0xffffff)
//蓝色
#define mainBlueColor UIColorFromHex(0x3BA7EC)
//红色
#define mainRedColor UIColorFromHex(0xF01B1D)
//灰色字体
//#define mainGrayColor UIColorFromHex(0x848484)

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
//#define SERVER_IP         @"http://ddcapp.top"
//#define SERVER_IP         @"http://211.149.191.75:8080"
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
#define API_USER       SERVER_IP@"/app/index/user"
//
#define API_SENDDEAIL       SERVER_IP@"/app/my/sendDetail"
//
#define API_RECEIVEDEAIL       SERVER_IP@"/app/my/receiveDetail"
//
#define API_CHANGEINTEGRAL       SERVER_IP@"/app/my/changeIntegral"
#define API_changeDDCD       SERVER_IP@"/app/my/changeDDCD"
//
#define API_CGDETAIL       SERVER_IP@"/app/my/cgDetail"

#define API_cgDDCDDetail       SERVER_IP@"/app/my/cgDDCDDetail"
//
#define API_BUY       SERVER_IP@"/app/market/buy"
//
#define API_BUYORDERLIST       SERVER_IP@"/app/market/buyOrderList"
//
#define API_ORDERCANCLE       SERVER_IP@"/app/market/orderCancle"
//
#define API_PAY       SERVER_IP@"/app/market/pay"
//
#define API_BUYLIST       SERVER_IP@"/app/market/buyList"
//
#define API_TOMARKET       SERVER_IP@"/app/market/toMarket"
//
#define API_BUYLOGS       SERVER_IP@"/app/market/buyLogs"
//
#define API_SELL       SERVER_IP@"/app/market/sell"
//
#define API_SELLORDERLIST       SERVER_IP@"/app/market/sellOrderList"
#define API_SELLLIST       SERVER_IP@"/app/market/sellList"
#define API_SELLLOGS       SERVER_IP@"/app/market/sellLogs"
#define API_SUREPAY       SERVER_IP@"/app/market/surePay"
#define API_ORDERDETAIL       SERVER_IP@"/app/market/orderDetail"
//领取奖励
#define API_REWARD       SERVER_IP@"/app/index/reward"
//积分记录
#define API_INTEGREALLOG       SERVER_IP@"/app/index/integralLog"
//积分记录
#define API_BALANCELOG       SERVER_IP@"/app/index/balanceLog"

//指导价 点击挂单时候获取
#define API_MARKET_PRICE      SERVER_IP@"/app/market/price"
//DDC币买入记录
#define API_DDC_BUYLOGS      SERVER_IP@"/app/market/ddc_buyLogs"
//DDC币卖出记录
#define API_DDC_SELLLOGS      SERVER_IP@"/app/market/ddc_sellLogs"

//DDC币买单列表
#define API_DDC_BUYLIST      SERVER_IP@"/app/market/ddc_buyList"
//DDC卖单列表
#define API_DDC_SELLLIST      SERVER_IP@"/app/market/ddc_sellList"
//DDC币从卖单里面下买单/从买单里面下卖单
#define API_DDC_TOMARKET      SERVER_IP@"/app/market/ddc_toMarket"
#define API_DDC_SELL      SERVER_IP@"/app/market/ddc_sell"
#define API_ddc_buyOrderList      SERVER_IP@"/app/market/ddc_buyOrderList"
#define API_ddc_sellOrderList      SERVER_IP@"/app/market/ddc_sellOrderList"
#define API_ddc_orderCancle      SERVER_IP@"/app/market/ddc_orderCancle"
#define API_sendDDCB      SERVER_IP@"/app/my/sendDDCB"
#define API_sendDDCBDetail      SERVER_IP@"/app/my/sendDDCBDetail"
#define API_receiveDDCBDetail      SERVER_IP@"/app/my/receiveDDCBDetail"




#endif /* FlowAPI_h */
