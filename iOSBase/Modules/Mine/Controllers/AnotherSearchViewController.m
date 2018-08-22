//
//  AnotherSearchViewController.m
//
//  Created by Caoyq on 16/3/29.
//  Copyright (c) 2016年 Caoyq. All rights reserved.
//

#import "AnotherSearchViewController.h"
#import "ZYPinYinSearch.h"
#import "HCSortString.h"

@interface AnotherSearchViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
@property (strong, nonatomic) UITableView *friendTableView;
@property (strong, nonatomic) UISearchBar *searchBar;
@property (strong, nonatomic) NSArray *dataSource;/**<排序前的整个数据源*/
@property (strong, nonatomic) NSDictionary *allDataSource;/**<排序后的整个数据源*/
@property (strong, nonatomic) NSMutableArray *searchDataSource;/**<搜索结果数据源*/
@property (strong, nonatomic) NSArray *indexDataSource;/**<索引数据源*/
@property (assign, nonatomic) BOOL isSearch;

@end

@implementation AnotherSearchViewController

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = mainBackgroudColor;
    [self initData];
    [self.view addSubview:self.friendTableView];
    [self.view addSubview:self.searchBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Init
- (void)initData {
    _dataSource = @[@"中国工商银行",
                    @"招商银行",
                    @"中国农业银行",
                    @"中国建设银行",
                    @"中国银行",
                    @"中国民生银行",
                    @"中国光大银行",
                    @"中信银行",
                    @"交通银行",
                    @"兴业银行",
                    @"上海浦东发展银行",
                    @"中国人民银行",
                    @"华夏银行",
                    @"深圳发展银行",
                    @"广东发展银行",
                    @"国家开发银行",
                    @"中国邮政储蓄银行",
                    @"中国进出口银行",
                    @"中国农业发展银行",
                    @"中国银行香港分行",
                    @"北京银行",
                    @"北京农村商业银行",
                    @"天津银行",
                    @"上海银行",
                    @"上海农村商业银行",
                    @"南京银行",
                    @"宁波银行",
                    @"杭州市商业银行",
                    @"深圳平安银行",
                    @"深圳农村商业银行",
                    @"温州银行",
                    @"厦门国际银行",
                    @"济南市商业银行",
                    @"重庆银行",
                    @"哈尔滨银行",
                    @"成都市商业银行",
                    @"于丹",
                    @"包头市商业银行",
                    @"南昌市商业银行",
                    @"贵阳商业银行",
                    @"兰州市商业银行",
                    @"常熟农村商业银行",
                    @"青岛市商业银行",
                    @"花旗中国银行",
                    @"汇丰中国银行",
                    @"渣打中国银行",
                    @"香港汇丰银行",
                    @"恒生银行"];
    _searchDataSource = [NSMutableArray new];
    
    _allDataSource = [HCSortString sortAndGroupForArray:_dataSource PropertyName:@"name"];
    _indexDataSource = [HCSortString sortForStringAry:[_allDataSource allKeys]];
}

- (UITableView *)friendTableView {
    if (!_friendTableView) {
        _friendTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 44, KScreenWidth, KScreenHeight-44) style:UITableViewStylePlain];
        _friendTableView.backgroundColor = mainBackgroudColor;
        _friendTableView.separatorColor = mainBackgroudColor;
        _friendTableView.sectionIndexColor = mainColor;
        _friendTableView.sectionIndexBackgroundColor = [UIColor clearColor];
        _friendTableView.delegate = self;
        _friendTableView.dataSource = self;
    }
    return _friendTableView;
}

- (UISearchBar *)searchBar {
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 44)];
        _searchBar.backgroundImage = [self imageWithColor:[UIColor clearColor] size:_searchBar.bounds.size];
        [_searchBar setBackgroundColor:mainBackgroudColor];
        [_searchBar setTintColor:mainColor];
        _searchBar.delegate = self;
        _searchBar.placeholder = @"搜索";
        UITextField *searchField = [_searchBar valueForKey:@"_searchField"];
        // 输入文本颜色
        searchField.textColor = mainColor;
        searchField.backgroundColor = mainItemsBackgroudColor;
        // 默认文本颜色
        [searchField setValue:mainColor forKeyPath:@"_placeholderLabel.textColor"];
        _searchBar.showsCancelButton = NO;
    }
    return _searchBar;
}

/** 取消searchBar背景色 */
- (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size
{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (!_isSearch) {
        return _indexDataSource.count;
    }else {
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (!_isSearch) {
        NSArray *value = [_allDataSource objectForKey:_indexDataSource[section]];
        return value.count;
    }else {
        return _searchDataSource.count;
    }
}
//头部索引标题
//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//    if (!_isSearch) {
//        return _indexDataSource[section];
//    }else {
//        return nil;
//    }
//}
-(UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section

{
    UILabel *headerLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width,38)];
    if (!_isSearch) {
        headerLabel.text = [NSString stringWithFormat:@"    %@",_indexDataSource[section]];
    }else {
        headerLabel.text = @"";
    }
    [headerLabel setFont:[UIFont boldSystemFontOfSize:18.0]];
    [headerLabel setTextColor:mainColor];
    [headerLabel setBackgroundColor:mainBackgroudColor];
    return headerLabel;
}

//右侧索引列表
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    if (!_isSearch) {
        return _indexDataSource;
    }else {
        return nil;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.backgroundColor = mainItemsBackgroudColor;
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.textLabel.textColor = mainColor;
        cell.textLabel.font = [UIFont systemFontOfSize:14];
    }
    if (!_isSearch) {
        NSArray *value = [_allDataSource objectForKey:_indexDataSource[indexPath.section]];
        cell.textLabel.text = value[indexPath.row];
    }else{
        cell.textLabel.text = _searchDataSource[indexPath.row];
    }
    return cell;
}
//索引点击事件
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    return index;
}

#pragma mark - Table View Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!_isSearch) {
        NSArray *value = [_allDataSource objectForKey:_indexDataSource[indexPath.section]];
        self.block(value[indexPath.row]);
    }else{
        self.block(_searchDataSource[indexPath.row]);
    }
    [self searchBarCancelButtonClicked:self.searchBar];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UISearchBarDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [_searchDataSource removeAllObjects];
    NSArray *ary = [HCSortString getAllValuesFromDict:_allDataSource];
    
    if (searchText.length == 0) {
        _isSearch = NO;
        [_searchDataSource addObjectsFromArray:ary];
    }else {
        _isSearch = YES;
        ary = [ZYPinYinSearch searchWithOriginalArray:ary andSearchText:searchText andSearchByPropertyName:@"name"];
        [_searchDataSource addObjectsFromArray:ary];
    }
    [self.friendTableView reloadData];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [UIView animateWithDuration:0.3 animations:^{
        self.navigationController.navigationBarHidden = YES;
        _searchBar.frame = CGRectMake(0, 20, KScreenWidth, 44);
        _friendTableView.frame = CGRectMake(0, 64, KScreenWidth, KScreenHeight-64);
        _searchBar.showsCancelButton = YES;
    }];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    _searchBar.frame = CGRectMake(0, 0, KScreenWidth, 44);
    self.navigationController.navigationBarHidden = NO;
    _searchBar.showsCancelButton = NO;
    [_searchBar resignFirstResponder];
    _searchBar.text = @"";
    _isSearch = NO;
    [_friendTableView reloadData];
}

#pragma mark - block
- (void)didSelectedItem:(SelectedItem)block {
    self.block = block;
}

@end
