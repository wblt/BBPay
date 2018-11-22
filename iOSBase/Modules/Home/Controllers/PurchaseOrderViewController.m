//
//  PurchaseOrderViewController.m
//  iOSBase
//
//  Created by 冷婷 on 2018/8/31.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "PurchaseOrderViewController.h"
#import "PurchaseOrderCell.h"
#import "PurchaseOrderModel.h"
#import "UploadPic.h"
#import "PurchaseOrderDetailViewController.h"
@interface PurchaseOrderViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    NSMutableArray *orderArr;
    int type;
    NSArray *btnArr;
    NSString *_url;
    UIButton *uploadBtn;
    UIImageView *uploadImg;
}
@property (nonatomic, strong) NSString *lastId;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *brn1;
@property (weak, nonatomic) IBOutlet UIButton *btn2;
@property (weak, nonatomic) IBOutlet UIButton *btn3;

@end

@implementation PurchaseOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    btnArr = @[_brn1,_btn2,_btn3];
    type = 0;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 70;
    self.tableView.backgroundColor = mainBackgroudColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"PurchaseOrderCell" bundle:nil] forCellReuseIdentifier:@"PurchaseOrderCell"];
    orderArr = [NSMutableArray array];
    [self requestData:@"1"];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self requestData:@"1"];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self requestData:@"2"];
    }];
}

- (void)requestData:(NSString *)queryType {
    
    RequestParams *parms = [[RequestParams alloc] initWithParams:([self.title isEqualToString:@"买入订单"] ? API_BUYORDERLIST : API_SELLORDERLIST)];
    [parms addParameter:@"USER_NAME" value:[SPUtil objectForKey:k_app_USER_NAME]];
    [parms addParameter:@"QUERY_ID" value:[queryType isEqualToString:@"1"] ? @"0" : _lastId];
    [parms addParameter:@"TYPE" value:queryType];
    [parms addParameter:@"STATUS" value:[NSString stringWithFormat:@"%d",type]];
    [[NetworkSingleton shareInstace] httpPost:parms withTitle:@"转出记录" successBlock:^(id data) {
        NSMutableArray *arr = [NSMutableArray array];
        for (NSDictionary *dic in data[@"pd"]) {
            PurchaseOrderModel *model = [PurchaseOrderModel mj_objectWithKeyValues:dic];
            [arr addObject:model];
        }
        
        if([queryType isEqualToString:@"1"]){
            orderArr = arr;
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer resetNoMoreData];
        }else{
            [orderArr addObjectsFromArray:arr];
            [self.tableView.mj_footer endRefreshing];
        }
        if (orderArr.count > 0) {
            PurchaseOrderModel *lastModel = orderArr[orderArr.count-1];
            _lastId = lastModel.ID;
        }
        if(arr.count == 0){
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        [self.tableView reloadData];
    } failureBlock:^(NSError *error) {
        
    }];
}

