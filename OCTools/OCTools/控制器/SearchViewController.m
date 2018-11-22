//
//  SearchViewController.m
//  OCTools
//
//  Created by 周 on 2018/11/19.
//  Copyright © 2018年 周. All rights reserved.
//

#import "SearchViewController.h"
#import "BaseSearchViewController.h"
#import "BaseNavigationController.h"
@interface SearchViewController ()<UITextFieldDelegate>

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UITextField *textF = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH - 120, 30)];
    textF.delegate = self;
    textF.backgroundColor = [UIColor whiteColor];
    textF.layer.cornerRadius = 15;
    textF.layer.masksToBounds = YES;
    textF.placeholder = @"点击搜索";
    self.navigationItem.titleView = textF;
}
    
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [textField resignFirstResponder];
     BaseSearchViewController *vc = [[BaseSearchViewController alloc]init];
     BaseNavigationController *na = [[BaseNavigationController alloc]initWithRootViewController:vc];
    [self presentViewController:na animated:NO completion:nil];
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
