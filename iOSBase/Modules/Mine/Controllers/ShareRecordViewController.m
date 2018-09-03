//
//  ShareRecordViewController.m
//  iOSBase
//
//  Created by 冷婷 on 2018/8/29.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "ShareRecordViewController.h"
#import "TurnOutRecordListCell.h"
#import "ShareRecordModel.h"
@interface ShareRecordViewController () <UITableViewDataSource, UITableViewDelegate> {
    NSMutableArray *shareArr;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation ShareRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"分享记录";
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 70;
    self.tableView.backgroundColor = mainBackgroudColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"TurnOutRecordListCell" bundle:nil] forCellReuseIdentifier:@"TurnOutRecordListCell"];
    [self requestData];
}

- (void)requestData {
    shareArr = [NSMutableArray array];
    RequestParams *parms = [[RequestParams alloc] initWithParams:API_FRIENDS];
    [parms addParameter:@"USER_NAME" value:[SPUtil objectForKey:k_app_USER_NAME]];
    [[NetworkSingleton shareInstace] httpPost:parms withTitle:@"分享记录" successBlock:^(id data) {
        for (NSDictionary *dic in data[@"pd"]) {
            ShareRecordModel *model = [ShareRecordModel mj_objectWithKeyValues:dic];
            [shareArr addObject:model];
        }
        [self.tableView reloadData];
    } failureBlock:^(NSError *error) {
        
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return shareArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TurnOutRecordListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TurnOutRecordListCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    ShareRecordModel *model = shareArr[indexPath.row];
    cell.title.text = model.NICK_NAME;
    cell.detail.text = model.TEL;
    cell.money.text = @"";
    cell.time.text = [Util timestampToString:[NSString stringWithFormat:@"%ld",[model.CREATE_TIME integerValue]/1000] formatterString:@"yyyy-MM-dd HH:mm:ss"];
    [cell.img sd_setImageWithURL:[NSURL URLWithString:model.HEAD_URL] placeholderImage:[UIImage imageNamed:@"head"]];
    if ([model.SPECIAL isEqualToString:@"1"]) {
        cell.img.layer.borderColor = [UIColor yellowColor].CGColor;
        cell.img.layer.borderWidth = 2;
    }else {
        cell.img.layer.borderColor = [UIColor clearColor].CGColor;
        cell.img.layer.borderWidth = 0;
    }
    return cell;
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
