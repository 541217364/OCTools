//
//  FoldViewController.m
//  OCTools
//
//  Created by 周 on 2018/11/21.
//  Copyright © 2018年 周. All rights reserved.
//

#import "FoldViewController.h"

@interface FoldViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableV;
@end

@implementation FoldViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.tableV];
}
- (UITableView *)tableV {
    if (!_tableV) {
        _tableV = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - HeightForNagivationBarAndStatusBar - HOME_INDICATOR_HEIGHT) style:UITableViewStylePlain];
        _tableV.delegate = self;
        _tableV.dataSource = self;
        _tableV.backgroundColor = [UIColor whiteColor];
        //设置可折叠
        _tableV.ww_foldable = YES;
    }
    return _tableV;
}
#pragma mark - UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UITableViewHeaderFooterView *header = nil;
    
    header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"header"];
    if(!header){
        header = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:@"header"];
        UITapGestureRecognizer *tapgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gestureTapped:)];
        [header addGestureRecognizer:tapgr];
    }
    
    if(header){
        header.textLabel.text = [NSString stringWithFormat:@"第%@组", @(section+1)];
        header.tag = section;
    }
    
    return header;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
    return cell;
}
#pragma mark - gesture
- (void)gestureTapped:(UIGestureRecognizer *)gesture
{
    UIView *header = gesture.view;
    NSInteger section = header.tag;
    [self.tableV ww_foldSection:section fold:![self.tableV ww_isSectionFolded:section]];
    
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
