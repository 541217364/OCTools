//
//  AppDelegate.m
//  OCTools
//
//  Created by 周 on 2018/10/29.
//  Copyright © 2018年 周. All rights reserved.
//

#import "AppDelegate.h"
#import "BaseNavigationController.h"
#import "Item1ViewController.h"
#import "Item2ViewController.h"
#import "GuidePageViewController.h"
#import "AdViewController.h"
#import "AvoidCrash.h"
@interface AppDelegate ()<BMKGeneralDelegate,UIAlertViewDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    //设置引导页
    /*
    GuidePageViewController *vc = [[GuidePageViewController alloc]init];
    vc.imageArrary = @[@"Intro_Screen_1",@"Intro_Screen_2",@"Intro_Screen_3",@"Intro_Screen_4"];
    //点击按钮后的方法回调
    vc.didClickStartBtnBlock = ^{
//        Item1ViewController *v1 = [[Item1ViewController alloc]init];
//        BaseNavigationController *n1 = [[BaseNavigationController alloc]initWithRootViewController:v1];
//        Item2ViewController *v2 = [[Item2ViewController alloc]init];
//        BaseNavigationController *n2 = [[BaseNavigationController alloc]initWithRootViewController:v2];
//
//        self.tabBarController = [[BaseTabBarController alloc]init];
//        self.tabBarController.viewControllers = @[n1,n2];
//
//        UITabBar *tabBar = self.tabBarController.tabBar;
//
//        UITabBarItem *item1 = [tabBar.items objectAtIndex:0];
//        item1.title = @"item1";
//
//        UITabBarItem *item2 = [tabBar.items objectAtIndex:1];
//        item2.title = @"item2";
//
//        self.window.rootViewController = self.tabBarController;
    };
    self.window.rootViewController = vc;
   */
    
    //防止崩溃功能
    [AvoidCrash makeAllEffective];
    
    //监听通知:AvoidCrashNotification, 获取AvoidCrash捕获的崩溃日志的详细信息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dealwithCrashMessage:) name:AvoidCrashNotification object:nil];
    
    //设置广告启动图
    AdViewController *vc = [[AdViewController alloc]init];
    vc.url = @"http://img.zcool.cn/community/01316b5854df84a8012060c8033d89.gif";
    vc.skipDidClickBlock = ^{
        Item1ViewController *v1 = [[Item1ViewController alloc]init];
        BaseNavigationController *n1 = [[BaseNavigationController alloc]initWithRootViewController:v1];
        Item2ViewController *v2 = [[Item2ViewController alloc]init];
        BaseNavigationController *n2 = [[BaseNavigationController alloc]initWithRootViewController:v2];
        
        self.tabBarController = [[BaseTabBarController alloc]init];
        self.tabBarController.viewControllers = @[n1,n2];
        
        UITabBar *tabBar = self.tabBarController.tabBar;
        
        UITabBarItem *item1 = [tabBar.items objectAtIndex:0];
        item1.title = @"item1";
        
        UITabBarItem *item2 = [tabBar.items objectAtIndex:1];
        item2.title = @"item2";
        
        self.window.rootViewController = self.tabBarController;
    };
    vc.adDidClickBlock = ^{
        NSLog(@"点击了广告页面");
    };
    self.window.rootViewController = vc;
    

    //添加网络变化的监听
    self.coon = [Reachability reachabilityForInternetConnection];
    [self.coon startNotifier];
    /**配置高德地图*/
    //配置HTTPS可用
    [AMapServices sharedServices].enableHTTPS = YES;
    //配置高德地图key
    [AMapServices sharedServices].apiKey = @"095c30bf13a270682b60572d310048a8";
    /**配置百度地图 需引入头文件（<BaiduMapAPI_Map/BMKMapComponent.h>）*/
    BMKMapManager *manager = [[BMKMapManager alloc]init];
    BOOL ret = [manager start:@"QyyYNtdIRObLlCduZjBY7N2RkOOCcqPC" generalDelegate:self];
    if (!ret) {
        NSLog(@"百度地图开启失败");
    }
    
    return YES;
}

#pragma mark 异常捕捉

- (void)dealwithCrashMessage:(NSNotification *)note {
    //不论在哪个线程中导致的crash，这里都是在主线程
    
    //注意:所有的信息都在userInfo中
    //你可以在这里收集相应的崩溃信息进行相应的处理(比如传到自己服务器)
    //详细讲解请查看 https://github.com/chenfanfang/AvoidCrash
    
    UIAlertView *alter = [[UIAlertView alloc]initWithTitle:@"提示" message:@"程序出现异常，给你带来的不便，尽请谅解，我们将尽快修复。" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
    
    [alter show];
    
    //异常拦截并且通过bugly上报
    //    NSDictionary *info = note.userInfo;
    //    NSString *errorReason = [NSString stringWithFormat:@"【ErrorReason】%@========【ErrorPlace】%@========【DefaultToDo】%@========【ErrorName】%@", info[@"errorReason"], info[@"errorPlace"], info[@"defaultToDo"], info[@"errorName"]];
    //    NSArray *callStack = info[@"callStackSymbols"];
    //
    //    [Bugly reportErrorName:Bugly_ErrorName_AvoidCrash errorReason:errorReason callStack:callStack extraInfo:nil];
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    exit(0);
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
