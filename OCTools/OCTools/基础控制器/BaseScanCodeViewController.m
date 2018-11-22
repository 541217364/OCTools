//
//  BaseScanCodeViewController.m
//  OCTools
//
//  Created by 周 on 2018/11/20.
//  Copyright © 2018年 周. All rights reserved.
//

#import "BaseScanCodeViewController.h"
#define TOP ([UIScreen mainScreen].bounds.size.height - 220 - HeightForNagivationBarAndStatusBar - HOME_INDICATOR_HEIGHT)/2
#define LEFT ([UIScreen mainScreen].bounds.size.width -220)/2
#define kScanRect CGRectMake(LEFT,TOP,220,220)//设置扫码区域
@interface BaseScanCodeViewController ()<AVCaptureMetadataOutputObjectsDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>{
    int num;
    BOOL upOrdown;
    NSTimer *timer;
    CAShapeLayer *cropLayer;
}
@property (nonatomic, strong)AVCaptureDevice *device;
@property (nonatomic, strong)AVCaptureDeviceInput *input;
@property (nonatomic, strong)AVCaptureMetadataOutput *output;
@property (nonatomic, strong)AVCaptureSession *session;
@property (nonatomic, strong)AVCaptureVideoPreviewLayer *preview;
/**上下扫动的线*/
@property (nonatomic, strong)UIImageView *line;
/**结果字符串*/
@property (nonatomic, strong)NSString *valueString;
@end

@implementation BaseScanCodeViewController
- (void)viewWillAppear:(BOOL)animated {
    if (_session != nil && timer != nil) {
        [self startScan];
    }
}
- (void)viewWillDisappear:(BOOL)animated {
    [self stopScan];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self requestCameraAuthorization];
    [self createScanView];
    [self setCropRect:kScanRect];
    [self performSelector:@selector(setupCamera) withObject:nil afterDelay:0.3];
}
//设置背景
- (void)setCropRect:(CGRect)cropRect {
    cropLayer = [[CAShapeLayer alloc] init];
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, nil, cropRect);
    CGPathAddRect(path, nil, self.view.bounds);
    
    [cropLayer setFillRule:kCAFillRuleEvenOdd];
    [cropLayer setPath:path];
    [cropLayer setFillColor:[UIColor blackColor].CGColor];
    [cropLayer setOpacity:0.6];
    [cropLayer setNeedsDisplay];
    
    [self.view.layer addSublayer:cropLayer];
}
//设置相机权限
- (void)requestCameraAuthorization {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusDenied || authStatus == AVAuthorizationStatusRestricted) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请在设置中允许打开相机" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }]];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

//设置相机
- (void)setupCamera {
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (device == nil) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"设备没有摄像头" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [self presentViewController:alert animated:YES completion:nil];
    }
    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    _input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    
    _output = [[AVCaptureMetadataOutput alloc]init];
    [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    //设置扫码区域
    CGFloat top = TOP / [UIScreen mainScreen].bounds.size.height;
    CGFloat left = LEFT / [UIScreen mainScreen].bounds.size.width;
    CGFloat width = 220 / [UIScreen mainScreen].bounds.size.width;
    CGFloat height = 220 / [UIScreen mainScreen].bounds.size.height;
    
    [_output setRectOfInterest:CGRectMake(top, left, height, width)];
    
    _session = [[AVCaptureSession alloc]init];
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    
    if ([_session canAddInput:self.input]) {
        [_session addInput:self.input];
    }
    if ([_session canAddOutput:self.output]) {
        [_session addOutput:self.output];
    }
    //条码类型，支持二维码，条形码
    [_output setMetadataObjectTypes:[NSArray arrayWithObjects:AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code, nil]];
    
    _preview = [AVCaptureVideoPreviewLayer layerWithSession:_session];
    _preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    _preview.frame = self.view.layer.bounds;
    [self.view.layer insertSublayer:_preview atIndex:0];
    //开始扫码
    [self startScan];
}
//创建扫码区
- (void)createScanView {
    //扫码区
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:kScanRect];
    imageView.image = [UIImage imageNamed:@"pick_bg.png"];
    imageView.userInteractionEnabled = YES;
    [self.view addSubview:imageView];
    
    //开启前置手电筒
    UIButton *lightBtn = [[UIButton alloc]initWithFrame:CGRectMake(220 / 2 - 25, 130, 50, 90)];
    [lightBtn setImage:[UIImage imageNamed:@"icon-sd"] forState:UIControlStateNormal];
    lightBtn.selected = NO;
    [lightBtn addTarget:self action:@selector(lightAction:) forControlEvents:UIControlEventTouchUpInside];
    [imageView addSubview:lightBtn];
    
    //扫描线
    upOrdown = NO;
    num = 0;
    _line = [[UIImageView alloc] initWithFrame:CGRectMake(LEFT, TOP+10, 220, 2)];
    _line.image = [UIImage imageNamed:@"line.png"];
    [self.view addSubview:_line];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:0.02 target:self selector:@selector(animation) userInfo:nil repeats:YES];
    //描述
    UILabel *desL = [[UILabel alloc]initWithFrame:CGRectMake(0, imageView.maxY + 20, UI_SCREEN_WIDTH, 20)];
    desL.font = [UIFont boldSystemFontOfSize:15];
    desL.text = @"将二维码放入框内，即可自动扫描";
    desL.textColor = [UIColor whiteColor];
    desL.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:desL];
}
- (void)animation {
    //扫码线动画
    if (upOrdown == NO) {
        num ++;
        _line.frame = CGRectMake(LEFT, TOP+10+2*num, 220, 2);
        if (2 * num == 200) {
            upOrdown = YES;
        }
    }else {
        num--;
        _line.frame = CGRectMake(LEFT, TOP+10+2*num, 220, 2);
        if (num == 0) {
            upOrdown = NO;
        }
    }
}

//手电筒控制
- (void)lightAction:(UIButton *)sender {
    Class captureDeviceClass = NSClassFromString(@"AVCaptureDevice");
    if (captureDeviceClass != nil) {
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        if ([device hasTorch] && [device hasFlash]) {
            [device lockForConfiguration:nil];
            if (sender.isSelected == NO) {
                //打开闪光灯
                [device setTorchMode:AVCaptureTorchModeOn];
                [device setFlashMode:AVCaptureFlashModeOn];
                sender.selected = YES;
            }else {
                [device setTorchMode:AVCaptureTorchModeOff];
                [device setFlashMode:AVCaptureFlashModeOff];
                sender.selected = NO;
            }
            [device unlockForConfiguration];
        }
    }
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)output didOutputMetadataObjects:(NSArray<__kindof AVMetadataObject *> *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    //有扫描结果
    if ([metadataObjects count] > 0) {
        //停止扫描
        [self stopScan];
        
        AVMetadataMachineReadableCodeObject *metadataObject = [metadataObjects objectAtIndex:0];
        //扫描的结果
        self.valueString = metadataObject.stringValue;
        
        //弹出结果
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        AudioServicesPlaySystemSound(1111);
        NSLog(@"%@",self.valueString);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self startScan];
        });
    }else {
        NSLog(@"无扫码信息");
        return;
    }
}

/**开始扫码*/
- (void)startScan {
    [self.session startRunning];
    [timer setFireDate:[NSDate date]];
}
/**结束扫码*/
- (void)stopScan {
    [self.session stopRunning];
    [timer setFireDate:[NSDate distantFuture]];
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
