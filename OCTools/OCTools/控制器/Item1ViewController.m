//
//  Item1ViewController.m
//  OCTools
//
//  Created by 周 on 2018/10/31.
//  Copyright © 2018年 周. All rights reserved.
//

#import "Item1ViewController.h"
#import "CycleViewController.h"
#import "StarRateViewController.h"
#import "ScrollMenuViewController.h"
#import "MenuAndItemsViewController.h"
#import "ImagePickViewController.h"
#import "AlertViewController.h"
#import "BaseWebViewController.h"
#import "AMapViewController.h"
#import "BaiduMapViewController.h"
@interface Item1ViewController ()<UITableViewDelegate,UITableViewDataSource,BaseTableViewDelegate,DatePickerViewDelegate,AddressPickViewDelegate>
@property (nonatomic, strong)BaseTableView *tab;
@property (nonatomic, strong)NSArray *data;
@end

@implementation Item1ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.data = @[@"自下向上弹出框",@"年月日选择器",@"年月选择器",@"地区选择器",@"图片轮播及文字轮播",@"星星评分",@"类似QQ的弹出菜单",@"可滚动菜单选择视图",@"类似QQ的自上而下的本地通知",@"简单的信息提示",@"使用UIActivityIndicatorView实现菊花效果",@"类似美团外卖的左边分类右边字内容的双列表",@"多图选择器",@"自定义Alert弹出视图",@"基础网页控制器",@"高德地图简单使用",@"百度地图简单使用"];
    
    self.tab = [[BaseTableView alloc]initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - HeightForNagivationBarAndStatusBar - TAB_BAR_HEIGHT) style:UITableViewStylePlain];
    self.tab.delegate = self;
    self.tab.dataSource = self;
    self.tab.EventDelegate = self;
    self.tab.isNoData = YES;
    [self.view addSubview:self.tab];
    
    NSLog(@"%@",[self.data objectAtIndex:20]);
}
#pragma mark - EventDelegate
- (void)refresh:(BaseTableView *)tableView {
    NSLog(@"刷新操作");
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tab.mj_header endRefreshing];
    });
}
- (void)reload:(BaseTableView *)tableView {
    NSLog(@"加载操作");
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tab.mj_footer endRefreshing];
    });
}
#pragma mark - UITableViewDelegate UITableViewDataSourece
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.data.count > 0) {
        self.tab.isNoData = NO;
    }else {
        self.tab.isNoData = YES;
        
    }
    return self.data.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.textLabel.text = self.data[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
        {
            UpView *upV = [[UpView alloc]init];
            [upV show];
        }
            break;
        case 1:
        {
            DatePickerView *dateV = [[DatePickerView alloc]init];
            dateV.contentHeight = 300.0f;
            dateV.dateStyle = DateStyleDate;
            dateV.delegate = self;
            [dateV show];
        }
            break;
        case 2:
        {
            DatePickerView *dateV = [[DatePickerView alloc]init];
            dateV.contentHeight = 300.0f;
            dateV.dateStyle = DateStyleYearAndMonth;
            dateV.delegate = self;
            [dateV show];
        }
            break;
        case 3:
        {
            AddressPickView *addressV = [[AddressPickView alloc]init];
            addressV.contentHeight = 300.0f;
            addressV.delegate = self;
            [addressV show];
        }
            break;
        case 4:
        {
            CycleViewController *vc = [[CycleViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 5:
        {
            StarRateViewController *vc = [[StarRateViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 6:
        {
            YCMenuAction *action1 = [YCMenuAction actionWithTitle:@"扫一扫" image:[UIImage imageNamed:@""] handler:^(YCMenuAction *action) {
                NSLog(@"点击了扫一扫");
            }];
            YCMenuAction *action2 = [YCMenuAction actionWithTitle:@"新消息" image:[UIImage imageNamed:@""] handler:^(YCMenuAction *action) {
                NSLog(@"点击了新消息");
            }];
            
            YCMenuView *view = [YCMenuView menuWithActions:@[action1,action2] width:140 atPoint:CGPointMake(UI_SCREEN_WIDTH - 20, HeightForNagivationBarAndStatusBar)];
        // 自定义设置
        //    view.menuColor = [UIColor whiteColor];
        //    view.separatorColor = [UIColor whiteColor];
        //    view.maxDisplayCount = 5;
        //    view.offset = 0;
        //    view.textColor = [UIColor whiteColor];
        //    view.textFont = [UIFont boldSystemFontOfSize:18];
        //    view.menuCellHeight = 60;
        //    view.dismissOnselected = YES;
        //    view.dismissOnTouchOutside = YES;
            [view show];
        }
            break;
        case 7:
        {
            ScrollMenuViewController *vc = [[ScrollMenuViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 8:
        {
            RemindView *rv = [RemindView shareRemindView];
            [rv setMessageType:MessageTypeSuccess andMessage:@"测试一下"];
            [rv show];
        }
            break;
        case 9:
        {
            [PromptView showPromptWithMessage:@"测试一下"];
        }
            break;
        case 10:
        {
            [LoadingView show];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [LoadingView dismiss];
            });
        }
        case 11:
        {
            MenuAndItemsViewController *vc = [[MenuAndItemsViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 12:
        {
            ImagePickViewController *vc = [[ImagePickViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 13:
        {
            AlertViewController *vc = [[AlertViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 14:
        {
            BaseWebViewController *vc = [[BaseWebViewController alloc]init];
            vc.url = @"http://www.baidu.com";
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 15:
        {
            AMapViewController *vc = [[AMapViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 16:
        {
            BaiduMapViewController *vc = [[BaiduMapViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        default:
            break;
    }
}
#pragma mark - DatePickerViewDelegate
- (void)didClickSureWithYear:(NSInteger)year AndMonth:(NSInteger)month AndDay:(NSInteger)day {
    NSLog(@"%ld,%ld,%ld",(long)year,month,day);
}
#pragma mark - AddressPickViewDelegate
- (void)didClickSureWithProvince:(NSString *)province City:(NSString *)city Area:(NSString *)area {
    NSLog(@"%@,%@,%@",province,city,area);
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
