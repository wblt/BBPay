//
//  DDCOrderViewController.m
//  iOSBase
//
//  Created by 冷婷 on 2018/10/22.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "DDCOrderViewController.h"
#import "DDCOrderCell.h"
@interface DDCOrderViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation DDCOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"查看订单";
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 41;
    self.tableView.backgroundColor = mainBackgroudColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"DDCOrderCell" bundle:nil] forCellReuseIdentifier:@"DDCOrderCell"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DDCOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DDCOrderCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
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
