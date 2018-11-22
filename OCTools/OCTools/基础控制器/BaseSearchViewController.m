//
//  BaseSearchViewController.m
//  OCTools
//
//  Created by 周 on 2018/11/19.
//  Copyright © 2018年 周. All rights reserved.
//

#import "BaseSearchViewController.h"

@interface BaseSearchViewController ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource>
/**结果列表*/
@property (nonatomic, strong)UITableView *resultTableView;
/**结果数据*/
@property (nonatomic, strong)NSMutableArray *resultData;
@end

@implementation BaseSearchViewController
- (void)viewWillAppear:(BOOL)animated {
    //界面出现时弹出键盘
    [self.searchBar becomeFirstResponder];
}
- (void)viewWillDisappear:(BOOL)animated {
    //界面消失时隐藏键盘
    [self.searchBar resignFirstResponder];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    self.searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, STATUS_BAR_HEIGHT, UI_SCREEN_WIDTH, HeightForNagivationBarAndStatusBar - STATUS_BAR_HEIGHT)];
    self.searchBar.delegate = self;
    //设置searchBar背景颜色
    self.searchBar.barTintColor = App_Main_Color;
    //隐藏searchBar的上下两条线
    UIImageView *imageV = [[[[self.searchBar subviews] firstObject]subviews]firstObject];
    imageV.layer.borderColor = App_Main_Color.CGColor;
    imageV.layer.borderWidth = 1;
    //显示取消按钮
    self.searchBar.showsCancelButton = YES;
    //设置占位字
    self.searchBar.placeholder = @"搜索";
    //设置取消按钮样式
    UIButton *cancelButton = [self.searchBar valueForKey:@"_cancelButton"];
    [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    //将searchBar放到导航栏上
    self.navigationItem.titleView = self.searchBar;
    //将列表放到界面上
    [self.view addSubview:self.resultTableView];
}
#pragma mark - 结果列表
- (UITableView *)resultTableView {
    if (!_resultTableView) {
        _resultTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - HeightForNagivationBarAndStatusBar - HOME_INDICATOR_HEIGHT) style:UITableViewStylePlain];
        _resultTableView.delegate = self;
        _resultTableView.dataSource = self;
        _resultTableView.backgroundColor = [UIColor whiteColor];
        _resultTableView.hidden = YES;
    }
    return _resultTableView;
}
#pragma mark - 结果数据
- (NSMutableArray *)resultData {
    if (!_resultData) {
        _resultData = [NSMutableArray array];
    }
    return _resultData;
}
#pragma mark - UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   return self.resultData.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.textLabel.text = self.resultData[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}
#pragma mark - UISearchBarDelegate
//结束输入
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
}
//开始输入
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
}
//搜索文字发生改变
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [self startSearchWithKeywords:searchText];
}
//搜索按钮被点击
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self startSearchWithKeywords:searchBar.text];
}
//取消按钮被点击
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self dismissViewControllerAnimated:NO completion:nil];
}
//开始搜索操作
- (void)startSearchWithKeywords:(NSString *)keywords {
    [self.resultData removeAllObjects];
    if (!keywords || keywords.length == 0) {
        self.resultTableView.hidden = YES;
    }else {
        [self.resultData addObject:keywords];
        self.resultTableView.hidden = NO;
    }
    [self.resultTableView reloadData];
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
