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
#import "NoticeViewController.h"
#import "UploadPic.h"
@interface MineViewController () <UITableViewDataSource, UITableViewDelegate,StarRatingViewDelegate> {
    NSArray *titleArr;
    NSArray *imgArr;
    MineHeadView *headV;
    NSString *headNewUrl;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
    titleArr = @[@[@"昵称",@"我的银行卡",@"我的资产"],@[@"登录密码",@"支付密码"],@[@"公告"],@[@"我的店铺",@"订单",@"管理地址"],@[@"分享",@"版本",@"关于"]];
    imgArr = @[@[@"nick_icon",@"mybank_icon",@"shuzichan_icon"],@[@"login_pwd_icon",@"pay_pwd"],@[@"gonggao_icon"],@[@"dianpu_icon",@"dingdan_icon",@"adrress_icon"],@[@"fengxiang_icon",@"banben_icon",@"about_icon"]];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 50;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"MineCell" bundle:nil] forCellReuseIdentifier:@"MineCell"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
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
        cell.detailTitle.text = [SPUtil objectForKey:k_app_NICK_NAME];
    }else if (indexPath.section == 4 && indexPath.row == 1) {
        cell.detailTitle.text = @"1.0.0";
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
        headV = [[NSBundle mainBundle] loadNibNamed:@"MineHeadView" owner:nil options:nil].lastObject;
        [headV.headImg sd_setImageWithURL:[NSURL URLWithString:[SPUtil objectForKey:k_app_HEAD_URL]] placeholderImage:[UIImage imageNamed:@"head"]];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toChangeHeadImgAction)];
        [headV.headImg addGestureRecognizer:tap];
        if ([[SPUtil objectForKey:k_app_sj] isEqualToString:@"1"]) {
            NSString *text = [NSString stringWithFormat:@"UID:S%@",[SPUtil objectForKey:k_app_USER_ID]];
            NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc]initWithString:text];
            [attributeStr addAttribute:NSForegroundColorAttributeName value:UIColorFromHex(0x52d869) range:NSMakeRange(4, 1)];
            headV.userName.attributedText = attributeStr;
        } else {
            NSString *text = [NSString stringWithFormat:@"UID:%@",[SPUtil objectForKey:k_app_USER_ID]];
            headV.userName.text = text;
        }
        [headV.nibStarRatingView setScore:[[SPUtil objectForKey:k_app_CREDIT] floatValue]/kNUMBER_OF_STAR withAnimation:YES];
        return headV;
    }
    return nil;
}

- (void)toChangeHeadImgAction {
    [UIAlertController showActionSheetWithTitle:@"更换头像" Message:nil cancelBtnTitle:@"取消" OtherBtnTitles:@[@"拍照",@"相册"] ClickBtn:^(NSInteger index) {
        NSUInteger sourceType = 0;
        // 判断系统是否支持相机
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            imagePickerController.delegate = self; //设置代理
            imagePickerController.allowsEditing = YES;
            imagePickerController.sourceType = sourceType; //图片来源
            if (index == 1) {
                //拍照
                sourceType = UIImagePickerControllerSourceTypeCamera;
                imagePickerController.sourceType = sourceType;
                [self presentViewController:imagePickerController animated:YES completion:nil];
            }else if (index == 2){
                //相册
                sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                imagePickerController.sourceType = sourceType;
                [self presentViewController:imagePickerController animated:YES completion:nil];
            }
        }else {
            sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            imagePickerController.sourceType = sourceType;
            [self presentViewController:imagePickerController animated:YES completion:nil];
        }

    }];
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
            [SPUtil clear];
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
        ShareCodeViewController *vc = [[ShareCodeViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.section == 4 && indexPath.row == 1) {
        
    }else if (indexPath.section == 4 && indexPath.row == 2) {
        AboutViewController *vc = [[AboutViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.section == 2 && indexPath.row == 0) {
        NoticeViewController *vc = [[NoticeViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else {
        [SVProgressHUD showInfoWithStatus:@"商城暂未开放，即将呈现敬请期待！"];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:^{}];
    // 上传照片
    NSString *photoPath = [[UploadPic sharedInstance] photoSavePathForURL:info[UIImagePickerControllerReferenceURL]];
    NSData *imageData = UIImageJPEGRepresentation(info[UIImagePickerControllerEditedImage],1.0);
    if ((float)imageData.length/1024 > 100) {//需要测试
        imageData = UIImageJPEGRepresentation(info[UIImagePickerControllerEditedImage], 1024*100.0/(float)imageData.length);
    }
    [imageData writeToFile:photoPath atomically:YES];
    NSString *fileName = [NSString stringWithFormat:@"%f_%d.jpg", [[NSDate date] timeIntervalSince1970], arc4random()%1000];
    [[UploadPic sharedInstance] uploadFileMultipartWithPath:photoPath fileName:fileName callback:^(NSString *url) {
        if (url.length == 0) {
            [SVProgressHUD showErrorWithStatus:@"上传失败"];
        }else {
            self->headV.headImg.image = info[UIImagePickerControllerEditedImage];
            self->headNewUrl = url;
            [self editHeadImg];
        }
    }];

}

- (void)editHeadImg {
    RequestParams *parms = [[RequestParams alloc] initWithParams:API_PERSONMES];
    [parms addParameter:@"USER_NAME" value:[SPUtil objectForKey:k_app_USER_NAME]];
    [parms addParameter:@"HEAD_URL" value:headNewUrl];
    [parms addParameter:@"NICK_NAME" value:[SPUtil objectForKey:k_app_NICK_NAME]];
    [[NetworkSingleton shareInstace] httpPost:parms withTitle:@"修改头像" successBlock:^(id data) {
        [SVProgressHUD showSuccessWithStatus:@"修改成功"];
        
        [SPUtil setObject:self->headNewUrl forKey:k_app_HEAD_URL];
        
    } failureBlock:^(NSError *error) {
        
    }];
}

//当用户取消选择的时候，调用该方法
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^{}];
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
