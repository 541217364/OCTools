//
//  Item2ViewController.m
//  OCTools
//
//  Created by 周 on 2018/10/31.
//  Copyright © 2018年 周. All rights reserved.
//

#import "Item2ViewController.h"
#import "AppDelegate.h"
#import "AuthorizationViewController.h"
#import "ChildControlViewController.h"
#import "CalendarViewController.h"
#import "SearchViewController.h"
#import "ScanViewController.h"
#import "BaseScanCodeViewController.h"
#import "FoldViewController.h"
@interface Item2ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)BaseTableView *tab;
@property (nonatomic, strong)NSMutableArray *data;
@end

@implementation Item2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //接收网络变化的通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(checkNetworkStatus) name:kReachabilityChangedNotification object:nil];
    
    self.data = [NSMutableArray arrayWithArray:@[@"网络请求",@"网络状态",@"权限管理",@"继承系统控件的子类控件",@"日历",@"搜索",@"扫一扫",@"折叠cell"]];
    self.tab = [[BaseTableView alloc]initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - HeightForNagivationBarAndStatusBar - HOME_INDICATOR_HEIGHT) style:UITableViewStylePlain];
    self.tab.delegate = self;
    self.tab.dataSource = self;
    [self.view addSubview:self.tab];
    [self checkNetworkStatus];
    

}
#pragma mark - 网络变化通知方法
- (void)checkNetworkStatus {
    AppDelegate *del = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NetworkStatus status = [del.coon currentReachabilityStatus];
    switch (status) {
        case NotReachable:
            {
                [self.data replaceObjectAtIndex:1 withObject:@"网络状态（网络不可用）"];
                [self.tab reloadData];
            }
            break;
        case ReachableViaWiFi:
        {
            [self.data replaceObjectAtIndex:1 withObject:@"网络状态（wifi可用）"];
            [self.tab reloadData];
        }
            break;
        case ReachableViaWWAN:{
            [self.data replaceObjectAtIndex:1 withObject:@"网络状态（手机网络可用）"];
            [self.tab reloadData];
        }
            break;
        default:
            break;
    }
}

#pragma makr - UITableVIewDelegate UITableViewDataSource
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
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
            {
                [LoadingView show];
                [[RequestManager shareManager]postRequest:@"http://app.nbrainbow.xin/api/app/order-management/order-address-data" parameters:@{} success:^(id  _Nonnull responseObject) {
                    NSLog(@"%@",responseObject);
                    [LoadingView dismiss];
                } failure:^(NSError * _Nonnull error) {
                    [PromptView showPromptWithMessage:@"网络异常"];
                    [LoadingView dismiss];
                }];
            }
            break;
        case 2:
        {
            AuthorizationViewController *vc = [[AuthorizationViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 3:
        {
            ChildControlViewController *vc = [[ChildControlViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 4:
        {
            CalendarViewController *vc = [[CalendarViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 5:
        {
            SearchViewController *vc = [[SearchViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 6:
        {
            BaseScanCodeViewController *vc = [[BaseScanCodeViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 7:
        {
            FoldViewController *vc = [[FoldViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
        default:
            break;
    }
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
