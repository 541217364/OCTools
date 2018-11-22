//
//  AdViewController.m
//  OCTools
//
//  Created by 周 on 2018/11/16.
//  Copyright © 2018年 周. All rights reserved.
//

#import "AdViewController.h"

@interface AdViewController ()
/**定时器*/
@property (nonatomic, strong)NSTimer *timer;
/**跳过按钮*/
@property (nonatomic, strong)UIButton *skipButton;
/**秒数*/
@property (nonatomic, assign)NSInteger second;
@end

@implementation AdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.second = 5;
   
}
/**设置gif网址*/
- (void)setUrl:(NSString *)url {
    _url = url;
    [self setupView];
    [self addTimer];
}
- (void)setupView {
    //底部图片，当广告图片还没有出来时展示的图片，与launchimage一致
    UIImageView *bottomView = [[UIImageView alloc] init];
    bottomView.image  = [self launchImageWithType:@"Portrait"];
    bottomView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    [self.view addSubview:bottomView];
    
    //广告
    UIImageView *adView = [[UIImageView alloc] init];
    adView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height * 0.8);
    adView.contentMode = UIViewContentModeScaleAspectFill;
    adView.clipsToBounds = YES;
    [self.view addSubview:adView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(adViewClick)];
    adView.userInteractionEnabled = YES;
    [adView addGestureRecognizer:tap];
    //请求gif
//    NSString *url = @"http://img.zcool.cn/community/01316b5854df84a8012060c8033d89.gif";
    
    [[SDWebImageDownloader sharedDownloader]downloadImageWithURL:[NSURL URLWithString:self.url] options:SDWebImageDownloaderUseNSURLCache progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
        adView.image = [UIImage sd_animatedGIFWithData:data];
    }];
    //跳过按钮
    UIButton *skipButton = [[UIButton alloc] init];
    [skipButton setTitle:[NSString stringWithFormat:@"%zd 跳过", self.second] forState:UIControlStateNormal];
    [skipButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    skipButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [skipButton addTarget:self action:@selector(skipButtonClick) forControlEvents:UIControlEventTouchUpInside];
    skipButton.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    skipButton.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 15 - 70, 20, 70, 35);
    skipButton.layer.cornerRadius = 35 / 2;
    [self.view addSubview:skipButton];
    self.skipButton = skipButton;
}
//返回当前launchimage
- (UIImage *)launchImageWithType:(NSString *)type {
    CGSize viewSize = [UIScreen mainScreen].bounds.size;
    NSString *viewOrientation = type;
    NSString *launchImageName = nil;
    NSArray* imagesDict = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"UILaunchImages"];
    for (NSDictionary* dict in imagesDict) {
        CGSize imageSize = CGSizeFromString(dict[@"UILaunchImageSize"]);
        
        if([viewOrientation isEqualToString:dict[@"UILaunchImageOrientation"]]) {
            if([dict[@"UILaunchImageOrientation"] isEqualToString:@"Landscape"]) {
                imageSize = CGSizeMake(imageSize.height, imageSize.width);
            }
            if(CGSizeEqualToSize(imageSize, viewSize)) {
                launchImageName = dict[@"UILaunchImageName"];
                UIImage *image = [UIImage imageNamed:launchImageName];
                return image;
            }
        }
    }
    return nil;
}
//添加计时器
- (void)addTimer {
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timeOut) userInfo:nil repeats:YES];
    self.timer = timer;
}
//设置超时
- (void)timeOut {
    self.second--;
    if (self.second > 0) {
        [self.skipButton setTitle:[NSString stringWithFormat:@"%zd 跳过", self.second] forState:UIControlStateNormal];
    } else {
        [self removeTimer];
        [self skipButtonClick];
    }
}
- (void)removeTimer {
    // 停止定时器
    [self.timer invalidate];
    self.timer = nil;
}
//点击广告
- (void)adViewClick {
    [self removeTimer];
    self.adDidClickBlock();
}
//跳过按钮
- (void)skipButtonClick{
    [self removeTimer];
    self.skipDidClickBlock();
}
- (void)dealloc {
    [self removeTimer];
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
