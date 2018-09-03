//
//  NoticeViewController.m
//  iOSBase
//
//  Created by 冷婷 on 2018/8/28.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "NoticeViewController.h"
#import "NoticeCell.h"
#import "NoticeModel.h"
@interface NoticeViewController () <UITableViewDataSource, UITableViewDelegate>
{
    NSMutableArray *noticeArr;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation NoticeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"公告";
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 85;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.backgroundColor = mainBackgroudColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"NoticeCell" bundle:nil] forCellReuseIdentifier:@"NoticeCell"];
    [self requestData];
}

- (void)requestData {
    noticeArr = [NSMutableArray array];
    RequestParams *parms = [[RequestParams alloc] initWithParams:API_NOTICE];
    [[NetworkSingleton shareInstace] httpPost:parms withTitle:@"公告" successBlock:^(id data) {
        for (NSDictionary *dic in data[@"pd"]) {
            NoticeModel *model = [NoticeModel mj_objectWithKeyValues:dic];
            [noticeArr addObject:model];
        }

        [self.tableView reloadData];
    } failureBlock:^(NSError *error) {
        
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return noticeArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NoticeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NoticeCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NoticeModel *model = noticeArr[indexPath.row];
    cell.title.text = model.TITLE;
    cell.detailTitle.text = model.CONTENT;
    cell.time.text = model.CREATE_TIME;
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
