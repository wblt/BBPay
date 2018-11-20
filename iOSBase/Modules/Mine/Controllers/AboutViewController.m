//
//  AboutViewController.m
//  iOSBase
//
//  Created by 冷婷 on 2018/8/20.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"关于";
    self.textView.text = @"【DDC的核心】：基于区块链分布式智能合约技术，实现货币的去中心化、点对点无损无痕流通，让流通产生价值，让快速流通增加哈希算力，最终加速价值的释放。\n名词释意：\n\n【余额】：法定货币现金，也可以称之为现金币，简称钱。\n\n【积分】：余额每次流通（转出、支付）一次，DDC系统会赠送80%的积分（只限去商家消费才有80%积分返）积分是余额流通产生的价值。\n\n【转出】：余额在两个账户或者多个账户之间的流通\n\n【转入】：收款（生成二维码）\n\n【买入】：在线挂单求购DDC豆\n\n【卖出】：在线挂单出售DDC豆\n\n【DDC资产】：基于区块链技术OPEN  COIN 开源算法开发的数字加密货币。DDC资产总发行量2100万，首发100万，第二期发行300万，第三期发现600万，剩余1100万由DDC钱包用户通过流通增加算力挖取。\n\n【分享】：分享链接或二维码，推广给其他用户使用。通过分享，被分享者在使用DDC的过程能加速分享者的积分释放速度。使用规则：\n\n【转出规则】：通过“转账”或“扫码支付”，转账方转出多少余额就收多少现金，同时获得80%的积分，收款方需支付相应的现金给转账方，收款方获得转账额80%余额和20%的积分。如：A转账给B—>10000余额，那么B支付10000的现金给A，A得到10000现金和8000的积分，B得到8000余额和2000的积分。\n\n【买入规则】：为确保线上交易诚信，创建订单需扣除10%的币作为保证金，交易完成后保证金自动退还。\n\n【卖出规则】：每天只容许挂卖一次，挂单卖出后得到1：1的现金。\n\n【加速释放规则】：用户积分按千分之二的速度释放积分到余额，在用户不断分享其他用户使用DDC钱包的情况下，其他用户的转账流通额度和速度可加速其积分释放速度，用户积分释放的速度将有可能是10%、20%、50%、100%。\n\n【会员级别规则】:下载注册为普通会员，充值1000元为有效会员，推荐10个有效会员且积分达到100万为VIP会员。\n\n【VIP会员】：享受15代余额流通的8%加入到积分账户。";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