- (IBAction)selectedTypeStatusAction:(UIButton *)sender {
    for (UIButton *btn in btnArr) {
        btn.selected = NO;
    }
    sender.selected = YES;
    if (sender == _brn1) {
        type = 0;
    }else if (sender == _btn2) {
        type = -1;
    }else if (sender == _btn3) {
        type = 3;
    }
    orderArr = [NSMutableArray array];
    [self requestData:@"1"];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return orderArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PurchaseOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PurchaseOrderCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    PurchaseOrderModel *model = orderArr[indexPath.row];
    cell.name.text = model.NICK_NAME;
    cell.score.text = model.BUSINESS_BALANCE;
    cell.time.text = [Util timestampToString:[NSString stringWithFormat:@"%ld",[model.CREATE_TIME integerValue]/1000] formatterString:@"yyyy-MM-dd HH:mm:ss"];
    [cell.img sd_setImageWithURL:[NSURL URLWithString:model.HEAD_URL] placeholderImage:[UIImage imageNamed:@"head"]];
    if ([self.title isEqualToString:@"买入订单"]) {
        if ([model.STATUS isEqualToString:@"0"]) {
            [cell.status setTitle:@"未完成" forState:0];
            [cell.cancleBtn setTitle:@"点取消" forState:0];
            cell.cancleBtn.hidden = NO;
        }else if ([model.STATUS isEqualToString:@"1"]) {
            [cell.status setTitle:@"待付款" forState:0];
            [cell.cancleBtn setTitle:@"去付款" forState:0];
            cell.cancleBtn.hidden = NO;
        }else if ([model.STATUS isEqualToString:@"2"]) {
            [cell.status setTitle:@"已付款" forState:0];
            cell.cancleBtn.hidden = YES;
        }else if ([model.STATUS isEqualToString:@"3"]) {
            [cell.status setTitle:@"已成交" forState:0];
            cell.cancleBtn.hidden = YES;
        }else if ([model.STATUS isEqualToString:@"4"]) {
            [cell.status setTitle:@"已取消" forState:0];
            cell.cancleBtn.hidden = YES;
        }
        [cell.cancleBtn addTapBlock:^(UIButton *btn) {
            if ([model.STATUS isEqualToString:@"0"]) {
                [UIAlertController showAlertViewWithTitle:@"温馨提示" Message:@"您确定要取消订单？" BtnTitles:@[@"取消",@"确定"] ClickBtn:^(NSInteger index) {
                    if (index == 1) {
                        RequestParams *parms = [[RequestParams alloc] initWithParams:API_ORDERCANCLE];
                        [parms addParameter:@"ID" value:model.ID];
                        [[NetworkSingleton shareInstace] httpPost:parms withTitle:@"取消订单" successBlock:^(id data) {
                            [SVProgressHUD showSuccessWithStatus:@"取消成功"];
                            orderArr = [NSMutableArray array];
                            [self requestData:@"1"];
                        } failureBlock:^(NSError *error) {
                            
                        }];
                    }
                }];
            }else if ([model.STATUS isEqualToString:@"1"]) {
                
                UIView *imageNoteView = [[NSBundle mainBundle] loadNibNamed:@"UploadImageNoteView" owner:nil options:nil].lastObject;
                imageNoteView.frame = self.view.bounds;
                uploadImg = [imageNoteView viewWithTag:101];
                uploadImg.userInteractionEnabled = YES;
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toPicSelected)];
                [uploadImg addGestureRecognizer:tap];
                uploadBtn = [imageNoteView viewWithTag:102];
                __weak typeof(self) weakSelf = self;
                [uploadBtn addTapBlock:^(UIButton *btn) {
                    if (!btn.selected) {
                        NSUInteger sourceType = 0;
                        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
                        imagePickerController.delegate = weakSelf; //设置代理
                        sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                        imagePickerController.sourceType = sourceType;
                        [weakSelf presentViewController:imagePickerController animated:YES completion:nil];
                    }else {
                        [imageNoteView removeFromSuperview];
                        RequestParams *parms = [[RequestParams alloc] initWithParams:API_PAY];
                        [parms addParameter:@"ID" value:model.ID];
                        [parms addParameter:@"IMAGE_NOTE" value:_url];
                        [[NetworkSingleton shareInstace] httpPost:parms withTitle:@"去付款" successBlock:^(id data) {
                            [SVProgressHUD showSuccessWithStatus:@"确认付款成功"];
                            orderArr = [NSMutableArray array];
                            [self requestData:@"1"];
                        } failureBlock:^(NSError *error) {
                            
                        }];
                    }
                    UIButton *closeBtn = [imageNoteView viewWithTag:103];
                    [closeBtn addTapBlock:^(UIButton *btn) {
                        [imageNoteView removeFromSuperview];
                    }];
                }];
                [self.view addSubview:imageNoteView];
                
            }
        }];
    }else {
        if ([model.STATUS isEqualToString:@"0"]) {
            [cell.status setTitle:@"未完成" forState:0];
            [cell.cancleBtn setTitle:@"点取消" forState:0];
            cell.cancleBtn.hidden = NO;
        }else if ([model.STATUS isEqualToString:@"1"]) {
            [cell.status setTitle:@"等待买家付款" forState:0];
            
            cell.cancleBtn.hidden = YES;
        }else if ([model.STATUS isEqualToString:@"2"]) {
            [cell.status setTitle:@"已付款" forState:0];
            [cell.cancleBtn setTitle:@"确认收款" forState:0];
            cell.cancleBtn.hidden = NO;
        }else if ([model.STATUS isEqualToString:@"3"]) {
            [cell.status setTitle:@"已成交" forState:0];
            cell.cancleBtn.hidden = YES;
        }else if ([model.STATUS isEqualToString:@"4"]) {
            [cell.status setTitle:@"已取消" forState:0];
            cell.cancleBtn.hidden = YES;
        }
        [cell.cancleBtn addTapBlock:^(UIButton *btn) {
            if ([model.STATUS isEqualToString:@"0"]) {
                [UIAlertController showAlertViewWithTitle:@"温馨提示" Message:@"您确定要取消订单？" BtnTitles:@[@"取消",@"确定"] ClickBtn:^(NSInteger index) {
                    if (index == 1) {
                        RequestParams *parms = [[RequestParams alloc] initWithParams:API_ORDERCANCLE];
                        [parms addParameter:@"ID" value:model.ID];
                        [[NetworkSingleton shareInstace] httpPost:parms withTitle:@"取消订单" successBlock:^(id data) {
                            [SVProgressHUD showSuccessWithStatus:@"取消成功"];
                            orderArr = [NSMutableArray array];
                            [self requestData:@"1"];
                        } failureBlock:^(NSError *error) {
                            
                        }];
                    }
                }];
            }else if ([model.STATUS isEqualToString:@"2"]) {
                YQPayKeyWordVC *yqVC = [[YQPayKeyWordVC alloc] init];
                [yqVC showInViewController:self money:model.BUSINESS_COUNT];
                yqVC.block = ^(NSString *pass) {
                    RequestParams *parms = [[RequestParams alloc] initWithParams:API_SUREPAY];
                    [parms addParameter:@"ID" value:model.ID];
                    [parms addParameter:@"PASSW" value:pass];
                    [[NetworkSingleton shareInstace] httpPost:parms withTitle:@"订单确认收款" successBlock:^(id data) {
                        [SVProgressHUD showSuccessWithStatus:@"确认收款"];
                        orderArr = [NSMutableArray array];
                        [self requestData:@"1"];
                    } failureBlock:^(NSError *error) {
                        
                    }];
                };
                
            }
        }];
    }
    
    return cell;
}

