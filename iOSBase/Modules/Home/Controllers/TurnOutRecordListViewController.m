//
//  TurnOutRecordListViewController.m
//  iOSBase
//
//  Created by 冷婷 on 2018/8/21.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "TurnOutRecordListViewController.h"
#import "TurnOutRecordListCell.h"
@interface TurnOutRecordListViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation TurnOutRecordListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"转出记录";
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 70;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"TurnOutRecordListCell" bundle:nil] forCellReuseIdentifier:@"TurnOutRecordListCell"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TurnOutRecordListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TurnOutRecordListCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    cell.titleText.text = titleArr[indexPath.section][indexPath.row];
//    cell.img.image = [UIImage imageNamed:imgArr[indexPath.section][indexPath.row]];
//    if (indexPath.section == 0 && indexPath.row == 0) {
//        cell.detailTitle.text = @"大兵哥";
//    }else if (indexPath.section == 4 && indexPath.row == 2) {
//        cell.detailTitle.text = @"1.0";
//    }else {
//        cell.detailTitle.text = @"";
//    }
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
