//
//  MineViewController.m
//  iOSBase
//
//  Created by 冷婷 on 2018/8/11.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "MineViewController.h"
#import "MineCell.h"
#import "MineHeadView.h"
#import "LoginViewController.h"
#import "EditNicknameViewController.h"
#import "MyBankViewController.h"
#import "IndividualPropertyViewController.h"
#import "EditLoginPwdViewController.h"
#import "ForgetPwdController.h"
#import "SuggestionViewController.h"
#import "ShareCodeViewController.h"
#import "AboutViewController.h"
@interface MineViewController () <UITableViewDataSource, UITableViewDelegate> {
    NSArray *titleArr;
    NSArray *imgArr;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    titleArr = @[@[@"昵称",@"我的银行卡",@"我的资产"],@[@"登录密码",@"支付密码"],@[@"公告",@"个人信息"],@[@"我的店铺",@"订单",@"管理地址"],@[@"投诉建议",@"分享",@"版本",@"关于"]];
    imgArr = @[@[@"nick_icon",@"mybank_icon",@"shuzichan_icon"],@[@"login_pwd_icon",@"pay_pwd"],@[@"gonggao_icon",@"msg_icon"],@[@"dianpu_icon",@"dingdan_icon",@"adrress_icon"],@[@"jianyi_icon",@"fengxiang_icon",@"banben_icon",@"about_icon"]];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 50;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"MineCell" bundle:nil] forCellReuseIdentifier:@"MineCell"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return titleArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *arr = titleArr[section];
    return arr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MineCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MineCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.titleText.text = titleArr[indexPath.section][indexPath.row];
    cell.img.image = [UIImage imageNamed:imgArr[indexPath.section][indexPath.row]];
    if (indexPath.section == 0 && indexPath.row == 0) {
        cell.detailTitle.text = @"大兵哥";
    }else if (indexPath.section == 4 && indexPath.row == 2) {
        cell.detailTitle.text = @"1.0";
    }else {
        cell.detailTitle.text = @"";
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 191;
    }
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == titleArr.count - 1) {
        return 70;
    }
    return 0.01;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        MineHeadView *headV = [[NSBundle mainBundle] loadNibNamed:@"MineHeadView" owner:nil options:nil].lastObject;
        [headV.backBtn addTapBlock:^(UIButton *btn) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
        return headV;
    }
    return nil;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == titleArr.count - 1) {
        UIView *footV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 70)];
        footV.backgroundColor = [UIColor clearColor];
        UIButton *tuichuBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 10, KScreenWidth, 50)];
        tuichuBtn.backgroundColor = mainItemsBackgroudColor;
        [tuichuBtn setTitle:@"退出登录" forState:UIControlStateNormal];
        [tuichuBtn setTitleColor:mainColor forState:UIControlStateNormal];
        [tuichuBtn addTapBlock:^(UIButton *btn) {
            [SPUtil setBool:NO forKey:k_app_login];
            LoginViewController *loginVC = [[LoginViewController alloc] init];
            BaseNavViewController *loginNav = [[BaseNavViewController alloc] initWithRootViewController:loginVC];
            AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            appDelegate.window.rootViewController = loginNav;
        }];
        [footV addSubview:tuichuBtn];
        return footV;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.navigationController.navigationBarHidden = NO;
    if (indexPath.section == 0 && indexPath.row == 0) {
        EditNicknameViewController *editVC = [[EditNicknameViewController alloc] init];
        [self.navigationController pushViewController:editVC animated:YES];
    }else if (indexPath.section == 0 && indexPath.row == 1) {
        MyBankViewController *myBankVC = [[MyBankViewController alloc] init];
        [self.navigationController pushViewController:myBankVC animated:YES];
    }else if (indexPath.section == 0 && indexPath.row == 2) {
        IndividualPropertyViewController *individualVC = [[IndividualPropertyViewController alloc] init];
        [self.navigationController pushViewController:individualVC animated:YES];
    }else if (indexPath.section == 1 && indexPath.row == 0) {
        EditLoginPwdViewController *editPwdVC = [[EditLoginPwdViewController alloc] init];
        editPwdVC.isPayPwd = NO;
        [self.navigationController pushViewController:editPwdVC animated:YES];
    }else if (indexPath.section == 1 && indexPath.row == 1) {
        EditLoginPwdViewController *editPwdVC = [[EditLoginPwdViewController alloc] init];
        editPwdVC.isPayPwd = YES;
        [self.navigationController pushViewController:editPwdVC animated:YES];
    }else if (indexPath.section == 4 && indexPath.row == 0) {
        SuggestionViewController *suggestionVC = [[SuggestionViewController alloc] init];
        [self.navigationController pushViewController:suggestionVC animated:YES];
    }else if (indexPath.section == 4 && indexPath.row == 1) {
        ShareCodeViewController *vc = [[ShareCodeViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.section == 4 && indexPath.row == 2) {
        self.navigationController.navigationBarHidden = YES;
    }else if (indexPath.section == 4 && indexPath.row == 3) {
        AboutViewController *vc = [[AboutViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else {
        self.navigationController.navigationBarHidden = YES;
        [SVProgressHUD showInfoWithStatus:@"开发中"];
    }
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