- (void)toPicSelected {
    NSUInteger sourceType = 0;
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self; //设置代理
    sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePickerController.sourceType = sourceType;
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:^{}];
    // 上传照片
    NSString *photoPath = [[UploadPic sharedInstance] photoSavePathForURL:info[UIImagePickerControllerReferenceURL]];
    NSData *imageData = UIImageJPEGRepresentation(info[UIImagePickerControllerOriginalImage],1.0);
    if ((float)imageData.length/1024 > 100) {//需要测试
        imageData = UIImageJPEGRepresentation(info[UIImagePickerControllerOriginalImage], 1024*100.0/(float)imageData.length);
    }
    [imageData writeToFile:photoPath atomically:YES];
    NSString *fileName = [NSString stringWithFormat:@"%f_%d.jpg", [[NSDate date] timeIntervalSince1970], arc4random()%1000];
    [[UploadPic sharedInstance] uploadFileMultipartWithPath:photoPath fileName:fileName callback:^(NSString *url) {
        if (url.length == 0) {
            [SVProgressHUD showErrorWithStatus:@"上传失败"];
        }else {
            uploadImg.image = info[UIImagePickerControllerOriginalImage];
            _url = url;
            uploadBtn.selected = YES;
        }
    }];
    
}

//当用户取消选择的时候，调用该方法
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^{}];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PurchaseOrderModel *model = orderArr[indexPath.row];
    PurchaseOrderDetailViewController *VC = [[PurchaseOrderDetailViewController alloc] init];
    VC.ID = model.ID;
    [self.navigationController pushViewController:VC animated:YES];
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
