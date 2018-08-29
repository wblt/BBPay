//
//  TurnOutRecordListViewController.m
//  iOSBase
//
//  Created by 冷婷 on 2018/8/21.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "TurnOutRecordListViewController.h"
#import "TurnOutRecordListCell.h"
#import "TurnOutRecordModel.h"
@interface TurnOutRecordListViewController () <UITableViewDataSource, UITableViewDelegate>
{
    NSMutableArray *turnOutArr;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation TurnOutRecordListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 70;
    self.tableView.backgroundColor = mainBackgroudColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"TurnOutRecordListCell" bundle:nil] forCellReuseIdentifier:@"TurnOutRecordListCell"];
    [self requestData];
}

- (void)requestData {
    turnOutArr = [NSMutableArray array];
    RequestParams *parms = [[RequestParams alloc] initWithParams:_url];
    [parms addParameter:@"USER_NAME" value:[SPUtil objectForKey:k_app_USER_NAME]];
    [parms addParameter:@"QUERY_ID" value:@"0"];
    [parms addParameter:@"TYPE" value:@"1"];
    [[NetworkSingleton shareInstace] httpPost:parms withTitle:@"转出记录" successBlock:^(id data) {
        for (NSDictionary *dic in data[@"pd"]) {
            TurnOutRecordModel *model = [TurnOutRecordModel mj_objectWithKeyValues:dic];
            [turnOutArr addObject:model];
        }
        [self.tableView reloadData];
    } failureBlock:^(NSError *error) {
        
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return turnOutArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TurnOutRecordListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TurnOutRecordListCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    TurnOutRecordModel *model = turnOutArr[indexPath.row];
    cell.title.text = model.NICK_NAME;
    cell.detail.text = [NSString stringWithFormat:@"UID:%@",model.USER_ID];
    cell.money.text = model.BALANCE;
    cell.time.text = model.CREATE_TIME;
    [cell.img sd_setImageWithURL:[NSURL URLWithString:model.HEAD_URL] placeholderImage:[UIImage imageNamed:@"head"]];
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
